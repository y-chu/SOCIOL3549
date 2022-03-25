******************************************************************************************************************************************************
** Coding tips for Stata - SGSA workshop
** Last modified: 2022-03-24, by Yue Chu
******************************************************************************************************************************************************

/* 

Objectives for this week: 
*Good coding practice
*Efficient coding
- Macros
- tempfile, tempvar
- loops
*Useful commands
- Data processing: reshape, merge, fuzzy match
- Missingness: mdesc, mvpatterns, mcartest, mi
*Output formatting
- eststo, esttab

Models are all conveniencely made up for demonstrating the codes.
Don't take the results seriously.
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
cd "~/Dropbox/OSU/Teaching/Stats-resource-for-social-science/SGSA_workshop"  // cd "<your own file path>"

//creat log file to keep track of what you have done in this session
log using "coding_tips_workshop_2022.log", replace

//load auto data
sysuse auto, clear

*********************************************************
************* Wrap long codes ***************************
*********************************************************

* use ///
codebook make price mpg rep78 ///
	headroom trunk, compact

* use #delimit
#delimit
codebook weight length turn displacement 
	gear_ratio foreign, compact ; 
#delimit cr

help #delimit //for more information

*********************************************************
************* Macro *************************************
*********************************************************

* global macro

global today c(current_date)
dis $today
dis subinstr(${today}," ","_",.)

/*
Note: very useful when you have new versions of input data 
and want to re-run your whole code and do version control.
For example:

global version = "20220101" 
use "input_${version}.dta", clear
run some code
save "output_${version}.dta", replace

*/

global x "weight foreign"

reg mpg $x
reg mpg $x length
reg mpg $x , vce(robust)

* local macro
local i=1+1
dis `i'

qui su price, d //quietly summarize price with detail
local median = r(p50)
dis "Median of price is " `median'
 
* difference between global and local

dis "$x"
//what happens if you use $x instead of "$x" 
dis $x //it shows values from first observation

dis `median'


*********************************************************
************* Tempvar ***********************************
*********************************************************

// create a temp variable called var1
tempvar var1 
g `var1' = 100/mpg
reg `var1' weight

// Note: need to replace if var1 has already been defined
replace `var1' = rnormal(0,1)
su `var1'



*********************************************************
************* Tempfiles *********************************
*********************************************************

// create a tempfile with mean and sd of price by group
preserve
collapse (mean) price_mean=price ///
		 (sd) price_sd=price, by(foreign)
tempfile temp
save `temp', replace //need to replace
restore

// merge group mean and sd of price back to master dataset
merge m:1 foreign using `temp'
drop _merge


*********************************************************
************* Loops *************************************
*********************************************************

* loop over values -forvalues- or -forv- for short
codebook rep78
forv i=1/5 {
	su price if rep78==`i'
}
//Note: forvalues only work with certain numlist
//see -help forvalues- for details

//If you want to loop over other types of number list, use -foreach-
foreach i of numlist 42 623 416 {
	dis `i'
}

* loop over strings
foreach str in "hello" "world" {
	dis "say `str'"
}

* loop over variables

foreach var in price weight {
	su `var'
}

foreach var of varlist price* mpg weight-length {
	su `var'
}

* loop over levels of a variable
local graphs ""
levelsof foreign, local(lvl)
local lbe: value label foreign
foreach i of local lvl {
	local label`i' : label `lbe' `i'
	scatter mpg weight if foreign == `i', ///
		title("`label`i''") name(fig`i', replace) nodraw
	local graphs "`graphs' fig`i'"
}
graph combine `graphs', col(2)
* graph export "graphs.png"

* while 
local i=0
while `i'<10 {
	loc i=`i'+1
	if (mod(`i',3)==0) dis `i'
}


*********************************************************
************* reshape ***********************************
*********************************************************


//say we want mpg for domestic and for foreign as two seperate var
preserve

keep make mpg foreign //treat make as ID here

reshape wide mpg, i(make) j(foreign) //long to wide
list in 1/5 //take a look

reshape long mpg, i(make) j(foreign) //wide to long
list in 1/5

restore


*********************************************************
************* merge and fuzzy match *********************
*********************************************************

* exact match using merge
* see example in tempfiles above (line#140-141)

* fuzzy match using matchit
* codes from : https://www.statalist.org/forums/forum/general-stata-discussion/general/1338206-what-are-the-differences-between-matchit-and-reclink

clear
// install packages if you don't have them
*ssc install freqindex 
*ssc install matchit
*ssc install reclink

// generate toy datasets from do file
include "test.do"

// 1- matchit first by the most relevant pair of columns
matchit id2 name2 using `file1', idu(id1) txtu(name1) t(0)
gsort -similscore //similarity score, largest to smallest
list

// 2- bring back the other columns
joinby id1 using `file1'
joinby id2 using `file2'

// 3- match it using the column syntax for as many columns you want
// clean the data (e.g. same case or removing symbols)
gen CITY1=upper(city1)
gen CITY2=upper(city2)
matchit CITY1 CITY2 , g(simCITY)

// 4- you can also use non-fuzzy string approaches here (e.g. numeric variables)
gen simage=1-abs(age1-age2)/max(age1,age2)

// 5- Generate the uber similarity score of your taste/needs
gen superscore1=similscore*simCITY*simage
gen superscore2=(similscore+simCITY+simage)/3
gen superscore3=.5*similscore+.25*simCITY+.25*simage
gsort -superscore3


* reclink
// generate toy datasets from do file
include "test.do"
use `file1', clear
//conform variable names
rename (name1 city1 age1) (name2 city2 age2)
reclink name2 city2 age2 using `file2', gen(simscore) ///
	idm(id1) idu(id2)


*********************************************************
************* Missingness *******************************
*********************************************************
* let's go back to auto data
sysuse auto, clear

* To have some fun, I randomly replace some values to missing
set seed 416
generate random = runiform()
sort random
replace mpg = . in 1/5
set seed 42
replace random = runiform()
sort random
replace weight = . in 1/7

* display number and % of missing values for each variable
mdesc

* missing patterns - visual examine
mvpatterns mpg rep78 weight


*** Test whether variables are missing completely at random (MCAR)

* MCAR test - ttest
recode mpg (.=1) (else=0), g(miss)
ttest weight, by(miss)

* MCAR test - chi2
tab foreign miss, chi2

* multiple variables - Little's test
mcartest mpg weight price rep78

*** Missing imputation (MI)

* regression imputation
reg mpg weight if miss==0
predict mpg1

scatter mpg weight if miss==0, col("navy") ///
	|| scatter mpg1 weight if miss==1, col("red")
	
//add stochastic noise: assuming normal distribution
//mean=0, sd=sd of observed y
qui su mpg if miss==0
local sd=r(sd)
set seed 42
g mpg2 = mpg1 + rnormal(0,`sd')

scatter mpg weight if miss==0, col("navy") ///
	|| scatter mpg1 weight if miss==1, col("red") ///
	|| scatter mpg2 weight if miss==1, col("green")

* MICE (multiple imputation by chained equations)

// specify format to produce imputations (wide = add a new column)
mi set wide
// specify variables (with missing) to be imputed
mi register imputed mpg weight rep78
// specify variables (without missing) use for imputation
mi register regular length price foreign
// imputation models
mi impute chained ///
	(regress) mpg weight ///
	(mlogit) rep78 ///
	, add(5) //number of imputations, rule of thumb 20+
// take a look at imputed values
su _*
// use imputed estimates in regression models
mi est: reg mpg weight price length i.foreign i.rep78
mi est, dftable //table with df and change in std. err.

*********************************************************
************* eststo esttab *****************************
*********************************************************
	
* estimation storage -eststo-

eststo: reg price weight mpg, notable noheader
eststo: reg price weight mpg foreign, notab nohe

* regression output as table
esttab, se ar2 /// //with std. err. and adjusted r2
	title("Regression table") ///
	mtitles("Model1" "Model2")

* estimation storage -est sto-
reg price weight mpg, notable noheader
est sto model1
reg price weight mpg i.foreign, notab nohe
est sto model2

* regression output as table
esttab model1 model2, ar2 label ///
	title("Regression table") ///
	nonumbers mtitles("Model1" "Model2") ///
	addnote("Source: auto.dta") ///
	varwidth(25) 
	
//Note: for comprehensive demonstration, see -help esttab-
//or http://repec.sowi.unibe.ch/stata/estout/esttab.html
	

//close log file so it is saved
log close



