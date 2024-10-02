clear all
* Set the path where you want to save the log file
local log_file "C:\stata\analysis_log.log"

* Open the log file
log using `log_file', replace

 edit

use "C:\stata\agro.dta"

*get descriptives for numerical data

summarize *

local num_vars Age Yea*

summarize `num_vars'


tabulate `num_vars'
///Converting string variable to numerical

encode Haveyou*, gen(Increasedsales_num)

encode Doyousell*, gen(Sellnutrient_num)



destring Haveyou*, replace

destring Doyousell*, replace

///Checking correlation


corr Increasedsales_num Sellnutrient_num


///Normality Test

reg Increasedsales_num Sellnutrient_num Yeas*

predict resid, residuals

swilk resid

///Scatter plot to check linearity

scatter Increasedsales_num Sellnutrient_num

///VIF test for multicollinearity

regress Increasedsales_num Sellnutrient_num Yeas*

vif
///Test for Heteroskedasticity(Breusch-Pagan Test)

estat hettest

///Regression


gen log_sales = log(Increasedsales_num)
reg log_sales Sellnutrient_num Yeas*



regress log_sales Yeas*

regress log_sales Sellnutrient_num 


reg log_sales Sellnutrient_num Yeas*, robust



regress log_sales Yeas*, robust

regress log_sales Sellnutrient_num, robust 

logit log_sales Sellnutrient_num Yeas*, robust



regress log_sales Yeas*, robust

regress log_sales Sellnutrient_num, robust 

///Post regression diagnostics

predict cooks, cooksd

summ cooks

///check for autocorrelation

estat dwatson



log close
