# Load libraries
library(dplyr)
library(readr)      # for tsv
library(readxl)     # for xls/xlsx

#setwd()
# ---- Step 1: Read your file ----
file_path <- "Maaslin2_output_LOSvsControl_significant_results.xlsx"   # change to your file path

# Detect file extension
file_ext <- tools::file_ext(file_path)

if(file_ext %in% c("tsv")) {
  otu_data <- read_tsv(file_path)
} else if(file_ext %in% c("xls", "xlsx")) {
  otu_data <- read_excel(file_path)
} else {
  stop("Unsupported file type! Only .tsv or .xls/.xlsx allowed.")
}

# ---- Step 2: Create up/down regulation column ----
otu_data <- otu_data %>%
  mutate(
    regulation = ifelse(coef > 0, "Up", "Down")
  )

# ---- Step 3: Compute fold changes ----
# Assuming coef is log2 fold change
otu_data <- otu_data %>%
  mutate(
    fold_change = 2^coef,                       # linear fold change
    FC_up = ifelse(coef > 0, 2^coef, NA),       # fold change if up
    FC_down = ifelse(coef < 0, 2^(-coef), NA)   # fold change if down
  )

# ---- Step 4: Optional - filter significant OTUs (q-value < 0.05) ----
significant_otus <- otu_data %>% filter(qval < 0.05)

# ---- Step 5: Save the processed tables ----
write.csv(otu_data, "Maaslin2_output_LOSvsControl_significant_results_fc.csv", row.names = FALSE)
#write.csv(significant_otus, "significant_otus.csv", row.names = FALSE)

print("OTU table processed and saved successfully!")
