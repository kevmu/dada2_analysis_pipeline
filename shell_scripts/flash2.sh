#Merge with FLASH2
#qsub flash2.sh

#!/bin/bash
#$ -S /bin/bash
#$ -N townj_flash2
#$ -j y
#$ -cwd
#$ -pe smp 4

#source /home/AAFC-AAC/townj/miniconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.2

source ~/.bash_profile
conda activate flash2_env

fastq_list_file="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/Macrosteles_fastq_files.txt"

cutadapt_dir="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/cutadapt30"
mkdir -p ${cutadapt_dir}

flash_merge_dir="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/merge30"
mkdir -p ${flash_merge_dir}

cutadapt_read1_suffix=".R1.cutadapt.fq"
cutadapt_read2_suffix=".R2.cutadapt.fq"

flash_output_suffix=".cutadapt.trim.merge"
fragment_length=240
fragment_length_stddev=50
read_length=250

for i in $(cat ${fastq_list_file}) \
; do flash2 \
-f ${fragment_length} \
-s ${fragment_length_stddev} \
-r ${read_length} \
${cutadapt_dir}/${i}${cutadapt_read1_suffix} \
${cutadapt_dir}/${i}${cutadapt_read2_suffix} \
-d ${flash_merge_dir} \
-o ${i}${flash_output_suffix} \
 ; done


