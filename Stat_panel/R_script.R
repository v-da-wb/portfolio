## LSE Data Analytics Online Career Accelerator 
# DA301:  Advanced Analytics for Organisational Impact

###############################################################################

# Assignment 5 scenario
## Turtle Games’s sales department has historically preferred to use R when performing 
## sales analyses due to existing workflow systems. As you’re able to perform data analysis 
## in R, you will perform exploratory data analysis and present your findings by utilising 
## basic statistics and plots. You'll explore and prepare the data set to analyse sales per 
## product. The sales department is hoping to use the findings of this exploratory analysis 
## to inform changes and improvements in the team. (Note that you will use basic summary 
## statistics in Module 5 and will continue to go into more detail with descriptive 
## statistics in Module 6.)

################################################################################

## Assignment 5 objective
## Load and wrangle the data. Use summary statistics and groupings if required to sense-check
## and gain insights into the data. Make sure to use different visualisations such as scatterplots, 
## histograms, and boxplots to learn more about the data set. Explore the data and comment on the 
## insights gained from your exploratory data analysis. For example, outliers, missing values, 
## and distribution of data. Also make sure to comment on initial patterns and distributions or 
## behaviour that may be of interest to the business.

################################################################################

# Module 5 assignment: Load, clean and wrangle data using R

## It is strongly advised that you use the cleaned version of the data set that you created and 
##  saved in the Python section of the course. Should you choose to redo the data cleaning in R, 
##  make sure to apply the same transformations as you will have to potentially compare the results.
##  (Note: Manual steps included dropping and renaming the columns as per the instructions in module 1.
##  Drop ‘language’ and ‘platform’ and rename ‘remuneration’ and ‘spending_score’) 

## 1. Open your RStudio and start setting up your R environment. 
## 2. Open a new R script and import the turtle_review.csv data file, which you can download from 
##      Assignment: Predicting future outcomes. (Note: You can use the clean version of the data 
##      you saved as csv in module 1, or, can manually drop and rename the columns as per the instructions 
##      in module 1. Drop ‘language’ and ‘platform’ and rename ‘remuneration’ and ‘spending_score’) 
## 3. Import all the required libraries for the analysis and view the data. 
## 4. Load and explore the data.
##    - View the head the data.
##    - Create a summary of the new data frame.
## 5. Perform exploratory data analysis by creating tables and visualisations to better understand 
##      groupings and different perspectives into customer behaviour and specifically how loyalty 
##      points are accumulated. Example questions could include:
##    - Can you comment on distributions, patterns or outliers based on the visual exploration of the data?
##    - Are there any insights based on the basic observations that may require further investigation?
##    - Are there any groupings that may be useful in gaining deeper insights into customer behaviour?
##    - Are there any specific patterns that you want to investigate
## 6. Create
##    - Create scatterplots, histograms, and boxplots to visually explore the loyalty_points data.
##    - Select appropriate visualisations to communicate relevant findings and insights to the business.
## 7. Note your observations and recommendations to the technical and business users.

###############################################################################

# Check the working directory is the folder containing the necessary data file
# getwd()
# setwd()
# ------------------------------------------------------------------------------
# Install/import necessary packages/libraries

# install.packages('tidyverse')
# install.packages("corrplot")
# install.packages("car")
library(car)
library(tidyverse)
library(conflicted)
library(dplyr)
library(ggplot2)
library(stringr)
library(tidyr)
library(corrplot) 
# Source: https://conflicted.r-lib.org/
# install.packages("devtools")
# devtools::install_github("r-lib/conflicted")

# 👤 User defined function: 
# ------------------------------------------------------------------------------
residual_diagnostics <- function(model) {
  # Check required packages
  if (!require(car)) install.packages("car", dependencies = TRUE)
  if (!require(lmtest)) install.packages("lmtest", dependencies = TRUE)
  
  library(car)
  library(lmtest)
  
  cat("=== Residual Diagnostic Plots ===\n")
  par(mfrow = c(2, 2))
  plot(model)
  
  cat("\n=== Shapiro-Wilk Test (Normality of Residuals) ===\n")
  print(shapiro.test(residuals(model)))
  
  cat("\n=== Breusch-Pagan Test (Homoscedasticity) ===\n")
  print(bptest(model))
  
  cat("\n=== Durbin-Watson Test (Autocorrelation) ===\n")
  print(durbinWatsonTest(model))
  
  cat("\n=== Cook's Distance (Influential Points) ===\n")
  plot(model, which = 4)
}
# ------------------------------------------------------------------------------

# Import a CSV file.
# data <- read.csv('turtle_reviews.csv', header=T)
data <- read.csv(file.choose(), header=T)

# Print the data frame.
data
View(data)
head(data)

# Check the dimensions of the data frame
dim(data)

# Sense-check the data set
as_tibble(data)

# Some columns' names are not readable => rename:
names(data)[c(3, 4, 9)] <- c("annual_income", "spending_score", "product_code")
colnames(data)

# Describe the data set
tail(data)

# Check for missing values
sum(is.na(data))

# Check for duplicates
sum(duplicated(data))

# 'Language' and 'platform' might be worth dropping as they contain a single value
data %>%
  map_int(~ n_distinct(.))

# 'review', 'summary' have already been analysed previously, drop as well
data <- data %>%
  select(-c("language","platform", "review", "summary"))

colnames(data)

dim(data)

# Check 5 education options
table(data$education)

# First letter of education types to uppercase
data <- data %>%
  mutate(education = str_to_title(education))

unique(data$education)

# Return the structure of the data frame.
# str(data)

# Check the type of the data frame.
# typeof(data)

# Check the class of the data frame.
# class(data)

# Inspect the final data set
as_tibble(data)

# Check for missing values
sum(is.na(data))

# Check for duplicates
sum(duplicated(data))
# A customer Id is required to confirm 203 duplicates as actual duplicates. 
# For now these values will be kept in the dataframe.

# Describe the final data set
summary(data)

# Export the data as a CSV file
write_csv(data, file='reviews_r.csv')

# ------------------------------------------------------------------------------
# EXPLORATORY ANALYSIS

# Import preprocessed CSV file.
# data <- read.csv('reviews_r.csv', header=T)
data <- read.csv(file.choose(), header=T)

# Product code seems rather a category. Change data type accordingly 
data$product_code <- as.character(data$product_code)
as_tibble(data)

# Sense-check imported dataframe
# Print the data frame.
View(data)
dim(data)
head(data)

# Create a data profile report.
DataExplorer::create_report(data)

summary(data)

# Check for outliers
data %>%
  select(where(is.numeric)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x = variable, y = value)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Distribution of Numeric values") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# The scale of loyalty points stands out. Given it is a predicted variable it is
# not going to be standardized. It has outliers that are not to be excluded due 
# to potential essential business insight in that data.

# Subset dataset to exclude loyalty points and repeat 
all_but_loyalty <- data %>%
  select(-c("loyalty_points"))

all_but_loyalty %>%
  select(where(is.numeric)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x = variable, y = value)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Distribution of Numeric values (w/o loyalty points)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# no outliers identified in the rest of the numeric data

# Check the distribution of numeric data
data %>%
  select(where(is.numeric)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x = value)) +
  geom_histogram(bins = 20, fill = "steelblue", color = "white") +
  facet_wrap(~ variable, scales = "free") +
  theme_minimal() +
  labs(title = "Distribution of All Numeric Columns")
# neither of the variables is normally distributed as it often happens

# Check frequency across categories
# Subset dataset to exclude product code 
all_cat_but_product <- data %>%
  select(-c("product_code"))
all_cat_but_product %>%
  select(where(~ !is.numeric(.))) %>%             
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  count(variable, value) %>%
  ggplot(aes(x = value, y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  facet_wrap(~ variable, scales = "free_x") +
  theme_minimal() +
  labs(x = "Value", y = "Count", title = "Categorical Columns Frequencies") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Check loyalty points across categories
all_cat_but_product %>%
  select(where(~ !is.numeric(.)), loyalty_points) %>%  # Select categorical columns + target numeric column
  pivot_longer(cols = -loyalty_points, names_to = "variable", values_to = "category") %>%
  drop_na(category) %>%
  group_by(variable, category) %>%
  summarise(total = sum(loyalty_points, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = category, y = total)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  facet_wrap(~ variable, scales = "free_x") +
  theme_minimal() +
  labs(x = "Category", y = "Loyalty points", title = "Loyalty Points by Category") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# As expected the majority of loyalty points are accumulated by the majorities:
# holders of graduate degrees and female representatives.

# ------------------------------------------------------------------------------
# EXPLORATORY ANALYSIS

# Establish what features drive loyalty points - correlation
# Create the correlation plot
cor_matrix <- cor(data[, sapply(data, is.numeric)], use = "complete.obs")

# Create the corrplot with correlation coefficients shown
corrplot(cor_matrix, method = "color", type = "upper", addCoef.col = "orange", 
         tl.col = "black", tl.srt = 45, number.cex = 0.7)
# Spending score and annual income have the strongest power to explain variance
# of loyalty points.

# View the correlation matrix
cor_matrix

# Age has minimal correlation with loyalty points, won't be considered
# Pair plots to visualise relationships
pairs(data[, c('loyalty_points', 'spending_score', 'annual_income')])

# Explore the shape of the relationship of loyalty points with spending score
# and annual income
# Scatter plot
ggplot(data, aes(x = spending_score, y = loyalty_points)) +
  geom_point(color = "steelblue", alpha = 0.6) +      # Scatter plot points
  geom_smooth(method = "lm", se = TRUE, color = "green") +  # Smoothed trend line
  theme_minimal() +
  labs(title = "Loyalty Points vs Spending Score", x = "Spending Score", y = "Loyalty Points")

# Scatter plot
ggplot(data, aes(x = annual_income, y = loyalty_points)) +
  geom_point(color = "steelblue", alpha = 0.6) +      # Scatter plot points
  geom_smooth(method = "lm", se = TRUE, color = "orange") +  # Smoothed trend line
  theme_minimal() +
  labs(title = "Loyalty Points vs Annual Income", x = "Annual Income", y = "Loyalty Points")

# A linear relationship was identified between loyalty points, annual income and
# spending score as per the identified correlation. Loyalty points increase in 
# both of the features, with this relationship being less distinct with greater
# income and spending.

# Scatter plot
ggplot(data, aes(x = age, y = loyalty_points)) +
  geom_point(color = "steelblue", alpha = 0.6) +      # Scatter plot points
  geom_smooth(method = "lm", se = TRUE, color = "yellow") +  # Smoothed trend line
  theme_minimal() +
  labs(title = "Loyalty Points vs Age", x = "Age", y = "Loyalty Points")

# The cone-shaped distribution of loyalty points across spending score and 
# annual income suggests groups of customers with same high income and spending
# score have different loyalty points. That observations highlight the need
# of further customer behaviour study. Cross-shaped distribution of annual income
# vs spending score in the pair plot suggests existence of different spending
# behaviour within the same income groups. Turtle games could use this insight
# for further marketing campaigns to even out the spending behaviour and aim
# higher customer retention.

# Measures of Shape
# Shapiro-Wilk test for normality
shapiro.test(data$loyalty_points) # W = 0.84307, p-value < 2.2e-16

# Specify qqnorm function (draw a qqplot).
qqnorm(data$loyalty_points)

# Specify qqline function.
qqline(data$loyalty_points) 

# Skewness and Kurtosis
# install.packages("e1071")
# library(e1071)
skewness(data$loyalty_points) # 1.46
kurtosis(data$loyalty_points) # 1.70
# The low p-value rejects the null of normal distribution. Loyalty point are not
# normally distributed, right skewed with peaked frequency distribution (light
# tails). Kurtosis of less than 3 suggests no extreme outliers.

# Calculate Range
range_loyalty  <- range(data$loyalty_points )

# Calculate Difference between highest and lowest values
difference_high_low <- diff(range_loyalty )

# Calculate Interquartile Range (IQR)
iqr_loyalty <- IQR(data$loyalty_points )

# Calculate Variance
variance_loyalty <- var(data$loyalty_points )

# Calculate Standard Deviation
std_deviation_loyalty <- sd(data$loyalty_points )

# Display results
list(
  Range = range_loyalty ,
  Difference = difference_high_low,
  IQR = iqr_loyalty,
  Variance = variance_loyalty,
  Standard_Deviation = std_deviation_loyalty
)

# Loyalty points have a wide range from 25 to 6847 points with the majority of
# observations within a small range of 979.25 points. Observations are substantially
# scattered with standard deviation of 1283.24 points.

# More Measures of Shape

scores <- data$loyalty_points 

# Calculate mean, median, and mode
mean_score <- mean(scores)
median_score <- median(scores)
mode_score <- as.numeric(names(sort(table(scores), decreasing = TRUE)[1]))

# Print the results
cat("Mean:", mean_score, "\n")
cat("Median:", median_score, "\n")
cat("Mode:", mode_score, "\n")

# As described by the skewness of the loyalty data, it's mean 1578 is greater
# than median 1276 meaning greater loyalty points are less frequent than average
# loyalty points.

###############################################################################
###############################################################################

# Assignment 6 scenario

## In Module 5, you were requested to redo components of the analysis using Turtle Games’s preferred 
## language, R, in order to make it easier for them to implement your analysis internally. As a final 
## task the team asked you to perform a statistical analysis and create a multiple linear regression 
## model using R to predict loyalty points using the available features in a multiple linear model. 
## They did not prescribe which features to use and you can therefore use insights from previous modules 
## as well as your statistical analysis to make recommendations regarding suitability of this model type,
## the specifics of the model you created and alternative solutions. As a final task they also requested 
## your observations and recommendations regarding the current loyalty programme and how this could be 
## improved. 

################################################################################

## Assignment 6 objective
## You need to investigate customer behaviour and the effectiveness of the current loyalty program based 
## on the work completed in modules 1-5 as well as the statistical analysis and modelling efforts of module 6.
##  - Can we predict loyalty points given the existing features using a relatively simple MLR model?
##  - Do you have confidence in the model results (Goodness of fit evaluation)
##  - Where should the business focus their marketing efforts?
##  - How could the loyalty program be improved?
##  - How could the analysis be improved?

################################################################################

## Assignment 6 assignment: Making recommendations to the business.

## 1. Continue with your R script in RStudio from Assignment Activity 5: Cleaning, manipulating, and 
##     visualising the data.
## 2. Load and explore the data, and continue to use the data frame you prepared in Module 5.
## 3. Perform a statistical analysis and comment on the descriptive statistics in the context of the 
##     review of how customers accumulate loyalty points.
##  - Comment on distributions and patterns observed in the data.
##  - Determine and justify the features to be used in a multiple linear regression model and potential
##.    concerns and corrective actions.
## 4. Create a Multiple linear regression model using your selected (numeric) features.
##  - Evaluate the goodness of fit and interpret the model summary statistics.
##  - Create a visual demonstration of the model
##  - Comment on the usefulness of the model, potential improvements and alternate suggestions that could 
##     be considered.
##  - Demonstrate how the model could be used to predict given specific scenarios. (You can create your own 
##     scenarios).
## 5. Perform exploratory data analysis by using statistical analysis methods and comment on the descriptive 
##     statistics in the context of the review of how customers accumulate loyalty points.
## 6. Document your observations, interpretations, and suggestions based on each of the models created in 
##     your notebook. (This will serve as input to your summary and final submission at the end of the course.)

################################################################################

# ------------------------------------------------------------------------------
# Multiple Linear Regression (Model 1)
# Subset numeric dataset
df <- data %>% select(annual_income, spending_score, loyalty_points, age)

# Create the multiple linear regression model1
model1 <- lm(loyalty_points ~ spending_score + annual_income, data = df)

# Summarize the model1
summary(model1)

# Visualising the model1

# Plot actual vs. predicted values with a different smoothing method if necessary
ggplot(df, aes(x = loyalty_points, y = predict(model1, df))) +
  geom_point(color = 'steelblue', alpha = 0.8) +
  stat_smooth(method = "lm", color = 'orange', se = FALSE) +  # You can change 'loess' to 'lm' or other methods
  labs(x = 'Actual', y = 'Predicted',
       title = 'Actual vs. Predicted Loyalty Points (Model 1)') +
  theme_minimal()+ 
  theme(panel.grid.minor = element_blank())

# Check for multicollinearity
# Run VIF test
vif(model1) # < 0.05 - not normally distributed

# Residuals diagnostics
residual_diagnostics(model1)

# Shapiro < 0.05 - heteroscedasticity
# DW 3.5 close to 4 - autocorrelation

# ------------------------------------------------------------------------------
# Multiple Linear Regression (Model 2)

# Create the multiple linear regression model2
model2 <- lm(loyalty_points ~ spending_score + annual_income + age, data = df)

# Summarize the model2
summary(model2)

# Visualising the model2

# Plot actual vs. predicted values with a different smoothing method if necessary
ggplot(df, aes(x = loyalty_points, y = predict(model2, df))) +
  geom_point(color = 'steelblue', alpha = 0.8) +
  stat_smooth(method = "lm", color = 'orange', se = FALSE) +  # You can change 'loess' to 'lm' or other methods
  labs(x = 'Actual', y = 'Predicted',
       title = 'Actual vs. Predicted Loyalty Points (Model 2)') +
  theme_minimal()+ 
  theme(panel.grid.minor = element_blank())


# Check for multicollinearity
# Run VIF test
vif(model2)

# Correlation matrix identified expected relationship between age and spending
# score. It is confirmed by the results of VIF test. Thus Model 2 is biased 
# and age should be excluded for purity of predictions. Recommend Model 1.

# The following indicates it is a robust model: adjusted R2 of 83% is very close
# to 100% and suggest the model explains the variance in loyalty points well
# through combination of spending score (SS) and annual income (AI). The p-value
# of SS and AI confirms them significant and overfitting was eliminated through
# exclusion of age. VIF of almost 1 confirmed no multicollinearity in model 1.
# The residual behaviour is poor and requires attention through better 
# understanding and addressing of outliers.

# Turtle Games should focues its marketing efforts the combination insights from
# linear regression analysis, clustering and sentiment analysis. That will allow
# the brand to tailor its marketing campaign to individual customer segments for 
# better customer retention, satisfaction, brand loyalty and subsequent revenue 
# growth.

# ------------------------------------------------------------------------------
# Prediciting with new data

# 3 example scenarios of 3 customers
new_data1 <- data.frame(annual_income = c(48, 60, 99), 
                        spending_score = c(50, 50, 50))

new_data2 <- data.frame(annual_income = c(48, 60, 99), 
                        spending_score = c(60, 48, 48))

new_data3 <- data.frame(annual_income = c(48, 60, 99), 
                        spending_score = c(61, 48, 48))

# Predict satisfaction score for new scenarios
predictions1 <- predict(model1, new_data1)
print(predictions1) # 1575 1983 3308

predictions2 <- predict(model1, new_data2)
print(predictions2) # 1904 1917 3242

predictions3 <- predict(model1, new_data3)
print(predictions3) # 1937 1917 3242

# The loyalty programme could be improved through prioritising SS
# over AI when assigning loyalty points to customers. The suggestion
# is based on the results of cluster analysis which identified low income high
# spenders. It is a group of customers of lowest income who have a high SS
# and thus are loyal. The scenarios demo confirmed that this group has to
# have a substantially high SS to obtain the same amount of loyalty
# points as higher income customers with lower SS. This hardly 
# maintains the enthusiasm and should be addressed through adjustment of 
# loyalty points calculation. 

# The analysis could be improved with elimination of outliers, with bigger data.
# Theoretically loyalty points are accumulated through purchases or engagement 
# with a brand. In other words, we need to see how many purchases and reviews 
# each customer made. The data set would provide that customer engagement 
# insight if each observation had a customer ID against it. The 
# efficiency of the loyalty program could be assessed through the analysis of 
# the accumulated points redemption over time (how a customer's loyalty points 
# balance changes over time).