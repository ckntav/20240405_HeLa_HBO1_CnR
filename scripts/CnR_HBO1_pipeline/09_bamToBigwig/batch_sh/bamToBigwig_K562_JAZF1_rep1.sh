#!/bin/sh
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=8G
#SBATCH --account=def-stbil30
#SBATCH --mail-user=christophe.tav@gmail.com
#SBATCH --mail-type=ALL


bamCoverage --binSize 1 -p 16 --normalizeUsing RPKM --samFlagInclude 64 --blackListFileName /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/input/ENCODE_exclusion_list_regions_ENCFF356LFX.bed -b /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/output/cnr-pipeline_JAZF1-GRCh38_PE/alignment/K562_JAZF1_rep1/K562_JAZF1_rep1.sorted.markdup.filtered.bam -o /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/output/cnr-pipeline_JAZF1-GRCh38_PE/tracks_byReplicate/K562_JAZF1_rep1_mate1_RPKM.bw
