#Downsample to 50,000 reads/sample
#qsub downsample.sh

#!/bin/bash
#$ -S /bin/bash
#$ -N townj_downsample
#$ -j y
#$ -cwd
#$ -pe smp 1

#source /home/AAFC-AAC/townj/miniconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.2
 
source ~/.bash_profile
conda activate seqtk_env

flash_merge_dir="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/merge30"
mkdir -p ${flash_merge_dir}

downsampled_dir="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/downsampled"
mkdir -p ${downsampled_dir}

seqtk_seed=100
downsample_num_reads=50000

input_suffix=".cutadapt.trim.merge.extendedFrags.fastq"
output_suffix=".cutadapt.trim.merge.downsampled"

for i in $(cat ${fastq_list_file}) \
; do seqtk sample -s ${seqtk_seed} \
${flash_merge_dir}/${i}${input_suffix} \
${downsample_num_reads} \
 > ${downsampled_dir}/${i}${output_suffix} \
; done



