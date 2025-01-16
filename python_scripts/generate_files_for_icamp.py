import os
import re
import csv
import sys


# python /home/AGR.GC.CA/muirheadk/drought_dataset/dada2_analysis_pipeline/python_scripts/merge_phyloseq_abund_tax.py --phyloseq_abund_infile /home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/drought/dada2_analysis/drought_16S_515_926/qiime2/phyloseq.tsv --tax_infile  /home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/drought/dada2_analysis/drought_16S_515_926/qiime2/taxonomy_exported_dada2/phyloseq_taxonomy.tsv --output_dir /home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/drought/dada2_analysis/drought_16S_515_926/qiime2/parsed_dada2_files


# The dada2 phyloseq otu table tsv file.
dada2_phyloseq_tsv_file = "/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/drought/dada2_analysis/drought_16S_515_926/qiime2/parsed_dada2_files/phyloseq_abund.tsv"


# The dada2 taxonomy tsv file.
dada2_taxonomy_tsv_file = "/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/drought/dada2_analysis/drought_16S_515_926/qiime2/parsed_dada2_files/phyloseq_tax.tsv"

# The iCAMP files directory path.
icamp_dir = "/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/iCAMP_files"

# Create the iCAMP files directory.
if not os.path.exists(icamp_dir):
    os.makedirs(icamp_dir)

# The iCAMP taxonomy table file.
otu_table_icamp_file = os.path.join(icamp_dir, "drought_asv_table.txt")

print(otu_table_icamp_file)


#tail -n+2 ${dada2_phyloseq_tsv_file} | sed 's/#OTU ID/SpeciesID/g' > ${otu_table_icamp_file}
otu_table_icamp_output_file = open(otu_table_icamp_file, 'w+')
otu_table_icamp_writer = csv.writer(otu_table_icamp_output_file, delimiter='\t', quotechar='', quoting=csv.QUOTE_NONE)

i = 0
dada2_phyloseq_tsv_input_file = open(dada2_phyloseq_tsv_file, "r")
csv_reader = csv.reader(dada2_phyloseq_tsv_input_file, delimiter='\t')
for row in csv_reader:

    if(re.search(r'#OTU ID', row[0])):
        asv_id_header = row[0]
        #asv_id_header.replace("#OTU\ ID", "SpeciesID")
        row[0] = re.sub("#OTU ID", "SpeciesID", asv_id_header)
        #print(row)
        otu_table_icamp_writer.writerow(row)
    
    elif(i > 0):
        otu_table_icamp_writer.writerow(row)
        
    i+=1

# The iCAMP taxonomy table file.
tax_table_icamp_file = os.path.join(icamp_dir, "drought_tax_table.txt")

# Print the classifications.txt file header.
#echo -e "SpeciesID\tDomain\tPhylum\tClass\tOrder\tFamily\tGenus" > ${tax_table_icamp_file}
tax_table_icamp_output_file = open(tax_table_icamp_file, 'w+')
tax_table_icamp_writer = csv.writer(tax_table_icamp_output_file, delimiter='\t', quotechar='', quoting=csv.QUOTE_NONE)
tax_table_icamp_writer.writerow(["SpeciesID","Domain","Phylum","Class","Order","Family","Genus"])

# Iterate over the otu table icamp file for the list of asv ids.
i = 0
dada2_taxonomy_tsv_input_file = open(dada2_taxonomy_tsv_file, "r")
csv_reader = csv.reader(dada2_taxonomy_tsv_input_file, delimiter='\t')
for row in csv_reader:
    if(i != 0):
        print(row)
        asv_id = row[0]
        tax_lineage = row[1]
        print(tax_lineage)
        lineage_array = tax_lineage.split("; ")
        index = len(lineage_array) - 1
        if(len(lineage_array) > 6):
            lineage_array = lineage_array[0:6]
        print(index)
        while(index < 5):
            print(index)

            print(lineage_array[index])
            lineage_array.append(lineage_array[index])
            index+=1
        print(lineage_array)
        
        tax_table_icamp_writer.writerow([asv_id] + lineage_array)

    i+=1

#for taxonomy_entry in $(tail -n+2 ${dada2_taxonomy_tsv_file});
#do
	#echo $asv_id;
	# d__Bacteria; p__Myxococcota; c__Polyangia; o__Polyangiales; f__BIrii41; g__BIrii41

	# The taxonomy lineage string.
#	tax_lineage=$(echo $taxonomy_entry | cut -f2 | sed 's/[a-z]__//g');
	#echo $tax_lineage;
	
	# The taxonomy lineage array.
#	lineage_array=($(echo $tax_lineage | sed 's/; /\n/g')) 

	# The length of the taxonomy lineage array.
#	lineage_array_length=${#lineage_array[@]}

	# Current index is taxonomy lineage level.
#	index=$((lineage_array_length - 1))

	#echo $index
	# Add the last taxonomic level down to the genus level so we can make a "complete" lineage.
#	while [ $index -lt 5 ];
#	do
#		echo $index;
		
#		echo ${lineage_array[$index]}
#		lineage_array+=(${lineage_array[$index]});
#		index=$((index + 1));
#	done

	# The converted taxonomy lineage for iCAMP.
#	new_tax_lineage=$(echo ${lineage_array[@]:0:6} | sed 's/ /\t/g')

#	echo -e "${asv_id}\t${new_tax_lineage}"

	# Print the file contents to the iCAMP taxonomy table file.
#	echo -e "${asv_id}\t${new_tax_lineage}" >> ${tax_table_icamp_file}

#done


