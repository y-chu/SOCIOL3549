******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 

* Read .dta file
* Save .log file
* Use Stata as a hand calculator
* Use Stata to find probabilities in normal distribution

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
log using "Week6 Normal distribution.log", replace

*********************************************************
************* Stata as a hand calculator ****************
*********************************************************

/*

You can use Stata as a hand calculator, with the -display- function.

see -help display- for more information

*/

* hand calculator
display 2+2
display 2*3
display 25/5

*********************************************************
************* Calculating normal curve ******************
*********************************************************

* -display normprob(<z score>)- function finds the proportion of the area under the standard normal curve

/* 
Attention: This is not exactly the same as what you see in the Appendix A table in the textbook.
Because the output of this command is the percentage BELOW the <z score> in a standard normal distribution. 
So it's not directly column (b) or column (c).
*/

* Try with our lab examples

display normprob(0.5)

display normprob(-1.64)

* If you'd like to find the area ABOVE the z score z=2 (area above 2 SD above the mean), you can use:
display 1-normprob(2)

/*
Now, you can use Stata to estimate the probabilities:

e.g. In our lab example, we have mean of birth weight = 3.23 kg and SD of birth weight = 0.14 kg
We want to find the probability that a girl's birth weight is between 3 and 3.3 kg.
*/

display normprob((3.3-3.23)/0.14) - normprob((3-3.23)/0.14)


* -display invnorm(<percentile>)- function finds the corresponding z-score given percentile
/* 
Suppose you want to know how many SD above the mean we need to be, 
in order to lie in the 90th percentile of the normal curve. 
*/

display invnorm(0.9)
//Interpretation of the output: you need to be 1.28 standard deviations above the mean to be in the 90th percentile of the distribution. 

display invnorm(0.5) //this is 50th percentile of the standard normal distribution, which is the median and mean (which is 0)


/*
Now, you can use Stata to estimate the minimum values in order to be in top x percentile of a distribution:

e.g. In our lab example, we have mean of birth weight = 3.23 kg and SD of birth weight = 0.14 kg
We want to find what's the minimum birth weight a girl need to be in order to be in the top 10% heaviest of all female births.
*/

display invnorm(0.9)*0.14+3.23
//Interpretation: the girl needs to be at least 3.41 kg in order to be among the top 10% baby girls heaviest at birth in US.


//close log file so it is saved
log close



