#!/bin/sh
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --account=def-stbil30
#SBATCH --mail-user=christophe.tav@gmail.com
#SBATCH --mail-type=ALL


mkdir -p /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/fastqc_beforetrim_output/HeLa_HBO1KO_H3K27me3_rep1_R2


/cvmfs/soft.computecanada.ca/easybuild/software/2023/x86-64-v3/Core/fastqc/0.12.1/fastqc --outdir /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/fastqc_beforetrim_output/HeLa_HBO1KO_H3K27me3_rep1_R2 --format fastq /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/raw/cnr_HBO1/raw_fastq/HeLaHBO1KOH3K27me3_S90_L001_R2_001.fastq.gz
