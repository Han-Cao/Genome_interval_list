# Genome_interval_list
Interval list used for sequencing analysis



### Interval list

***

**wgs_calling_regions.hg19.interval_list**: downloaded from gnomAD (https://storage.googleapis.com/gcp-public-data--gnomad/intervals/hg19-v0-wgs_evaluation_regions.v1.interval_list)

**wgs_calling_regions.hg38.interval_list**: downloaded from gatk resource bundle (https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0/)

<br/>



### Analysis intervals

***

**wgs_analysis_intervals_hg19**: converted from wgs_calling_regions.hg19.interval_list

<br/>



### Code

***

**split_analysis_intervals.R**: split whole interval list into scattered interval lists for parallel analysis

<br/>

