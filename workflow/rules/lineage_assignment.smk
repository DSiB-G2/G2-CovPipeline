
rule pangolin_la:
    input:
        "results/{sample}/de_novo_consensus/{sample}.fa",
        #"results/{sample}/ragtag/ragtag.scaffold.fasta",
    output:
        "results/{sample}/lineage_assignment/{sample}.csv"
    conda:
        "../envs/pangolin.yaml"
    log:
        "logs/lineage_assignment/{sample}.log",
    shell:
        "pangolin {input} --outfile {output}"