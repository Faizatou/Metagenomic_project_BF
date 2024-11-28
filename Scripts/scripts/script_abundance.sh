#!/bin/bash
# Calculate taxonomic abundance from Kraken2 reports

# Define input and output directories
kraken2_report_dir="/home/sorgho/output_dir"   # Directory where Kraken2 report files are located
output_abundance_file="/home/sorgho/taxonomic_abundance.txt"  # Output file for taxonomic abundance

# Create output file and add headers
echo -e "Taxon_ID\tTaxon_Name\tTaxonomic_Level\tTotal_Reads\tAbundance_Percentage" > $output_abundance_file

# Loop over each Kraken2 report file
for report_file in $kraken2_report_dir/*_kraken2_report.txt; do
  # Extract the base name of the report file (without the extension)
  filename=$(basename "$report_file" "_kraken2_report.txt")

  echo "Processing $report_file ..."

  # Read Kraken2 report file and process each line
  while IFS=$'\t' read -r perc_reads num_reads tax_rank tax_id tax_name; do
    # Skip header lines or lines without taxonomic information
    if [[ "$perc_reads" == "C" || -z "$perc_reads" || -z "$num_reads" || -z "$tax_name" ]]; then
      continue
    fi

    # Calculate the relative abundance (in percentage)
    tax_level=$tax_rank
    total_reads=$(echo "$num_reads" | awk '{print $1}')
    abundance_percentage=$perc_reads

    # Write the taxonomic abundance to the output file
    echo -e "$tax_id\t$tax_name\t$tax_level\t$total_reads\t$abundance_percentage" >> $output_abundance_file

  done < "$report_file"

done

echo "Taxonomic abundance calculation completed. Results saved to $output_abundance_file."
