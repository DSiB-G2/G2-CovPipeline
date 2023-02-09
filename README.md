# G2-CovPipeline
Master student project under the supervision of IKIM-Essen

A covid variant calling pipeline implemented with Snakemake workflow managment system

## Running the pipeline
Instructions on how to run the pipeline

### 1) Connect to cluster c45 via Remote-SSH/Remote Explorer extensions in your IDE

### 2) Configure the config files
- Config file can be found under _config/_

### 3) Install Snakemake
- [Install Snakemake] (https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)

### 4) Clone the github repository 

### 5) Get Data
- Run retreive_data.py (Only when a connection to c45 is established)
    ```
    cd data/
    python data/retreive_data.py
    ```
- Run get_reference.sh
    ```
    cd data/reference/
    sh get_reference.sh
    ```
### 6) Run with snakemake 
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
    -[quast](https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/quast.html)


