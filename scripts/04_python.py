# ==============================================================================
# Course: ECO346 - Data Visualization Techniques for Economists
# Assignment: 1 (Fall 2026)
# Registration No: FA24-BEDS-002
# Variant: 2 (Sindh Rural)
# Script: scripts/04_python_or_stata.py
# Task: Question 5 - Replicate Question 3 Band Table & Plot in Python
# ==============================================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1. Load Local CSV Files
person = pd.read_csv("data/pslm_person_subset.csv")
hh = pd.read_csv("data/pslm_hh_subset.csv")

# 2. Merge Household Data & Filter for Variant 2 (Sindh Rural)
# prov_code == 3 (Sindh), urban_rural == 1 (Rural)
df = pd.merge(person, hh, on="hhid")
variant = df[(df["prov_code"] == 3) & (df["urban_rural"] == 1)].copy()

# 3. Literacy Sample Criteria (Age 10-64, non-missing literate)
lit = variant[(variant["age"] >= 10) & (variant["age"] <= 64) & (variant["literate"].notna())].copy()

# 4. Define 5-year Age Bands and Midpoints
age_bins = list(range(10, 66, 5))
age_labels = ["10-14", "15-19", "20-24", "25-29", "30-34", "35-39", 
              "40-44", "45-49", "50-54", "55-59", "60-64"]
midpoints = list(range(12, 63, 5))
midpoint_dict = dict(zip(age_labels, midpoints))

lit["band"] = pd.cut(lit["age"], bins=age_bins, right=False, labels=age_labels)
lit["midpoint"] = lit["band"].map(midpoint_dict)
lit["sex_label"] = lit["sex"].map({1: "Male", 2: "Female"})

# 5. Compute Weighted Literacy Rate per Band
def weighted_mean(group):
    return (group["literate"] * group["hhweight"]).sum() / group["hhweight"].sum() * 100

summary = lit.groupby(["band", "midpoint", "sex_label"], observed=False).apply(
    lambda g: pd.Series({
        "n_obs": len(g),
        "weighted_lit_rate": weighted_mean(g)
    })
).reset_index()

summary["is_thin"] = summary["n_obs"] < 30

# Print Band Table Verification
pivot_df = summary.pivot(index="band", columns="sex_label", values=["n_obs", "weighted_lit_rate"])
print("=== QUESTION 5 PYTHON BAND TABLE ===")
print(pivot_df.round(1))

# Extract specific literacy rate for Women aged 15-19
w_15_19 = summary[(summary["band"] == "15-19") & (summary["sex_label"] == "Female")]["weighted_lit_rate"].values[0]
print(f"\nLiteracy rate of women aged 15-19 (Python): {w_15_19:.1f}%")

# 6. Redraw Figure and Save as SVG
plt.figure(figsize=(8, 5))

for sex_name, color in [("Male", "#1F77B4"), ("Female", "#E377C2")]:
    sub = summary[summary["sex_label"] == sex_name].sort_values("midpoint")
    plt.plot(sub["midpoint"], sub["weighted_lit_rate"], label=sex_name, color=color, linewidth=2)
    
    # Solid points for n >= 30, hollow for thin cells n < 30
    normal_pts = sub[~sub["is_thin"]]
    thin_pts = sub[sub["is_thin"]]
    
    plt.scatter(normal_pts["midpoint"], normal_pts["weighted_lit_rate"], color=color, s=50, zorder=3)
    plt.scatter(thin_pts["midpoint"], thin_pts["weighted_lit_rate"], facecolors="none", edgecolors=color, s=50, linewidth=1.5, zorder=3)

plt.xticks(midpoints, age_labels)
plt.ylim(0, 100)
plt.xlabel("Age Band (Years)")
plt.ylabel("Weighted Literacy Rate (%)")
plt.title("Gender Literacy Disparity Widens in Older Age Cohorts in Rural Sindh (Python)")
plt.grid(True, linestyle="--", alpha=0.5)
plt.tight_layout()

# Save figure as SVG
plt.savefig("figures/relationship_py.svg")
print("Saved figures/relationship_py.svg successfully.")
