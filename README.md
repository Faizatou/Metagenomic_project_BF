# Metagenomic_project_BF

## TABLE OF CONTENTS
- Insight
- Trainees
- Supervisors
- Objectives
- Project description
- Mind map
- Software used
- Bioinformatics analysis
- Jupyter book
- License
- Contact us
  
## INSIGHT
This project involves developing and implementing an analysis plan for metagenomic data generated on an ONT platform.
Here we want to define and implement the analysis steps and make the scripts available to ensure reproducibility. The data were obtained from ENA (PRJEB34900).

By using this platform, the user will be able to reproduce all the results presented in this project.

## TRAINEES
- Faizatou S SORGHO (URCN)
- Emilie S BADOUM (GRAS)

## SUPERVISORS
- Romuald BOUA (URCN)
- Ezéchiel B TIBIRI (INERA)

## OBJECTIVE OF THIS TRAINING
By submitting this tutored project, our supervisors' focus is to ensure that we will not only be able to perform bioinformatics analyses, but also that we will be able to interpret the results we obtain. The specific aim is to detect contaminants in water using metagenomics analysis.
At the end of this training or tutored project, we should be able to:
- Acquire specific technical skills (pre-processing of sequencing data, sequence assembly)
- Deepen theoretical knowledge of water contaminants
- Analyze data (practical use of real data)

##  PROJECT DESCRIPTION :  Development and implementation of an analysis plan for metagenomic data generated on an ONT platform
While traditional freshwater microbiological tests focus on the detection of specific bacterial indicator species, including pathogens, direct tracing of all aquatic DNA using metagenomics offers an interesting alternative. However, in situ water metagenomic studies face considerable cost and logistical challenges. 
Using defined compositions and the spatio-temporal microbiota of surface water from an example river in Cambridge (UK), we provide here guidelines for bioinformatic analyses. At the end of this work, based on the data provided, we hope to gain a better understanding of the community of water contaminants, while specifying the most predominant ones.
These data come from environmental (water) samples (Urban et al., 2021; https://elifesciences.org articles/61504). The data are available for download from ENA at the following link: https://www.ebi.ac.uk/ena/browser/view/PRJEB34900
In practice, we will need to define and carry out the analysis steps and make the scripts available to ensure reproducibility.

## MIND MAP
Before setting out the various stages of this activity, a mind map was drawn up to highlight the different axes on which the whole of this work will be carried out. Here is the link :

## SOFTAWARE USED
- Nanoplot
- Kraken2
- Krona
- Diamond
- Canu

## BIONINFORMACTIC ANALYSIS

### Step 1 : Get metagenomic data
We will analyse a freshwater Sample (Urban et al., 2021; https://elifesciences.org/articles/61504).
* Connect to the cluster on your terminal via your login
```bash
ssh login@bioinfo-master1.ird.fr
```
* Connect to a node on a specific partition according to your analyses
x = partition
y = number of cpus

```bash
srun -p x -c y --pty bash -i
```
```bash
mkdir -p Data
cd Data
# download your compressed freshwater Sample, https://www.ebi.ac.uk/ena/browser/view/PRJEB34900 ERR3806859_1-ERR3806892_1
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR380/009/ERR3806859/ERR3806859_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR380/006/ERR3806876/ERR3806876_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR380/000/ERR3806860/ERR3806860_1.fastq.gz
```

### Step 2 : Basecalling

Electrical signals are stocked on fast5 format files when DNA molecules are sequenced.
These signals need to be converted on standard fastq files to post-analysis.
Several training dataset models are usually used to convert fast5 to fastq. For this Job we used Guppy

### Step 3 : Quality Control on Long Reads with Nanoplot

Control reads quality using Nanoplot. You can parameter this tool using --help.

```bash
NanoPlot --help

Install Nanoplot/1.44.0
NanoPlot -t 8 --fastq ~/projet_BS/Data/*fastq.gz --outdir NANOPLOT_files

#test for one sample
NanoPlot --fastq /home/faiza/Downloads/projet_turore/database_initial/ERR3806875_1.fastq.gz --outdir ./output 

# for all of sample
NanoPlot --fastq /home/faiza/Downloads/projet_turore/database_initial/ERR38068*.fastq.gz --outdir ./output_combined
```
Observe Stats

### Step 4 : Use KRAKEN2 for taxonomic assignation

Step 4.1 : Download a bacterial database

```bash
Kraken2 --help

kraken2-build --special "silva" --db kraken_database/.
```

Step 4.2 : Kraken2 command 
Define the directory containing FASTQ files
```bash
input_dir="/projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR"  # Replace with your actual input directory
output_dir="/home/sorgho/output_dir"  # Replace with your desired output directory
kraken2_db="/home/sorgho/kraken_database"  # Replace with the path to your Kraken2 database
```
Create output directory if it doesn't exist
```bash
mkdir -p $output_dir
### Check if Kraken2 database exists
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
```

Run Kraken2 
```bash
kraken2 --db kraken_database/ /projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR/ERR38068*.fastq.gz --report report.txt --report-minimizer-data --> output_kraken
# Inspect the database content
kraken2-inspect --db kraken_database | head -15
```

Step  4.3 : Vizualise kraken2 output with krona
```bash
ktImportTaxonomy -m 3 -t 5 report.txt -o kraken.html 2> krakenkrona.err
```

Step 4.4 : Calculate taxonomic abundance from Kraken2 reports

Define input and output directories
```bash
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
```
### Step 5 : Use Diamond for taxonomic assignation
Step 5.1. Download bacteria bank
```bash
Set paths to your directories and files
input_dir="/projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR"      # Directory containing the FASTQ files
output_dir="/home/sorgho/output_dir/DIAMOND_Results"      # Directory where the DIAMOND results will be saved
diamond_db="/diamond/database"    # Path to your DIAMOND protein database
diamond_exec="diamond"                    # DIAMOND executable (assuming it's in the PATH)
```

Step 5.2 : Run Diamond 
```bash
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
 ```
### Step 6 : Genome Assembly with Canu
  
## Contact us 
- Faizatou S SORGHO (sorghofaiza@gmail.com)
- Emilie S BADOUM (e.badoum@gras.bf)
- Ezechiel B TIBIRI (ezechiel.tibiri@wave-center.org)
- Romuald BOUA (romyboua@gmail.com)


