# rule trimming:
#     input:
#         first = "data/{sample}_R1_001.fastq",
#         second = "data/{sample}_R2_001.fastq"
#     output:
#         first = "results/{sample}/trimmed/{sample}_1.trimmed.fastq",
#         second = "results/{sample}/trimmed/{sample}_2.trimmed.fastq",
#         merged = "results/{sample}/merged/{sample}.merged.fastq",
#         html_report = "workflow/report/{sample}/{sample}_report.html",
#         json_report = "workflow/report/{sample}/{sample}_report.json",
#     conda:
#         "../envs/fastp.yaml"
#     log:
#         "logs/trimming/{sample}.log",
#     params:
#         adapter_1 = config["adapter"]["read_1"],
#         adapter_2 = config["adapter"]["read_2"]
#     shell:
#         "fastp -i {input.first} -I {input.second} -o {output.first} -O {output.second} "
#         "--merge --merged_out {output.merged} -h {output.html_report} -j {output.json_report} " 
#         "--adapter_sequence {params.adapter_1} --adapter_sequence_r2 {params.adapter_2} "
#         "--cut_right --cut_right_window_size 4 --cut_right_mean_quality 20" # Default
#         # "fastp -i {input.first} -I {input.second} -o {output.first} -O {output.second} "
#         # "-h {output.html_report} -j {output.json_report} " 
#         # "--adapter_sequence {params.adapter_1} --adapter_sequence_r2 {params.adapter_2} "
#         # "--cut_right --cut_right_window_size 4 --cut_right_mean_quality 20" # No merges
# #         "fastp -i {input.first} -I {input.second} --merge --merged_out {output.merged} "
# #         "-out1 {output.first} -out2 {output.second} --include_unmerged -h {output.html_report} -j {output.json_report} " 
# #         "--adapter_sequence {params.adapter_1} --adapter_sequence_r2 {params.adapter_2} "
# #         "--cut_right --cut_right_window_size 4 --cut_right_mean_quality 20" # Merged + Singletons

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