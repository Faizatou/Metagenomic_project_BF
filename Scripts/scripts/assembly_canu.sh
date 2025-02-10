#!/bin/bash

# Définir les variables
INPUT_DIR="/projects/medium/CIBIG_metagenomic_eaux/RAW_DATA/FASTQ_DIR"  # Remplacer par le chemin réel
GENOME_SIZE="2.0m"          # Taille estimée du génome pour un projet métagénomique. Ajustez si nécessaire.
OUTPUT_ROOT_DIR="output_dir"  # Répertoire où les résultats seront enregistrés.
PREFIX="16S_assembly"         # Préfixe des fichiers de sortie.
THREADS=4                     # Nombre de threads (ajustez selon votre matériel).

# Boucle pour traiter chaque fichier FASTQ dans le répertoire d'entrée
for fastq_file in $INPUT_DIR/*.fastq.gz; do
  # Extraire le nom du fichier sans l'extension
  filename=$(basename "$fastq_file" .fastq.gz)

  # Définir le répertoire de sortie spécifique à chaque fichier FASTQ
  OUTPUT_DIR="$OUTPUT_ROOT_DIR/${filename}_16S_assembly"

  # Créer le répertoire de sortie si nécessaire
  mkdir -p $OUTPUT_DIR

  # Exécuter CANU pour chaque fichier FASTQ
  echo "Traitement de $fastq_file ..."
  canu -p $PREFIX -d $OUTPUT_DIR genomeSize=$GENOME_SIZE -nanopore-raw $fastq_file

  echo "Analyse terminée pour $fastq_file. Résultats dans $OUTPUT_DIR."
done

echo "Tous les fichiers FASTQ ont été traités."

# Optionnel : suivre les logs en temps réel pendant l'exécution
# Cela vous permettra de suivre les logs de l'assemblage
tail -f $OUTPUT_ROOT_DIR/*/*.log

