import pysam
import argparse

parser = argparse.ArgumentParser(description='Select variants only by start position')
parser.add_argument('-i', '--input', help='Input VCF file', required=True)
parser.add_argument('-o', '--output', help='Output VCF file', required=True)
parser.add_argument('-L', '--interval-list', help='Interval list file', required=True)

args = parser.parse_args()

vcf_in = pysam.VariantFile(args.input)
vcf_out = pysam.VariantFile(args.output, 'w', header=vcf_in.header)

intervals = []
with open(args.interval_list, 'r') as f:
    for line in f:
        # skip headers
        if line.startswith('@'):
            continue
        # parse intervals
        line_split = line.strip().split('\t')
        interval_dict = {'chr': line_split[0], 'start': int(line_split[1]), 'end': int(line_split[2])}
        intervals.append(interval_dict)

for interval in intervals:
    chr = interval['chr']
    start = interval['start']
    end = interval['end']

    # pysam fetch is 0-based, interval list is 1-based, so start-1
    for x in vcf_in.fetch(chr, start-1, end):
        if (x.pos >= start) and (x.pos <= end):
            vcf_out.write(x)

vcf_in.close()
vcf_out.close()
pysam.tabix_index(args.output, preset='vcf')
