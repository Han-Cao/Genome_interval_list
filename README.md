# Genome_interval_list
Interval list used for sequencing analysis



## Interval list

**wgs_calling_regions.hg19.interval_list**: downloaded from gnomAD (https://storage.googleapis.com/gcp-public-data--gnomad/intervals/hg19-v0-wgs_evaluation_regions.v1.interval_list)

**wgs_calling_regions.hg19.extended.interval_list**: extended calling regions of wgs_calling_regions.hg19.interval_list. It covers all regions in the original interval list, but also includes those non-calling regions with known SNP/bp > 0.01 (dbSNP153).

**wgs_calling_regions.hg38.interval_list**: downloaded from gatk resource bundle (https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0/)

<br/>



## Analysis intervals

**wgs_analysis_intervals_hg19**: converted from wgs_calling_regions.hg19.interval_list

**wgs_analysis_intervals_hg19_extended**: converted from wgs_calling_regions.hg19.extended.interval_list

**wgs_analysis_intervals_hg38**: converted from wgs_calling_regions.hg38.interval_list

**interval_list_summary.txt**: summary of interval_list, including number of intervals, total length.

<br/>



## Code

**split_analysis_intervals.R**: split whole interval list into scattered interval lists for parallel analysis. Compared to GATK's SplitIntervals, this script aims to limit the output interval list under a certain size (e.g., 50MB) and avoid generating interval lists covering different chromosomes. Intervals greater than the upper limit will not be split.

<br/>

