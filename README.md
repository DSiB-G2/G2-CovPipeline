# G2-CovPipeline
A student project under the supervision of IKIM-Essen for the Master's project course "Data Science in Bioinformatics"

During the course, we have implemented an easy to use pipeline for assigning lineages to SARS-CoV-2 (COVID) next generation sequencing data using the Snakemake workflow managment system.

## Instructions on how to run the pipeline

### 1) Optional: Connect to IKIM cluster (e.g. c45), preferably via Remote-SSH/Remote Explorer extensions in your IDE
While this project can also be run elsewhere, being remotely connected to the cluster is the most straightforward experience due to scripts that can automatically fetch sample data.

### 2) Install Mambaforge, if not already installed
```
curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -o Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x86_64.sh
```

### 3) Install Snakemake
Given that Mamba is installed, run
```
conda activate base
mamba create -c conda-forge -c bioconda --name snakemake snakemake snakedeploy
```
to install both Snakemake and Snakedeploy in an isolated environment. For all following commands ensure that this environment is activated via
```
conda activate snakemake
```

### 4) Install project
First create an appropriate working directory for our snakemake workflow and enter it:
```
mkdir -p G2-CovPipeline
cd G2-CovPipeline
```
In all following steps, we will assume that you are inside of that directory unless otherwise specified. 

Second, run 
```
snakedeploy deploy-workflow https://github.com/DSiB-G2/G2-CovPipeline . --tag v1.0
```

Snakedeploy will create two folders workflow and config. The former contains the deployment of the chosen workflow as a Snakemake module, the latter contains configuration files which will be modified in the next step in order to configure the workflow to your needs. Later, when executing the workflow, Snakemake will automatically find the main Snakefile in the workflow subfolder.

### 5) Retrieve samples via scripts
If a connection to the IKIM cluster is established, you may execute the full code block (containing the `retrieve_data.py` script) below to directly copy the exemplary `.fastq` samples to your data folder.
If no connection is established, you have the option to customize your input file configuration within step 6).
```
mkdir -p data/reference
wget -O data/retrieve_data.py https://github.com/DSiB-G2/G2-CovPipeline/blob/main/data/retrieve_data.py?raw=true
wget -O data/reference/get_reference.sh https://github.com/DSiB-G2/G2-CovPipeline/blob/main/data/reference/get_reference.sh?raw=true
cd data/
python retrieve_data.py
sh reference/get_reference.sh
cd ..
```

Regardless of whether a connection was established or not you may execute the `get_reference.sh` file above to retrieve the reference genome from NCBI.
However, if your project directory name is different to `G2-CovPipeline` you might want to execute the following command directly from your `data/reference` directory, instead of using the shell script: 
```
wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_045512.2&rettype=fasta" -O NC_045512.2.fasta
```

### 6) Configure the config files (if necessary)
- The config file can be found under _config/_
- You may change the adapters if necessary (the preset ones are for NimaGen)
- You may change the samples.csv file if necessary (filename without "_L001_R1/R2_001.fastq" extension; two paths to paired-end read files relative to the project directory)

When using the samples from step 5) no further adjustments should be necessary.

### 7) Run with snakemake 
Again make sure the snakemake environment is active with `conda activate snakemake`

Now execute the following code to run snakemake from the project working directory:
```
cd ~/G2-CovPipeline
snakemake --use-conda --cores all
```

Please note that the execution will usually take several minutes, especially at first-time execution due to package installations.

### 8) Create a report with results
After the pipeline was executed successfully, you can generate a report.zip file and unpack it to take a look at the generated files within the html_report/report.html
```
snakemake --report report.zip && unzip report.zip -d html_report
```

*In the `RESULT` section of the report you have access to intermediate files as well as the lineage assignments for each sample under `Results -> Lineage Assignment -> CSV Viewer / CSV File Download`.*

# Resources
- For getting started we mainly used the following tutorial and made alterations whenever sensible:
    [Variant Calling Tutorial] (https://datacarpentry.org/wrangling-genomics/)

- Furthermore, the softwares used in this pipeline utilizes heavily on the following snakemake wrappers as well as Snakemake itself and Mambaforge (Conda):
    - [Snakemake] (https://snakemake.readthedocs.io)
    - [Mambaforge] (https://github.com/conda-forge/miniforge)
    - [fastp] (https://github.com/OpenGene/fastp)
    - [bwa] (https://bio-bwa.sourceforge.net/)
    - [samtools] (https://github.com/samtools/samtools)
    - [bcftools] (https://samtools.github.io/bcftools/)
    - [vcftools] (https://vcftools.github.io/man_latest.html)
    - [seqtk] (https://github.com/lh3/seqtk)
    - [pangolin] (https://cov-lineages.org/resources/pangolin.html)
    - [metaSPAdes] (https://github.com/ablab/spades)
    - [RagTag] (https://github.com/malonge/RagTag)
    - [rust-bio-tools] (https://github.com/rust-bio/rust-bio-tools)


