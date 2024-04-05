setwd("/Users/chris/Desktop/20240405_HeLa_HBO1_CnR")

library(tidyverse)
library(GenomicRanges)

#
fastq_list_filename <- "20240405_CnR_HBO1_fastq_list.txt"
df <- read_tsv(file.path("input", "cnr_HBO1", fastq_list_filename)) %>% 
  dplyr::filter(antibody != "IgG")
fastq_folder <- "cnr_HBO1"
output_pipeline_dir <- "cnr-pipeline_HBO1-GRCh38_PE"
script_pipeline_dir <- "CnR_HBO1_pipeline"
workdir <- "/home/chris11/projects/def-stbil30/chris11/20240405_HeLa_HBO1_CnR"

#
ENCODE_elr <- rtracklayer::import("input/ENCODE_exclusion_list_regions_ENCFF356LFX.bed")
stdChr <- paste0("chr", c(seq(1:22), "X", "Y"))
peaks_dir <- file.path("output", output_pipeline_dir, "peak_call")

for (i in 1:nrow(df)) {
  sample_name <- df$sample_name[i]
  antibody_factor <- df$antibody[i]
  # condition_i <- df$condition[i]
  rep_i <- df$replicate[i]
  cell_line_i <- df$cell_line[i]
  knock_out_i <- df$knock_out[i]
  
  # line <- df[i, ]
  # timepoint_i <- line %>% pull(time_point)
  # rep_i <- line %>% pull(isogenic_replicate)
  message("# ", sample_name)
  
  basename <- paste(cell_line_i, knock_out_i, antibody_factor, rep_i, sep = "_")
  message("   > ", basename)
  
  peaks_path <- file.path(peaks_dir, basename, paste0(basename, "_peaks.narrowPeak"))
  
  #
  peaks_raw <- rtracklayer::import(peaks_path)
  seqlevelsStyle(peaks_raw) <- "UCSC"
  
  message("\tRaw number of peaks : ", length(peaks_raw))
  
  #
  message("\t> Remove ", length(peaks_raw[!seqnames(peaks_raw) %in% stdChr]), " regions not on standard chromosomes")
  peaks_stdchr <- keepSeqlevels(peaks_raw, stdChr[stdChr %in% seqlevels(peaks_raw)], pruning.mode = "coarse")
  # message("\tNumber of peaks on standard chromosomes : ", length(peaks_stdchr))
  
  #
  message("\t> Remove ", length(subsetByOverlaps(peaks_stdchr, ENCODE_elr)), " excluded ENCODE regions")
  peaks_notbl <- subsetByOverlaps(peaks_stdchr, ENCODE_elr, invert = TRUE)
  
  # message("\tNumber of peaks not on the ENCODE exclusion list regions : ", length(peaks_notbl))
   
  #
  message("\tFinal number of peaks : ", length(peaks_notbl))
  output_filename <- paste0(basename, "_peaks.narrowPeak.stdchr.bed")
  output_path <- file.path(peaks_dir, basename, output_filename)
  # message("\t", output_path)
  rtracklayer::export(peaks_notbl, con = output_path, format = "bed")
}
