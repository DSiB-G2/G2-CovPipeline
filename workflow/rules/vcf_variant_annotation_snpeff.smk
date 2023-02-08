rule vcf_variant_annotation_snpeff:
    input:
        calls="results/{sample}/vcf/{sample}.calls.vcf.gz", # (vcf, bcf, or vcf.gz)
        db="resources/snpeff/ebola_zaire" # path to reference db downloaded with the snpeff download wrapper
    output:
        calls="results/{sample}/vcf/{sample}.variants.annotated.snpeff.vcf.gz",   # annotated calls (vcf, bcf, or vcf.gz)
        stats="results/{sample}/vcf/{sample}.variants.snpeff.html",  # summary statistics (in HTML), optional
        csvstats="snpeff/{sample}.csv" # summary statistics in CSV, optional
    log:
        "logs/snpeff/{sample}.log"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=4096
    wrapper:
        "v1.23.1/bio/snpeff/annotate"

rule snpeff_download:
    output:
        # wildcard {reference} may be anything listed in `snpeff databases`
        directory("resources/snpeff/{reference}")
    log:
        "logs/snpeff/download/{reference}.log"
    params:
        reference="{reference}"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    wrapper:
        "v1.23.1/bio/snpeff/download"