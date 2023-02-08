rule fastp_pe:
    input:
        sample=["data/{sample}_R1_001.fastq", "data/{sample}_R2_001.fastq"]
    output:
        trimmed=["results/{sample}/trimmed/{sample}_1.trimmed.fastq", "results/{sample}/trimmed/{sample}_2.trimmed.fastq"],
        unpaired="results/{sample}/merged/{sample}.unpaired.fastq",
        merged="results/{sample}/merged/{sample}.merged.fastq",
        failed="results/{sample}/trimmed/{sample}.failed.fastq",
        html="report/pe/{sample}.html",
        json="report/pe/{sample}.json"
    log:
        "logs/fastp/pe/{sample}.log"
    params:
        # adapter_1 = config["adapter"]["read_1"], TODO Fix later
        # adapter_2 = config["adapter"]["read_2"], TODO Fix later
        adapters="--adapter_sequence GCGAATTTCGACGATCGTTGCATTAACTCGCGAA  --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT",
        extra="--merge --cut_right --cut_right_window_size 4 --cut_right_mean_quality 20"
    threads: 2
    wrapper:
        "v1.23.1/bio/fastp"