#!/bin/bash

# no padding
gatk SplitIntervals \
-R "GRCh38.fa" \
-L wgs_calling_regions.hg38.interval_list \
--scatter-count 200 \
--subdivision-mode INTERVAL_SUBDIVISION \
--dont-mix-contigs \
--interval-file-prefix interval_ \
--extension .interval_list \
--interval-file-num-digits 3 \
-O wgs_analysis_intervals_hg38_subdivided

# bcftools-stype interval list
ls wgs_analysis_intervals_hg38_subdivided/*interval_list | while read interval;
do
    name=$(basename $interval)
    grep -v "^@" $interval | cut -f 1-3 > wgs_analysis_intervals_hg38_subdivided_bcftools/${name}
done

# padding
ls wgs_analysis_intervals_hg38_subdivided/*interval_list | while read interval;
do
    name=$(basename $interval)
    gatk PreprocessIntervals \
    -R "GRCh38.fa" \
    -L $interval \
    --padding 1000 \
    --bin-length 0 \
    --interval-merging-rule OVERLAPPING_ONLY \
    -O wgs_analysis_intervals_hg38_subdivided_padding/${name}
done

# padded bcftools-stype interval list:
# remove headers and merge butting intervals within the same interval_list for bcftools
ls wgs_analysis_intervals_hg38_subdivided_padding/*interval_list | while read interval;
do
    name=$(basename $interval)
    grep -v "^@" $interval | awk '{print $1"\t"$2"\t"$3}' | \
    bedtools merge -d 1 -i - > wgs_analysis_intervals_hg38_subdivided_padding_bcftools/${name}
done