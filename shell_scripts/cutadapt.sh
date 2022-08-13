#qsub cutadapt.sh

#!/bin/bash
#$ -S /bin/bash
#$ -N townj_cutadapt
#$ -j y
#$ -cwd
#$ -pe smp 8

#source /home/AAFC-AAC/townj/miniconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.2

source ~/.bash_profile
conda activate cutadapt_env

input_dir="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/fastq"
fastq_list_file="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/Macrosteles_fastq_files.txt"

cutadapt_dir="/home/AAFC-AAC/dumonceauxt/Macrosteles-Edel/pre_processing/cutadapt30"
mkdir -p ${cutadapt_dir}

adapter1_f="16S-515bf=GTGYCAGCMGCCGCGGTAA"
adapter2_f="16S-515bfR=TTACCGCGGCKGCTGRCAC"
adapter1_r="16S-806r=GGACTACHVGGGTWTCTAAT"
adapter2_r="16S-806rR=ATTAGAWACCCBDGTAGTCC"

min_read_length=100
num_remove_adapters=2
quality_cutoff=30

read1_suffix="_R1_001.fastq.gz"
read2_suffix="_R2_001.fastq.gz"

cutadapt_read1_suffix=".R1.cutadapt.fq"
cutadapt_read2_suffix=".R2.cutadapt.fq"

find ${input_dir} -name "*.fastq.gz" -type f | sed 's/_R[1-2]_001\.fastq\.gz//g' | sort -V | uniq > ${fastq_list_file}

for i in $(cat ${fastq_list_file}) \
; do cutadapt \
 -g ${adapter1_f} \
 -a ${adapter2_f} \
 -G ${adapter1_r} \
 -A ${adapter2_r} \
 -m ${min_read_length} \
 -n $(num_remove_adapters) \
 --discard-untrimmed \
 -q ${quality_cutoff} \
 --pair-filter=both \
${input_dir}/${i}${read1_suffix} \
${input_dir}/${i}${read2_suffix} \
-o ${cutadapt_dir}/${i}${cutadapt_read1_suffix} \
-p ${cutadapt_dir}/${i}${cutadapt_read2_suffix} \
; done


