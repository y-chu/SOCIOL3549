******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 

* Read .dta file
* Save .log file
* Standardize a variable
* Get confidence interval of mean
* Data visualization: histogram 

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
log using "Week5 Standard distribution.log", replace

*********************************************************
****************** load existing GSS data ***************
*********************************************************

//load local GSS data file
use "2012 GSS Data.dta", clear

*********************************************************
************** STANDARDIZE A VARIABLE  ******************
*********************************************************

/*
 Our objective is to standardize an interval-ratio level variable.
 
 To do this, we need to create a new variable that is the standardized version of 
 the variable of interest.
 
 There are multiple ways you can do this: 
 
*/

**** method 1. use -summarize- (or could be shortened as -sum-) and then generate a new variable using the formula (x- mean) / standard deviation
******** 
sum age //this gives mean and sd

* you can then see the numbers and do the calculations directly
gen z_age1 = (age - 48.1935) / 17.68711
sum age z_age1

* or you can extract the mean and sd using macros - which are temporarilly saved outputs

/*

For the left single quote, we use the grave accent, which occupies a
    key by itself on most computer keyboards. On U.S. keyboards, the grave
    accent is located at the top left, next to the numeral 1.
For the right single quote, we use the standard single quote, or
    apostrophe. On U.S. keyboards, the single quote is located on the same
    key as the double quote, on the right side of the keyboard next to the
    Enter key.
	
*/

sum age
local mean = r(mean) //save mean from the -sum- output as local macro named mean
local sd = r(sd) //save sd from the -sum- output as local macro named sd
display `mean' //display the local macro mean 
display `sd' //display the local macro sd
gen z_age2 = (age - `mean') / `sd' 

sum age z_age2

**** method 2. use -egen newvar = std(var) - to directly generate stanardized variable
******** 

egen z_age3 = std(age) // you can also specify your mean and sd in options: egen z_age = std(age), mean(0) std(1)
sum age z_age3



/*
Note on Scientific Notation:
This may be a review for some of you, but -7.3e-9 = -0.0000000073.
This number is effectively 0. 
*/

/*
You know you’re correct when the mean=0 and standard deviation=1. 
Remember, you can only apply this procedure to an interval variable! 
*/

*********************************************************
*************** CONFIDENCE INTERVALS  *******************
*********************************************************


/*

 Our objective is to create a confidence level for an inteval-ratio level variable.
 
 -ci mean var, level(xx)- is to calculate confidence interval of variable with level xx
*/

* Default
ci means age

* Specified Confidence Intervals (i.e., obtain for 90%, 95%, 99%, etc.)

ci means age, level(90)

ci means age, level(95)

ci means age, level(99)

ci means age, level(99.9)


*********************************************************
**************** DATA VISUALIZATION  ********************
*********************************************************

/* 
- histogram- (-hist-) provides a histogram of your variable
We can produce histogram of both and compare
*/

//histogram of raw age, name it as "age1", add a graph title "Raw age"
hist age, normal bin(30) name(age1, replace) title("Raw age") 

//histogram of standarized age, name it as "age2", add a graph title "Standardized age"
hist z_age1, normal bin(30) name(age2) title("Standardized age") 

graph combine age1 age2 //compare the two graphs side by side


** can standarization make a "skewed" variable to "normally distributed"?
* try with educ - highest year of education
hist educ, normal name(educ1, replace) title("Raw educ") 
egen z_educ = std(educ) //generate standardized educ
hist z_educ, normal name(educ2, replace) title("Standardized educ") 

graph combine educ1 educ2 //compare the two graphs side by side

* try with income06 - total family income
hist income06, normal name(income1, replace) title("Raw income") 

//try do income06 by yourself

//close log file so it is saved
log close



