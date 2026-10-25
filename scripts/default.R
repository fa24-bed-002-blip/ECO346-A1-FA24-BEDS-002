# ==============================================================================
# Course: ECO346 - Data Visualization Techniques for Economists
# Assignment: 1 (Fall 2026)
# Registration No: FA24-BEDS-002
# Variant: 2 (Sindh Rural)
# Script: scripts/01_default.R
# Task: Question 4 - R Default Scatterplot (Before Redesign)
# ==============================================================================

# 1. Load Required Packages
library(tidyverse)
library(svglite)

# 2. Load Local Datasets
person <- read.csv("data/pslm_person_subset.csv")
hh     <- read.csv("data/pslm_hh_subset.csv")

# 3. Merge Household Variables and Filter for Variant 2 (Sindh Rural)
# Criteria: prov_code == 3 (Sindh) & urban_rural == 1 (Rural)
data_variant <- person %>%
  inner_join(hh, by = "hhid") %>%
  filter(prov_code == 3, urban_rural == 1)

# 4. Literacy Sample Criteria
# Aged 10-64 with non-missing literate variable
literacy_sample <- data_variant %>%
  filter(age >= 10, age <= 64, !is.na(literate))

# 5. Question 4: R Default Plot (Untouched Defaults)
# Pure ggplot(data, aes(x, y)) + geom_point() as specified in Question 4
p_default <- ggplot(literacy_sample, aes(x = age, y = literate)) + 
  geom_point()

# 6. Save Default Figure as SVG
ggsave(
  filename = "figures/default.svg", 
  plot     = p_default, 
  width    = 7, 
  height   = 5
)