******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 

* Read .dta file
* Describe the data
* Calculate frequencies

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
cd "~/Dropbox/OSU/Teaching/3549 STATISTICS/SOCIOL3549/"  // cd "<your own file path>"

//creat log file to keep track of what you have done in this session
log using "Stata example/Week3 Frequency.log", replace

*********************************************************
****************** load existing GSS data ***************
*********************************************************

//load local GSS data file
use "GSS Data/2012 GSS Data.dta", clear
keep age sex degree educ attend relig reliten //keep only the selected variables: age, sex, religious preference, religious service attendance, strength of religious affiliation.

*********************************************************
****************** DATA EXPLORATION  ********************
*********************************************************

* Examples of Stata Commands to Obtain: Descriptive Statistics

/* 

You can use some of the Stata commands for - Descriptive Statistics - by 
themselves to get descriptive stats for your entire dataset at one time. 
Remember that you can execute some commands using only their abbreviation 
(e.g., sum for summarize).

For most Stata commands, there are supplementary commands that will allow you to 
augment the original command (e.g., summarize, detail). This provides additional 
summary information about the distributions of a variable (e.g., kurtosis) as 
well as helps to identify the median value.

See Stata manual for details <Help>
*/

* -summarize- (or could be shortened as -sum-) provides key summary stats (obs(n), mean, Std. Dev., Min, Max)
 
summarize educ //you can execute these commands for specific variables
sum educ, detail

summarize // if you don't specify, the command is executed for all variables
summarize, detail


* codebook is a Stata command that provides a general summary of variable(s) 

codebook
codebook _all // "_all" means all variables in the data set
codebook _all, compact // compact, display compact report on the variables

codebook attend
codebook degree educ //you can also do one or more variables by listing them all

/* 
tabstat can also provide a variety of key summary stats (e.g., obs(n), mean, 
median, Std. Dev., Min, Max). <see GUI>
*/

tabstat age, stat(n mean median sd min max)


* The following command will ensure that Stata reports values and value labels
numlabel _all, add

//tabulate variables
/* 
tabulate (tab) provides frequency, relative frequency, and cumulative 
freqency distributions. tab1 will provide these tables for multiple variables 
at once. tab, missing will provide a frequency distrbution that also indicates
the number of missing values. <see GUI>
*/


tabulate attend
tabulate attend, mis //tabulate, include the observations with missing values
tabulate attend sex, column //tabulate two variables, with column percentages

*********************************************************
****************** DATA MANIPULATION  *******************
*********************************************************

* Examples of Stata commands for setting various values to "missing" 

/* 

Using either the commands 'codebook' or 'tab , missing' we can identify whether 
or not there are missing values in the data for a given variable. 

*/

codebook attend

/* 

From our data exploration steps above, we identify that .d is the current 
coding for missing values. We could also check our data documentation, which 
also indicates that .d is the original code for missing data for this variable. 
This is a specific category code for missing value. Stata recognizes 26 versions
(e.g., .a .b .c ... for the entire alphabet) as well as "." 

For demonstration purposes, we will recode our data to set .d to the generic 
version; i.e., "."

After running this code, we can run the Stata command codebook or tab, missing 
to check if the data have been updated correctly

*/


/* 

There are two ways to recode a numeric variable: 

We can use the Stata command 'recode', 
or we can use a new Stata command: 'replace' <see GUI>

*/

replace attend = . if attend == .d

recode attend (.d = .) //alternative

* Recode Missing Values (specific variable)
*mvdecode attend, mv()

* Recode Missing Values (entire dataset)
*mvdecode _all, mv()


*********************************************************
************** GENERATE NEW VARIABLES  ******************
*********************************************************

* Creating a categorical variable for ever attended religious services

//one way is to -generate- a new variable, and replace the values by specifying conditions
generate everattend = .
replace everattend = 0 if attend==0
replace everattend = 1 if attend > 0  & attend <= 8
tabulate attend everattend, missing

label variable everattend "ever attendedreligious services"

label define everattend_label 0 "never" 1 "at least once"
label values everattend everattend_label

tabulate everattend

//an alternative way is to use -recode- command
recode attend (0=0) (1/8=1) , generate(everattend2)
tabulate everattend2, missing

label values everattend2 everattend_label

tabulate everattend everattend2, missing


*********************************************************
**************** DATA VISUALIZATION  ********************
*********************************************************

//- histogram- (-hist-) provides a histogram of your variable <see GUI>
histogram age

histogram attend

//-graph pie- provides pie chart for variable
graph pie attend, over(attend) //show distribution of attend

//-graph bar- provides bar chart for variable
graph bar age, over(sex) //show mean age by sex


//close log file so it is saved
log close



