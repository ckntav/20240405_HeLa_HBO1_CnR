setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)

##### module load bowtie2/2.5.1 samtools/1.17

#
fastq_list_filename <- "20240405_CnR_HBO1_fastq_list.txt"
df <- read_tsv(file.path("input", "cnr_HBO1", fastq_list_filename))
fastq_folder <- "cnr_HBO1"
output_pipeline_dir <- "cnr-pipeline_HBO1-GRCh38_PE"
script_pipeline_dir <- "CnR_HBO1_pipeline"
workdir <- "/home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR"

#
header_sh <- c("#!/bin/sh",
               "#SBATCH --time=12:00:00",
               "#SBATCH --nodes=1",
               "#SBATCH --ntasks-per-node=1",
               "#SBATCH --cpus-per-task=4",
               "#SBATCH --mem-per-cpu=32G",
               "#SBATCH --account=def-stbil30",
               "#SBATCH --mail-user=christophe.tav@gmail.com",
               "#SBATCH --mail-type=ALL")

#
# bowtie2_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/bowtie2/2.5.1/bin/bowtie2"
bowtie2_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2023/x86-64-v3/Compiler/gcccore/bowtie2/2.5.2/bin/bowtie2"
# samtools_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/samtools/1.17/bin/samtools"
samtools_path <- "/cvmfs/soft.computecanada.ca/easybuild/software/2023/x86-64-v3/Compiler/gcccore/samtools/1.18/bin/samtools"
bowtie2_hg38_idx <- file.path(workdir, "input/bowtie2_genome_index_homo_sapiens/Homo_sapiens.GRCh38")

#
nThreads <- 8

for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  # message("# ", i, " | ", sample_name)
  
  #
  output_fastp_dir <- file.path(workdir, "raw", fastq_folder, "fastp_output")
  output_bowtie2_dir <- file.path(workdir, "output", output_pipeline_dir, "alignment", sample_name)
  call_mkdir_align <- paste("mkdir", "-p", output_bowtie2_dir)
  
  # fastq files
  fastq_R1_filename <- paste0(sample_name, "_1.fastq.gz")
  fastq_R1_filepath <- file.path(output_fastp_dir, fastq_R1_filename)
  fastq_R2_filename <- paste0(sample_name, "_2.fastq.gz")
  fastq_R2_filepath <- file.path(output_fastp_dir, fastq_R2_filename)
  
  # logdir
  log_filename <- paste0(sample_name, ".bowtie2.log")
  log_filepath <- file.path(output_bowtie2_dir , log_filename)
  
  #
  bam_filename <- paste0(sample_name, ".bam")
  bam_filepath <- file.path(output_bowtie2_dir , bam_filename)
  
  # call bowtie2
  call_bowtie2 <- paste(bowtie2_path,
                        "-1", fastq_R1_filepath,
                        "-2", fastq_R2_filepath,
                        "-x", bowtie2_hg38_idx,
                        "--local", "--very-sensitive-local",
                        # "--end-to-end", "--very-sensitive",
                        #"--no-unal",
                        "--no-mixed",
                        "--no-discordant",
                        "--phred33",
                        #"--dovetail",
                        "-I", "10",
                        "-X", "700",
                        "--threads", nThreads,
                        "2>", log_filepath, "|",
                        samtools_path, "view", "-bS",
                        ">", bam_filepath)
  
  # TODO samtools sort directement ici
  
  # message(" > cmd line : ", call_bowtie2)
  
  # generate scripts
  file_sh <- file.path("scripts", script_pipeline_dir, "04_align_with_bowtie2", "batch_sh",
                        paste0("align_with_bowtie2_", sample_name, ".sh"))
  message("sbatch ", file_sh)
  fileConn <- file(file_sh)
  writeLines(c(header_sh, "\n", call_mkdir_align, "\n", call_bowtie2), fileConn)
  close(fileConn)
  # message(" > Saved in ", file_sh)
}