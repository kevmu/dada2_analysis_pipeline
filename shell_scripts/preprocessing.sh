#qsub preprocessing.sh

#!/bin/bash
#$ -S /bin/bash
#$ -N preprocessing
#$ -j y
#$ -cwd
#$ -pe smp 8

#source /home/AAFC-AAC/townj/miniconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.2

source ~/.bashrc
conda activate cutadapt_env

# Cutadapt command configuration data.
input_dir="/home/AAFC-AAC/muirheadk/projects/Macrosteles-Edel/fastq"

output_dir="/home/AAFC-AAC/muirheadk/projects/Macrosteles-Edel"
mkdir -p ${output_dir}

preprocessing_dir="${output_dir}/pre_processing"
mkdir -p ${preprocessing_dir}

# The fastq list input file.
fastq_list_file="${preprocessing_dir}/fastq_list_files.txt"

# The manifest input file that lists the sample ids, path to the fastq files and direction.#Manifest file must be .csv with column headers: sample-id,absolute-filepath,direction
#eg line: D01-01ppm2010_S10_L001,/home/AAFC-AAC/dumonceauxt/Topp_antifungal/pre_processing/downsampled/D01-01ppm2010_S10_L001.cutadapt.trim.merge.downsampled,forward
fastq_manifest_infile="${preprocessing_dir}/fastq_sample_manifest.csv"

cutadapt_dir="${preprocessing_dir}/cutadapt"
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

# Flash2 command configuration data.
flash_merge_dir="${preprocessing_dir}/flash2_merge";
mkdir -p ${flash_merge_dir}

# The flash2 output file suffix.
flash_output_suffix=".cutadapt.trim.merge"

fragment_length=240
fragment_length_stddev=50
read_length=250

## If downsampling.
# downsampled_dir="${preprocessing_dir}/downsampled"
# mkdir -p ${downsampled_dir}

# seqtk_seed=100
# downsample_num_reads=50000

# input_suffix=".cutadapt.trim.merge.extendedFrags.fastq"
# output_suffix=".cutadapt.trim.merge.downsampled"

find ${input_dir} -name "*.fastq.gz" -type f | sed 's/_R[1-2]_001\.fastq\.gz//g' | sort -V | uniq > ${fastq_list_file}

for i in $(cat ${fastq_list_file}) \
; do cutadapt \
 -g ${adapter1_f} \
 -a ${adapter2_f} \
 -G ${adapter1_r} \
 -A ${adapter2_r} \
 -m ${min_read_length} \
 -n ${num_remove_adapters} \
 --discard-untrimmed \
 -q ${quality_cutoff} \
 --pair-filter=both \
${input_dir}/${i}${read1_suffix} \
${input_dir}/${i}${read2_suffix} \
-o ${cutadapt_dir}/${i}${cutadapt_read1_suffix} \
-p ${cutadapt_dir}/${i}${cutadapt_read2_suffix} \
; done


conda activate flash2_env

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
 
# conda activate seqtk_env

# for i in $(cat ${fastq_list_file}) \
# ; do seqtk sample -s ${seqtk_seed} \
# ${flash_merge_dir}/${i}${input_suffix} \
# ${downsample_num_reads} \
 # > ${downsampled_dir}/${i}${output_suffix} \
# ; done

# Generate the manifest file for qiime2.
echo "Generate the manifest file for qiime2."
echo "sample-id,absolute-filepath,direction" >> ${fastq_manifest_infile};
for i in $(cat ${fastq_list_file});
do echo $i;
echo -e "${i},${flash_merge_dir}/${i}${flash_output_suffix},forward" >> ${fastq_manifest_infile};
done

