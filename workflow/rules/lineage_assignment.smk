
rule pangolin_la:
    input:
        "results/consensus/{sample}.fa",
    output:
        "results/lineage_assignment/{sample}.csv"
    conda:
        "../envs/pangolin.yaml"
    shell:
        "pangolin {input} --outfile {output}"