rule vcf_variant_annotation:
    input:
        calls="results/{sample}/vcf/{sample}.calls.vcf.gz",  # .vcf, .vcf.gz or .bcf
        cache="resources/vep/cache",  # can be omitted if fasta and gff are specified
        plugins="resources/vep/plugins",
        # optionally add reference genome fasta
        fasta=f"data/reference/{genome}.fasta",
        # fai="genome.fasta.fai", # fasta index
        # gff="annotation.gff",
        # csi="annotation.gff.csi", # tabix index
        # add mandatory aux-files required by some plugins if not present in the VEP plugin directory specified above.
        # aux files must be defined as following: "<plugin> = /path/to/file" where plugin must be in lowercase
        # revel = path/to/revel_scores.tsv.gz
    output:
        calls="results/{sample}/vcf/{sample}.variants.annotated.vcf.gz",  # .vcf, .vcf.gz or .bcf
        stats="results/{sample}/vcf/{sample}.variants.html",
    params:
        # Pass a list of plugins to use, see https://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html
        # Plugin args can be added as well, e.g. via an entry "MyPlugin,1,FOO", see docs.
        plugins=["SingleLetterAA, HGVSIntronOffset"],
        extra="--everything",  # optional: extra arguments
    log:
        "logs/vcf_variant_annotation/{sample}.log",
    threads: 4
    wrapper:
        "v1.23.1/bio/vep/annotate"


# My Notes:
# For .vcf.gz output may need to be added: --vcf --fields "Allele,Gene,HGVSc,HGVSp" 

# Viewed Sites:
# https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/vep/annotate.html#example
# http://useast.ensembl.org/info/docs/tools/vep/vep_formats.html?redirect=no#vcfout
# https://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html