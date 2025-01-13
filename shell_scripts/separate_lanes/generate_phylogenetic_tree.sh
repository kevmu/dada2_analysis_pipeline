# Get the conda file path from source and activate the conda environment.
source ~/.bashrc
##conda activate qiime2-2022.2
conda activate qiime2-amplicon-2024.2

# The dataset representative sequences input file.
dada2_rep_seqs_file="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/drought/dada2_analysis/drought_16S_515_926/qiime2/rep_seqs_filtered_dada2.qza"

# The output directory.
output_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/drought_dada2_analysis/merged_lanes/phylogenetic_tree_files"
mkdir -p $output_dir

# The dataset representative sequences mafft alignment file
mafft_align_file="${output_dir}/aligned_rep_seqs.qza"

# Run mafft on the mafft_align_file.
echo "qiime alignment mafft \
--i-sequences ${dada2_rep_seqs_file} \
--o-alignment ${mafft_align_file}"
#qiime alignment mafft \
#--i-sequences ${dada2_rep_seqs_file} \
#--o-alignment ${mafft_align_file}

# The masked alignment file.
masked_align_file="${output_dir}/masked_aligned_rep_seqs.qza"

# Mask the alignment.
echo "qiime alignment mask \
--i-alignment ${mafft_align_file} \
--o-masked-alignment ${masked_align_file}"
#qiime alignment mask \
#--i-alignment ${mafft_align_file} \
#--o-masked-alignment ${masked_align_file}

# The unrooted tree file.
unrooted_tree_file="${output_dir}/unrooted_tree.qza"

# Construct a phylogenetic tree using fasttree.
echo "qiime phylogeny fasttree \
--i-alignment ${masked_align_file} \
--o-tree ${unrooted_tree_file}"
#qiime phylogeny fasttree \
#--i-alignment ${masked_align_file} \
#--o-tree ${unrooted_tree_file}

# The rooted tree file.
rooted_tree_file="${output_dir}/rooted_tree.qza"

# Make the midpoint the root of the tree.
echo "qiime phylogeny midpoint-root\
--i-tree ${unrooted_tree_file} \
--o-rooted-tree ${rooted_tree_file}"
#qiime phylogeny midpoint-root \
#--i-tree ${unrooted_tree_file} \
#--o-rooted-tree ${rooted_tree_file}

# Exporting the mafft alignment file.
exported_mafft_align_dir="${output_dir}/exported_mafft_align_file"
qiime tools export \
--input-path ${mafft_align_file} \
--output-path ${exported_mafft_align_dir}

# Exporting the masked mafft alignment file.
exported_masked_mafft_align_dir="${output_dir}/exported_masked_mafft_align_file"
qiime tools export \
--input-path ${masked_align_file} \
--output-path ${exported_masked_mafft_align_dir}

# Exporting the unrooted tree in newick format.
exported_unrooted_tree_dir="${output_dir}/exported_unrooted_tree"
qiime tools export \
--input-path ${unrooted_tree_file} \
--output-path ${exported_unrooted_tree_dir}

# Exporting the rooted tree in newick format.
exported_rooted_tree_dir="${output_dir}/exported_rooted_tree"
qiime tools export \
--input-path ${rooted_tree_file} \
--output-path ${exported_rooted_tree_dir}

echo "Exported all files."

