rule assembly_megahit:
    input:
        first = "results/{sample}/trimmed/{sample}_1.trimmed.fastq",
        second = "results/{sample}/trimmed/{sample}_2.trimmed.fastq"
    output:
        directory("results/{sample}/megahit_assembled/{sample}")
    log:
        "logs/megahit/{sample}.log",
    conda:
        "../envs/megahit.yaml"
    shell:
        "megahit -1 {input.first} -2 {input.second} -o {output}"

rule run_metaspades:
    input:
        reads=["results/{sample}/trimmed/{sample}_1.trimmed.fastq", "results/{sample}/trimmed/{sample}_2.trimmed.fastq"],
    output:
        contigs="results/{sample}/spades_assembly/contigs.fasta",
        scaffolds="results/{sample}/spades_assembly/scaffolds.fasta",
        dir=directory("results/{sample}/spades_assembly/intermediate_files"),
    benchmark:
        "logs/benchmarks/spades_assembly/{sample}.txt"
    params:
        # all parameters are optional
        k="auto",
#        extra="--only-assembler",
    log:
        "logs/spades/{sample}.log",
    threads: 8
    resources:
        mem_mem=250000,
        time=60 * 24,
    wrapper:
        "v1.23.1/bio/spades/metaspades"

rule order_contigs:
    input:
        contigs="results/{sample}/spades_assembly/contigs.fasta",
        reference=f"data/reference/{genome}.fasta",
    output:
        file="results/{sample}/ragtag/ragtag.scaffold.fasta",
        folder=directory("results/{sample}/ragtag/"),
    log:
        "logs/ragtag/{sample}.log",
    conda:
        "../envs/ragtag.yaml"
    shell:
        "ragtag.py scaffold -o {output.folder} {input.reference} {input.contigs}"

# Align reads to reference genome
#this wrapper does bwa mem and change it to bam when sort is "none"
rule bwa_mem_de_novo:
    input:
        reads="results/{sample}/ragtag/ragtag.scaffold.fasta",
        idx=multiext(f"data/reference/{genome}", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        "results/{sample}/de_novo_mapped/{sample}.bam",
    log:
        "logs/bwa_mem/{sample}.log",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sorting=config["rule_parameters"]["bwa_mem"]["sorting"],  # Can be 'none', 'samtools' or 'picard'.
    wrapper:
        "v1.21.1/bio/bwa/mem"


# Sort BAM file by coordinates
rule samtools_sort_de_novo:
    input:
        "results/{sample}/de_novo_mapped/{sample}.bam",
    output:
        "results/{sample}/de_novo_mapped/{sample}.sorted.bam",
    log:
        "logs/samtools_sort/{sample}.log",
    params:
        extra=config["rule_parameters"]["samtools_sort"]["extra"],
    wrapper:
        "v1.21.1/bio/samtools/sort"

# Calculate the read coverage of positions in the genome
rule bcftools_mpileup_de_novo:
    input:
        alignments="results/{sample}/de_novo_mapped/{sample}.sorted.bam",
        ref=f"data/reference/{genome}.fasta",  # this can be left out if --no-reference is in options
    output:
        pileup="results/{sample}/de_novo_pileups/{sample}.pileup.vcf.gz",
    params:
        uncompressed_bcf=config["rule_parameters"]["bcftools_mpileup"]["uncompressed_bcf"],
        extra=config["rule_parameters"]["bcftools_mpileup"]["extra"]
    log:
        "logs/bcftools_mpileup/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/mpileup"

# Detect the single nucleotide variants (SNVs)
rule bcftools_call_de_novo:
    input:
        pileup="results/{sample}/de_novo_pileups/{sample}.pileup.vcf.gz",
    output:
        calls="results/{sample}/de_novo_vcf/{sample}.calls.vcf.gz",
    params:
        uncompressed_bcf=False,
        caller=config["rule_parameters"]["bcftools_call"]["caller"],  # valid options include -c/--consensus-caller or -m/--multiallelic-caller
        extra=config["rule_parameters"]["bcftools_call"]["extra"],
    log:
        "logs/bcftools_call/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/call"



# index vcf (has to be gz)
rule bcftools_index_de_novo:
    input:
        "results/{sample}/de_novo_vcf/{sample}.calls.vcf.gz",
    output:
        "results/{sample}/de_novo_vcf/{sample}.calls.vcf.gz.csi",
    log:
        "logs/bcftools_index/{sample}.log",
    params:
        extra=config["rule_parameters"]["bcftools_index"]["extra"],  # optional parameters for bcftools index
    wrapper:
        "v1.21.4/bio/bcftools/index"

# apply variants to create consensus sequence
rule bcf_consensus_de_novo:
    input:
        "results/{sample}/de_novo_vcf/{sample}.calls.vcf.gz.csi",
        vcf="results/{sample}/de_novo_vcf/{sample}.calls.vcf.gz",
        ref=f"data/reference/{genome}.fasta",
    output:
        "results/{sample}/de_novo_consensus/{sample}.fa",
    log:
        "logs/bcf_consensus/{sample}.log",
    conda:
        "../envs/bcftools.yaml"
    shell:
        "bcftools consensus -I -s {wildcards.sample} -f {input.ref} {input.vcf} -o {output}"