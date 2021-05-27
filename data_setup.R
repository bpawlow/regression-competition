# Setting up ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(corrplot)
library("dplyr")

# Seed
set.seed(300)

## load data
training <- read_csv("train.csv") %>%
  janitor::clean_names() # clean up column names

testing <- read_csv("test.csv") %>%
  janitor::clean_names()

typeof(training) 

## Visualizing correlation

numeric_training <- select_if(training, is.numeric)

A <- cor(numeric_training)
corrplot(A, method = 'circle')
  
## Some stand-out correlation plots

ggplot(numeric_training, aes(x=loan_amnt, y=money_made_inv)) + 
  geom_point() + 
  geom_smooth(method="loess") # loan_amnt decreases target

ggplot(numeric_training, aes(x=out_prncp_inv, y=money_made_inv)) + 
  geom_point(color = 'red') + 
  geom_smooth(method="loess") # out_prncp inv decreases target

# Modeling and Recipes 

#setting up recipe for regression model(s)

recipe <- recipe(money_made_inv ~ term + loan_amnt + grade +
                   out_prncp_inv + num_tl_120dpd_2m + num_tl_90g_dpd_24m, 
                    data = training) %>% 
  step_dummy(grade, term, one_hot = TRUE)

prep(recipe) %>% 
  bake(new_data = NULL)

#V-fold cross-validation

folds <- vfold_cv(data = training, v = 5, repeats = 3)

folds

#Training/tuning different models

## Saving objects for tuning in other R-scripts
save(folds, recipe,
     training, testing, file = "data_setup.rda")
