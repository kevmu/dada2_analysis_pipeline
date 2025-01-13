#!/bin/bash

# Get the conda file path from source and activate the conda environment.
source ~/.bashrc
##conda activate qiime2-2022.2
conda activate qiime2-amplicon-2024.2

lanes=("LFJP3"
"LH5TF"
"LRBM9"
)

sample_ids_file_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/dada2_analysis_pipeline/shell_scripts/separate_lanes"

output_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis"

target_name="16S_515_926"

for lane in "${lanes[@]}";
do
 
    #echo $lane
    #exit 0;

    #sample_ids_list_file="${target_name_dir}/${project_name}_${target_name}_sample_ids.txt"
    #project_target_table_file="${target_name_dir}/${project_name}_${target_name}_filtered_table.qza"
    #project_target_rep_seqs_file="${target_name_dir}/${project_name}_${target_name}_rep_seqs.qza"
    sample_ids_file_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/dada2_analysis_pipeline/shell_scripts/separate_lanes"
    target_name_dir="${output_dir}/${lane}/dada2_denoise/project_dir/${lane}/${target_name}"

    dada2_table_file="${output_dir}/${lane}/dada2_denoise/all_datasets/table_dada2.qza"
    dada2_rep_seqs_file="${output_dir}/${lane}/dada2_denoise/all_datasets/rep_seqs_dada2.qza"
    
    sample_ids_list_file="${sample_ids_file_dir}/${lane}_${target_name}_sample_ids.txt"
    project_target_table_file="${target_name_dir}/${lane}_${target_name}_filtered_table.qza"
    project_target_rep_seqs_file="${target_name_dir}/${lane}_${target_name}_rep_seqs.qza"

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

    echo "project_target_table_file=${project_target_table_file}"
    echo "project_target_rep_seqs_file=${project_target_rep_seqs_file}"

done

