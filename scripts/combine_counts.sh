# Make sure to decompress counts_backup.zip before running script
# set wd
cd /Users/joshua_harris/Dropbox/Research/PhD/Bioinformatics/Datasets/Dataset_TCGA_BRCA/data/RNAseq/
# Making new dir
mkdir -p ./read_counts


# Find all gz files and copy to new folder
for count_path in $(find ./counts -name "*.gz"); do
	#statements
	echo "[COPYING] ${count_path}"
	cp $count_path ./read_counts/
done


# decompressing gz files
for file_gz in $(find ./read_counts -name "*.gz"); do
	#statements
	echo "[DECOMPRESSING] ${file_gz}"
	gunzip $file_gz
done

# renaming files
for file_gz in $(find ./read_counts -name "*.counts"); do
	#statements
	echo "[RENAMING] ${file_gz}"
	# renaming files
	mv $file_gz ${file_gz}.txt
done

