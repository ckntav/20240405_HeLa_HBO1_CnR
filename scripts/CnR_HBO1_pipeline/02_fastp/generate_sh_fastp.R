setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)

##### module load fastp/0.23.4

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

fastp_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/fastp/0.23.4/bin/fastp"

for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  # message("# ", i, " | ", sample_name)
  
  ##### R1 & R2
  # message(" > R1 & R2")
  in_fastq_R1_filename <- df$fastq_R1_filename[i]
  in_fastq_R1_filepath <- file.path(workdir, "raw", fastq_folder, "raw_fastq", in_fastq_R1_filename)
  in_fastq_R2_filename <- df$fastq_R2_filename[i]
  in_fastq_R2_filepath <- file.path(workdir, "raw", fastq_folder, "raw_fastq", in_fastq_R2_filename)
  
  output_fastp_dir <- file.path(workdir, "output", output_pipeline_dir, "fastp_output", sample_name)
  call_mkdir_fastpdir <- paste("mkdir", "-p", output_fastp_dir)
  
  output_fastq_dir <- file.path(workdir, "raw", fastq_folder, "fastp_output")
  call_mkdir_fastqdir <- paste("mkdir", "-p", output_fastq_dir)
  
  out_fastq_R1_filename <- paste0(sample_name, "_1.fastq.gz")
  out_fastq_R1_filepath <- file.path(output_fastq_dir, out_fastq_R1_filename)
  out_fastq_R2_filename <- paste0(sample_name, "_2.fastq.gz")
  out_fastq_R2_filepath <- file.path(output_fastq_dir, out_fastq_R2_filename)
  
  out_html_report <- file.path(output_fastp_dir, paste0(sample_name, "_fastp_report.html"))
  out_json_report <- file.path(output_fastp_dir, paste0(sample_name, "_fastp_report.json"))
  
  call_fastp <- paste(fastp_path,
                      "--in1", in_fastq_R1_filepath,
                      "--in2", in_fastq_R2_filepath,
                      "--detect_adapter_for_pe",
                      # "--dedup", "--dup_calc_accuracy", 6,
                      "--overrepresentation_analysis",
                      "--overrepresentation_sampling", 10,
                      "--thread", 8,
                      "--length_required", 99,
                      "--out1", out_fastq_R1_filepath,
                      "--out2", out_fastq_R2_filepath,
                      "--html", out_html_report,
                      "--json", out_json_report)
  
  file_sh <- file.path("scripts", script_pipeline_dir, "02_fastp", "batch_sh",
                       paste0("fastp_", sample_name, ".sh"))
  message("sbatch ", file_sh)
  fileConn <- file(file_sh)
  writeLines(c(header_sh, "\n", call_mkdir_fastpdir, "\n", call_mkdir_fastqdir, "\n", call_fastp), fileConn)
  close(fileConn)
}


