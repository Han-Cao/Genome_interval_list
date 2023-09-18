# Genome_interval_list
Interval list used for sequencing analysis

## Parallel analysis with subdivided interval lists

The major aim of this repo is to create interval lists to parallel GATK's joint calling. Spliting interval lists with subdivision produces small and scattered interval lists for parallel analysis. However, duplicated variant calls can appear at the boundaries of butting interval lists, especially with padding. To avoid this, one solution is to run GATK's joint calling with the subdivided interval lists, and then select output by start position (`POS` field) to remove duplicated calls. 

GATK's `SelectVariants` always selects by overlapping (i.e., any base of a indel within the interval will be selected), which cannot remove duplicated indels overlapping 2 intervals. The script `SelectVariantsByStart.py` accept GATK-style interval list to select variants by start position and is faster than `SelectVariants`. An alternative solution is to use `bcftools view --regions-overlap pos` with bcftools-style interval list.


## Interval list

**wgs_calling_regions.hg19.interval_list**: downloaded from gnomAD (https://storage.googleapis.com/gcp-public-data--gnomad/intervals/hg19-v0-wgs_evaluation_regions.v1.interval_list)

**wgs_calling_regions.hg19.extended.interval_list**: extended calling regions of wgs_calling_regions.hg19.interval_list. It covers all regions in the original interval list, but also includes those non-calling regions with known SNP/bp > 0.01 (dbSNP153).

**wgs_calling_regions.hg38.interval_list**: downloaded from gatk resource bundle (https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0/). Only include headers for analysis contigs.

<br/>



## Analysis intervals

**wgs_analysis_intervals_hg19**: converted from wgs_calling_regions.hg19.interval_list without subdivision

**wgs_analysis_intervals_hg19_extended**: converted from wgs_calling_regions.hg19.extended.interval_list without subdivision

**wgs_analysis_intervals_hg38**: converted from wgs_calling_regions.hg38.interval_list without subdivision

**wgs_analysis_intervals_hg38_subdivided**: converted from wgs_calling_regions.hg38.interval_list with subdivision

**wgs_analysis_intervals_hg38_subdivided_padding_bcftools**: 1kb padded bcftools-style interval list of wgs_analysis_intervals_hg38_subdivided


<br/>



## Script

**split_analysis_intervals.R**: split whole interval list into scattered interval lists without subdivision for parallel analysis. Compared to GATK's SplitIntervals, this script aims to limit the output interval list under a certain size (e.g., 50MB). This is usefull when SplitInterval --subdivision-mode BALANCING_WITHOUT_INTERVAL_SUBDIVISION cannot generate small enough interval lists. However,

**gatk_SplitIntervals.sh**: split interval list into even scattered interval lists with subdivision. It also generate (padded) bcftools-style interval lists.

**SelectVariantsByStart.py**: select variants by only start position (`pysam` is required). `INFO/END` will always added if is is defined in the header, as `pysam` considers it as a mandatory field.

<br/>

