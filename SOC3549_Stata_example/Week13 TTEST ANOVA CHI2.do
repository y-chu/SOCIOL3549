******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 

* Read .dta file
* Save .log file
* Hypothesis testing - t-test
* Hypothesis testing - one way ANOVA
* Hypothesis testing - chi2

A useful summary list of codes 
https://stats.idre.ucla.edu/stata/code/descriptives-ttests-anova-and-regression/

In-class exercise for today:
Using 2012 GSS Data.dta
1. test whether being married or not is associated with years of education completed
2. test whether mean weeks worked in the past year is associated with race
3. test whether difference race groups have different education attainment 
(as measured by highest degree earned)

Upload your log file showing the code and result to Carmen for attendance.
Please use proper "comments" to indicate what you're doing.

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
log using "Week13 hypothesis testing.log", replace

*********************************************************
****************** load existing GSS data ***************
*********************************************************

//load local GSS data file
use "2012 GSS Data.dta", clear

*********************************************************
************* One sample t-test *************************
*********************************************************

/*
When you know sample size, sample mean and sample SD, you can use 

for single mean t-test
-ttesti <sample size> <sample mean> <sample SD> <hypothesized mean>, level(<confidence level >)- function

for two means t-test
-ttesti <sample size1> <sample mean1> <sample SD1> <sample size2> <sample mean2> <sample SD2>, level(<confidence level >)- function

Remember that confidence level is (1-alpha)*100 %

use -help ttesti- for more details

*/

/* 
Take our in-class exercise example from week 11 recitation

GRE verbal test score for students with different intended major:

Social science - a sample of 50 students: mean=155.1, SD = 8.4
Natural science - a sample of 50 students: mean=149.9, SD = 9.2

confidence level = (1-alpha)*100 = (1-0.05)*100 = 95 %

*/

ttesti 50 155.1 8.4 50 149.9 9.2, level(95)


/*
When you have individual scores in the sample, you can use

for single mean t-test
-ttest <variable> == <hypothesized mean>, level(<confidence level>)- function

for two means t-test
-ttest <variable>, by(group variable) level(<confidence level>)- function

default is level(95) for alpha=0.05 if don't specify confidence level

use -help ttest- for more details
*/

//test mean year of education by gender
ttest educ, by(sex) level(95)

//test mean weeks worked in the past year by gender
ttest weekswrk, by(sex)


*********************************************************
*************** one way ANOVA ***************************
*********************************************************

/*
you can use 
-oneway <Dependent Var.> <Independent Var.>, tabulate- function

or 

-anova <Dependent Var.> <Independent Var.>- function

The results should be consistent, -oneway- function allows for output of 
more results by specifying options, such as -tabulate- for summary table.
see -help oneway- for more details.

*/

//test mean year of education by marital status: married vs ever married vs never married
//first step: combine widowed, divorced, separated to "ever married"
codebook marital //take a look at the variable
recode marital (1=1) (2/4=2) (5=3), g(marital3) //recode marital, and save the new 3-category variable as "marital3"
label def marital3l 1 "married" 2 "ever married" 3 "never married" //label the values of new variable
label val marital3 marital3l
codebook marital3

//one way anova
oneway educ marital3, tabulate

//if you want to add multiple comparison
oneway educ marital3, bonferroni //bonferroni multiple comparison

//alternatively, you can use -anova- for analysis of variance table
anova educ marital3

*********************************************************
*************** chi-square analysis *********************
*********************************************************

/*
you can use 
-tabulate <var1> <var2>, chi2- function

*/

//test highest degree earned by gender
ta degree sex, col chi2 

//test whether total family income is associated with race
//regroup income to very low, low, middle, high income groups
codebook income06 //take a look at the income variable, and variable label
label list LABAO //see what the labels mean for variable income06
su income06, d //see percentiles for breaking
recode income06 (1/13=1) (14/18=2) (19/21=3) (22/25=4), g(income4)
label def income4l 1 "very low income" 2 "low income" 3 "middle income" 4 "high income"
label val income4 income4l
codebook income4

ta income4 race, col chi2


//Hint for excercise question 1
//first step: recode marital status to a binary variable "married" vs "not married"
//in other words, combine never married, widowed, divorced, separated to "not married"
recode marital (1=1) (2/5=0) , g(marital2) //recode marital, and save the new binary variable as "marital2"
label def marital2l 1 "married" 0 "not married" //label the values of new binary variable
label val marital2 marital2l
codebook marital2
//next step:  by married vs not married, test hypothesis


//close log file so it is saved
log close



