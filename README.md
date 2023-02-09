# G2-CovPipeline
Master student project under the supervision of IKIM-Essen

A covid variant calling pipeline implemented with Snakemake workflow managment system

## Running the pipeline
Instructions on how to run the pipeline

### 1) Connect to IKIM cluster (e.g. c45) via Remote-SSH/Remote Explorer extensions in your IDE

### 2) Install Mambaforge, if not already installed
```
curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -o Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x86_64.sh
```

### 3) Install Snakemake
```
conda activate base
mamba create -c conda-forge -c bioconda --name snakemake snakemake snakedeploy

conda activate snakemake
```

### 4) Install project
```
mkdir -p /G2-CovPipeline
cd /G2-CovPipeline
```
In all following steps, we will assume that you are inside of that directory. 

Second, run 
```
snakedeploy deploy-workflow https://github.com/DSiB-G2/G2-CovPipeline . --tag 1.0
```

Snakedeploy will create two folders workflow and config. The former contains the deployment of the chosen workflow as a Snakemake module, the latter contains configuration files which will be modified in the next step in order to configure the workflow to your needs. Later, when executing the workflow, Snakemake will automatically find the main Snakefile in the workflow subfolder.

### 5) Retrieve samples via scripts (Only when a connection to c45 is established)
```
cd data/
python retrieve_data.py
cd reference/
sh get_reference.sh
```

### 6) Configure the config files (if necessary)
- Config file can be found under _config/_
- Change adapters if necessary (the preset ones are for NimaGen)
- Change samples.csv file if necessary (filename without "_L001_R1/R2_001.fastq" extension; two paths to paired-end reads)

### 7) Run with snakemake 
- Make sure the snakemake environment is active
```
snakemake --use-conda --cores all
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
    - [metaSPAdes] (https://github.com/ablab/spades)
    - [quast] (https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/quast.html)


