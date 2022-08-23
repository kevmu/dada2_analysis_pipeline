##transfer ITS_phyloseq.biom to folder R/Topp-soil-ITS/Data on local computer
##analyze using phyloseq
##folder structure in R/Topp-soil-ITS: 3 folders: Data; Figures; R_code
##Jen provided the R code; needs to be tuned to this data (ITS only) - data import, alpha diversity, beta diversity
##tutorials for phyloseq: https://joey711.github.io/phyloseq/preprocess.html http://evomics.org/wp-content/uploads/2016/01/phyloseq-Lab-01-Answers.html

##qiime statistics - calculate these and export for excel (tsv or csv)
##make day.txt
##make treatment.txt
##use nano - make sure syntax matches JJRLC_Metadata.txt - ie D0 D7 D30
##check code below for Metadata.txt; must change to JJRLC_Metadata.txt

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime feature-table filter-samples \
  # --i-table ${dada2_table_min_samples_filtered_file} \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --p-where "[Day] = '$i'" \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_table-filtered.qza' \
# ; done

## rarefied data - to 10k
# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity core-metrics \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_table-filtered.qza' \
  # --p-sampling-depth 10000 \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --output-dir /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000' \
# ; done

##the command below yielded an error - There must be at least one metadata column that contains categorical data, isn't empty, doesn't consist of unique values, and doesn't consist of exactly one value.
# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000'/shannon_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_shannon_group_significance.qzv' \
# ; done

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000'/observed_otus_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_observed_otus_group_significance.qzv' \
# ; done 

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_core-metrics-10000'/evenness_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/day$i'_evenness_group_significance.qzv' \
# ; done 

##repeat for treatment
# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime feature-table filter-samples \
  # --i-table ${dada2_table_min_samples_filtered_file} \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --p-where "[Treatment] = '$i'" \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_table-filtered.qza' \
# ; done

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity core-metrics \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_table-filtered.qza' \
  # --p-sampling-depth 10000 \
  # --m-metadata-file ${dataset_metadata_file}  \
  # --output-dir /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000' \
# ; done

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000'/shannon_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_shannon_group_significance.qzv' \
# ; done 

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000'/observed_features_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_observed_otus_group_significance.qzv' \
# ; done 

# for i in `cat /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/treatment.txt` \
# ; do qiime diversity alpha-group-significance \
 # --i-alpha-diversity /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_core-metrics-10000'/evenness_vector.qza \
 # --m-metadata-file ${dataset_metadata_file} \
 # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/trt$i'_evenness_group_significance.qzv' \
# ; done 

##Permanova

# qiime diversity beta-group-significance \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --m-metadata-column Treatment \
  # --p-pairwise True \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_permanova_trt.qzv

# qiime diversity beta-group-significance \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --m-metadata-column Treatment \
  # --p-pairwise True \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_permanova_trt.qzv

# qiime diversity adonis \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --p-formula "Treatment*Day" \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/bray_curtis_adonis_trt_day.qzv

# qiime diversity adonis \
  # --i-distance-matrix /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_distance_matrix.qza  \
  # --m-metadata-file ${dataset_metadata_file} \
  # --p-formula "Treatment*Day" \
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/JJRLC_core-metrics-results-10000/jaccard_adonis_trt_day.qzv

##ANCOM

# qiime feature-table filter-samples \
  # --i-table ${dada2_table_min_samples_filtered_file} \
  # --m-metadata-file ${dataset_metadata_file} \
  # --p-min-frequency 2000 \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-filtered-minfreq.qza

# qiime feature-table filter-features \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-filtered-minfreq.qza \
  # --p-min-frequency 10 \
  # --p-min-samples 4 \
  # --o-filtered-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom.qza

# qiime composition add-pseudocount \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom.qza \
  # --o-composition-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_comp.qza

# qiime composition ancom \
  # --i-table /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_comp.qza \
  # --m-metadata-file ${dataset_metadata_file} \
  # --m-metadata-column Treatment\
  # --o-visualization /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt.qzv

# qiime tools export \
  # --input-path /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt.qzv \
  # --output-path /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt-exported

# awk '$3 == "True"' \
 # /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt-exported/ancom.tsv \
# > /home/AAFC-AAC/dumonceauxt/Topp_antifungal/qiime2/ITS-ancom_trt-exported/JJRLC_TRUE_ancom.tsv 


