rule fastp_pe:
    input:
        sample=get_fastq
    output:
        trimmed=["results/{sample}/trimmed/{sample}_1.trimmed.fastq", "results/{sample}/trimmed/{sample}_2.trimmed.fastq"],
        unpaired="results/{sample}/merged/{sample}.unpaired.fastq",
        merged="results/{sample}/merged/{sample}.merged.fastq",
        failed="results/{sample}/trimmed/{sample}.failed.fastq",
        html="workflow/report/{sample}/{sample}.html",
        json="workflow/report/{sample}/{sample}.json"
    log:
        "logs/fastp/pe/{sample}.log"
    params:
        adapters=config["rule_parameters"]["fastp_pe"]["adapters"],
        extra=config["rule_parameters"]["fastp_pe"]["extra"]
    threads: config["threads"]
    wrapper:
        "v1.23.1/bio/fastp"
