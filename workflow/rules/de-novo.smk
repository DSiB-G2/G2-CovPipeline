rule run_metaspades:
    input:
        # reads=["results/{sample}/trimmed/{sample}_1.trimmed.fastq", "results/{sample}/trimmed/{sample}_2.trimmed.fastq", "results/{sample}/merged/{sample}.merged.fastq", "results/{sample}/merged/{sample}.unpaired.fastq"],
        reads=["results/{sample}/trimmed/{sample}_1.trimmed.fastq", "results/{sample}/trimmed/{sample}_2.trimmed.fastq"],
    output:
        contigs="results/{sample}/spades_assembly/contigs.fasta",
        scaffolds="results/{sample}/spades_assembly/scaffolds.fasta",
        dir=directory("results/{sample}/spades_assembly/intermediate_files"),
    benchmark:
        "logs/benchmarks/spades_assembly/{sample}.txt"
    params:
        k="auto",
        # extra="--only-assembler",
    log:
        "logs/spades/{sample}.log",
    threads: 16
    resources:
        mem_mem=250000,
        time=60 * 24,
    wrapper:
        "v1.23.1/bio/spades/metaspades"

rule order_contigs:
    input:
        contigs="results/{sample}/spades_assembly/contigs.fasta",
        reference=f"data/reference/{genome}.fasta",
    output:
        file="results/{sample}/ragtag/ragtag.scaffold.fasta", #??
        folder=directory("results/{sample}/ragtag/"),
    log:
        "logs/ragtag/{sample}.log",
    conda:
        "../envs/ragtag.yaml"
    shell:
        "ragtag.py scaffold -o {output.folder} {input.reference} {input.contigs}"