# Model Prediction Calculations and Assessment ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)

#load necessary mode tuning and workflow info

load('data_setup.rda')
load(file = "randomforest.rds") 

rf_tuned %>% 
  collect_metrics() %>% 
  arrange(mean) %>% 
  head(1) # showing best parameters for random forest

rf_workflow_tuned <- rf_workflow %>% 
  finalize_workflow(select_best(rf_tuned, metric = "rmse"))

rf_results <- fit(rf_workflow_tuned, training)

data_metric <- metric_set(rmse)

submission <- predict(rf_results, new_data = testing) %>% 
  mutate(Id = 1:3818) %>% 
  rename(
    Predicted = .pred
  ) %>% 
  select(Id, Predicted)

#exporting to csv

write_csv(submission, 'submission.csv')

### MARS MODEL

#load necessary mode tuning and workflow info

load(file = "mars.rds") 

mars_tuned %>% 
  collect_metrics() %>% 
  arrange(mean) %>% 
  filter(.metric == 'rmse') %>% 
  head(1)

mars_workflow_tuned <- mars_workflow %>% 
  finalize_workflow(select_best(mars_tuned, metric = "rmse"))

mars_results <- fit(mars_workflow_tuned, training)

data_metric <- metric_set(rmse)

submission_2 <- predict(mars_results, new_data = testing) %>% 
  mutate(Id = 1:3818) %>% 
  rename(
    Predicted = .pred
  ) %>% 
  select(Id, Predicted)

#exporting to csv

write_csv(submission_2, 'submission_2.csv')

  