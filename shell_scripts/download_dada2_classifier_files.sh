#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --partition=cpu2019

### Program for downloading 16S rRNA or ITS fasta files for qiime feature-classifier for dada2.

#can use a screen session for this-takes a while. Type screen. To detach, type ctrlAD; to resume; screen -r (job name); to kill, ctrlAK
while getopts i:o: option
do
case "${option}"
in
i) DATABASE_TYPE=${OPTARG};;
o) OUTPUT_DIR=${OPTARG};;
esac
done


echo $DATABASE_TYPE
echo $OUTPUT_DIR
#exit 0;

if [[ "${DATABASE_TYPE}" == 'silva_16S_138_99_515_806' ]];
then
	echo "Downloading the silva_16S_138_99_515_806 database."
elif [[ "${DATABASE_TYPE}" == 'ITS_Unite' ]];
then
	echo "Downloading the ITS_Unite database."
else
	echo "You entered ${DATABASE_TYPE} for the database type."
	echo "Please enter silva_16S_138_99_515_806 for the Silva 138 16S rRNA 515/806 classifier or ITS_Unite for the ITS Unite fungal classifier! Use the -i parameter option for the DATABASE_TYPE."
	exit 0;
fi

if [ -z $OUTPUT_DIR ];
then
	echo "You entered ${OUTPUT_DIR}."
	echo "Please enter a valid directory path!"
	exit 0;
fi
echo "Starting download script...."

# Get the conda file path from source and activate the conda environment.
#source ~/.bash_profile
#source ~/.bashrc

#source /home/muirheadk/miniconda3/etc/profile.d/conda.sh
source /home/AGR.GC.CA/muirheadk/miniconda3/etc/profile.d/conda.sh
conda activate qiime2-2022.2

# echo $DATABASE_TYPE
# echo $OUTPUT_DIR

# Create the output directory output_dir if it does not exist.
if [ ! -d $OUTPUT_DIR ] 
then
    mkdir -p $OUTPUT_DIR
fi

# Create the classifier output directory classifier_dir if it does not exist.
classifier_dir="${OUTPUT_DIR}/classifiers"
if [ ! -d $classifier_dir ] 
then
    mkdir -p $classifier_dir
fi

cd ${classifier_dir}

# Get the most recent classifier.
if [[ "${DATABASE_TYPE}" == "silva_16S_138_99_515_806" ]];
then
	## SILVA 16S rRNA fasta.
	

	# Create the silva output directory silva_dir if it does not exist.
	silva_dir="${classifier_dir}/silva_16S_138_99_515_806"
	if [ ! -d $silva_dir ] 
	then
		mkdir -p $silva_dir
	fi
	cd ${silva_dir}
	
	# Downloading the silva-138-99-seqs-515-806.qza file.
	echo "Downloading the silva-138-99-seqs-515-806.qza file."
	wget -O silva-138-99-seqs-515-806.qza https://data.qiime2.org/2022.2/common/silva-138-99-seqs-515-806.qza
	
	# Downloading the silva-138-99-tax-515-806.qza file file.	
	echo "Downloading the silva-138-99-tax-515-806.qza file."
	wget -O silva-138-99-tax-515-806.qza https://data.qiime2.org/2022.2/common/silva-138-99-tax-515-806.qza

	######
	## Import the sh_refs_qiime_ver7_99_01.12.2017.fasta FeatureData[Sequence].
	# echo "Importing the sh_refs_qiime_ver7_99_01.12.2017.fasta FeatureData[Sequence]."
	# qiime tools import \
	 # --type FeatureData[Sequence] \
	 # --input-path sh_refs_qiime_ver7_99_01.12.2017.fasta \
	 # --output-path unite-ver7-99-seqs-01.12.2017.qza


	##Import the sh_taxonomy_qiime_ver7_99_01.12.2017.txt FeatureData[Taxonomy].
	# echo "Importing the sh_taxonomy_qiime_ver7_99_01.12.2017.txt FeatureData[Taxonomy]."
	# qiime tools import \
	 # --type FeatureData[Taxonomy] \
	 # --input-path sh_taxonomy_qiime_ver7_99_01.12.2017.txt \
	 # --output-path unite-ver7-99-tax-01.12.2017.qza \
	 # --input-format HeaderlessTSVTaxonomyFormat
	######
	
	# Run qiime feature-classifier fit-classifier-naive-bayes.
	echo "Executing qiime feature-classifier fit-classifier-naive-bayes."
	qiime feature-classifier fit-classifier-naive-bayes \
	 --i-reference-reads silva-138-99-seqs-515-806.qza \
	 --i-reference-taxonomy silva-138-99-tax-515-806.qza \
	 --o-classifier silva-138-99-classifier-515-806.qza
	 
elif [[ "${DATABASE_TYPE}" ==  "ITS_Unite" ]];
then
	## UNITE ITS fasta.
	
	# Downloading the sh_qiime_release_01.12.2017.zip file.
	echo "Downloading the sh_qiime_release_01.12.2017.zip file."
	wget -O sh_qiime_release_01.12.2017.zip https://files.plutof.ut.ee/doi/0A/0B/0A0B25526F599E87A1E8D7C612D23AF7205F0239978CBD9C491767A0C1D237CC.zip 

	# Unzip the sh_qiime_release_01.12.2017.zip file.
	echo "Unzip the sh_qiime_release_01.12.2017.zip file."
	unzip sh_qiime_release_01.12.2017.zip -d unite_20171201

	unite_dir="${classifier_dir}/unite_20171201"
	cd ${unite_dir}

	# Import the sh_refs_qiime_ver7_99_01.12.2017.fasta FeatureData[Sequence].
	echo "Importing the sh_refs_qiime_ver7_99_01.12.2017.fasta FeatureData[Sequence]."
	qiime tools import \
	 --type FeatureData[Sequence] \
	 --input-path sh_refs_qiime_ver7_99_01.12.2017.fasta \
	 --output-path unite-ver7-99-seqs-01.12.2017.qza

	# Import the sh_taxonomy_qiime_ver7_99_01.12.2017.txt FeatureData[Taxonomy].
	echo "Importing the sh_taxonomy_qiime_ver7_99_01.12.2017.txt FeatureData[Taxonomy]."
	qiime tools import \
	 --type FeatureData[Taxonomy] \
	 --input-path sh_taxonomy_qiime_ver7_99_01.12.2017.txt \
	 --output-path unite-ver7-99-tax-01.12.2017.qza \
	 --input-format HeaderlessTSVTaxonomyFormat

	# Run qiime feature-classifier fit-classifier-naive-bayes.
	echo "Executing qiime feature-classifier fit-classifier-naive-bayes."
	qiime feature-classifier fit-classifier-naive-bayes \
	 --i-reference-reads unite-ver7-99-seqs-01.12.2017.qza \
	 --i-reference-taxonomy unite-ver7-99-tax-01.12.2017.qza \
	 --o-classifier unite-ver7-99-classifier-01.12.2017.qza
fi


