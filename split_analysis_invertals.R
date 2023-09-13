# Split genome into intervals for analysis
# Usage: Rscript --vanilla split_analysis_invertals.R input_interval_list output_folder

# set length cutoff
length_cutoff <- 5e7

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

add_interval_summary <- function(df_interval, df_res, name){
  n_interval <- nrow(df_interval)
  total_lenth <- sum(df_interval$end - df_interval$start)
  df_new <- data.frame(Name=name, N_interval=n_interval, Total_length=total_lenth)
  df_res <- rbind(df_res, df_new)
  return(df_res)
}

# read header
header <- readLines(input_file)
header <- header[grepl("^@", header)]

# read interval list
intervals <- read.table(input_file, sep = "\t", comment.char = "@")
colnames(intervals) <- c("chr", "start", "end", "strand", "name")

# split interval list
df_results <- data.frame()

intervals$length <- intervals$end - intervals$start
row_from <- 1
output_no <- 1
for (row_to in 1:nrow(intervals)) {
  # output if last
  if(row_to == nrow(intervals)){
    df_interval_new <- intervals[row_from:row_to, 1:5]
    fname <- paste0(output_prefix, formatC(output_no, width=3, flag="0"), ".interval_list")
    write_interval_list(df_interval_new, fname, header = header)
    df_results <- add_interval_summary(df_interval_new, df_results, name=basename(fname))
  }
  # output if chromosome change
  else if(intervals[row_from, "chr"] != intervals[row_to+1, "chr"]){
    df_interval_new <- intervals[row_from:row_to, 1:5]
    fname <- paste0(output_prefix, formatC(output_no, width=3, flag="0"), ".interval_list")
    write_interval_list(df_interval_new, fname, header = header)
    df_results <- add_interval_summary(df_interval_new, df_results, name=basename(fname))
    
    output_no <- output_no + 1
    row_from <- row_to + 1
    next
  }
  # output if total length > cutoff
  else if(sum(intervals[row_from:(row_to+1), "length"]) > length_cutoff){
    df_interval_new <- intervals[row_from:row_to, 1:5]
    fname <- paste0(output_prefix, formatC(output_no, width=3, flag="0"), ".interval_list")
    write_interval_list(df_interval_new, fname, header = header)
    df_results <- add_interval_summary(df_interval_new, df_results, name=basename(fname))

    output_no <- output_no + 1
    row_from <- row_to + 1
    next
  }
}

write.table(df_results, file.path(output_folder, "interval_list_summary.txt"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)



