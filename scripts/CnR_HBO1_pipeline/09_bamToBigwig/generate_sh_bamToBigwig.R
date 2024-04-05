setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)

##### mugqic
##### module load mugqic/deepTools

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
               "#SBATCH --cpus-per-task=16",
               "#SBATCH --mem-per-cpu=8G",
               "#SBATCH --account=def-stbil30",
               "#SBATCH --mail-user=christophe.tav@gmail.com",
               "#SBATCH --mail-type=ALL")

#
alignment_dir <- file.path("output", output_pipeline_dir, "alignment")
tracks_dir <- file.path("output", output_pipeline_dir, "tracks_byReplicate")

message("mkdir -p ", file.path(workdir, tracks_dir))

#
# bamCoverage_path <- "/cvmfs/soft.mugqic/CentOS6/software/deepTools/deepTools-3.5.0/bin/bamCoverage"

#
ENCODE_blacklist <- "input/ENCODE_exclusion_list_regions_ENCFF356LFX.bed"

#
norm <- "RPKM"

#
for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  # message("# ", i, " | ", sample_name)
  
  bam <- file.path(workdir, alignment_dir, sample_name, paste0(sample_name, ".sorted.markdup.filtered.bam"))
  bw <- file.path(workdir, tracks_dir, paste0(sample_name, "_mate1_", norm, ".bw"))
  
  # print(paste0(" > bam : ", bam))
  # print(paste0(" > bigwig : ", bw))
  
  #
  # call_bamCoverage <- paste("bamCoverage", "--extendReads", 225, "--binSize", 10,
  #                           "--smoothLength", 30,
  #                           "-p", 16,
  #                           "--normalizeUsing", norm,
  #                           "--blackListFileName", file.path(workdir, ENCODE_blacklist),
  #                           "-b", bam,
  #                           "-o", bw)
  # message(call_bamCoverage)
  
  # call_bamCoverage <- paste("bamCoverage",
  #                           # "--extendReads", 225,
  #                           "-e",
  #                           "--binSize", 50,
  #                           # "--smoothLength", 30,
  #                           "-p", 16,
  #                           "--normalizeUsing", norm,
  #                           "--blackListFileName", file.path(workdir, ENCODE_blacklist),
  #                           "-b", bam,
  #                           "-o", bw)
  
  call_bamCoverage <- paste("bamCoverage",
                            "--binSize", 1,
                            "-p", 16,
                            "--normalizeUsing", norm,
                            "--samFlagInclude", 64,
                            "--blackListFileName", file.path(workdir, ENCODE_blacklist),
                            "-b", bam,
                            "-o", bw)
  
  #
  file_sh <- file.path("scripts", script_pipeline_dir, "09_bamToBigwig", "batch_sh",
                       paste0("bamToBigwig_", sample_name, ".sh"))
  message("sbatch ", file_sh)
  fileConn <- file(file_sh)
  writeLines(c(header_sh, "\n", call_bamCoverage), fileConn)
  close(fileConn)
}