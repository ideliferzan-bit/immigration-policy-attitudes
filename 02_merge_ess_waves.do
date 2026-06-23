* 02_merge_ess_waves.do
* Append cleaned ESS waves 7-11 into a single dataset.

cd ".."
set more off

use "data/ESS7_clean.dta", clear
append using "data/ESS8_clean.dta"
append using "data/ESS9_clean.dta"
append using "data/ESS10_clean.dta"
append using "data/ESS11_clean.dta"

* Ensure the full ESS sample is limited to the selected countries
keep if regexm(cntry, "^(AT|BE|CZ|DE|EE|ES|FI|FR|HU|IE|LT|NL|PL|PT|SE|SI)$")

save "data/ESS7-11_clean.dta", replace

display "ESS7-11 merged dataset saved"
