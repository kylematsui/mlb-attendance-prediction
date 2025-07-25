library(dplyr)
library(ggplot2)
library(tidyverse)
library(tidymodels)
library(glmnet)

tidymodels::tidymodels_prefer() 
options(scipen = 999)

# preprocessing
mlbdata <- read.csv("mlb_teams.csv")
mlb <- na.omit(mlbdata)

# EDA
summary(mlb$home_attendance) #summary of home attendance

# Linear regression of Wins vs home attendance
ggplot(mlb, aes(x = wins, y = home_attendance)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  labs(title = "Wins vs Attendance")

model1 <- lm(home_attendance ~ wins, data = mlb)
summary(model1)

# Linear regression Runs scored vs home attendance
ggplot(mlb, aes(x = runs_scored, y = home_attendance)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  labs(title = "Runs Scored vs Attendance")

model2 <- lm(home_attendance ~ runs_scored, data = mlb)
summary(model2)

# Linear regression of Homeruns vs home attendance
ggplot(mlb, aes(x = homeruns, y = home_attendance)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  labs(title = "Earned Run Average vs Attendance")

model3 <- lm(home_attendance ~ homeruns, data = mlb)
summary(model3)

# Histogram of home attendance
ggplot(mlb, aes(x = home_attendance)) +
  geom_histogram(binwidth = 500000, color = "white") +
  labs(title = "Distribution of Home Attendance",
       x = "Home Attendance",
       y = "Frequency") +
  theme_minimal()

mlb$win_pct = mlb$wins / (mlb$wins+mlb$losses)
mlb$runs_per_game = mlb$runs_scored/mlb$games_played

# model training
set.seed(1)

mlb_split <- mlb %>% initial_split(prop = 0.80)
mlb_train <- training(mlb_split)
mlb_test <- testing(mlb_split)

mlb_recipe <- recipe(home_attendance ~ wins + homeruns + runs_scored + hits, data = mlb_train) %>%
  step_normalize(all_predictors())

model <- linear_reg()

mlb_wflow <- workflow() %>%
  add_model(model) %>%
  add_recipe(mlb_recipe)

mlb_fit <- fit(mlb_wflow, data = mlb_train)

results <- augment(mlb_fit, new_data = mlb_test)

results %>% # high variance shown within the graph
  ggplot(aes(x = home_attendance, y = .pred)) +
  geom_abline(lty = 2, color="red") +
  geom_point(alpha = 0.7, color="blue") +
  labs(title = "Predicted versus actual values of home attendance", 
       x = "Home Attendance", 
       y = "Predicted Home Attendance") +
  coord_obs_pred()

mlb_metrics <- metric_set(rmse, rsq, mae)
mlb_metrics(results, truth = home_attendance, estimate = .pred)

# lasso regression model
X <- model.matrix(home_attendance ~ wins + homeruns + runs_scored + hits + strikeouts_by_pitchers + doubles + triples + walks + stolen_bases + complete_games + shutouts + saves + double_plays + earned_run_average + win_pct + runs_per_game, data = mlb)[, -1] 
y <- mlb$home_attendance

cv_model <- cv.glmnet(X, y, alpha = 1)

best_lambda <- cv_model$lambda.min
best_lambda

X_scaled <- scale(X)
lasso_model <- glmnet(X_scaled, y, alpha = 1, lambda = best_lambda, standardize = TRUE)

coef(lasso_model)

# final model
set.seed(1)
mlb_split <- mlb %>% initial_split(prop = 0.80)
mlb_train <- training(mlb_split)
mlb_test <- testing(mlb_split)

mlb_recipe <- recipe(home_attendance ~ wins + runs_per_game + hits + homeruns + strikeouts_by_pitchers, data = mlb_train) %>%     step_normalize(all_predictors())

model <- linear_reg() 

mlb_wflow <- workflow() %>%
  add_model(model) %>%
  add_recipe(mlb_recipe)

mlb_fit <- fit(mlb_wflow, data = mlb_train)

results <- augment(mlb_fit, new_data = mlb_test)


results %>% # high variance shown within the graph
  ggplot(aes(x = home_attendance, y = .pred)) +
  geom_abline(lty = 2, color="red") +
  geom_point(alpha = 0.7, color="blue") +
  labs(title = "Final Model: Predicted versus actual values of \nhome attendance", 
       x = "Home Attendance", 
       y = "Predicted Home Attendance") +
  coord_obs_pred()

mlb_metrics <- metric_set(rmse, rsq, mae)
mlb_metrics(results, truth = home_attendance, estimate = .pred)
