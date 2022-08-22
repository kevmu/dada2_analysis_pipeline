#!/bin/bash
#$ -S /bin/bash
#$ -N dada2_analysis_pipeline_job
#$ -j y
#$ -cwd
#$ -o dada2_analysis_pipeline.out
#$ -e dada2_analysis_pipeline.err
#$ -pe smp 10

#source /home/AAFC-AAC/dumonceauxt/miniconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.2

# Get the conda file path from source and activate the conda environment.
source ~/.bashrc
conda activate qiime2-2022.2

# The manifest input file that lists the sample ids, path to the fastq files and direction.#Manifest file must be .csv with column headers: sample-id,absolute-filepath,direction
#eg line: D01-01ppm2010_S10_L001,/home/AAFC-AAC/dumonceauxt/Topp_antifungal/pre_processing/downsampled/D01-01ppm2010_S10_L001.cutadapt.trim.merge.downsampled,forward
fastq_manifest_infile="/home/AAFC-AAC/muirheadk/projects/Macrosteles-Edel/pre_processing/fastq_sample_manifest.csv"

# Dataset Metadata input file.
dataset_metadata_file="/home/AAFC-AAC/muirheadk/projects/Macrosteles-Edel/Macrosteles-Edel_Metadata.txt"

# The dada2 classifier database file.
#dada2_classifier_file="/home/AAFC-AAC/muirheadk/projects/classifiers/unite_20171201/unite-ver7-99-classifier-01.12.2017.qza"
dada2_classifier_file="/home/AAFC-AAC/muirheadk/projects/classifiers/silva_16S_138_99_515_806/silva-138-99-classifier-515-806.qza"


# The number of threads to use in dada2.
num_threads=10

#Generate amplicon sequence variants (ASVs) using DADA2
#These seqs have already been trimmed/truncated so those parameters are 0
#qiime2_dada2.sh
trim_left=0
trunc_len=0

# Minimum length of sequences in bps to remove within the sequence length filtering step.
min_sequence_length=100

# Minimum number of samples to filter out features occuring only 1 sample using -p-min-samples. Use n > 1 (Default: 2)
min_num_samples=2

output_dir="/home/AAFC-AAC/muirheadk/projects/Macrosteles-Edel"
mkdir -p $output_dir

# The qiime output directory.
qiime_output_dir="${output_dir}/qiime2"
mkdir -p $qiime_output_dir

# The qiime2 import file.
dada2_demux_file="${qiime_output_dir}/single_end_demux_dada2.qza"

# Import the manifest input fileinto qiime demux format.
echo "Import the manifest input file into qiime demux format."
echo "qiime tools import\
 --type 'SampleData[SequencesWithQuality]'\
 --input-path ${fastq_manifest_infile}\
 --output-path ${dada2_demux_file}\
 --input-format SingleEndFastqManifestPhred33"

#exit 0;
 
#qiime tools import\
# --type 'SampleData[SequencesWithQuality]'\
# --input-path ${fastq_manifest_infile}\
# --output-path ${dada2_demux_file}\
# --input-format SingleEndFastqManifestPhred33
 
#exit 0;

dada2_rep_seqs_file="${qiime_output_dir}/rep_seqs_dada2.qza"
dada2_rep_seqs_min_len_file="${qiime_output_dir}/rep_seqs_${min_sequence_length}bp_dada2.qza"
dada2_table_file="${qiime_output_dir}/table_dada2.qza"
dada2_denoising_stats_file="${qiime_output_dir}/denoising_stats_dada2.qza"

dada2_table_min_len_file="${qiime_output_dir}/min_length_table_${min_sequence_length}bp_dada2.qza"
dada2_table_min_len_filtered_file="${qiime_output_dir}/min_length_${min_sequence_length}bp_filtered_table_dada2.qza"

dada2_taxonomy_file="${qiime_output_dir}/taxonomy_dada2.qza"

dada2_rep_seqs_filtered_file="${qiime_output_dir}/rep_seqs_filtered_dada2.qza"

# Plot files
dada2_table_filtered_plot_file="${qiime_output_dir}/filtered_table_plot_dada2.qzv"
dada2_rep_seqs_plot_file="${qiime_output_dir}/rep_seqs_plot_dada2.qzv"
dada2_taxonomy_plot_file="${qiime_output_dir}/taxonomy_plot_dada2.qzv"
dada2_taxa_bar_plot_file="${qiime_output_dir}/taxa_bar_plots_dada2.qzv"

# Output directories
dada2_stats_output_dir="${qiime_output_dir}/stats_exported_dada2"
dada2_rep_seqs_min_len_stats_output_dir="${qiime_output_dir}/rep_seqs_${min_sequence_length}bp_exported_dada2"
dada2_rep_seqs_output_dir="${qiime_output_dir}/rep_seqs_exported_dada2"

dada2_filtered_table_output_dir="${qiime_output_dir}/feature_table_filtered_exported"
feature_table_biom_file="${dada2_filtered_table_output_dir}/feature-table.biom"
feature_table_tsv_file="${dada2_filtered_table_output_dir}/feature-table.tsv"

phyloseq_biom_file="${qiime_output_dir}/phyloseq.biom"

phyloseq_tsv_file="${qiime_output_dir}/phyloseq.tsv"

dada2_taxonomy_output_dir="${qiime_output_dir}/taxonomy_exported_dada2"

dada2_rep_seqs_filtered_dir="${qiime_output_dir}/rep_seqs_filtered_exported_dada2"


taxonomy_tsv_file="${dada2_taxonomy_output_dir}/taxonomy.tsv"
phyloseq_taxonomy_tsv_file="${dada2_taxonomy_output_dir}/phyloseq_taxonomy.tsv"

echo "Running dada2 denoise-single...";
echo "qiime dada2 denoise-single \
 --p-n-threads ${num_threads} \
 --verbose \
 --i-demultiplexed-seqs ${dada2_demux_file} \
 --p-trim-left ${trim_left} \
 --p-trunc-len ${trunc_len} \
 --o-representative-sequences ${dada2_rep_seqs_file} \
 --o-table ${dada2_table_file} \
 --o-denoising-stats ${dada2_denoising_stats_file}"

#qiime dada2 denoise-single \
# --p-n-threads ${num_threads} \
# --verbose \
# --i-demultiplexed-seqs ${dada2_demux_file} \
# --p-trim-left ${trim_left} \
# --p-trunc-len ${trunc_len} \
# --o-representative-sequences ${dada2_rep_seqs_file} \
# --o-table ${dada2_table_file} \
# --o-denoising-stats ${dada2_denoising_stats_file}
 
#exit 0;

qiime tools export --input-path ${dada2_denoising_stats_file} --output-path ${dada2_stats_output_dir}

#Remove seqeunces less than 100bp

qiime feature-table filter-seqs \
    --i-data ${dada2_rep_seqs_file} \
    --m-metadata-file ${dada2_rep_seqs_file} \
    --p-where "length(sequence) > ${min_sequence_length}" \
    --o-filtered-data ${dada2_rep_seqs_min_len_file} \


#exit 0;

#generates a list of sequences > 100 bp - want just those ones
qiime tools export \
    --input-path ${dada2_rep_seqs_min_len_file} \
    --output-path ${dada2_rep_seqs_min_len_stats_output_dir}

#exit 0;

dada2_min_len_read_ids_file="${dada2_rep_seqs_min_len_stats_output_dir}/sequences_to_keep.txt"
if [ ! -s $dada2_min_len_read_ids_file ]; 
then	
	#gets the sequences you want
	echo "SampleID" >> ${dada2_min_len_read_ids_file}
	grep ">" \
	"${dada2_rep_seqs_min_len_stats_output_dir}/dna-sequences.fasta" \
	| sed 's/>//' \
	>> ${dada2_min_len_read_ids_file}
else
	echo "Have sequences_to_keep.txt";

fi

#exit 0;

#then manually add column header SampleID using nano; save changes

#examine number of sequences before and after 100 bp filtering

##export from before
#qiime tools export --input-path JJRLC_rep-seqs-dada2.qza --output-path JJRLC_rep-seqs-dada2-exported
##grep number of reads before and after, in both folders
#grep -c ">" dna-sequences.fasta
##folder after: JJRLC_rep-seqs-100bp-exported 
##foler before: JJRLC_rep-seqs-dada2-exported

#Filter the table using your txt file

#table now only has ASV sequences >100bp

qiime feature-table filter-features \
--i-table ${dada2_table_file} \
--m-metadata-file ${dada2_min_len_read_ids_file} \
--o-filtered-table ${dada2_table_min_len_file}

#exit 0;
#Filter out features occuring only in one sample; can change to other filters using -p min-samples. Often include things that are in at least 5% of the total number of samples
qiime feature-table filter-features \
  --i-table ${dada2_table_min_len_file} \
  --p-min-samples ${min_num_samples} \
  --o-filtered-table ${dada2_table_min_len_filtered_file}
#exit 0;  
  
#add metadata; create file using nano: JJRLC_Metadata.txt using the illumina sample sheet - has sample names and all associated metadata
qiime feature-table summarize \
 --i-table ${dada2_table_min_len_filtered_file} \
 --m-sample-metadata-file ${dataset_metadata_file} \
 --o-visualization ${dada2_table_filtered_plot_file}
 
#can visualize results of qzv file using qiime2view.org

#to view results, export to a tab-delimited table- can download and view in excel:
qiime tools export \
--input-path ${dada2_table_min_len_filtered_file} \
--output-path ${dada2_filtered_table_output_dir}

echo "biom convert \
 -i ${feature_table_biom_file} \
 -o ${feature_table_tsv_file} \
 --to-tsv"
biom convert \
 -i ${feature_table_biom_file} \
 -o ${feature_table_tsv_file} \
 --to-tsv

#make rep-seqs file - view using qiime2view.org
qiime tools export \
--input-path ${dada2_rep_seqs_file} \
--output-path ${dada2_filtered_table_output_dir}

qiime feature-table tabulate-seqs \
 --i-data ${dada2_rep_seqs_file} \
 --o-visualization ${dada2_rep_seqs_plot_file}

if [ ! -s $dada2_taxonomy_file ];
then
	echo "qiime feature-classifier classify-sklearn \
	--i-classifier ${dada2_classifier_file} \
	--i-reads ${dada2_rep_seqs_file} \
	--o-classification ${dada2_taxonomy_file}"

	qiime feature-classifier classify-sklearn \
	--i-classifier ${dada2_classifier_file} \
	--i-reads ${dada2_rep_seqs_file} \
	--o-classification  ${dada2_taxonomy_file}

else
	echo "taxonomy classification file exists."
fi

#start here 20201-06-29
qiime metadata tabulate \
  --m-input-file ${dada2_taxonomy_file} \
  --o-visualization ${dada2_taxonomy_plot_file}

qiime tools export \
  --input-path ${dada2_taxonomy_file} \
  --output-path ${dada2_taxonomy_output_dir}

#did this one 2021-06-29
qiime taxa barplot \
  --i-table ${dada2_table_min_len_filtered_file} \
  --i-taxonomy ${dada2_taxonomy_file} \
  --m-metadata-file ${dataset_metadata_file} \
  --o-visualization ${dada2_taxa_bar_plot_file}

qiime feature-table filter-seqs \
 --i-data ${dada2_rep_seqs_file}  \
 --i-table ${dada2_table_min_len_filtered_file} \
 --o-filtered-data ${dada2_rep_seqs_filtered_file}

qiime tools export \
--input-path ${dada2_rep_seqs_filtered_file} \
--output-path ${dada2_rep_seqs_filtered_dir} 
 
#Alpha Diversity
#Prepare for phyloseq - can do some statistics and visualization in R - also calculate statistics below using qiime2 and export to tsv or csv for viewing and analysis in Excel
#phyloseq
#Change taxonomy.tsv colnames to #OTUID, taxonomy, confidence, save as phyloseq_taxonomy.tsv
if [ ! -s $phyloseq_taxonomy_tsv_file ];
then
	echo -e "#OTUID\ttaxonomy\tconfidence" >> ${phyloseq_taxonomy_tsv_file}
	tail -n+2 < ${taxonomy_tsv_file} | sed -i 's/[a-z]__//g' >> ${phyloseq_taxonomy_tsv_file}
else
	echo "phyloseq_taxonomy.tsv already created."
fi

biom add-metadata \
-i ${feature_table_biom_file} \
-o ${phyloseq_biom_file} \
--observation-metadata-fp ${phyloseq_taxonomy_tsv_file} \
--sc-separated taxonomy \
--sample-metadata-fp ${dataset_metadata_file}


echo "biom convert \
 -i ${phyloseq_biom_file} \
 -o ${phyloseq_tsv_file} \
 --to-tsv"
biom convert \
 -i ${phyloseq_biom_file} \
 -o ${phyloseq_tsv_file} \
 --to-tsv


echo "The dada2_analysis_pipeline.sh script finished."
exit 0;
##transfer ITS_phyloseq.biom to folder R/Topp-soil-ITS/Data on local computer
##analyze using phyloseq
##folder structure in R/Topp-soil-ITS: 3 folders: Data; Figures; R_code
##Jen provided the R code; needs to be tuned to this data (ITS only) - data import, alpha diversity, beta diversity
##tutorials for phyloseq: https://joey711.github.io/phyloseq/preprocess.html http://evomics.org/wp-content/uploads/2016/01/phyloseq-Lab-01-Answers.html

##qiime statistics - calculate these and export for excel (tsv or csv)
##make day.txt
##make treatment.txt
##use nano - make sure syntax matches JJRLC_Metadata.txt - ie D0 D7 D30
##check code below for Metadata.txt; must change to JJRLC_Metadata.txt

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime feature-table filter-samples \
  # --i-table ${dada2_table_min_len_filtered_file} \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --p-where "[Day] = '$i'" \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_table-filtered.qza' \
# ; done

## rarefied data - to 10k
# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity core-metrics \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_table-filtered.qza' \
  # --p-sampling-depth 10000 \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --output-dir /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000' \
# ; done

##the command below yielded an error - There must be at least one metadata column that contains categorical data, isn't empty, doesn't consist of unique values, and doesn't consist of exactly one value.
# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000'/shannon_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_shannon_group_significance.qzv' \
# ; done

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000'/observed_otus_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_observed_otus_group_significance.qzv' \
# ; done 

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000'/evenness_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_evenness_group_significance.qzv' \
# ; done 

##repeat for treatment
# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime feature-table filter-samples \
  # --i-table ${dada2_table_min_len_filtered_file} \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --p-where "[Treatment] = '$i'" \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_table-filtered.qza' \
# ; done

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity core-metrics \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_table-filtered.qza' \
  # --p-sampling-depth 10000 \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --output-dir /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000' \
# ; done

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000'/shannon_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_shannon_group_significance.qzv' \
# ; done 

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000'/observed_features_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_observed_otus_group_significance.qzv' \
# ; done 

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000'/evenness_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_evenness_group_significance.qzv' \
# ; done 

##Permanova

# qiime diversity beta-group-significance \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --m-metadata-column Treatment \
  # --p-pairwise True \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_permanova_trt.qzv

# qiime diversity beta-group-significance \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --m-metadata-column Treatment \
  # --p-pairwise True \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_permanova_trt.qzv

# qiime diversity adonis \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --p-formula "Treatment*Day" \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_adonis_trt_day.qzv

# qiime diversity adonis \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --p-formula "Treatment*Day" \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_adonis_trt_day.qzv

##ANCOM

# qiime feature-table filter-samples \
  # --i-table ${dada2_table_min_len_filtered_file} \
  # --m-metadata-file ${dataset_metadata_file} \
  # --p-min-frequency 2000 \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-filtered-minfreq.qza

# qiime feature-table filter-features \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-filtered-minfreq.qza \
  # --p-min-frequency 10 \
  # --p-min-samples 4 \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom.qza

# qiime composition add-pseudocount \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom.qza \
  # --o-composition-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_comp.qza

# qiime composition ancom \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_comp.qza \
  # --m-metadata-file ${dataset_metadata_file} \
  # --m-metadata-column Treatment\
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt.qzv

# qiime tools export \
  # --input-path /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt.qzv \
  # --output-path /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt-exported

# awk '$3 == "True"' \
 # /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt-exported/ancom.tsv \
# > /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt-exported/JJRLC_TRUE_ancom.tsv 
