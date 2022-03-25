******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 

* Read .dta file
* Save .log file
* Describe the data
* Generate measures of central tendency:
	* mode
	* mean
	* median
* Generate measures of dispersion:
	* range
	* standard deviation
	* variance
	* CRV
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
log using "Week4 Central tendency.log", replace

*********************************************************
****************** load existing GSS data ***************
*********************************************************

//load local GSS data file
use "2012 GSS Data.dta", clear

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

* -codebook- provides a general description of the variable
codebook age

* -summarize- (or could be shortened as -sum-) provides key summary stats (obs(n), mean, variance, Std. Dev., Min, Max)
 
summarize age //you can execute these commands for specific variables
sum age, detail //this gives detailed percentiles, so 50th percentile is the median

/*
Interpretation
50% – This is the 50th percentile, also known as the median.  If you order the values of the variable from lowest to highest, the median would be the value exactly in the middle.  In other words, half of the values would be below the median, and half would be above.  This is a good measure of central tendency if the variable has outliers.

Smallest – This is a list of the four smallest values of the variable.  In this example, the four smallest values are all 31.

Largest – This is a list of the four largest values of the variable.  In this example, the four largest values are all 67.

Obs – This column tells you the number of observations (or cases) that were valid (i.e., not missing) for that variable.  If you had 200 observations in your data set, but you had 10 missing values for the variable female, then the number in this column would be 190.

Mean – This is the arithmetic mean across the observations. It is the most widely used measure of central tendency. It is commonly called the average. The mean is sensitive to extremely large or small values.

Std. Dev. – This is the standard deviation of the variable.  This gives information regarding the spread of the distribution of the variable.

Variance – This is the standard deviation squared (i.e., raised to the second power).  It is also a measure of spread of the distribution.

Skewness – Skewness measures the degree and direction of asymmetry.  A symmetric distribution such as a normal distribution has a skewness of 0, and a distribution that is skewed to the left, e.g., when the mean is less than the median, has a negative skewness.

Kurtosis – Kurtosis is a measure of the heaviness of the tails of a distribution. A normal distribution has a kurtosis of 3. Heavy tailed distributions will have kurtosis greater than 3 and light tailed distributions will have kurtosis less than 3.
*/


/* 
-tabstat- can also provide a variety of key summary stats (e.g., obs(n), mean, 
median, Std. Dev., Min, Max). <see GUI>
*/

help tabstat
tabstat age, stat(n mean median sd min max)

tabstat age, stat(n mean median sd min max skewness kurtosis) //you can also quantify skewness and kurtosis


* Stata don't have a built-in command for getting mode. 
* One way to get mode of a variable is by generate frequency distribution table and find the category with highest frequencies
/* 
-tabulate- (-tab-) provides frequencies
*/
tab educ
tab educ, mis //include missing as a category

tab age

/*
Another way to do this is to use -egen-
-egen- is Extensions to generate, it has an option of generating mode and create it as a new variable as you name it. 
However, if the variable have multiple modes, you need to specify minmode, maxmode, or nummode() to create one mode of your choice. Otherwise the values will be all missing.
See -help egen- for more information.

-egen- is a very powerful command to have, make sure you check out the help file for it for more information.
*/
help egen
egen mode_age = mode(age), maxmode
codebook mode_age

/*
One other way is to use user developed package.
*/
help modes //you need to manually install package: sg113
modes age

*********************************************************
**************** DATA VISUALIZATION  ********************
*********************************************************

//- histogram- (-hist-) provides a histogram of your variable <see GUI>
histogram age
histogram age, freq //showing frequencies on the y axis, rather than density

hist age, normal //add a normal density plot to the graph
graph export "histogram of age.png", as(png) replace //export graph as a png file named "histogram of age.png" in current working directory folder

hist age, width(1) //set width of bins to one year of age

//close log file so it is saved
log close



