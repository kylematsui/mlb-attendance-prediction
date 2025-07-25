# MLB Attendance Prediction

This project explores how well Major League Baseball (MLB) team statistics can predict home game attendance. Using data from [OpenIntro's MLB dataset](https://www.openintro.org/data/index.php?data=mlb_teams), the analysis involves data cleaning, exploratory data analysis (EDA), feature engineering, and predictive modeling using linear regression and Lasso regression.

## 🖥️ View the Full Analysis  
You can explore the complete rendered report, including all code, plots, and outputs, online at [RPubs](https://rpubs.com/kylematsui/mlb-attendance-prediction).

## 📊 Objective
Build a supervised machine learning model that predicts a team’s total home attendance based on team performance statistics such as wins, home runs, runs scored, ERA, and more.

## 🎓 Course Information

This project was completed as the final project for the **[UC Berkeley ATDP Data Science Lab with R](https://atdp.berkeley.edu/catalog/#SecondaryDivisionOnline/DataScienceLabwithR)** summer course. The course focused on applying statistical analysis, data visualization, and machine learning techniques using the R programming language. This capstone project applied those skills to a real-world dataset, demonstrating the end-to-end process of building, evaluating, and interpreting a predictive model.

## 🧰 Tools & Libraries
- R
- R Studio
- `dplyr`
- `ggplot2`
- `tidyverse`
- `tidymodels`
- `glmnet`

## 📁 Files
- `mlb_attendance_analysis.Rmd`: Main analysis notebook (EDA, modeling, interpretation)
- `mlb_attendance_prediction_presentation.pdf`: Summary slide deck presenting key findings, methodology, and conclusions from the analysis
- `mlb_teams.csv`: Dataset containing MLB team stats and attendance figures (source: OpenIntro)

## 🔍 Key Steps
- **Data Cleaning**: Removed NA values
- **EDA**: Visualized relationships between attendance and key variables
- **Feature Engineering**: Created `win_pct` and `runs_per_game`
- **Modeling**: 
  - Linear regression to estimate relationships
  - Lasso regression to identify most important predictors
- **Evaluation**: RMSE, MAE, and R² metrics used to assess model performance

## 📌 Findings
- Team performance (especially wins, runs per game, and home runs) has a positive relationship with home attendance.
- However, the model's R² was relatively low, suggesting other external factors (e.g. market size, promotions, weather) play a large role in fan turnout.

## 📎 Data Source
- [OpenIntro MLB Teams Dataset](https://www.openintro.org/data/index.php?data=mlb_teams)

## 👤 Author
Kyle Matsui

## 📝 License
This project is licensed under the [MIT License](LICENSE).
