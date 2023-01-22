# Calculate the read coverage of positions in the genome
rule bcftools_mpileup:
    input:
        alignments="results/mapped/{sample}.sorted.bam",
        ref="data/reference/" + genome + ".fasta",  # this can be left out if --no-reference is in options
    output:
        pileup="results/pileups/{sample}.pileup.vcf.gz",
    params:
        uncompressed_bcf=config["rule_parameters"]["bcftools_mpileup"]["uncompressed_bcf"],
        extra=config["rule_parameters"]["bcftools_mpileup"]["extra"]
    log:
        "logs/bcftools_mpileup/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/mpileup"

# Detect the single nucleotide variants (SNVs)
rule bcftools_call:
    input:
        pileup="results/pileups/{sample}.pileup.vcf.gz",
    output:
        calls="results/vcf/{sample}.calls.vcf.gz",
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
        "results/vcf/{sample}.calls.vcf.gz",
    output:
        "results/vcf/{sample}.calls.vcf.gz.csi",
    log:
        "logs/bcftools_index/{sample}.log",
    params:
        extra="",  # optional parameters for bcftools index
    wrapper:
        "v1.21.4/bio/bcftools/index"


# apply variants to create consensus sequence
rule bcf_consensus:
    input:
        "results/vcf/{sample}.calls.vcf.gz.csi",
        vcf="results/vcf/{sample}.calls.vcf.gz",
        ref="data/reference/" + genome + ".fasta",
    output:
        "results/consensus/{sample}.fa",
    conda:
        "../envs/bcftools.yaml"
    shell:
        "bcftools consensus -I -s {wildcards.sample} -f {input.ref} {input.vcf} -o {output}"


# I
# Filter and report the SNV variants in variant calling format (VCF)
#rule filter_vcf:
#    input:
#        "results/vcf/{sample}.calls.vcf"
#    output:
#        "results/filtered/{sample}.filtered.vcf"
#    params:
#        extra=config["rule_parameters"]["filter_vcf"]["extra"],
#    wrapper:
#        "v1.21.1/bio/vcftools/filter"



