#!/bin/sh
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --account=def-stbil30
#SBATCH --mail-user=christophe.tav@gmail.com
#SBATCH --mail-type=ALL


/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/sambamba/0.8.0/sambamba view -t 8 -f bam -F "not unmapped and not failed_quality_control and mapping_quality >= 20" /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/output/cnr-pipeline_JAZF1-GRCh38_PE/alignment/K562_IgG_rep1/K562_IgG_rep1.sorted.markdup.bam -o /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/output/cnr-pipeline_JAZF1-GRCh38_PE/alignment/K562_IgG_rep1/K562_IgG_rep1.sorted.markdup.filtered.bam


/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/sambamba/0.8.0/sambamba index /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/output/cnr-pipeline_JAZF1-GRCh38_PE/alignment/K562_IgG_rep1/K562_IgG_rep1.sorted.markdup.filtered.bam /home/chris11/projects/def-stbil30/chris11/20240404_K562_JAZF1_CnR/output/cnr-pipeline_JAZF1-GRCh38_PE/alignment/K562_IgG_rep1/K562_IgG_rep1.sorted.markdup.filtered.bam.bai
