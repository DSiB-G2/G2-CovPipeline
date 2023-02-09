import pandas as pd


configfile: "config/config.yaml"


# get paired end samples name
# SAMPLES = config["samples"]

samples = pd.read_csv(config["samples"], dtype=str, sep=";").set_index("sample", drop=False)

SAMPLES = samples.index.tolist()


def get_fastq(wildcards):
    """Get fastq files of given sample-unit."""
    fastqs = samples.loc[(wildcards.sample), ["read_1", "read_2"]].dropna()
    assert len(fastqs) == 2, "Please input only paired-end reads!"

    return [fastqs.read_1, fastqs.read_2]


# get reference genome
genome = config["reference_genome"]
