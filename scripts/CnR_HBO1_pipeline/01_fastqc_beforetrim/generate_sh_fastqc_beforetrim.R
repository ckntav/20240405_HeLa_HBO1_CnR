setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)

##### module load fastqc

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

fastqc_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2023/x86-64-v3/Core/fastqc/0.12.1/fastqc"


for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  # message("# ", i, " | ", sample_name)
  
  ##### R1
  #
  # message(" > R1")
  fastq_R1_filename <- df$fastq_R1_filename[i]
  fastq_R1_filepath <- file.path(workdir, "raw", fastq_folder, "raw_fastq", fastq_R1_filename)
  output_fastqc_R1_path <- file.path(workdir, "output", output_pipeline_dir, "fastqc_beforetrim_output", paste(sep = "_", sample_name, "R1"))
  call_mkdir_R1 <- paste("mkdir", "-p", output_fastqc_R1_path)
  
  #
  call_fastqc_R1 <- paste(fastqc_path,
                          "--outdir", output_fastqc_R1_path,
                          "--format", "fastq",
                          fastq_R1_filepath)
  
  #
  file_sh1 <- file.path("scripts", script_pipeline_dir , "01_fastqc_beforetrim", "batch_sh",
                       paste0("fastqc_beforetrim_", sample_name, "_R1.sh"))
  message("sbatch ", file_sh1)
  fileConn1 <- file(file_sh1)
  writeLines(c(header_sh, "\n", call_mkdir_R1, "\n", call_fastqc_R1), fileConn1)
  close(fileConn1)

  
  ##### R2
  #
  # message(" > R2")
  fastq_R2_filename <- df$fastq_R2_filename[i]
  fastq_R2_filepath <- file.path(workdir, "raw", fastq_folder, "raw_fastq", fastq_R2_filename)
  output_fastqc_R2_path <- file.path(workdir, "output", output_pipeline_dir, "fastqc_beforetrim_output", paste(sep = "_", sample_name, "R2"))
  call_mkdir_R2 <- paste("mkdir", "-p", output_fastqc_R2_path)
  
  #
  call_fastqc_R2 <- paste(fastqc_path,
                          "--outdir", output_fastqc_R2_path,
                          "--format", "fastq",
                          fastq_R2_filepath)
  
  #
  file_sh2 <- file.path("scripts", script_pipeline_dir , "01_fastqc_beforetrim", "batch_sh",
                        paste0("fastqc_beforetrim_", sample_name, "_R2.sh"))
  message("sbatch ", file_sh2)
  fileConn2 <- file(file_sh2)
  writeLines(c(header_sh, "\n", call_mkdir_R2, "\n", call_fastqc_R2), fileConn2)
  close(fileConn2)
}


