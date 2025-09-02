# Causal ML Model for Segmented Price Elasticity

## Project Summary

This project analyzes the classic Dominick's Finer Foods orange juice dataset to determine the causal impact of price changes on sales. Going beyond a simple market-level analysis, this project uses machine learning to identify distinct customer segments and then estimates the price elasticity for each segment individually, culminating in an interactive web application for strategic price simulation.

---

## Key Features

* **Causal Inference:** Employs an Instrumental Variable (IV) regression to correct for price endogeneity and isolate the true causal effect of price on sales.
* **Machine Learning Segmentation:** Uses a Gaussian Mixture Model (GMM) to cluster households into 7 distinct segments based on demographic data.
* **Segment-Specific Insights:** A final IV model with interaction terms calculates the price elasticity for each of the 7 customer segments, revealing significant differences in price sensitivity.
* **Interactive Simulator:** A web application built with R Shiny allows for interactive simulation of pricing strategies on each specific customer segment.

---

## Techniques Used

* **Languages:** R
* **Econometrics:** Instrumental Variable (IV) Regression
* **Machine Learning:** Gaussian Mixture Models (GMM) for clustering
* **Packages:** `tidyverse`, `ivreg`, `mclust`, `shiny`

---

## How to Run the App

1.  Clone this repository.
2.  Make sure you have all the necessary packages installed in R.
3.  Open the `app.R` file in RStudio.
4.  Click the "Run App" button.
