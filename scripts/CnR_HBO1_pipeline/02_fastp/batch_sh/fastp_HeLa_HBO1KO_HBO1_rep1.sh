#!/bin/sh
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --account=def-stbil30
#SBATCH --mail-user=christophe.tav@gmail.com
#SBATCH --mail-type=ALL


mkdir -p /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/fastp_output/HeLa_HBO1KO_HBO1_rep1


mkdir -p /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/raw/cnr_HBO1/fastp_output


/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/fastp/0.23.4/bin/fastp --in1 /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/raw/cnr_HBO1/raw_fastq/HeLaHBO1KOHBO1_S85_L001_R1_001.fastq.gz --in2 /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/raw/cnr_HBO1/raw_fastq/HeLaHBO1KOHBO1_S85_L001_R2_001.fastq.gz --detect_adapter_for_pe --overrepresentation_analysis --overrepresentation_sampling 10 --thread 8 --length_required 99 --out1 /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/raw/cnr_HBO1/fastp_output/HeLa_HBO1KO_HBO1_rep1_1.fastq.gz --out2 /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/raw/cnr_HBO1/fastp_output/HeLa_HBO1KO_HBO1_rep1_2.fastq.gz --html /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/fastp_output/HeLa_HBO1KO_HBO1_rep1/HeLa_HBO1KO_HBO1_rep1_fastp_report.html --json /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/fastp_output/HeLa_HBO1KO_HBO1_rep1/HeLa_HBO1KO_HBO1_rep1_fastp_report.json
