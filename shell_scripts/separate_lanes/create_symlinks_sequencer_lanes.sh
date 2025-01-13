# The fastq read 1 suffix.
read1_fastq_suffix="_R1_001.fastq.gz"

# The fastq read 2 suffix.
read2_fastq_suffix="_R2_001.fastq.gz"

# The fastq file extension.
fastq_ext=$(echo $read1_fastq_suffix | cut -d '.' -f2-)
#echo $fastq_ext
#exit 0;

# The output directory to make symbolic links.
output_dir="/home/AGR.GC.CA/muirheadk/drought_dataset/fastq_files"
mkdir -p $output_dir

# The fastq path list file.
fastq_paths_file="${output_dir}/fastq_paths_list.txt"

# Initialize the shell array so that we can index the following paths by array index.
#"/archive/townj/illumina_archive/240502_M01666_0223_000000000-LFJP3/Fastq"
#"/archive/townj/illumina_archive/240529_M01666_0228_000000000-LH5TF/Fastq"
#"/archive/townj/illumina_archive/241112_M01666_0242_000000000-LRBM9/Fastq"

paths=( "/archive/townj/illumina_archive/240502_M01666_0223_000000000-LFJP3/Fastq" "/archive/townj/illumina_archive/240529_M01666_0228_000000000-LH5TF/Fastq" "/archive/townj/illumina_archive/241112_M01666_0242_000000000-LRBM9/Fastq")

for path in "${paths[@]}"
do
	echo $path
	lane_name=$(echo $path | rev | cut -d '/' -f2 | rev)

	new_lane_dir="${output_dir}/${lane_name}"
	mkdir -p $new_lane_dir

	for file in $(find ${path} -type f -name "*.${fastq_ext}" | sort -V);
	do
		echo $file
		filename=$(echo $file | rev| cut -d '/' -f1 | rev | sed 's/-/_/g')
		new_file="${new_lane_dir}/${filename}"
                echo $filename
		
		echo "ln -s ${file} ${new_file}"
		ln -s ${file} ${new_file}
	done

done

##### ONLY USE unlink to remove symbolic links or risk losing the file if you use the remove command.

