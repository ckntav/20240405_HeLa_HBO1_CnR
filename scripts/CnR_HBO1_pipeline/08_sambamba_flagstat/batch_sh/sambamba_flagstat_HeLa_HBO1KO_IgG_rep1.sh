#!/bin/sh
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --account=def-stbil30
#SBATCH --mail-user=christophe.tav@gmail.com
#SBATCH --mail-type=ALL


/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/sambamba/0.8.0/sambamba flagstat /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/alignment/HeLa_HBO1KO_IgG_rep1/HeLa_HBO1KO_IgG_rep1.bam > /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/alignment/HeLa_HBO1KO_IgG_rep1/HeLa_HBO1KO_IgG_rep1.flagstat


/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/sambamba/0.8.0/sambamba flagstat /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/alignment/HeLa_HBO1KO_IgG_rep1/HeLa_HBO1KO_IgG_rep1.sorted.markdup.bam > /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/alignment/HeLa_HBO1KO_IgG_rep1/HeLa_HBO1KO_IgG_rep1.sorted.markdup.flagstat


/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/sambamba/0.8.0/sambamba flagstat /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/alignment/HeLa_HBO1KO_IgG_rep1/HeLa_HBO1KO_IgG_rep1.sorted.markdup.filtered.bam > /home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR/output/cnr-pipeline_HBO1-GRCh38_PE/alignment/HeLa_HBO1KO_IgG_rep1/HeLa_HBO1KO_IgG_rep1.sorted.markdup.filtered.flagstat
