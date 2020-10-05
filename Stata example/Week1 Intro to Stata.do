******************************************************************************************************************************************************
** Recitation for Sociology 3549
** Created: 2020-08-15, by Yue Chu
******************************************************************************************************************************************************

* Remember that a great reason why DO files are so useful is that you can save notes
* This makes it super easy to start up wherever you leave off in your work
* You'll see below that notes/note markers can also be helpful organizational tools 


// Notes are indicated using either *, //, or /* ... */ 
// These marks will tell Stata to not execute your notes as Stata commands
// You can also use these marks to turn off Stata commands rather than deleting them 


/* 

Our first task will be to open our data in Stata. 

Remember that there are multiple ways for us to accomplish this task. For 
instance, we could use Stata's graphical user interface (GUI) or we could execute 
Stata commands directly from our DO file. Below are examples of Stata commands 
that I could use either on my Mac at home or on a PC here on campus. 

If you are unsure of the proper command or file path, a great way to start out 
is to use the GUI and then copy the command and file pathway to your DO file 
for future use.

*/

*********************************************************
****************** set up working environment ***********
*********************************************************

//Tell Stata to not pause for --more-- messages & not stop at the bottom of a given page
set more off 

//clear memory: removes data, value labels etc. from memory before loading new data or starting new project
capture clear 

//close log file if any is open
cap log close

//set working directory
cd "~/Dropbox/OSU/Teaching/3549 STATISTICS/SOCIOL3549/" 

//see current working directory
pwd 

*********************************************************
****************** load existing GSS data ***************
*********************************************************
//creat log file to keep track of what you have done in this session
log using "Stata example/Week1 Intro to Stata.log", replace

//load local GSS data file
use "GSS Data/2012 GSS Data.dta", clear

//Stata's help system: help [command_or_topic_name]
help codebook 
help tabulate

//describe data contents
codebook _all // "_all" means all variables in the data set
codebook _all, compact // compact, display compact report on the variables
codebook adults //you can also do one or more variables by listing them all
codebook age, detail //you can also do one or more variables by listing them all

//search for variables: any mentioning of the strings in variable names or variable lables
lookfor reli //look for variables with mentioning of "reli" 

//tabulate variables
tabulate sex //default table shows value labels
tabulate sex, nolabel //if you don't want to show the actual values rather than labels, use "nolabel" option
tabulate childs, mis //tabulate, include the observations with missing values
tabulate sex race //two-way tabulation
tabulate sex race, column //tabulate two variables, with column percentages

//keep and drop variables - this can NOT be un-do, so be careful! If you regret about this move, reload the data and start-over again.
drop wrkstat weekswrk
keep age sex educ attend relig reliten //keep only the selected variables: age, sex, religious preference, religious service attendance, strength of religious affiliation.

//save as new data file
save "GSS Data/2012 GSS Data_religion.dta", replace //replace data file if file with same name exists in target directory.

//close log file so it is saved
log close



