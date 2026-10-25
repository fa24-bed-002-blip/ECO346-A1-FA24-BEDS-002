# ==============================================================================
# Course: ECO346 - Data Visualization Techniques for Economists
# Assignment: 1 (Fall 2026)
# Registration No: FA24-BEDS-002
# Variant: 2 (Sindh Rural)
# Script: scripts/03_relationship.R
# Task: Question 3 - Weighted Literacy Rate by Age Band and Sex
# ==============================================================================

# 1. Load Required Packages
library(tidyverse)
library(svglite)

# 2. Load Local Datasets
person <- read.csv("data/pslm_person_subset.csv")
hh     <- read.csv("data/pslm_hh_subset.csv")

# 3. Merge Household Variables and Filter for Variant 2 (Sindh Rural)
data_variant <- person %>%
  inner_join(hh, by = "hhid") %>%
  filter(prov_code == 3, urban_rural == 1)

# 4. Literacy Sample Criteria
# Aged 10-64 with non-missing literate variable
lit_data <- data_variant %>%
  filter(age >= 10, age <= 64, !is.na(literate))

# Define 5-year Age Bands (10-14 to 60-64)
age_cuts  <- seq(10, 65, by = 5)
age_labels <- c("10-14", "15-19", "20-24", "25-29", "30-34", "35-39", 
                "40-44", "45-49", "50-54", "55-59", "60-64")
midpoints  <- seq(12, 62, by = 5)

lit_data <- lit_data %>%
  mutate(
    band = cut(age, breaks = age_cuts, right = FALSE, labels = age_labels),
    midpoint = midpoints[as.numeric(band)],
    sex_label = if_else(sex == 1, "Male", "Female")
  )

# 5. Compute Weighted Literacy Rates and Unweighted Observations Count
band_summary <- lit_data %>%
  group_by(band, midpoint, sex_label) %>%
  summarise(
    n_obs = n(),
    weighted_lit_rate = sum(hhweight * literate) / sum(hhweight) * 100,
    .groups = "drop"
  ) %>%
  mutate(is_thin = n_obs < 30)

# Format Band Table for Output and README
band_table <- band_summary %>%
  select(band, sex_label, n_obs, weighted_lit_rate) %>%
  pivot_wider(
    names_from = sex_label,
    values_from = c(n_obs, weighted_lit_rate)
  )

# Calculate Gender Gap per Band
gap_data <- band_summary %>%
  select(midpoint, band, sex_label, weighted_lit_rate) %>%
  pivot_wider(names_from = sex_label, values_from = weighted_lit_rate) %>%
  mutate(gap = abs(Male - Female))

max_gap_row <- gap_data %>% arrange(desc(gap)) %>% slice(1)

# Print Summary Numbers to Console for Form/README Submission
cat("=== QUESTION 3 REPORTED NUMBERS ===\n")
cat("Band Table Preview:\n")
print(band_table)
cat("\nWeighted Literacy Rates:\n")
cat("Women (15-19):", round(gap_data$Female[gap_data$band == "15-19"], 1), "%\n")
cat("Men (15-19):", round(gap_data$Male[gap_data$band == "15-19"], 1), "%\n")
cat("Women (55-59):", round(gap_data$Female[gap_data$band == "55-59"], 1), "%\n")
cat("Men (55-59):", round(gap_data$Male[gap_data$band == "55-59"], 1), "%\n")
cat("Band with largest gap:", max_gap_row$band, "(Gap:", round(max_gap_row$gap, 1), "%)\n")

# 6. Plot Relationship Figure
end_labels <- band_summary %>%
  filter(midpoint == max(midpoint))

p_rel <- ggplot(band_summary, aes(x = midpoint, y = weighted_lit_rate, color = sex_label, group = sex_label)) +
  geom_line(linewidth = 1) +
  geom_point(aes(shape = is_thin), size = 3, fill = "white", stroke = 1.2) +
  scale_shape_manual(values = c("FALSE" = 16, "TRUE" = 21), guide = "none") +
  scale_color_manual(values = c("Male" = "#1F77B4", "Female" = "#E377C2")) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20)) +
  scale_x_continuous(breaks = midpoints, labels = age_labels) +
  # Direct Series Labeling at line end (No Legend)
  geom_text(
    data = end_labels,
    aes(label = sex_label),
    hjust = -0.2, vjust = 0.5, fontface = "bold", size = 4
  ) +
  # Annotation for Largest Gap
  annotate(
    "segment", 
    x = max_gap_row$midpoint, xend = max_gap_row$midpoint,
    y = max_gap_row$Female, yend = max_gap_row$Male,
    arrow = arrow(ends = "both", length = unit(0.1, "inches")), color = "black"
  ) +
  annotate(
    "text", 
    x = max_gap_row$midpoint + 1, 
    y = (max_gap_row$Female + max_gap_row$Male) / 2,
    label = paste("Largest Gap:", max_gap_row$band), 
    hjust = 0, fontface = "italic", size = 3.5
  ) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Gender Literacy Disparity Widens in Older Age Cohorts in Rural Sindh",
    x = "Age Band (Years)",
    y = "Weighted Literacy Rate (%)",
    caption = "Source: PSLM 2019-20. Sample: Persons aged 10-64 in Rural Sindh. Weighted by hhweight.\nHollow markers indicate thin cells (unweighted n < 30)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "none",
    plot.margin = margin(10, 40, 10, 10),
    plot.title = element_text(face = "bold", size = 12)
  )

# 7. Save Figure as SVG
ggsave("figures/relationship.svg", plot = p_rel, width = 8, height = 5)