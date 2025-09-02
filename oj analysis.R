# Step 1: Install and load necessary libraries
# Tidyverse is a collection of R packages for data science (like dplyr, ggplot2)
# Lubridate helps with dates
# We will add more libraries later as we build more complex models

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(lubridate)) install.packages("lubridate")

library(tidyverse)
library(lubridate)
oj_data <- read.csv("oj.csv")
("First 6 rows of the data:")
("Summary of the dataset:")
oj_data_clean <- oj_data %>%
  mutate(
    # Convert brand and feat to factors for easier modeling later
    brand = as.factor(brand),
    feat = as.factor(feat),
    # Create a real date column. The original week is "weeks since 1989-09-14"
    WeekDate = as.Date("1989-09-14") + weeks(week - min(week))
  )
# Let's check our new 'WeekDate' column
print("Data after adding the date column:")
head(oj_data_clean)
# --- Let's create our first visualization ---

# Plot the weekly sales (log of sales is often better for visualization)
# for the three brands over time.
# --- Let's create our first visualization ---

# Plot the weekly sales (log of sales is often better for visualization)
# for the three brands over time.
ggplot(oj_data_clean, aes(x = WeekDate, y = logmove, color = brand)) +
  geom_smooth(method = "loess", se = FALSE) + # geom_smooth shows the trend line
  labs(
    title = "Weekly Log Sales of Orange Juice Brands Over Time",
    x = "Date",
    y = "Log of Weekly Sales",
    color = "Brand"
  ) +
  theme_minimal()
colnames(oj_data_clean)
demand_model_1 <- lm(logmove ~ log(price) + brand, data = oj_data_clean)
summary(demand_model_1)
# Install and load the 'ivreg' package for instrumental variable regression
if(!require(ivreg)) install.packages("ivreg")
library(ivreg)
if(!require(ivreg)) install.packages("ivreg")
library(ivreg)
demand_model_2_iv <- ivreg(logmove ~ log(price) + brand | feat + brand, data = oj_data_clean)
summary(demand_model_2_iv)
if(!require(mclust)) install.packages("mclust")
library(mclust)
# --- Prepare Data for Clustering ---

# Select the columns that describe the households
household_data <- oj_data_clean %>%
  select(INCOME, HHLARGE, WORKWOM, HVAL150, ETHNIC, EDUC)

# Ensure all data is numeric for the algorithm
household_data_numeric <- household_data %>%
  mutate(across(everything(), as.numeric))

# Scale the data to prevent variables with large values from dominating
household_data_scaled <- scale(household_data_numeric)
gmm_model <- Mclust(household_data_scaled)
summary(gmm_model)
oj_data_clean$gmm_cluster <- as.factor(gmm_model$classification)
print("Households per GMM cluster:")
table(oj_data_clean$gmm_cluster)
str(gmm_model)
segmented_iv_model <- ivreg(logmove ~ log(price) * gmm_cluster + brand | 
                              feat * gmm_cluster + brand, 
                            data = oj_data_clean)
summary(segmented_iv_model)
cluster_3_customers <- oj_data_clean %>%
  filter(gmm_cluster == 3)
summary(cluster_3_customers)
