
rule pangolin_la:
    input:
        "data/reference/" + genome + ".fasta",
    output:
        "results/ref_pangolin/out.csv"
    conda:
        "../envs/pangolin.yaml"
    shell:
        "pangolin {input} --outfile {output}"