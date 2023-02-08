rule generate_report:
    input:
        vcf="results/{sample}/vcf/{sample}.calls.vcf.gz",
        ref=f"data/reference/{genome}.fasta",
    output:
        "workflow/report/{sample}/{sample}_variants.html",
    log:
        "logs/generate_report/{sample}.log",
    conda:
        "../envs/igv_report.yaml"
    shell:
        "create_report {input.vcf} {input.ref} "
        "--output {output}"
