rule assembly_megahit:
    input:
        first = "results/trimmed/{sample}_1.trimmed.fastq",
        second = "results/trimmed/{sample}_2.trimmed.fastq"
    output:
        directory("results/megahit_assembled/{sample}")
    log:
        "logs/megahit/{sample}.log",
    conda:
        "../envs/megahit.yaml"
    shell:
        "megahit -1 {input.first} -2 {input.second} -o {output}"