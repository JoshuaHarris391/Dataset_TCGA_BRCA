# defining path to gdc transfer tool
GDC_CLIENT=~/tools/gdc-client
# Setting wd
cd /Users/joshua_harris/Dropbox/Research/PhD/Bioinformatics/Datasets/Dataset_TCGA_BRCA
# Making dir
mkdir -p ./data/gdc_clinical
# Changing dir
cd ./data/gdc_clinical
# downloading files from manifest
$GDC_CLIENT download -m /Users/joshua_harris/Dropbox/Research/PhD/Bioinformatics/Datasets/Dataset_TCGA_BRCA/gdc_manifest/gdc_manifest.2020-08-26_clinical.txt
