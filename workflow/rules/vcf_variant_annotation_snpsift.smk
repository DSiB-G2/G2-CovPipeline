rule test_snpsift_annotate:
    input:
        call="results/{sample}/vcf/{sample}.calls.vcf.gz",
        database="resources/snpsift/annotation.vcf"
    output:
        call="results/{sample}/vcf/{sample}.variants.annotated.snpsift.vcf.gz"
    log:
        "logs/vcf_variant_annotation_snpsift/{sample}.log"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    threads: 4    
    wrapper:
        "v1.23.1/bio/snpsift/annotate"


rule test_snpsift_dbnsfp:
    input:
        call = "results/{sample}/vcf/{sample}.calls.vcf.gz",
        dbNSFP = "resources/snpsift/dbnsfp.txt.gz.tbi"
    output:
        call = "results/{sample}/vcf/{sample}.dbnsfp.snpsift.vcf.gz"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    threads: 4    
    wrapper:
        "v1.23.1/bio/snpsift/dbnsfp"

rule test_snpsift_gmt:
    input:
        call = "results/{sample}/vcf/{sample}.calls.vcf.gz",
        gmt = "resources/snpsift/c3.all.gmt"
    output:
        call = "results/{sample}/vcf/{sample}.genesets.snpsift.vcf"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    threads: 4
    wrapper:
        "v1.23.1/bio/snpsift/genesets"

rule test_snpsift_gwascat:
    input:
        call = "results/{sample}/vcf/{sample}.calls.vcf",
        gwascat = "gwascatalog.txt"
    output:
        call = "annotated/out.vcf"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    threads: 4
    wrapper:
        "v1.23.1/bio/snpsift/gwascat"

rule test_snpsift_vartype:
    input:
        vcf="results/{sample}/vcf/{sample}.calls.vcf.gz"
    output:
        vcf="results/{sample}/vcf/{sample}.varType.snpsift.vcf.gz.vcf"
    message:
        "Testing SnpSift varType"
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    log:
        "logs/vcf_variant_annotation_varType_snpsift/{sample}.log"
    wrapper:
        "v1.23.1/bio/snpsift/varType"