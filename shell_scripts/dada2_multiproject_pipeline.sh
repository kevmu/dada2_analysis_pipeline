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
##conda activate qiime2-2022.2
conda activate qiime2-amplicon-2024.2

# The dataset Metadata input file.
dataset_metadata_file="/home/AAFC-AAC/muirheadk/multi_target_project/sample_dataset/dada2_denoise/project_dir/Test6_Melfort/16S_515_806/Test6_Melfort_16S_515_806_metadata.tsv"

# The dataset representative sequences input file.
dada2_rep_seqs_file="/home/AAFC-AAC/muirheadk/multi_target_project/sample_dataset/dada2_denoise/project_dir/Test6_Melfort/16S_515_806/Test6_Melfort_16S_515_806_rep_seqs.qza"

# The dataset table input file.
dada2_table_file="/home/AAFC-AAC/muirheadk/multi_target_project/sample_dataset/dada2_denoise/project_dir/Test6_Melfort/16S_515_806/Test6_Melfort_16S_515_806_filtered_table.qza"

# The output directory to write output files.
output_dir="/home/AAFC-AAC/muirheadk/multi_target_project/sample_dataset"
mkdir -p $output_dir

## The dada2 classifier database file.
# Unite ITS classifier Database.
#dada2_classifier_file="${HOME}/classifiers/unite_20171201/unite-ver7-99-classifier-01.12.2017.qza"

# SILVA 16S classifier database file.
dada2_classifier_file="${HOME}/classifiers/silva_16S_138_99_515_806/silva-138-99-classifier-515-806.qza"

# Minimum length of sequences in bps to remove within the sequence length filtering step.
min_sequence_length=100

# Minimum number of samples to filter out features occuring only 1 sample using -p-min-samples. Use n > 1 (Default: 2)
min_num_samples=2

# The dada2 analysis output directory.
dada2_analysis_dir="${output_dir}/dada2_analysis"
mkdir -p $dada2_analysis_dir

# The project name taken from the metadata file name given as input. Should have the project and target names in the filename.
project_name=$(basename $dataset_metadata_file | sed 's/_metadata.tsv//g')

# The project_directory.
project_dir="${dada2_analysis_dir}/${project_name}"
mkdir -p $project_dir

# The qiime output directory.
qiime_output_dir="${project_dir}/qiime2"
mkdir -p $qiime_output_dir
 
## The minimum length dada2 representative sequences file.
dada2_rep_seqs_min_len_file="${qiime_output_dir}/rep_seqs_${min_sequence_length}bp_dada2.qza"

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

# Check to see if the output files from dada2_denoise_multiproject_data.sh script has been run and completed.
if [ ! -s $dataset_metadata_file ] && [ ! -s $dada2_rep_seqs_file ] && [  ! -s $dada2_table_file ];
then
    echo "Rerun the dada2_denoise_multiproject_data.sh script. One of the output files do not exist!"
    echo "${dataset_metadata_file}"
    echo "${dada2_rep_seqs_file}"
    echo "${dada2_table_file}"
    exit 1;
fi

# Creating the dada2 representative sequences minimum length filtered file.
# Remove seqeunces less than 100bp
if [ ! -s $dada2_rep_seqs_min_len_file ];
then
    echo "qiime feature-table filter-seqs \
    --i-data ${dada2_rep_seqs_file} \
    --m-metadata-file ${dada2_rep_seqs_file} \
    --p-where \"length(sequence) > ${min_sequence_length}\" \
    --o-filtered-data ${dada2_rep_seqs_min_len_file}"
    qiime feature-table filter-seqs \
    --i-data ${dada2_rep_seqs_file} \
    --m-metadata-file ${dada2_rep_seqs_file} \
    --p-where "length(sequence) > ${min_sequence_length}" \
    --o-filtered-data ${dada2_rep_seqs_min_len_file}
else
    dada2_rep_seqs_min_len_filename=$(basename $dada2_rep_seqs_min_len_file)
    echo "The ${dada2_rep_seqs_min_len_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Export dna-sequences file.
#generates a list of sequences > 100 bp - want just those ones
dada2_min_len_dna_sequences_file="${dada2_rep_seqs_min_len_stats_output_dir}/dna-sequences.fasta"
if [ ! -s $dada2_min_len_dna_sequences_file ];
then
    echo "qiime tools export \
    --input-path ${dada2_rep_seqs_min_len_file} \
    --output-path ${dada2_rep_seqs_min_len_stats_output_dir}"
    qiime tools export \
    --input-path ${dada2_rep_seqs_min_len_file} \
    --output-path ${dada2_rep_seqs_min_len_stats_output_dir}
else
    dada2_rep_seqs_min_len_filename=$(basename $dada2_min_len_dna_sequences_file)
    echo "The ${dada2_rep_seqs_min_len_filename} file has already been created. Skipping to next set of commands!!!"
fi

dada2_min_len_read_ids_file="${dada2_rep_seqs_min_len_stats_output_dir}/sequences_to_keep.txt"
if [ ! -s $dada2_min_len_read_ids_file ]; 
then		
    #gets the sequences you want
    echo "SampleID" >> ${dada2_min_len_read_ids_file}
    grep ">" \
    ${dada2_min_len_dna_sequences_file} \
    | sed 's/>//' \
    >> ${dada2_min_len_read_ids_file}
else
    dada2_min_len_read_ids_filename=$(basename $dada2_min_len_read_ids_file)
    echo "The ${dada2_min_len_read_ids_filename} file has already been created. Skipping to next set of commands!!!"
fi


# Creating the dada2 minimum length filtered table file.
# Filter the table using your txt file
# table now only has ASV sequences >100bp
if [ ! -s $dada2_table_min_len_file ];
then
    echo "qiime feature-table filter-features \
    --i-table ${dada2_table_file} \
    --m-metadata-file ${dada2_min_len_read_ids_file} \
    --o-filtered-table ${dada2_table_min_len_file}"
    qiime feature-table filter-features \
    --i-table ${dada2_table_file} \
    --m-metadata-file ${dada2_min_len_read_ids_file} \
    --o-filtered-table ${dada2_table_min_len_file}
else
    dada2_table_min_len_filename=$(basename $dada2_table_min_len_file)
    echo "The ${dada2_table_min_len_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Creating the dada2 minimum length filtered table file.
# Filter out features occuring only in one sample; can change to other filters using -p min-samples. Often include things that are in at least 5% of the total number of samples
if [ ! -s $dada2_table_min_samples_filtered_file ];
then
    echo "qiime feature-table filter-features \
    --i-table ${dada2_table_min_len_file} \
    --p-min-samples ${min_num_samples} \
    --o-filtered-table ${dada2_table_min_samples_filtered_file}"
    qiime feature-table filter-features \
    --i-table ${dada2_table_min_len_file} \
    --p-min-samples ${min_num_samples} \
    --o-filtered-table ${dada2_table_min_samples_filtered_file}
else
    dada2_table_min_samples_filtered_filename=$(basename $dada2_table_min_samples_filtered_file)
    echo "The ${dada2_table_min_samples_filtered_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Creating the dada2 filtered table plot file for visualization.
if [ ! -s $dada2_table_filtered_plot_file ];
then
    echo "qiime feature-table summarize \
     --i-table ${dada2_table_min_samples_filtered_file} \
     --m-sample-metadata-file ${dataset_metadata_file} \
     --o-visualization ${dada2_table_filtered_plot_file}"
    qiime feature-table summarize \
     --i-table ${dada2_table_min_samples_filtered_file} \
     --m-sample-metadata-file ${dataset_metadata_file} \
     --o-visualization ${dada2_table_filtered_plot_file}
else
    dada2_table_filtered_plot_filename=$(basename $dada2_table_filtered_plot_file)
    echo "The ${dada2_table_filtered_plot_filename} file has already been created. Skipping to next set of commands!!!"
fi

#can visualize results of qzv file using qiime2view.org
# Creating .
if [ ! -s $feature_table_biom_file ];
then
    echo "qiime tools export \
    --input-path ${dada2_table_min_samples_filtered_file} \
    --output-path ${dada2_filtered_table_output_dir}"
    qiime tools export \
    --input-path ${dada2_table_min_samples_filtered_file} \
    --output-path ${dada2_filtered_table_output_dir}

else
    feature_table_biom_filename=$(basename $feature_table_biom_file)
    echo "The ${feature_table_biom_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Converting the feature table biom file to a tsv file.
if [ ! -s $feature_table_tsv_file ];
then
    echo "biom convert \
     -i ${feature_table_biom_file} \
     -o ${feature_table_tsv_file} \
     --to-tsv"
    biom convert \
     -i ${feature_table_biom_file} \
     -o ${feature_table_tsv_file} \
     --to-tsv

else
    feature_table_tsv_filename=$(basename $feature_table_tsv_file)
    echo "The ${feature_table_tsv_filename} file has already been created. Skipping to next set of commands!!!"
fi


# Creating the dada2 representative sequences plot file for visualization.
#make rep-seqs file - view using qiime2view.org
if [ ! -s $dada2_rep_seqs_plot_file ];
then
    qiime tools export \
    --input-path ${dada2_rep_seqs_file} \
    --output-path ${dada2_filtered_table_output_dir}
    qiime feature-table tabulate-seqs \
     --i-data ${dada2_rep_seqs_file} \
     --o-visualization ${dada2_rep_seqs_plot_file}
else
    dada2_rep_seqs_plot_filename=$(basename $dada2_rep_seqs_plot_file)
    echo "The ${dada2_rep_seqs_plot_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Classifying the taxonomy for each ASV using dada2 classifier.
if [ ! -s $dada2_taxonomy_file ];
then
	echo "qiime feature-classifier classify-sklearn \
	--i-classifier ${dada2_classifier_file} \
	--i-reads ${dada2_rep_seqs_file} \
	--o-classification ${dada2_taxonomy_file}"

	qiime feature-classifier classify-sklearn \
	--i-classifier ${dada2_classifier_file} \
	--i-reads ${dada2_rep_seqs_file} \
	--o-classification ${dada2_taxonomy_file}
else
    dada2_taxonomy_filename=$(basename $dada2_taxonomy_file)
    echo "The ${dada2_taxonomy_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Creating the dada2 taxonomy plot file for vizualization.
if [ ! -s $dada2_taxonomy_plot_file ];
then
    echo "qiime metadata tabulate \
      --m-input-file ${dada2_taxonomy_file} \
      --o-visualization ${dada2_taxonomy_plot_file}"
    qiime metadata tabulate \
      --m-input-file ${dada2_taxonomy_file} \
      --o-visualization ${dada2_taxonomy_plot_file}
else
    dada2_taxonomy_plot_filename=$(basename $dada2_taxonomy_plot_file)
    echo "The ${dada2_taxonomy_plot_filename} file has already been created. Skipping to next set of commands!!!"
fi

#
if [ ! -s $taxonomy_tsv_file ];
then
    echo "qiime tools export \
      --input-path ${dada2_taxonomy_file} \
      --output-path ${dada2_taxonomy_output_dir}"
    qiime tools export \
      --input-path ${dada2_taxonomy_file} \
      --output-path ${dada2_taxonomy_output_dir}
else
    taxonomy_tsv_filename=$(basename $taxonomy_tsv_file)
    echo "The ${taxonomy_tsv_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Generate the dada2 taxonomy bar plot file for visualization.
if [ ! -s $dada2_taxa_bar_plot_file ];
then
    echo "qiime taxa barplot \
      --i-table ${dada2_table_min_samples_filtered_file} \
      --i-taxonomy ${dada2_taxonomy_file} \
      --m-metadata-file ${dataset_metadata_file} \
      --o-visualization ${dada2_taxa_bar_plot_file}"
    qiime taxa barplot \
      --i-table ${dada2_table_min_samples_filtered_file} \
      --i-taxonomy ${dada2_taxonomy_file} \
      --m-metadata-file ${dataset_metadata_file} \
      --o-visualization ${dada2_taxa_bar_plot_file}
else
    dada2_taxa_bar_plot_filename=$(basename $dada2_taxa_bar_plot_file)
    echo "The ${dada2_taxa_bar_plot_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Create the filtered dada2 representative sequences file.
if [ ! -s $dada2_rep_seqs_filtered_file ];
then
    echo "qiime feature-table filter-seqs \
     --i-data ${dada2_rep_seqs_file}  \
     --i-table ${dada2_table_min_samples_filtered_file} \
     --o-filtered-data ${dada2_rep_seqs_filtered_file}"
    qiime feature-table filter-seqs \
     --i-data ${dada2_rep_seqs_file}  \
     --i-table ${dada2_table_min_samples_filtered_file} \
     --o-filtered-data ${dada2_rep_seqs_filtered_file}
else
    dada2_rep_seqs_filtered_filename=$(basename $dada2_rep_seqs_filtered_file)
    echo "The ${dada2_rep_seqs_filtered_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Create the dada2 representative filtered DNA sequences file.
dada2_rep_seqs_dna_sequences_file="${dada2_rep_seqs_filtered_dir}/dna-sequences.fasta"
if [ ! -s $dada2_rep_seqs_dna_sequences_file ];
then
    echo "qiime tools export \
    --input-path ${dada2_rep_seqs_filtered_file} \
    --output-path ${dada2_rep_seqs_filtered_dir}"
    qiime tools export \
    --input-path ${dada2_rep_seqs_filtered_file} \
    --output-path ${dada2_rep_seqs_filtered_dir}
else
    dada2_rep_seqs_dna_sequences_filename=$(basename $dada2_rep_seqs_dna_sequences_file)
    echo "The ${dada2_rep_seqs_dna_sequences_filename} file has already been created. Skipping to next set of commands!!!"
fi

#echo $taxonomy_tsv_file
#exit 0;

#Alpha Diversity
#Prepare for phyloseq - can do some statistics and visualization in R - also calculate statistics below using qiime2 and export to tsv or csv for viewing and analysis in Excel
#phyloseq
#Change taxonomy.tsv colnames to #OTUID, taxonomy, confidence, save as phyloseq_taxonomy.tsv
if [ ! -s $phyloseq_taxonomy_tsv_file ];
then
	echo -e "#OTUID\ttaxonomy\tconfidence" >> ${phyloseq_taxonomy_tsv_file}
	tail -n+2 < ${taxonomy_tsv_file} | sed 's/[a-z]__//g' >> ${phyloseq_taxonomy_tsv_file}
else
    phyloseq_taxonomy_tsv_filename=$(basename $phyloseq_taxonomy_tsv_file)
    echo "The ${phyloseq_taxonomy_tsv_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Generate the phyloseq abundance count biom file.
if [ ! -s $phyloseq_abund_biom_file ];
then
    echo "biom add-metadata \
    -i ${feature_table_biom_file} \
    -o ${phyloseq_abund_biom_file} \
    --observation-metadata-fp ${phyloseq_taxonomy_tsv_file} \
    --sc-separated taxonomy \
    --sample-metadata-fp ${dataset_metadata_file}"
    biom add-metadata \
    -i ${feature_table_biom_file} \
    -o ${phyloseq_abund_biom_file} \
    --observation-metadata-fp ${phyloseq_taxonomy_tsv_file} \
    --sc-separated taxonomy \
    --sample-metadata-fp ${dataset_metadata_file}
else
    phyloseq_abund_biom_filename=$(basename $phyloseq_abund_biom_file)
    echo "The ${phyloseq_abund_biom_filename} file has already been created. Skipping to next set of commands!!!"
fi

# Converting the phyloseq abundance count table from biom to tsv.
if [ ! -s $phyloseq_abund_tsv_file ];
then
    echo "biom convert \
    -i ${phyloseq_abund_biom_file} \
    -o ${phyloseq_abund_tsv_file} \
    --to-tsv"
    biom convert \
    -i ${phyloseq_abund_biom_file} \
    -o ${phyloseq_abund_tsv_file} \
    --to-tsv
else
    phyloseq_abund_tsv_filename=$(basename $phyloseq_abund_tsv_file)
    echo "The ${phyloseq_abund_tsv_filename} file has already been created. Skipping to next set of commands!!!"
fi


# Generate the dada2 species taxonomy file.
species_taxonomy_tsv_file="${dada2_taxonomy_output_dir}/dada2_species_taxonomy.tsv"
if [ ! -s $species_taxonomy_tsv_file ];
then
    echo -e "#OTUID\ttaxonomy\tconfidence" >> ${species_taxonomy_tsv_file}
    grep "s__" < ${taxonomy_tsv_file} >> ${species_taxonomy_tsv_file}
else
    species_taxonomy_tsv_filename=$(basename $species_taxonomy_tsv_file)
    echo "The ${species_taxonomy_tsv_filename} file has already been created. Skipping to next set of commands!!!"
fi

merged_phyloseq_abund_tax_file="${dada2_taxonomy_output_dir}/merged_phyloseq_abund_tax.tsv"

python ../python_scripts/merge_phyloseq_abund_tax.py --phyloseq_abund_infile ${phyloseq_abund_tsv_file} --tax_infile ${taxonomy_tsv_file} --output_dir ${dada2_taxonomy_output_dir}

echo "The merged phyloseq abundance and taxonomy summary file is located at the following path ${merged_phyloseq_abund_tax_file}."

echo "The dada2_analysis_pipeline.sh script has finished."

exit 0;

