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

# The output directory to write output files.
output_dir="/home/AGR.GC.CA/muirheadk/macrosteles/macrosteles_edel_22"
mkdir -p $output_dir

# The number of threads to use in dada2.
num_threads=10

#These seqs have already been trimmed/truncated so those parameters are 0
trim_left=0
trunc_len=0

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
dada2_table_file="${qiime_output_dir}/table_dada2.qza"
dada2_denoising_stats_file="${qiime_output_dir}/denoising_stats_dada2.qza"

# Output directories
dada2_stats_output_dir="${qiime_output_dir}/stats_exported_dada2"

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

