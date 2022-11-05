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
input_dir="/home/AGR.GC.CA/muirheadk/macrosteles/macrosteles_edel_22/fastq_files"

# The metadata input file of the project.
metadata_infile="/Users/kevin.muirhead/Desktop/Macrosteles_Microbiome_Metadata.txt"
 
# The output directory.
output_dir="/Users/kevin.muirhead/Desktop/macrosteles_edel_22_test"

# Create the output directory if it doesn't already exist.
mkdir -p ${output_dir}

## Cutadapt program parameters.
min_read_length=100
num_remove_adapters=2
quality_cutoff=30

read1_suffix="_R1_001.fastq.gz"
read2_suffix="_R2_001.fastq.gz"

cutadapt_read1_suffix=".R1.cutadapt.fq"
cutadapt_read2_suffix=".R2.cutadapt.fq"

# Get the target adapters given the target string.
get_target_adapters(){

    # $target is local variable.
    local target="$1"

    echo $target;

    # 16S 515/806 adapters.
    if [ $target == "16S_515_806" ];
    then

        adapter1_f="16S-515bf=GTGYCAGCMGCCGCGGTAA"
        adapter2_f="16S-515bfR=TTACCGCGGCKGCTGRCAC"
        adapter1_r="16S-806r=GGACTACHVGGGTWTCTAAT"
        adapter2_r="16S-806rR=ATTAGAWACCCBDGTAGTCC"
        
    # 16S 515/926 adapters.
    elif [ $target == "16S_515_926" ];
    then

        adapter1_f="16S-515bf=GTGYCAGCMGCCGCGGTAA"
        adapter2_f="16S-515bfR=TTACCGCGGCKGCTGRCAC"
        adapter1_r="16S-926r=CCGYCAATTYMTTTRAGTTT"
        adapter2_r="16S-926rR=AAACTYAAAKRAATTGRCGG"
        
    # ITS adapters.
    elif [ $target == "ITS" ];
    then

        adapter1_f="ITSf1=CTTGGTCATTTAGAGGAAGTAA"
        adapter2_f="ITS2R=GCATCGATGAAGAACGCAGC"
        adapter1_r="ITS2=GCTGCGTTCTTCATCGATGC"
        adapter2_r="ITSf1R=TTACTTCCTCTAAATGACCAAG"

    # cpn60 H279/H1612 adapters.
    # Janet uses cpn60 H279/H1612 for R1.
    elif [ $target == "cpn60_H279_H1612" ];
    then

        adapter1_f="H279bf=GANNNNGCNGGNGAYGGNACNACNACN"
        adapter2_f="H279bfR=NGTNGTNGTNCCRTCNCCNGCNNNNTC"
        adapter1_r="H1612r=GTSGTSGTRCCGTCRCCNGCNNNNTC"
        adapter2_r="H1612rR=GANNNNGCNGGYGACGGYACSACSAC"
        
    # cpn60_H280_H1613 adapters.
    elif [ $target == "cpn60_H280_H1613" ];
    then

        adapter1_f="H280bf=AARGCNCCNGGNTTYGGNGANMRNMR"
        adapter2_f="H280bfR=YKNYKNTCNCCRAANCCNGGNGCYTT"
        adapter1_r="H1613r=CGRCGRTCRCCGAAGCCSGGNGCCTT"
        adapter2_r="H1613rR=AAGGCNCCSGGCTTCGGYGAYCGYCG"

    else
        echo "Please enter 16S_515_806, 16S_515_926, ITS, cpn60_H279_H1612, or cpn60_H280_H1613 for the correct adapters in each column of the metadata file. Please see in script for adapter sequences for these target values.";
        exit 0;
    fi
    echo $adapter1_f;
    echo $adapter2_f;
    echo $adapter1_r;
    echo $adapter2_r;
}

### Flash2 program parameters.

# The flash2 output file suffix.
flash_output_suffix=".cutadapt.trim.merge"

# The manifest file fastq file suffix.
manifest_fastq_suffix=".cutadapt.trim.merge.extendedFrags.fastq";

## Flash2 command configuration data.
fragment_length=240
fragment_length_stddev=50
read_length=250

preprocessing_dir="${output_dir}/pre_processing"
mkdir -p ${preprocessing_dir}

cutadapt_dir="${preprocessing_dir}/cutadapt"
mkdir -p ${cutadapt_dir}

flash_merge_dir="${preprocessing_dir}/flash2_merge";
mkdir -p ${flash_merge_dir}

### Running cutadapt.
# Make sure that the input field separator for newlines is a newline character '\n'.
IFS=$'\n'

# Get the header line of the metadata file.
header=$(head -n+1 $metadata_infile);

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

# Get rows starting after the header line using tail -n+2.
for row in $(tail -n+2 $metadata_infile);
do
    echo $row;
    project_name=$(echo $row | tr '\t' ',' | cut -d ',' -f $project_index);
    target_name=$(echo $row | tr '\t' ',' | cut -d ',' -f $target_index);

    echo $project_name;
    echo $target_name;
    
    # Get the adapters for this entry based on the target column value.
    get_target_adapters "$target_name"
    
    # Activate the cutadapt conda environment.
    conda activate cutadapt_env
    
    cutadapt \
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

    # Activate the flash2 conda environment.
    conda activate flash2_env

    flash2 \
    -f ${fragment_length} \
    -s ${fragment_length_stddev} \
    -r ${read_length} \
    ${cutadapt_dir}/${i}${cutadapt_read1_suffix} \
    ${cutadapt_dir}/${i}${cutadapt_read2_suffix} \
    -d ${flash_merge_dir} \
    -o ${i}${flash_output_suffix} \

done

# The manifest input file that lists the sample ids, path to the fastq files and direction.#Manifest file must be .csv with column headers: sample-id,absolute-filepath,direction
#eg line: D01-01ppm2010_S10_L001,/home/AAFC-AAC/dumonceauxt/Topp_antifungal/pre_processing/downsampled/D01-01ppm2010_S10_L001.cutadapt.trim.merge.downsampled,forward
fastq_manifest_infile="${preprocessing_dir}/fastq_sample_manifest.csv"

## Generate the manifest file for qiime2.
echo "Generate the manifest file for qiime2."
echo "sample-id,absolute-filepath,direction" > ${fastq_manifest_infile};
for i in $(cat ${fastq_list_file});
do
    echo $i;
    echo -e "${i},${flash_merge_dir}/${i}${manifest_fastq_suffix},forward" >> ${fastq_manifest_infile};
done

echo "The prepocessing.sh script has finished."

