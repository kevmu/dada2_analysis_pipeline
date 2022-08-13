#Taxonomy
echo "Starting download script...."

# Get the conda file path from source and activate the conda environment.
source ~/.bash_profile
conda activate qiime2-2022.2

#can use a screen session for this-takes a while. Type screen. To detach, type ctrlAD; to resume; screen -r (job name); to kill, ctrlAK

#Get the most recent UNITE classifier
classifier_dir="/export/home/AAFC-AAC/muirheadk/projects/classifiers"
mkdir ${classifier_dir}
cd ${classifier_dir}

# Downloading the sh_qiime_release_01.12.2017.zip file.
echo "Downloading the sh_qiime_release_01.12.2017.zip file."
wget -O sh_qiime_release_01.12.2017.zip https://files.plutof.ut.ee/doi/0A/0B/0A0B25526F599E87A1E8D7C612D23AF7205F0239978CBD9C491767A0C1D237CC.zip 

# Unzip the sh_qiime_release_01.12.2017.zip file.
echo "Unzip the sh_qiime_release_01.12.2017.zip file."
unzip sh_qiime_release_01.12.2017.zip -d unite_20171201

unite_dir="/export/home/AAFC-AAC/muirheadk/projects/classifiers/unite_20171201"
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


