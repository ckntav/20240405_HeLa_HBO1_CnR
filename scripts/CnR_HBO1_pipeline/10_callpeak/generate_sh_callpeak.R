setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)

##### mugqic
##### module load mugqic/deepTools/3.5.0

#
fastq_list_filename <- "20240405_CnR_HBO1_fastq_list.txt"
df <- read_tsv(file.path("input", "cnr_HBO1", fastq_list_filename)) %>% 
  dplyr::filter(antibody != "IgG")
fastq_folder <- "cnr_HBO1"
output_pipeline_dir <- "cnr-pipeline_HBO1-GRCh38_PE"
script_pipeline_dir <- "CnR_HBO1_pipeline"
workdir <- "/home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR"

#
header_sh <- c("#!/bin/sh",
               "#SBATCH --time=3:00:00",
               "#SBATCH --nodes=1",
               "#SBATCH --ntasks-per-node=1",
               "#SBATCH --cpus-per-task=16",
               "#SBATCH --mem-per-cpu=8G",
               "#SBATCH --account=def-stbil30",
               "#SBATCH --mail-user=christophe.tav@gmail.com",
               "#SBATCH --mail-type=ALL")

#
alignment_dir <- file.path("output", output_pipeline_dir, "alignment")

#
for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  cell_line <- df$cell_line[i]
  knock_out <- df$knock_out[i]
  # message("# ", i, " | ", sample_name)
  
  #
  bam_trt <- file.path(workdir, alignment_dir, sample_name, paste0(sample_name, ".sorted.markdup.filtered.bam"))
  
  #
  sample_name_ctrl <- paste(sep = "_", cell_line, knock_out, "IgG", "rep1")
  
  #
  # if (cell_line == "VCAP") {
  #   sample_name_ctrl <- "VCAP_IgG_R1881"
  # } else if (cell_line == "LAPC4") {
  #   sample_name_ctrl <- "LAPC4_IgG_DHT"
  # }
  
  bam_ctrl <- file.path(workdir, alignment_dir, sample_name_ctrl, paste0(sample_name_ctrl, ".sorted.markdup.filtered.bam"))
  
  
  #
  peak_dir <- file.path(workdir, "output", output_pipeline_dir, "peak_call", sample_name)
  
  #
  call_mkdir <- paste("mkdir", "-p", peak_dir)
  call_touch <- paste("touch", peak_dir)
  
  #
  call_callpeak <- paste("macs2", "callpeak",
                         "--format", "BAMPE",
                         # "--nomodel",
                         "--gsize 2479938032.8",
                         "--treatment", bam_trt,
                         "--control", bam_ctrl,
                         # "--nolambda",
                         # "-q", "0.01",
                         "--name", paste0(peak_dir, "/", sample_name),
                         ">&", paste0(peak_dir, "/", sample_name, ".diag.macs.out"))
  
  # TODO tester sans le CTRL
  
  # message(call_callpeak)
  
  file_sh <- file.path("scripts", script_pipeline_dir, "10_callpeak", "batch_sh",
                       paste0("callpeak_", sample_name, ".sh"))
  message("sbatch ", file_sh)
  fileConn <- file(file_sh)
  writeLines(c(header_sh, "\n", call_mkdir, "\n", call_touch, "\n", call_callpeak), fileConn)
  close(fileConn)
}
