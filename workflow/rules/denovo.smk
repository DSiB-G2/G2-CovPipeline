rule assembly_megahit:
    input:
        first = "results/trimmed/{sample}_1.trimmed.fastq",
        second = "results/trimmed/{sample}_2.trimmed.fastq",
    output:
        "results/megahit_assembled/{sample}/final.contigs.fa"
    conda:
        "../envs/megahit.yaml"
    shell:
        "megahit -1 {input.first} -2 {input.second} -o {output}"