#!/bin/bash

# Set paths to your directories and files
input_dir="/projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR"      # Directory containing the FASTQ files
output_dir="/home/sorgho/output_dir/DIAMOND_Results"      # Directory where the DIAMOND results will be saved
diamond_db="/diamond/database"    # Path to your DIAMOND protein database
diamond_exec="diamond"                    # DIAMOND executable (assuming it's in the PATH)

# Create the Results directory
mkdir -p DIAMOND_Results

# Loop through each FASTQ file in the input directory
for fastq_file in $input_dir/*.fastq.gz; do
    # Extract the base name of the FASTQ file (without path and extension)
    filename=$(basename "$fastq_file" .fastq.gz)

    # Define output files for DIAMOND results
    diamond_output="$output_dir/${filename}_diamond_output.dmnd"
    diamond_report="$output_dir/${filename}_diamond_report.txt"

    # Run DIAMOND alignment (using blastx for nucleotide-to-protein alignment)
    echo "Running DIAMOND for $fastq_file ..."
    $diamond_exec blastx \
        --db $diamond_db \
        --query $fastq_file \
        --out $diamond_output \
        --outfmt 6 \
        --threads 4 \
        --more-sensitive \
        --verbose \
        --report $diamond_report

    # Check if DIAMOND was successful
    if [ $? -eq 0 ]; then
        echo "DIAMOND analysis completed for $fastq_file. Results saved to $diamond_output and $diamond_report."
    else
        echo "Error: DIAMOND failed for $fastq_file."
    fi
done

echo "All FASTQ files have been processed."
