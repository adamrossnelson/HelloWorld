// Prepared to illustrate question at:
// https://www.statalist.org/forums/forum/general-stata-discussion/general/1430851-interesting-tabulation-question

// JUNE 2018 UPDATE: Project moved to repo at:
// https://github.com/adamrossnelson/cumtab

// Set workspace.
set more off
clear all
set obs 1000

// Define a shuffle function.
program shuffleit
    set seed 123456
    gen srtr = runiform(0,100)
    sort srtr
    drop srtr
end

// Create fictional planting year data.
gen plantyear = 2010
replace plantyear = 2011 if _n > 750
replace plantyear = 2012 if _n < 250
replace plantyear = 2013 if _n > 475 & _n < 650
replace plantyear = 2014 if _n > 300 & _n < 425

// Shuffle the data.
shuffleit

// Create fictional cultivation data.
gen result = 1
replace result = 2 if _n > 630
replace result = 3 if _n > 870
label define col_heads 0 "Total Seeds" 1 "Not Grmntd" 2 "Grmntd" 3 "Fruited"
label values result col_heads

// Display a summary of the data with tabulate.
tab plantyear result

// Shuffle the data.
shuffleit

// Add some geographic data.
gen region = 0
replace region = 1 if _n > 600
label define ns 0 "South Fields" 1 "North Fields"
label values region ns

// Check output.
table plantyear result region, scolumn

// Code added as a solution as proposed on StataList.org.
preserve
clonevar tabresult = result 

// Expand data to include fruited in germinated column.
expand 2 if tabresult == 3, generate(added1)
replace tabresult = 2 if added1
expand 2 if added1 == 0, generate(added2)
replace tabresult = 0 if added2

// Display a summary of the data with tablecol (ssc install tablecol).
table plantyear tabresult region, scolumn
restore



