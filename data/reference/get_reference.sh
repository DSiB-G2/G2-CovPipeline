#!/bin/bash
cd ~/G2-CovPipeline/data/reference/
wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_045512.2&rettype=fasta" -O NC_045512.2.fasta 