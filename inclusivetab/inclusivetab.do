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
gen result = 0
replace result = 1 if _n > 630
replace result = 2 if _n > 870
label define col_heads 0 "Not Grmntd" 1 "Grmntd" 2 "Fruited"
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

// Display a summary of the data with tablecol (ssc install tablecol)
tablecol plantyear result region, row col
