******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 

* Read .dta file
* Save .log file
* Calculate confidence interval 
* Hypothesis testing - one sample z-test

*/

*********************************************************
****************** set up working environment ***********
*********************************************************
//Tell Stata to not pause for --more-- messages & not stop at the bottom of a given page
set more off 

//clear memory: removes data, value labels etc. from memory before loading new data or starting new project
capture clear 

//close any open log file before start new log file
capture log close

//set working directory
cd "C:\Users\CHU.282\OneDrive - The Ohio State University\SOC3549"  // cd "<your own file path>"

//creat log file to keep track of what you have done in this session
log using "Week10 CI ztest.log", replace

*********************************************************
****************** load existing GSS data ***************
*********************************************************

//load local GSS data file
use "2012 GSS Data.dta", clear

*********************************************************
**************** Confidence Intervals *******************
*********************************************************


/*
When you know sample size, sample mean and population SD, 
you can use -cii means <sample size> <sample mean> <SD>, level(#)- function 
to compute #% confidence interval

*/

/* 
Take our in-class example on GRE verbal test score from week 8 recitation

GRE verbal test score has SD = 8.5. You took a sample of n=64 students with mean score =149.7
Question: what is the interval which we are 95% confident that the true population mean would fall into?
*/

cii means 64 149.7 8.5, level(95)

* Consistent with our hand calculation: 
* based on our sample of 64 students, we are 95% confident that average GRE score for all students falls between 147.6 and 151.8.


/*
You can also create a confidence level for an inteval level variable.

Using -ci means <variable list>, level(#)-- function, default is level(95) for 95% CI

it computes means, standard errors and confidence intervals for each of the variables in variable list.

*/

* Default confidence level is 95%
ci means age

* Specified level of confidence 
ci means age, level(90)

ci means age, level(99)

* Compute CI for multiple variable at the same time
ci means age educ income06, level(95)

* Note: The standard error of the mean, is sample variance s/sqrt(n)

*********************************************************
************* One sample Z-test *************************
*********************************************************

/*
When you know sample size, sample mean and population SD, 
you can use 
-ztesti <sample size> <sample mean> <population SD> <hypothesized mean>, level(<confidence level >)- function
for one sample z-test / single mean z-test

Remember that confidence level is (1-alpha)*100 %

*/

/* 
Take our in-class example on GRE verbal test score from week 9 recitation

GRE verbal test score has SD = 8.5. You took a sample of n=64 students with mean score =149.7
You want to test null hypothesis of whether population mean for GRE verbal test score is equal to 150, at the alpha level of 0.05

confidence level = (1-alpha)*100 = (1-0.05)*100 = 95 %

*/

ztesti 64 149.7 8.5 150, level(95)

/* 
Interpretation of Stata output: 

z score for sample mean: z=-0.2824

For our H0 mean=150 , Ha should be mean !=150 (!= in Stata means unequal)
So we look at the column in the middle at the bottom of the result.

Pr(|Z|>|z|) is the two-tailed p-value evaluating the null against an alternative that the mean is not equal to 150
The probability of observing a greater absolute value of Z score under the null hypothesis is 0.7777.
We compare this to the pre-specified alpha level (in our case, alpha=0.05)
The probability = 0.7777 is greater than alpha level = 0.05

We fail to reject null hypothesis at alpha level of 0.05. 

*/


/*
You can also test sample against a hypothesized population value for a variable.

Using -ztest <variable> == <hypothesized mean>, level(<confidence level>)- function,
default is level(95) for alpha=0.05 if don't specify confidence level

*/

ztest age==45, level(95)

ztest age==45, level(90)


//close log file so it is saved
log close



