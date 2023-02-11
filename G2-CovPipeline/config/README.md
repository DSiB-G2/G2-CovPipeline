# Configuring G2-CovPipeline
This markdown will provide an insight on configuring the pipeline


## pipeline structure
```
├── workflow
│   ├── rules
|   │   ├── rules.smk
│   ├── envs
|   │   ├── tools.yaml
|   └── Snakefile
├── config
│   ├── config.yaml
│   └── samples.csv   
├── data
|   ├── reference
|   │   ├── reference.fasta
|   ├── sampleName_R1_001.fastq
|   ├── sampleName_R2_001.fastq
```




## config.yaml
Note: Only paired ends!!!!

- Samples:
    To add samples edit the samples.csv file: Add the name of the sample in "sample" column and add the two reads file respectively

- Reference genome:
    The ID of the reference genome. It shjould be stored under data/reference/

- adapter:
    The adapter sequence. We do not use fasta fail. If needs to be changed simply replace the sequence in the config file

- rule parameters:
    For every rule (except what is in preprocess.smk) there are parameteres that are tuneable