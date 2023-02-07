rule generate_report:
    input:
        vcf = "results/{sample}/vcf/{sample}.calls.vcf.gz",
        ref = f"data/reference/{genome}.fasta",
        bam = "results/{sample}/mapped/{sample}.sorted.bam"
    output:
        "workflow/report/{sample}/{sample}_variants.html",
    log:
        "logs/generate_report/{sample}.log",
    conda:
        "../envs/igv_report.yaml"
    shell:
        "create_report {input.vcf} {input.ref} "
        "--output {output} "
        "--sample-columns DP GQ "
        "--info-columns COSMIC_ID "
        "--tracks {input.vcf} {input.bam}"
