

library(dplyr)
library(readr)
library(readxl)

## change the file path 2 location i/p & o/p


# 1️⃣ Read MaAsLin2 results
sig_res <- read_tsv("DC_runs/out5Maaslin2_EcoliControl/significant_results.tsv")

# 2️⃣ Read taxonomy table
taxa_map <- read_excel("20250512_OTU tables_percohort_sepsis prediction model.xlsx", 
                       sheet = "OTU table all") %>% 
  as.data.frame()

# Check your taxonomy columns to confirm names
# colnames(taxa_map)

# 3️⃣ Merge all significant MaAsLin2 results with taxonomy
sig_taxa_full <- sig_res %>%
  left_join(taxa_map, by = c("feature" = "ID.1")) %>%
  arrange(qval)  # rank by q-value

# 4️⃣ Save full ranked result table
write.csv(sig_taxa_full, 
          "DC_runs/out5Maaslin2_EcoliControl/5.Significant_features_taxonomy.csv", 
          row.names = FALSE)

# 5️⃣ Optional: Print summary
cat("✅ File saved with", nrow(sig_taxa_full), 
    "rows and", ncol(sig_taxa_full), "columns\n")


# Count total unique significant features
n_unique_features <- length(unique(sig_taxa_full$feature))

# Count how many belong to the genus Escherichia-Shigella
n_unique_escherichia <- sig_taxa_full %>%
  filter(Genus == "Escherichia-Shigella") %>%
  summarise(n = n_distinct(feature)) %>%
  pull(n)

# Print the results
cat("Total unique significant features:", n_unique_features, "\n")
cat("Unique features belonging to Escherichia-Shigella:", n_unique_escherichia, "\n")





