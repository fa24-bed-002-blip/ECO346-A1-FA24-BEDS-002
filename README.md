# ECO346 Assignment 1: Data Visualization and Literacy Analysis

**Student Registration No:** FA24-BEDS-002  
**Variant:** 2 (Sindh Rural)  
**Tools Used:** R (Positron/RStudio) & Python  

---

## 1. Variant Details
This analysis focuses on **Variant 2**, covering the rural households of Sindh:
* **Province:** Sindh (`prov_code == 3`)[cite: 1]
* **Geography:** Rural (`urban_rural == 1`)[cite: 1]

---

## 2. Literacy Rate Analysis Across Age Cohorts (Question 3)

| Age Band | Midpoint | Female Sample (n) | Male Sample (n) | Female Weighted Literacy (%) |
| :---: | :---: | :---: | :---: | :---: |
| **10–14** | 12 | 529 | 718 | 35.5% |
| **15–19** | 17 | 446 | 548 | 28.0% |
| **20–24** | 22 | 455 | 422 | 23.4% |
| **25–29** | 27 | 430 | 419 | 24.6% |
| **30–34** | 32 | 399 | 382 | 17.7% |
| **35–39** | 37 | 319 | 391 | 19.5% |
| **40–44** | 42 | 285 | 274 | 13.2% |
| **45–49** | 47 | 198 | 221 | 9.1% |
| **50–54** | 52 | 152 | 208 | 7.2% |
| **55–59** | 57 | 98 | 100 | 9.6% |
| **60–64** | 62 | 77 | 100 | 6.8% |

---

### Question 2: Distribution of Education Spending
* **Sample Summary:** This analysis includes students with active education spending (`ed_total > 0`) falling between Rs 100 and Rs 1,000,000.
* **Key Observations:** Education spending in rural Sindh is highly uneven. Most families spend relatively small amounts on schooling, while a very small group of households spends substantially higher amounts, making the graph heavily skewed to the right.
* **Role of Household Weights:** The weighted median differs from the unweighted median because survey weights (`hhweight`) adjust for household selection probabilities. Using weights ensures that our figures accurately reflect the entire rural population of Sindh rather than just the raw sample.

---

### Question 3: Age Profile & Gender Disparities
* **Key Takeaway:** Literacy rates are significantly higher among younger people compared to older generations. This trend reflects steady improvements in school access and educational policies over recent decades (a cohort effect).
* **Gender Disparity:** Males have higher literacy rates than females across every age group, showing a persistent educational gap between men and women in rural Sindh.
* **Analytical Limitation:** Since this data comes from a single survey at one point in time (cross-sectional data), we cannot separate true age-related changes of individuals from broader historical improvements in schooling access over generations.

---

### Question 4: Plot Redesign & Visualization Choices
* **The Problem:** The default scatterplot (`default.svg`) plots a binary outcome (0 or 1), causing thousands of overlapping dots to cluster along just two flat lines. This makes it impossible to see real trends or patterns.
* **The Solution:** The redesigned figure (`relationship.svg`) solves overplotting by grouping ages into 5-year bands and plotting the average weighted literacy rate for each group. It uses clean line charts for trends, distinct colors for gender comparison, and hollow markers to highlight small sample sizes ($n < 30$).
* **Trade-off:** While the line chart makes broad population trends much easier to understand, it hides individual-level variation within each age group.

---

### Question 5: Python Replication Assessment
* **Replication Results:** Replicating the analysis in Python produced exact matching weighted literacy percentages when rounded to one decimal place.
* **Environment Differences:** The primary differences between R and Python were default graphic aesthetics—such as canvas margins, grid layouts, and legend styles (`ggplot2` vs. `matplotlib`). Explicit formatting was added in Python to ensure both output figures look identical.
---

### Question 5: Python Replication Assessment
* **Replication Results:** Replicating the pipeline in Python produced identical weighted literacy percentages to R when rounded to one decimal place[cite: 3].
* **Environment Differences:** Default aesthetic choices differed between platforms—such as default canvas margins, grid styles, and font layouts (`ggplot2` vs. `matplotlib`)[cite: 3]. Explicit formatting was added in Python to maintain output consistency across both environments[cite: 3].
