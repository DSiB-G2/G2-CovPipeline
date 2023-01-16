# Calculate the read coverage of positions in the genome
rule bcftools_mpileup:
    input:
        alignments="results/mapped/{sample}.sorted.bam",
        ref="data/reference/" + genome + ".fasta",  # this can be left out if --no-reference is in options
    output:
        pileup="results/pileups/{sample}.pileup.bcf",
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
        pileup="results/pileups/{sample}.pileup.bcf",
    output:
        calls="results/mapped/{sample}.calls.vcf",
    params:
        caller=config["rule_parameters"]["bcftools_call"]["caller"],  # valid options include -c/--consensus-caller or -m/--multiallelic-caller
        extra=config["rule_parameters"]["bcftools_call"]["extra"],
    log:
        "logs/bcftools_call/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/call"


# Filter and report the SNV variants in variant calling format (VCF)
rule filter_vcf:
    input:
        "results/mapped/{sample}.calls.vcf"
    output:
        "results/vcf/{sample}.filtered.vcf"
    params:
        extra=config["rule_parameters"]["filter_vcf"]["extra"],
    wrapper:
        "v1.21.1/bio/vcftools/filter"

#rule wgs_fasta:
#    input:
#        vcf="results/vcf/{sample}.filtered.vcf",
#        ref="data/reference/" + genome + ".fasta",
#    output:
#        "results/wgs/{sample}.fasta"
#    conda:
#        "../envs/wgs.yaml"
#    shell:
#        "cat {input.ref} | vcf-consensus {input.vcf} > {output}"

