******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

*********************************************************
****************** set up environment *******************
*********************************************************

//Tell Stata to not pause for --more-- messages
set more off 

//clear environment
capture clear 

//set working directory
cd "~/Dropbox/OSU/Teaching/3549 STATISTICS/SOCIOL3549/" 

*********************************************************
****************** load existing GSS data ***************
*********************************************************
//creat log file to keep track of what you have done in this session
log using "Stata example/Read data.log", replace

//load local GSS data file
use "GSS Data/2012 GSS Data.dta", clear

//describe data contents
codebook _all, compact // "_all" means all variables in the data set
codebook adults //you can also do one or more variables by listing them all

//tabulate variables
tab sex
tab race
tab sex race, column //tabulate two variables, with column percentages

//close log file so it is saved
log close
