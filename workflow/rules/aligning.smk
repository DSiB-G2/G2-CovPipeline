# Index the reference genome
rule bwa_index:
    input:
        "data/reference/" + genome + ".fasta"
    output:
        idx=multiext("data/reference/" + genome + ".fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/bwa_index/" + genome + ".log",
    params:
        algorithm=config["rule_parameters"]["bwa_index"]["algorithm"],
    wrapper:
        "v1.21.1/bio/bwa/index"

# Align reads to reference genome
#this wrapper does bwa mem and change it to bam when sort is "none"
rule bwa_mem:
    input:
        reads=["results/trimmed/{sample}_1.trimmed.fastq", "results/trimmed/{sample}_2.trimmed.fastq"],
        idx=multiext("data/reference/" + genome + ".fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        "results/mapped/{sample}.bam",
    log:
        "logs/bwa_mem/{sample}.log",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sorting=config["rule_parameters"]["bwa_mem"]["sorting"],  # Can be 'none', 'samtools' or 'picard'.
    wrapper:
        "v1.21.1/bio/bwa/mem"


# Sort BAM file by coordinates
rule samtools_sort:
    input:
        "results/mapped/{sample}.bam",
    output:
        "results/mapped/{sample}.sorted.bam",
    log:
        "logs/samtools_sort/{sample}.log",
    params:
        extra=config["rule_parameters"]["samtools_sort"]["extra"],
    wrapper:
        "v1.21.1/bio/samtools/sort"


#qc
rule samtools_index:
    input:
        "results/mapped/{sample}.sorted.bam",
    output:
        "results/mapped/{sample}.sorted.bam.bai",
    log:
        "logs/samtools_index/{sample}.log",
    params:
        extra=config["rule_parameters"]["samtools_index"]["extra"],
    wrapper:
        "v1.21.1/bio/samtools/index"

#qc
rule samtools_flagstat:
    input:
        "results/mapped/{sample}.sorted.bam",
    output:
        "results/mapped/{sample}.sorted.bam.flagstat",
    log:
        "logs/samtools_flagstat/{sample}.log",
    params:
        extra=config["rule_parameters"]["samtools_flagstat"]["extra"],  # optional params string
    wrapper:
        "v1.21.1-1-g03463da5/bio/samtools/flagstat"

#qc
rule samtools_idxstats:
    input:
        bam="results/mapped/{sample}.sorted.bam",
        idx="results/mapped/{sample}.sorted.bam.bai",
    output:
        "results/mapped/{sample}.sorted.bam.idxstats",
    log:
        "logs/samtools_idxstats/{sample}.log",
    params:
        extra=config["rule_parameters"]["samtools_idxstats"]["extra"],  # optional params string
    wrapper:
        "v1.21.1-1-g03463da5/bio/samtools/idxstats"