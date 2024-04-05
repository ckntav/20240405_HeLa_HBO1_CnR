setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)

##### module load sambamba/0.8.0

#
fastq_list_filename <- "20240405_CnR_HBO1_fastq_list.txt"
df <- read_tsv(file.path("input", "cnr_HBO1", fastq_list_filename))
fastq_folder <- "cnr_HBO1"
output_pipeline_dir <- "cnr-pipeline_HBO1-GRCh38_PE"
script_pipeline_dir <- "CnR_HBO1_pipeline"
workdir <- "/home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR"

#
header_sh <- c("#!/bin/sh",
               "#SBATCH --time=3:00:00",
               "#SBATCH --nodes=1",
               "#SBATCH --ntasks-per-node=1",
               "#SBATCH --cpus-per-task=4",
               "#SBATCH --mem-per-cpu=8G",
               "#SBATCH --account=def-stbil30",
               "#SBATCH --mail-user=christophe.tav@gmail.com",
               "#SBATCH --mail-type=ALL")

#
# bowtie2_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/bowtie2/2.5.1/bin/bowtie2"
# samtools_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/samtools/1.17/bin/samtools"
# bowtie2_hg38_idx <- "/home/chris11/projects/def-stbil30/chris11/20230918_CnR_pipeline_demo/input/bowtie2_genome_index_homo_sapiens/Homo_sapiens.GRCh38"
sambamba_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/sambamba/0.8.0/sambamba"

#
nThreads <- 8

for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  # message("# ", i, " | ", sample_name)
  
  #
  output_bowtie2_dir <- file.path(workdir, "output", output_pipeline_dir, "alignment", sample_name)
  
  #
  bam_filename <- paste0(sample_name, ".bam")
  bam_filepath <- file.path(output_bowtie2_dir , bam_filename)
  
  #
  bam_sorted_filename <- paste0(sample_name, ".sorted.bam")
  bam_sorted_filepath <- file.path(output_bowtie2_dir , bam_sorted_filename)
  bam_sorted_index_filepath <- paste0(bam_sorted_filepath, ".bai")
  
  # sambamba sort
  call_sambamba_sort <- paste(sambamba_path, "sort", bam_filepath, "--out", bam_sorted_filepath)
  
  # sambamba index
  call_sambamba_index <- paste(sambamba_path, "index", bam_sorted_filepath, bam_sorted_index_filepath)

  # 
  # generate scripts
  file_sh <- file.path("scripts", script_pipeline_dir, "05_sambamba_sort", "batch_sh",
                        paste0("sambamba_sort_", sample_name, ".sh"))
  message("sbatch ", file_sh)
  fileConn <- file(file_sh)
  writeLines(c(header_sh, "\n", call_sambamba_sort, "\n", call_sambamba_index), fileConn)
  close(fileConn)
  # message(" > Saved in ", file_sh)
}


