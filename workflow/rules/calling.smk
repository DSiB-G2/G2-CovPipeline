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
        calls="results/vcf/{sample}.calls.vcf",
    params:
        caller=config["rule_parameters"]["bcftools_call"]["caller"],  # valid options include -c/--consensus-caller or -m/--multiallelic-caller
        extra=config["rule_parameters"]["bcftools_call"]["extra"],
    log:
        "logs/bcftools_call/{sample}.log",
    wrapper:
        "v1.21.1/bio/bcftools/call"



rule norm_vcf:
    input:
        "results/vcf/{sample}.calls.vcf",
        ref="data/reference/" + genome + ".fasta",
    output:
        "results/vcf_norm/{sample}.norm.bcf", # can also be .bcf, corresponding --output-type parameter is inferred automatically
    log:
        "{prefix}.norm.log",
    params:
        extra="--rm-dup none",  # optional
        #uncompressed_bcf=False,
    wrapper:
        "v1.21.4/bio/bcftools/norm"


rule bcf_filter_o_vcf:
    input:
        "results/vcf_norm/{sample}.norm.bcf",
    output:
        ""results/flt_indels/{sample}.flt-indels.bcf",
    log:
        "log/{prefix}.filter.vcf.log",
    params:
        filter="-i 'QUAL > 5'",
        extra="",
    wrapper:
        "v1.21.4/bio/bcftools/filter"

# NOT FINISH yet

# I
# Filter and report the SNV variants in variant calling format (VCF)
rule filter_vcf:
    input:
        "results/vcf/{sample}.calls.vcf"
    output:
        "results/filtered/{sample}.filtered.vcf"
    params:
        extra=config["rule_parameters"]["filter_vcf"]["extra"],
    wrapper:
        "v1.21.1/bio/vcftools/filter"



