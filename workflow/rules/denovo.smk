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