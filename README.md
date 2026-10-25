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

## 3. Findings & Short Responses

### Question 2: Distribution of Education Spending
* **Sample Summary:** Computed for students with positive spending (`ed_total > 0`) within the range of Rs 100 to Rs 1,000,000[cite: 2].
* **Key Observations:** The distribution of annual education spending is heavily right-skewed[cite: 2]. While most families spend modest amounts on schooling, a small fraction spends significantly higher amounts[cite: 2].
* **Weights Influence:** Weighted and unweighted medians differ because survey weights (`hhweight`) adjust for sampling probabilities and household structures, making the estimates reflective of the true rural population of Sindh[cite: 1, 2].

---

### Question 3: Age Profile & Gender Disparities
* **Key Takeaway:** Literacy rates drop noticeably in older age groups[cite: 3]. Younger generations display higher literacy, pointing to progressive improvements in educational access over time (a cohort effect)[cite: 3].
* **Gender Disparity:** Males maintain higher literacy rates across all age brackets, though the gender gap varies across cohorts[cite: 3].
* **Analytical Limitation:** Because this analysis uses cross-sectional data from a single point in time, it cannot separate true age-related changes within individuals from generational changes in schooling access over time[cite: 3].

---

### Question 4: Plot Redesign & Visualization Choices
* **The Problem:** The default scatterplot (`default.svg`) maps binary data ($0/1$), leading to severe overplotting where thousands of points overlap along two horizontal lines[cite: 3].
* **The Solution:** The redesigned figure (`relationship.svg`) replaces raw dots with age-group averages[cite: 2, 3]. It uses continuous lines to highlight trends, distinct colors for gender comparison, and marker styles to signal small sample sizes ($n < 30$)[cite: 2, 3].
* **Trade-off:** While the redesign highlights trends and population patterns clearly, it abstracts away individual-level variation within each age band[cite: 3].

---

### Question 5: Python Replication Assessment
* **Replication Results:** Replicating the pipeline in Python produced identical weighted literacy percentages to R when rounded to one decimal place[cite: 3].
* **Environment Differences:** Default aesthetic choices differed between platforms—such as default canvas margins, grid styles, and font layouts (`ggplot2` vs. `matplotlib`)[cite: 3]. Explicit formatting was added in Python to maintain output consistency across both environments[cite: 3].
