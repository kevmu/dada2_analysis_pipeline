#!/bin/bash
#$ -S /bin/bash
#$ -N dada2_analysis_pipeline_job
#$ -j y
#$ -cwd
#$ -o dada2_analysis_pipeline.out
#$ -e dada2_analysis_pipeline.err
#$ -pe smp 10

### Use the dada2 denoising software for error correction before ASV calling.

#source /home/AAFC-AAC/dumonceauxt/miniconda3/etc/profile.d/conda.sh
#conda activate dada2_denoise-2021.2

# Get the conda file path from source and activate the conda environment.
source ~/.bashrc
##conda activate qiime2-2022.2
conda activate qiime2-amplicon-2024.2

# The metadata input file for the project.
#metadata_infile="/export/home/AAFC-AAC/muirheadk/multi_target_project/sample_dataset/sample_metadata.tsv"
metadata_infile="/home/AGR.GC.CA/muirheadk/drought_dataset/dada2_analysis_pipeline/shell_scripts/separate_lanes/fastq_file_lane_LFJP3_metadata.txt"

## The qiime2 dada2 denoise-single parameters.

# The number of threads to use in dada2.
num_threads=10

# These seqs have already been trimmed/truncated so those parameters are 0.
trim_left=0
trunc_len=0

## The output directory to write output files.
#output_dir="/export/home/AAFC-AAC/muirheadk/multi_target_project/sample_dataset"
output_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LFJP3"

# Create the output directory if it doesn't already exist.
mkdir -p ${output_dir}

# The pre_processing directory.
preprocessing_dir="${output_dir}/pre_processing"

## The manifest input file that lists the sample ids, path to the fastq files and direction.
##Manifest file must be .csv with column headers: sample-id,absolute-filepath,direction
##eg line: D01-01ppm2010_S10_L001,/home/AAFC-AAC/dumonceauxt/Topp_antifungal/pre_processing/downsampled/D01-01ppm2010_S10_L001.cutadapt.trim.merge.downsampled,forward
fastq_manifest_infile="${preprocessing_dir}/fastq_sample_manifest.csv"

## The qiime dada2 denoise output directory.
dada2_denoise_dir="${output_dir}/dada2_denoise"
mkdir -p $dada2_denoise_dir

## The all samples output directory.
all_datasets_dir="${dada2_denoise_dir}/all_datasets"
mkdir -p $all_datasets_dir

## The dada2_denoise import file.
dada2_demux_file="${all_datasets_dir}/single_end_demux_dada2.qza"

## The dada2_denoise import file.
dada2_demux_file="${all_datasets_dir}/single_end_demux_dada2.qza"

## Import the manifest input file into qiime demux format.
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

## The dada2_denoise dada2 Files.
dada2_rep_seqs_file="${all_datasets_dir}/rep_seqs_dada2.qza"
dada2_table_file="${all_datasets_dir}/table_dada2.qza"
dada2_denoising_stats_file="${all_datasets_dir}/denoising_stats_dada2.qza"

# Output directories
dada2_stats_output_dir="${all_datasets_dir}/stats_exported_dada2"

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

# Make sure that the input field separator for newlines is a newline character '\n'.
IFS=$'\n'

# Get the header line of the metadata file.
header=$(head -n+1 $metadata_infile);

# Get the column index for the sample ids from the header line.
sample_id_index=$(echo $header | sed -n $'1s/\t/\\\n/gp' | grep -in 'sample' | cut -d':' -f1);
echo $sample_id_index;

# Checking if a project column exists.
if [[ -z $sample_id_index ]];
then
    echo "Please make sure that you have the word 'sample' in the header for the sample_id. i.e. #SampleID.";
    exit 0;
fi

# Get the column index for the project from the header line.
project_index=$(echo $header | sed -n $'1s/\t/\\\n/gp' | grep -in 'project' | cut -d':' -f1);
echo $project_index;

# Checking if a project column exists.
if [[ -z $project_index ]];
then
    echo "Please make sure that you have the word 'project' in the header for the project_name. i.e. project, Project, PROJECT, project_name.";
    exit 0;
fi

# Get the column index for the target from the header line.
target_index=$(echo $header | sed -n $'1s/\t/\\\n/gp' | grep -in 'target' | cut -d':' -f1);
echo $target_index;

# Checking if a target column exists.
if [[ -z $target_index ]];
then
    echo "Please make sure that you have the word 'target' in the header for the project_name. i.e. target, Target, TARGET, target_name.";
    exit 0;
fi

# Make the project output directory.
project_output_dir="${dada2_denoise_dir}/project_dir"
mkdir -p $project_output_dir

# Get the column index 1 and column index 2 for the order of the project and target columns.
if [ $project_index -lt $target_index ];
then
    column_index1=${project_index}
    column_index2=${target_index}
elif [ $project_index -gt $target_index ];
then
    column_index1=${target_index}
    column_index2=${project_index}
fi

# Make a file of samples ids for each project.
for row_entry in $(tail -n+2 $metadata_infile | tr '\t' ',' | cut -d ',' -f $column_index1,$column_index2 | sort -V | uniq | sed 's/ /_/g');
do

    # Get the project name and target name from the row entry based on column order.
    if [ $project_index -lt $target_index ];
    then
        project_name=$(echo $row_entry | cut -d ',' -f1)
        target_name=$(echo $row_entry | cut -d ',' -f2) 
    elif [ $project_index -gt $target_index ];
    then
        target_name=$(echo $row_entry | cut -d ',' -f1)
        project_name=$(echo $row_entry | cut -d ',' -f2)
    fi
 
    #echo $project_name;
    #echo $target_name;
    
    # The project name directory.
    project_name_dir="${project_output_dir}/${project_name}"
    mkdir -p $project_name_dir;

    # The target name directory.
    target_name_dir="${project_name_dir}/${target_name}"
    mkdir -p $target_name_dir; 
 
    echo "${project_name}_${target_name}_sample_ids.txt";

    sample_ids_list_file="${target_name_dir}/${project_name}_${target_name}_sample_ids.txt"
    echo "#SampleID" > ${sample_ids_list_file}

    project_target_metadata_file="${target_name_dir}/${project_name}_${target_name}_metadata.tsv"
    echo "${header}" > ${project_target_metadata_file}

done

# Make a list of sample ids based on the project name.
# Get rows starting after the header line using tail -n+2.
for row in $(tail -n+2 $metadata_infile);
do
    echo $row;
    sample_id=$(echo $row | tr '\t' ',' | cut -d ',' -f $sample_id_index);
    project_name=$(echo $row | tr '\t' ',' | cut -d ',' -f $project_index);
    target_name=$(echo $row | tr '\t' ',' | cut -d ',' -f $target_index);
    
    echo $sample_id;
    echo $project_name;
    echo $target_name;
    echo "${project_name}_${target_name}_sample_ids.txt";
   
    # The project name directory.
    project_name_dir="${project_output_dir}/${project_name}"
    mkdir -p $project_name_dir;

    # The target name directory.
    target_name_dir="${project_name_dir}/${target_name}"
    mkdir -p $target_name_dir;

    ## Distribute based on project name.
    sample_ids_list_file="${target_name_dir}/${project_name}_${target_name}_sample_ids.txt"
    echo ${sample_id} >> ${sample_ids_list_file}

    project_target_metadata_file="${target_name_dir}/${project_name}_${target_name}_metadata.tsv"
    echo ${row} >> ${project_target_metadata_file}

done

# Get the filtered files after splitting the denoised dataset by project.
for row_entry in $(tail -n+2 $metadata_infile | tr '\t' ',' | cut -d ',' -f $column_index1,$column_index2 | sort -V | uniq | sed 's/ /_/g');
do
    # Get the project name and target name from the row entry based on column order.
    if [ $project_index -lt $target_index ];
    then
        project_name=$(echo $row_entry | cut -d ',' -f1)
        target_name=$(echo $row_entry | cut -d ',' -f2)
    elif [ $project_index -gt $target_index ];
    then
        target_name=$(echo $row_entry | cut -d ',' -f1)
        project_name=$(echo $row_entry | cut -d ',' -f2)
    fi

    # The project name directory.
    project_name_dir="${project_output_dir}/${project_name}"
    mkdir -p $project_name_dir;

    # The target name directory.
    target_name_dir="${project_name_dir}/${target_name}"
    mkdir -p $target_name_dir;

    sample_ids_list_file="${target_name_dir}/${project_name}_${target_name}_sample_ids.txt"
    project_target_table_file="${target_name_dir}/${project_name}_${target_name}_filtered_table.qza"
    project_target_rep_seqs_file="${target_name_dir}/${project_name}_${target_name}_rep_seqs.qza"

    # Get the filtered table based on the sample_ids for the project.
    echo "qiime feature-table filter-samples \
      --i-table ${dada2_table_file} \
      --m-metadata-file ${sample_ids_list_file} \
      --o-filtered-table ${project_target_table_file}"
    qiime feature-table filter-samples \
      --i-table ${dada2_table_file} \
      --m-metadata-file ${sample_ids_list_file} \
      --o-filtered-table ${project_target_table_file}

    # Get the rep seqs file using the table generated in the previous command.
    echo "qiime feature-table filter-seqs \
      --i-data ${dada2_rep_seqs_file} \
      --i-table ${project_target_table_file} \
      --o-filtered-data ${project_target_rep_seqs_file}"
    qiime feature-table filter-seqs \
      --i-data ${dada2_rep_seqs_file} \
      --i-table ${project_target_table_file} \
      --o-filtered-data ${project_target_rep_seqs_file}

done

echo "The dada2_denoise_data.sh script has finished."

exit 0;


  
