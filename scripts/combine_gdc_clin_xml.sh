# set wd
cd /Users/joshua_harris/Dropbox/Research/PhD/Bioinformatics/Datasets/Dataset_TCGA_BRCA/data/
# Making new dir
mkdir -p gdc_clinial_combined_xml


# Find all xml files and copy to new folder
for count_path in $(find ./gdc_clinical -name "*nationwidechildrens.org_clinical*.xml"); do
	#statements
	echo "[COPYING] ${count_path}"
	cp $count_path ./gdc_clinial_combined_xml/
done

# Building file with XML paths
cd /Users/joshua_harris/Dropbox/Research/PhD/Bioinformatics/Datasets/Dataset_TCGA_BRCA/

for count_path in $(find data/gdc_clinial_combined_xml -name "*nationwidechildrens.org_clinical*.xml"); do
	#statements
	echo "${count_path}" >> data/gdc_clinial_combined_xml_filenames.txt
done
