#!/bin/bash
## Run Kraken2 for taxonomic assignment

# Define the directory containing FASTQ files
input_dir="/projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR"  # Replace with your actual input directory
output_dir="/home/sorgho/output_dir"  # Replace with your desired output directory
kraken2_db="/home/sorgho/kraken_database"  # Replace with the path to your Kraken2 database

# Create output directory if it doesn't exist
mkdir -p $output_dir

# Check if Kraken2 database exists
if [ ! -d "$kraken2_db" ]; then
  echo "Error: Kraken2 database directory '$kraken2_db' does not exist."
  exit 1
fi

# Check if there are any FASTQ files to process
shopt -s nullglob
fastq_files=($input_dir/*.fastq.gz)
if [ ${#fastq_files[@]} -eq 0 ]; then
  echo "Error: No FASTQ files found in '$input_dir'."
  exit 1
fi

# Loop through each FASTQ file in the input directory
for fastq_file in "${fastq_files[@]}"; do
  # Extract the base name of the file (without the extension)
  filename=$(basename "$fastq_file" .fastq.gz)

  # Define the output files for Kraken2
  output_file="$output_dir/${filename}_kraken2_report.txt"
  classified_output_file="$output_dir/${filename}_kraken2_classified.txt"

  # Run Kraken2 for each FASTQ file
  echo "Processing $fastq_file ..."
  kraken2 --db "$kraken2_db" --report "$output_file" --output "$classified_output_file" "$fastq_file"

  # Check if Kraken2 ran successfully
  if [ $? -eq 0 ]; then
    echo "Analysis completed for $fastq_file. Results saved to $output_file and $classified_output_file."
  else
    echo "Error: Kraken2 failed for $fastq_file."
  fi
done

echo "All FASTQ files have been processed."


