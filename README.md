# G2-CovPipeline
Master student project under IKIM-Essen

This is Group 2's attempt on creating a Covid Variants pipeline using the Snakemake workflow management system

## Running the pipeline
This section covers how to run the pipeline

### 1) Configure the config files
Config file is found under config/

### 2) Install Snakemake
- [Install Snakemake] (https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)

### 3) Get Data
- Run retreive_data.py (do it only when you have access to c45)
    ```
    cd data/
    python data/retreive_data.py
    ```

- Run get_reference.sh
    ```
    cd data/reference/
    sh get_reference.sh
    ```
### 4) Run with snakemake 
- activate snakemake first
    ```
    conda activate snakemake
    ```

- run snakemake
    ```
    snakemake --use-conda --cores 1
    ```


# Resources
- Pipeline is based on:
    We made a few changes and used a few different tools/software
    [Variant Calling Tutorial] (https://datacarpentry.org/wrangling-genomics/)

- The softwares used in this pipeline utilizes heavily on snakemake wrappers
    - [Snakemake] (https://snakemake.readthedocs.io)
    - [fastp] (https://github.com/OpenGene/fastp)
    - [bwa] (https://bio-bwa.sourceforge.net/)
    - [samtools] (https://github.com/samtools/samtools)
    - [bcftools] (https://samtools.github.io/bcftools/)
    - [vcftools] (https://vcftools.github.io/man_latest.html)
    - [seqtk] (https://github.com/lh3/seqtk)
    - [pangolin] (https://cov-lineages.org/resources/pangolin.html)
    - [megahit] (https://github.com/voutcn/megahit)


