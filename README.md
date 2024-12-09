# Metagenomic_project_BF

## TABLE OF CONTENTS
- Insight
- Trainees
- SUpervisors
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
Faizatou S SORGHO (URCN)
Emilie S BADOUM (GRAS)

## SUPERVISORS
Romuald BOUA (URCN)
Ezéchiel B TIBIRI (INERA)

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
- Prokka
- Kaiju

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

# Inspect the database content
kraken2-inspect --db kraken_database | head -15
```

Step 4.2 : Run Kraken2

```bash
kraken2 --db kraken_database/ /projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR/ERR38068*.fastq.gz --report report.txt --report-minimizer-data --> output_kraken
```

Step  4.3 : Vizualise kraken2 output with krona
```bash
ktImportTaxonomy -m 3 -t 5 report.txt -o kraken.html 2> krakenkrona.err
```

4. Use Diamond for taxonomic assignation
   
4.1. Download bacteria bank
   
## Contact us 
Faizatou S SORGHO (sorghofaiza@gmail.com)
Emilie S BADOUM (e.badoum@gras.bf)
Ezechiel B TIBIRI (ezechiel.tibiri@wave-center.org)
Romuald BOUA (romyboua@gmail.com)


