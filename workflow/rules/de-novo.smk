rule metaspades_assembly:
    input:
        reads=["results/{sample}/trimmed/{sample}_1.trimmed.fastq", "results/{sample}/trimmed/{sample}_2.trimmed.fastq"],
    output:
        contigs=report("results/{sample}/spades_assembly/contigs.fasta", category="Assembly", subcategory="Contigs"),
        scaffolds="results/{sample}/spades_assembly/scaffolds.fasta",
        dir=directory("results/{sample}/spades_assembly/intermediate_files"),
    benchmark:
        "logs/benchmarks/spades_assembly/{sample}.txt"
    params:
        k="auto",
    log:
        "logs/spades/{sample}.log",
    threads: config["threads"]
    resources:
        mem_gb=192,
    wrapper:
        "v1.23.1/bio/spades/metaspades"

rule ragtag_scaffold:
    input:
        contigs="results/{sample}/spades_assembly/contigs.fasta",
        reference=f"data/reference/{genome}.fasta",
    output:
        file=report("results/{sample}/ragtag/ragtag.scaffold.fasta", category="Assembly", subcategory="Scaffolds"),
        folder=directory("results/{sample}/ragtag/"),
    log:
        "logs/ragtag/{sample}.log",
    conda:
        "../envs/ragtag.yaml"
    shell:
        "ragtag.py scaffold -o {output.folder} {input.reference} {input.contigs}"