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

# def aggregate_csv(wildcards):
#     dfs = []

#     sample_names = samples.loc[(wildcards.sample), ["sample"]]
#     for sample_name in sample_names:
#         file_path = os.path.join("results", sample_name, "lineage_assignment", sample_name + ".csv")
#         df = pd.read_csv(file_path)

#         dfs.append(df)

#     aggregated_df = pd.concat(dfs)
#     aggregated_df.to_csv("results/aggregated_lineages.csv", index=False)

#     return sample_names

# def aggregate_csv(wildcards):
#     dfs = []

#     sample_names = samples["sample"].to_numpy()
#     for sample_name in sample_names:
#         file_path = os.path.join("results", sample_name, "lineage_assignment", sample_name + ".csv")
#         df = pd.read_csv(file_path)

#         dfs.append(df)

#     aggregated_df = pd.concat(dfs)
#     aggregated_df.to_csv("results/aggregated_lineages.csv", index=False)

#     return "results/aggregated_lineages.csv"

def aggregate_csv(wildcards):
    dfs = []
    sample_names = samples["sample"].to_numpy()

    for sample_name in sample_names:
        file_path = os.path.join("results", sample_name, "lineage_assignment", f"{sample_name}.csv")
        df = pd.read_csv(file_path)

        df["sample"] = sample_name
        dfs.append(df)

    aggregated_df = pd.concat(dfs)
    aggregated_df = aggregated_df[["sample"] + [col for col in aggregated_df.columns if col != "sample"]]

    # aggregated_df = pd.concat(dfs)
    aggregated_df.to_csv("results/aggregated_lineages.csv", index=False)

    return "results/aggregated_lineages.csv"


# get reference genome
genome = config["reference_genome"]
