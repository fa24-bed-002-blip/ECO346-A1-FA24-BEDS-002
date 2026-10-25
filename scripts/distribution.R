# ==============================================================================
# Course: ECO346 - Data Visualization Techniques for Economists
# Assignment: 1 (Fall 2026)
# Registration No: FA24-BEDS-002
# Variant: 2 (Sindh Rural)
# Script: scripts/02_distribution.R
# Task: Question 2 - Distribution of Annual Education Spending on Students
# ==============================================================================

# 1. Load Required Packages
library(tidyverse)
library(svglite)

# 2. Load Local Datasets
person <- read.csv("data/pslm_person_subset.csv")
hh     <- read.csv("data/pslm_hh_subset.csv")

# 3. Merge Household Variables and Filter for Variant 2 (Sindh Rural)
# prov_code == 3 (Sindh), urban_rural == 1 (Rural)
data_variant <- person %>%
  inner_join(hh, by = "hhid") %>%
  filter(prov_code == 3, urban_rural == 1)

# 4. Filter Education Spending Sample (Students: ed_total > 0)
students_raw <- data_variant %>%
  filter(!is.na(ed_total), ed_total > 0)

# Filter for log range [100, 1000000] (10^2 to 10^6 rupees)
students <- students_raw %>%
  filter(ed_total >= 100 & ed_total <= 1000000)

n_total    <- nrow(students_raw)
n_excluded <- n_total - nrow(students)

# 5. Define Exact Cumulative-Weight Quantile Function
# Replaces standard quantile() per assignment specification
calc_weighted_quantile <- function(df, val_col, weight_col, p) {
  df_sorted <- df %>% arrange(.data[[val_col]])
  cum_share <- cumsum(df_sorted[[weight_col]]) / sum(df_sorted[[weight_col]])
  idx <- which(cum_share >= p)[1]
  return(df_sorted[[val_col]][idx])
}

# Calculate Summary Statistics
w_med   <- calc_weighted_quantile(students, "ed_total", "hhweight", 0.50)
w_p10   <- calc_weighted_quantile(students, "ed_total", "hhweight", 0.10)
w_p90   <- calc_weighted_quantile(students, "ed_total", "hhweight", 0.90)

unw_med <- median(students$ed_total)
ratio_90_10 <- round(w_p90 / w_p10, 2)

# Print Summary Results to Console for Form/README Submission
cat("=== QUESTION 2 REPORTED NUMBERS ===\n")
cat("Number of students:", n_total, "\n")
cat("Unweighted median:", unw_med, "\n")
cat("Weighted median:", w_med, "\n")
cat("Weighted 10th percentile:", w_p10, "\n")
cat("Weighted 90th percentile:", w_p90, "\n")
cat("90/10 Ratio:", ratio_90_10, "\n")
cat("Number excluded:", n_excluded, "\n")

# 6. Plot Weighted Histogram on Log Scale
p_dist <- ggplot(students, aes(x = ed_total, weight = hhweight)) +
  geom_histogram(
    aes(y = after_stat(density)),
    binwidth = 0.1,
    boundary = 2,
    fill = "#4C72B0",
    color = "white"
  ) +
  scale_x_log10(
    breaks = 10^(2:6),
    labels = c("100", "1,000", "10,000", "100,000", "1,000,000")
  ) +
  geom_vline(xintercept = w_med, linetype = "dashed", color = "#C44E52", linewidth = 0.8) +
  geom_vline(xintercept = w_p90, linetype = "dashed", color = "#8172B0", linewidth = 0.8) +
  annotate(
    "text", x = w_med, y = Inf, 
    label = paste0("Weighted Median:\nRs ", format(round(w_med), big.mark = ",")), 
    vjust = 1.2, hjust = -0.05, color = "#C44E52", fontface = "bold", size = 3.5
  ) +
  annotate(
    "text", x = w_p90, y = Inf, 
    label = paste0("Weighted 90th Pct:\nRs ", format(round(w_p90), big.mark = ",")), 
    vjust = 1.2, hjust = -0.05, color = "#8172B0", fontface = "bold", size = 3.5
  ) +
  labs(
    title = "Annual Education Expenditure Per Student in Rural Sindh",
    x = "Annual Education Spending (Rupees, Log Scale)",
    y = "Density per log10 unit",
    caption = paste0(
      "Source: PSLM 2019-20. Sample: Students in Rural Sindh with ed_total > 0. Weighted by hhweight.\n",
      n_excluded, " students outside Rs 100-1,000,000 excluded."
    )
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    panel.grid.minor = element_blank()
  )

# 7. Save Figure as SVG
ggsave("figures/distribution.svg", plot = p_dist, width = 8, height = 5)