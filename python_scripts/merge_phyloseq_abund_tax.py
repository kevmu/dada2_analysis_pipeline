#!/usr/bin/python
import os
import sys
import re
import csv
import argparse

parser = argparse.ArgumentParser()

# Sample command
# 
phyloseq_abund_infile = None
tax_infile = None
output_dir = None

parser.add_argument('--phyloseq_abund_infile', action='store', dest='phyloseq_abund_infile',
                            help='phyloseq abundance count tsv file as input. (i.e. $HOME)')
parser.add_argument('--tax_infile', action='store', dest='tax_infile',
                            help='taxonomy tsv file as input. (i.e. $HOME)')
parser.add_argument('--output_dir', action='store', dest='output_dir',
                            help='output directory as input. (i.e. $HOME)')
parser.add_argument('--version', action='version', version='%(prog)s 1.0')

results = parser.parse_args()

phyloseq_abund_infile = results.phyloseq_abund_infile
tax_infile = results.tax_infile
output_dir = results.output_dir

if(phyloseq_abund_infile == None):
    print('\n')
    print('error: please use the --phyloseq_abund_infile option to specify the phyloseq abundance count tsv file as input')
    print('phyloseq_abund_infile =' + ' ' + str(phyloseq_abund_infile))
    print('\n')
    parser.print_help()
    sys.exit(1)
if(tax_infile == None):
    print('\n')
    print('error: please use the --tax_infile option to specify the taxonomy tsv file as input')
    print('tax_infile =' + ' ' + str(tax_infile))
    print('\n')
    parser.print_help()
    sys.exit(1)
if(output_dir == None):
    print('\n')
    print('error: please use the --output_dir option to specify the output directory as input')
    print('output_dir =' + ' ' + str(output_dir))
    print('\n')
    parser.print_help()
    sys.exit(1)

if not os.path.exists(output_dir):
    os.makedirs(output_dir)


phyloseq_abund_header = ""
phyloseq_abund_data = {}
i = 0
with open(phyloseq_abund_infile, "r") as phyloseq_abund_input_file:
    csv_reader = csv.reader(phyloseq_abund_input_file, delimiter='\t')
    for row in csv_reader:

        #print(row)
        #sys.exit()
        if(i != 0):
            if(i == 1): # Keeping header for merged file.
                phyloseq_abund_header = row
                print(phyloseq_abund_header)
            else:
                dada2_seq_id = row[0]
                print(dada2_seq_id)
                phyloseq_abund_data[dada2_seq_id] = row
        i += 1
        
tax_data = {}
i = 0
with open(tax_infile, "r") as tax_input_file:
    csv_reader = csv.reader(tax_input_file, delimiter='\t')
    for row in csv_reader:

        #print(row)
        #sys.exit()
        if(i != 0):
            print(row)
            dada2_seq_id = row[0]
            print(dada2_seq_id)
            tax_data[dada2_seq_id] = row
        i += 1
       
merged_phyloseq_abund_tax_tsv_outfile = os.path.join(output_dir, "merged_phyloseq_abund_tax.tsv")
merged_phyloseq_abund_tax_tsv_output_file = open(merged_phyloseq_abund_tax_tsv_outfile, 'w+')
merged_phyloseq_abund_tax_tsv_writer = csv.writer(merged_phyloseq_abund_tax_tsv_output_file, delimiter='\t', quotechar='', quoting=csv.QUOTE_NONE)
merged_phyloseq_abund_tax_tsv_writer.writerow(["#OTUID","taxonomy","confidence"] + phyloseq_abund_header[1:])
for dada2_seq_id in phyloseq_abund_data:
    print(dada2_seq_id)
    if(dada2_seq_id in tax_data):
        merged_phyloseq_abund_tax_tsv_writer.writerow(tax_data[dada2_seq_id] + phyloseq_abund_data[dada2_seq_id][1:])

phyloseq_tax_tsv_outfile = os.path.join(output_dir, "phyloseq_tax.tsv")
phyloseq_tax_tsv_output_file = open(phyloseq_tax_tsv_outfile, 'w+')
phyloseq_tax_tsv_writer = csv.writer(phyloseq_tax_tsv_output_file, delimiter='\t', quotechar='', quoting=csv.QUOTE_NONE)
phyloseq_tax_tsv_writer.writerow(["#OTUID","taxonomy","confidence"])
for dada2_seq_id in phyloseq_abund_data:
    print(dada2_seq_id)
    if(dada2_seq_id in tax_data):
        phyloseq_tax_tsv_writer.writerow(tax_data[dada2_seq_id])

phyloseq_abund_tsv_outfile = os.path.join(output_dir, "phyloseq_abund.tsv")
phyloseq_abund_tsv_output_file = open(phyloseq_abund_tsv_outfile, 'w+')
phyloseq_abund_tsv_writer = csv.writer(phyloseq_abund_tsv_output_file, delimiter='\t', quotechar='', quoting=csv.QUOTE_NONE)
phyloseq_abund_tsv_writer.writerow(phyloseq_abund_header)
for dada2_seq_id in phyloseq_abund_data:
    print(dada2_seq_id)
    phyloseq_abund_tsv_writer.writerow(phyloseq_abund_data[dada2_seq_id])


