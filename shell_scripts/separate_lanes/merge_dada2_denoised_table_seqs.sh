
# Get the conda file path from source and activate the conda environment.
source ~/.bashrc

##conda activate qiime2-2022.2
conda activate qiime2-amplicon-2024.2

qiime_output_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes"
mkdir -p $qiime_output_dir

# Denoised dada2 table file.
dada2_denoised_table_file1="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LFJP3/dada2_denoise/project_dir/LFJP3/16S_515_926/LFJP3_16S_515_926_filtered_table.qza"

# Denoised dada2 table file.
dada2_denoised_table_file2="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LH5TF/dada2_denoise/project_dir/LH5TF/16S_515_926/LH5TF_16S_515_926_filtered_table.qza"

# Denoised dada2 table file.
dada2_denoised_table_file3="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LRBM9/dada2_denoise/project_dir/LRBM9/16S_515_926/LRBM9_16S_515_926_filtered_table.qza"

# Merged dada2 table file.
dada2_merged_table_file="${qiime_output_dir}/merged_table_dada2.qza"

echo "qiime feature-table merge
--i-tables ${dada2_denoised_table_file1} \
--i-tables ${dada2_denoised_table_file2} \
--i-tables ${dada2_denoised_table_file3} \
--o-merged-table ${dada2_merged_table_file}"

qiime feature-table merge \
--i-tables ${dada2_denoised_table_file1} \
--i-tables ${dada2_denoised_table_file2} \
--i-tables ${dada2_denoised_table_file3} \
--o-merged-table ${dada2_merged_table_file}


# The representative sequences filtered dada2 file.
dada2_denoised_seqs_file1="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LFJP3/dada2_denoise/project_dir/LFJP3/16S_515_926/LFJP3_16S_515_926_rep_seqs.qza"

# The representative sequences filtered dada2 file.
dada2_denoised_seqs_file2="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LH5TF/dada2_denoise/project_dir/LH5TF/16S_515_926/LH5TF_16S_515_926_rep_seqs.qza"

# The representative sequences filtered dada2 file.
dada2_denoised_seqs_file3="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/LRBM9/dada2_denoise/project_dir/LRBM9/16S_515_926/LRBM9_16S_515_926_rep_seqs.qza"

# Merged representative sequences filtered dada2 file.
dada2_merged_rep_seqs_file="${qiime_output_dir}/merged_rep_seqs_dada2.qza"

echo "qiime feature-table merge-seqs \
--i-data ${dada2_denoised_seqs_file1} \
--i-data ${dada2_denoised_seqs_file2} \
--i-data ${dada2_denoised_seqs_file3} \
--o-merged-data ${dada2_merged_rep_seqs_file}"

qiime feature-table merge-seqs \
--i-data ${dada2_denoised_seqs_file1} \
--i-data ${dada2_denoised_seqs_file2} \
--i-data ${dada2_denoised_seqs_file3} \
--o-merged-data ${dada2_merged_rep_seqs_file}

echo $dada2_merged_table_file
echo $dada2_merged_rep_seqs_file


