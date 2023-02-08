# Calculate the read coverage of positions in the genome
rule bcftools_mpileup:
    input:
        alignments="results/{sample}/mapped/{sample}.sorted.bam",
        ref=f"data/reference/{genome}.fasta",
    output:
        pileup="results/{sample}/pileups/{sample}.pileup.vcf.gz",
    params:
        uncompressed_bcf=config["rule_parameters"]["bcftools_mpileup"][
            "uncompressed_bcf"
        ],
        extra=config["rule_parameters"]["bcftools_mpileup"]["extra"],
    log:
        "logs/bcftools_mpileup/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/mpileup"


# Detect the single nucleotide variants (SNVs)
rule bcftools_call:
    input:
        pileup="results/{sample}/pileups/{sample}.pileup.vcf.gz",
    output:
        calls="results/{sample}/vcf/{sample}.calls.vcf.gz",
    params:
        uncompressed_bcf=False,
        caller=config["rule_parameters"]["bcftools_call"]["caller"],  # valid options include -c/--consensus-caller or -m/--multiallelic-caller
        extra=config["rule_parameters"]["bcftools_call"]["extra"],
    log:
        "logs/bcftools_call/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/call"


# index vcf (has to be gz)
rule bcftools_index:
    input:
        "results/{sample}/vcf/{sample}.calls.vcf.gz",
    output:
        "results/{sample}/vcf/{sample}.calls.vcf.gz.csi",
    log:
        "logs/bcftools_index/{sample}.log",
    params:
        extra=config["rule_parameters"]["bcftools_index"]["extra"],  # optional parameters for bcftools index
    wrapper:
        "v1.21.4/bio/bcftools/index"

# apply variants to create consensus sequence
rule bcf_consensus:
    input:
        "results/{sample}/vcf/{sample}.calls.vcf.gz.csi",
        vcf="results/{sample}/vcf/{sample}.calls.vcf.gz",
        ref=f"data/reference/{genome}.fasta",
    output:
        "results/{sample}/consensus/{sample}.fa",
    log:
        "logs/bcf_consensus/{sample}.log",
    conda:
        "../envs/bcftools.yaml"
    shell:
        "bcftools consensus -I -s {wildcards.sample} -f {input.ref} {input.vcf} -o {output}"

# Filter and report the SNV variants in variant calling format (VCF)
# rule filter_vcf:
#    input:
#        "results/{sample}/vcf/{sample}.calls.vcf"
#    output:
#        "results/{sample}/filtered/{sample}.filtered.vcf"
#    params:
#        extra=config["rule_parameters"]["filter_vcf"]["extra"],
#    wrapper:
#        "v1.21.1/bio/vcftools/filter"