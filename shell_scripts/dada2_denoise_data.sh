#!/bin/bash
#$ -S /bin/bash
#$ -N dada2_analysis_pipeline_job
#$ -j y
#$ -cwd
#$ -o dada2_analysis_pipeline.out
#$ -e dada2_analysis_pipeline.err
#$ -pe smp 10

### Generate amplicon sequence variants (ASVs) using DADA2

#source /home/AAFC-AAC/dumonceauxt/miniconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.2

# Get the conda file path from source and activate the conda environment.
source ~/.bashrc
conda activate qiime2-2022.2

# The manifest input file that lists the sample ids, path to the fastq files and direction.
#Manifest file must be .csv with column headers: sample-id,absolute-filepath,direction
#eg line: D01-01ppm2010_S10_L001,/home/AAFC-AAC/dumonceauxt/Topp_antifungal/pre_processing/downsampled/D01-01ppm2010_S10_L001.cutadapt.trim.merge.downsampled,forward
fastq_manifest_infile="/home/AGR.GC.CA/muirheadk/macrosteles/macrosteles_edel_22/pre_processing/fastq_sample_manifest.csv"

# Dataset Metadata input file.
dataset_metadata_file="/home/AGR.GC.CA/muirheadk/macrosteles/macrosteles_edel_22/macrosteles_edel_22_metadata.txt"

## The dada2 classifier database file.
# Unite ITS classifier Database.
#dada2_classifier_file="/home/AAFC-AAC/muirheadk/projects/classifiers/unite_20171201/unite-ver7-99-classifier-01.12.2017.qza"
# SILVA 16S classifier database file.
dada2_classifier_file="/home/AGR.GC.CA/muirheadk/dada2_databases/silva_16S_138_99_515_806/classifiers/silva_16S_138_99_515_806/silva-138-99-classifier-515-806.qza"

# The output directory to write output files.
output_dir="/home/AGR.GC.CA/muirheadk/macrosteles/macrosteles_edel_22"
mkdir -p $output_dir

# The number of threads to use in dada2.
num_threads=10

#These seqs have already been trimmed/truncated so those parameters are 0
trim_left=0
trunc_len=0

# Minimum length of sequences in bps to remove within the sequence length filtering step.
min_sequence_length=100

# Minimum number of samples to filter out features occuring only 1 sample using -p-min-samples. Use n > 1 (Default: 2)
min_num_samples=2

# The qiime output directory.
qiime_output_dir="${output_dir}/qiime2"
mkdir -p $qiime_output_dir

# The qiime2 import file.
dada2_demux_file="${qiime_output_dir}/single_end_demux_dada2.qza"

# Import the manifest input file into qiime demux format.
if [ ! -s $dada2_demux_file ];
then
    echo "Import the manifest input file into qiime demux format."
    echo "qiime tools import\
     --type 'SampleData[SequencesWithQuality]'\
     --input-path ${fastq_manifest_infile}\
     --output-path ${dada2_demux_file}\
     --input-format SingleEndFastqManifestPhred33"
     
    qiime tools import\
    --type 'SampleData[SequencesWithQuality]'\
    --input-path ${fastq_manifest_infile}\
    --output-path ${dada2_demux_file}\
    --input-format SingleEndFastqManifestPhred33
    
 else
    dada2_demux_filename=$(basename $dada2_demux_file)
    echo "The ${dada2_demux_filename} file has already been created. Skipping to next set of commands!!!"
 fi
 
## The qiime2 dada2 Files.
dada2_rep_seqs_file="${qiime_output_dir}/rep_seqs_dada2.qza"
dada2_rep_seqs_min_len_file="${qiime_output_dir}/rep_seqs_${min_sequence_length}bp_dada2.qza"
dada2_table_file="${qiime_output_dir}/table_dada2.qza"
dada2_denoising_stats_file="${qiime_output_dir}/denoising_stats_dada2.qza"

# Minimum length dada2 table files.
dada2_table_min_len_file="${qiime_output_dir}/min_length_table_${min_sequence_length}bp_dada2.qza"
# Minimum length dada2 table file.
dada2_table_min_samples_filtered_file="${qiime_output_dir}/min_length_${min_sequence_length}bp_filtered_table_dada2.qza"

# The taxonomy dada2 file.
dada2_taxonomy_file="${qiime_output_dir}/taxonomy_dada2.qza"

# The representative sequences filtered dada2 file.
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
dada2_rep_seqs_filtered_dir="${qiime_output_dir}/rep_seqs_filtered_exported_dada2"

# Filtered feature table directory and files
dada2_filtered_table_output_dir="${qiime_output_dir}/feature_table_filtered_exported"
feature_table_biom_file="${dada2_filtered_table_output_dir}/feature-table.biom"
feature_table_tsv_file="${dada2_filtered_table_output_dir}/feature-table.tsv"

# Taxonomy classification files.
dada2_taxonomy_output_dir="${qiime_output_dir}/taxonomy_exported_dada2"
taxonomy_tsv_file="${dada2_taxonomy_output_dir}/taxonomy.tsv"
phyloseq_taxonomy_tsv_file="${dada2_taxonomy_output_dir}/phyloseq_taxonomy.tsv"


# Phyloseq abundance files.
phyloseq_abund_biom_file="${qiime_output_dir}/phyloseq.biom"
phyloseq_abund_tsv_file="${qiime_output_dir}/phyloseq.tsv"


# Run the dada2 denoise-single command to obtain the.
if [ ! -s  $dada2_rep_seqs_file ] && [  ! -s $dada2_table_file ] && [ ! -s $dada2_denoising_stats_file ];
then

    echo "Running dada2 denoise-single command...";
    echo "qiime dada2 denoise-single \
     --p-n-threads ${num_threads} \
     --verbose \
     --i-demultiplexed-seqs ${dada2_demux_file} \
     --p-trim-left ${trim_left} \
     --p-trunc-len ${trunc_len} \
     --o-representative-sequences ${dada2_rep_seqs_file} \
     --o-table ${dada2_table_file} \
     --o-denoising-stats ${dada2_denoising_stats_file}"

    qiime dada2 denoise-single \
     --p-n-threads ${num_threads} \
     --verbose \
     --i-demultiplexed-seqs ${dada2_demux_file} \
     --p-trim-left ${trim_left} \
     --p-trunc-len ${trunc_len} \
     --o-representative-sequences ${dada2_rep_seqs_file} \
     --o-table ${dada2_table_file} \
     --o-denoising-stats ${dada2_denoising_stats_file}
     
else
    echo "The dada2 denoise-single output files have already been created."
    dada2_rep_seqs_filename=$(basename $dada2_rep_seqs_file)
    echo "The ${dada2_rep_seqs_filename} file has already been created. Skipping to next set of commands!!!"
    dada2_table_filename=$(basename $dada2_table_file)
    echo "The ${dada2_table_filename} file has already been created. Skipping to next set of commands!!!"
    dada2_denoising_stats_filename=$(basename $dada2_denoising_stats_file)
    echo "The ${dada2_denoising_stats_filename} file has already been created. Skipping to next set of commands!!!"
    
fi

# Convert the dada2 denoising statistics file to a tab-delimited file.
dada2_stats_tsv_file="${dada2_stats_output_dir}/stats.tsv"
if [ ! -s $dada2_stats_tsv_file ];
then
    echo "qiime tools export --input-path ${dada2_denoising_stats_file} --output-path ${dada2_stats_output_dir}"
    qiime tools export --input-path ${dada2_denoising_stats_file} --output-path ${dada2_stats_output_dir}
else
    dada2_stats_tsv_filename=$(basename $dada2_stats_tsv_file)
    echo "The ${dada2_stats_tsv_filename} file has already been created. Skipping to next set of commands!!!"
fi

echo "The dada2_denoise_data.sh script has finished."

exit 0;

