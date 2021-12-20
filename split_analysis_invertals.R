# Split genome into intervals for analysis
# Usage: Rscript --vanilla split_analysis_invertals.R input_interval_list output_folder

# parse arguments
args <- commandArgs(trailingOnly=TRUE)
input_file <- args[1]
output_folder <- args[2]

if(! dir.exists(output_folder)){
  dir.create(output_folder)
}
output_prefix <- file.path(output_folder, "interval_")

# define functions
write_interval_list <- function(x, file, header){
  cat(header, sep = '\n',  file = file)
  write.table(x, file, sep = "\t", append = TRUE, quote = FALSE, row.names = FALSE, col.names = FALSE)
}

# read header
header <- readLines(input_file)
header <- header[grepl("^@", header)]

# read interval list
intervals <- read.table(input_file, sep = "\t", comment.char = "@")
colnames(intervals) <- c("chr", "start", "end", "strand", "name")

# split interval list
length_cutoff <- 5e7

intervals$length <- intervals$end - intervals$start
row_from <- 1
output_no <- 1
for (row_to in 1:nrow(intervals)) {
  # output if last
  if(row_to == nrow(intervals)){
    write_interval_list(intervals[row_from:row_to, 1:5], paste0(output_prefix, formatC(output_no, width=3, flag="0"), ".interval_list"), header = header)
  }
  # output if chromosome change
  else if(intervals[row_from, "chr"] != intervals[row_to+1, "chr"]){
    write_interval_list(intervals[row_from:row_to, 1:5], paste0(output_prefix, formatC(output_no, width=3, flag="0"), ".interval_list"), header = header)
    output_no <- output_no + 1
    row_from <- row_to + 1
    next
  }
  # output if total length > cutoff
  else if(sum(intervals[row_from:(row_to+1), "length"]) > length_cutoff){
    write_interval_list(intervals[row_from:row_to, 1:5], paste0(output_prefix, formatC(output_no, width=3, flag="0"), ".interval_list"), header = header)
    output_no <- output_no + 1
    row_from <- row_to + 1
    next
  }
}




