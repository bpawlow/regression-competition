# Random Forest tuning ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(tictoc)

# load required objects ----
load('data_setup.rda')

# Define model ----
rf_model <- rand_forest(mode = "regression",
                        min_n = tune(),
                        mtry = tune()) %>% 
  set_engine("ranger", importance = "impurity")

# set-up tuning grid ----

rf_param <- parameters(rf_model) %>% 
  update(mtry = mtry(range = c(2, 8)))

rf_param

# define tuning grid

rf_grid <- grid_regular(rf_param, levels = 5)

rf_grid

# workflow ----

rf_workflow <- workflow() %>% 
  add_model(rf_model) %>% 
  add_recipe(recipe)

rf_tuned <- rf_workflow %>% 
  tune_grid(resamples = folds, grid = rf_grid)

# Write out results & workflow

save(rf_workflow, 
     rf_tuned, file = "randomforest.rds") 