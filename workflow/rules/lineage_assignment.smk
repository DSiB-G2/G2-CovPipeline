
rule pangolin_la:
    input:
        "results/{sample}/consensus/{sample}.fa",
    output:
        "results/{sample}/lineage_assignment/{sample}.csv"
    conda:
        "../envs/pangolin.yaml"
    log:
        "logs/lineage_assignment/{sample}.log",
    shell:
        "pangolin {input} --outfile {output}"