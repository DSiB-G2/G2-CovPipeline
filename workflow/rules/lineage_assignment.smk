rule pangolin_la:
    input:
        "results/{sample}/consensus/{sample}.fa",
    output:
        report("results/{sample}/lineage_assignment/{sample}.csv", category="Lineage Assignment", subcategory="CSV File Download"),
    conda:
        "../envs/pangolin.yaml"
    log:
        "logs/lineage_assignment/{sample}.log",
    shell:
        "pangolin {input} --outfile {output}"
