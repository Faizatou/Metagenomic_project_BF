
library(dplyr)

# load database

taxonomic_abundance_April_1 <- taxonomic_abundance_April %>% 
  group_by(Taxon_ID,Taxonomic_Level,) %>% 
  summarise(Abundance_Percentage = sum(Abundance_Percentage, na.rm = T)) %>% 
  rename(April = Abundance_Percentage)

taxonomic_abundance_June_1 <- taxonomic_abundance_June %>% 
  group_by(Taxon_ID,Taxonomic_Level,) %>% 
  summarise(Abundance_Percentage = sum(Abundance_Percentage, na.rm = T)) %>% 
  rename(June = Abundance_Percentage)

taxonomic_abundance_August_1 <- taxonomic_abundance_August %>% 
  group_by(Taxon_ID,Taxonomic_Level,) %>% 
  summarise(Abundance_Percentage = sum(Abundance_Percentage, na.rm = T)) %>% 
  rename(August = Abundance_Percentage)


taxonomic_abundance <- taxonomic_abundance_April_1 %>% 
  left_join(taxonomic_abundance_June_1, by=c("Taxon_ID","Taxonomic_Level",)) %>%
  left_join(taxonomic_abundance_August_1, by=c("Taxon_ID","Taxonomic_Level")) 
#reorganization col
taxonomic_abundance <- taxonomic_abundance_1, by=c("Taxon_ID", setdiff(names(taxonomic_abundance), "Taxon_ID"))
library(dplyr)

taxonomic_abundance_1 <- taxonomic_abundance %>%
  select(Taxon_ID, everything())

April_sum <- sum(taxonomic_abundance$April, na.rm = T)
June_sum <- sum(taxonomic_abundance$June, na.rm = T)
Aug_sum <- sum(taxonomic_abundance$August, na.rm = T)

options(scipen = 999)

taxonomic_abundance <- taxonomic_abundance_April_1 %>%
  filter()
  mutate(April_perc = April/April_sum*100)

  Charger les bibliothèques nécessaires
  library(tidyr)
  library(dplyr)
  
  # Utiliser pivot_wider pour transformer les mois en colonnes
  tax_wide <- taxonomic_abundance_1 %>%
    pivot_wider(names_from = Taxon_ID, values_from = c(April, June, August))
  
  # Voir les résultats
  print(tax_wide)
  # Charger phyloseq
  library(phyloseq)
  
  # Créer l'otu_table en utilisant les colonnes de données d'abondance (April, June, August)
  otu_data <- taxonomic_abundance_1[, c("April", "June", "August")]  # Extraire les colonnes d'abondance
  rownames(otu_data) <- taxonomic_abundance_1$Taxonomic_Level  # Utiliser Taxononomic_level comme rownames
  
  # Créer l'OTU table
  otu_table_obj <- otu_table(as.matrix(otu_data), taxa_are_rows = TRUE)  # taxa_are_rows = TRUE signifie que les lignes correspondent aux taxons
  # Créer une tax_table avec les informations taxonomiques
  
  tax_data <- taxonomic_abundance[, c("Taxonomic_Level", "Taxon_ID")]
  
  # Ajouter des colonnes pour chaque niveau taxonomique (par exemple, Kingdom, Phylum, etc.)
  # Remplir avec des valeurs NA ou un niveau générique si ces informations ne sont pas disponibles
  
  tax_data$D <- NA
  tax_data$P <- NA
  tax_data$C <- NA
  tax_data$O <- NA
  tax_data$F <- NA
  tax_data$G <- NA
  
  # Créer la tax_table
  tax_table_obj <- tax_table(as.matrix(tax_data[, -2]))  # Enlever Taxon_ID pour que chaque colonne soit un niveau taxonomique
  Créer les métadonnées des échantillons
  sample_data_obj <- sample_data(data.frame(
    Sample = c("April", "June", "August"),
    Month = c("April", "June", "August"),
    row.names = c("April", "June", "August")
  )) 
  # Créer l'objet phyloseq
  physeq <- phyloseq(otu_table_obj, tax_table_obj, sample_data_obj)
  
  # Vérifier l'objet phyloseq
  physeq                      
  # Calculer la diversité alpha (Shannon Index)
  richness <- estimate_richness(physeq, measures = "Shannon")
  
  # Afficher les résultats de la diversité alpha
  print(richness)
  # Réaliser une ordination PCoA (distance Bray-Curtis)
  ordination <- ordinate(physeq, method = "PCoA", distance = "bray", na.rm = T)
  
  # Visualiser l'ordination
  plot_ordination(physeq, ordination, color = "Month") + geom_point(size= 3)
  # Créer une heatmap des 20 premiers taxons (par exemple)
  plot_heatmap(physeq, taxa.label = "Genus", sample.label = "Month", z.taxa = 1:10)
  
  library(ggplot2)
            
#Vérifiez les NA et Inf dans les données de l'OTU table
sum(is.na(otu_table(physeq)))
sum(is.infinite(otu_table(physeq)))

# Si vous avez des NA, vous pouvez les remplacer par zéro (ou une autre valeur de votre choix)
otu_table(physeq)[is.na(otu_table(physeq))] <- 0

# Si vous avez des valeurs infinies, vous pouvez également les remplacer par zéro ou une autre valeur
otu_table(physeq)[is.infinite(otu_table(physeq))] <- 0

# Essayez de nouveau de générer la heatmap
plot_heatmap(physeq, taxa.label = "Genus", sample.label = "Month", z.taxa = 1:10, na.rm = T)           
Créer un bar plot des taxons au niveau du genre

bar_plot <- plot_bar(physeq, x = "Sample", fill = "G")

# Afficher le graphique
bar_plot + theme_bw() + 
  labs(title = "Abondance relative des taxons par échantillon") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))                
