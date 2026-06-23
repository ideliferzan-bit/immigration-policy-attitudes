* 01_clean_ess_waves.do
* Clean and harmonize ESS waves 7-11 for the project.
* Place raw ESS wave files in data/raw/ and save cleaned files to data/.

cd ".."
set more off

*---------------------------------------------*
* ESS wave 7
*---------------------------------------------*
use "data/raw/ESS7_clean_raw.dta", clear

* Keep only the variables needed for the analysis
keep essround idno anweight pweight cntry brncntr mocntr facntr hinctnta agea gndr domicil eduyrs imdfetn imbgeco lrscale

* Restrict sample to native-born respondents in the selected countries
keep if brncntr == 1 & mocntr == 1 & facntr == 1
keep if regexm(cntry, "^(AT|BE|CZ|DE|EE|ES|FI|FR|HU|IE|LT|NL|PL|PT|SE|SI)$")

* Recode and rename variables
format essround %1.0f
rename agea age
rename domicil residence
rename eduyrs education
rename hinctnta hh_income

recode lrscale (77 88 99 = .)

gen female = (gndr == 2)
label define female 0 "Male" 1 "Female", replace
label values female female

* Outcome variables
gen imm_attitude = 5 - imdfetn
label define imm_attitude 1 "Allow none" 2 "Allow a few" 3 "Allow some" 4 "Allow many", replace
label values imm_attitude imm_attitude
rename imbgeco econ_impact

* Remove missing control cases only after harmonization checks
keep if !missing(age, education, residence, lrscale)

save "data/ESS7_clean.dta", replace

display "ESS7 cleaned and saved"

* Repeat the block above for ESS8, ESS9, ESS10, ESS11
* Update file names as needed and save to data/ESS8_clean.dta, etc.
*---------------------------------------------*

* Example block for ESS11
use "data/raw/ESS11e04_1.dta", clear
keep essround idno anweight pweight cntry brncntr mocntr facntr hinctnta agea gndr domicil eduyrs imdfetn imbgeco lrscale
keep if brncntr == 1 & mocntr == 1 & facntr == 1
keep if regexm(cntry, "^(AT|BE|CZ|DE|EE|ES|FI|FR|HU|IE|LT|NL|PL|PT|SE|SI)$")
format essround %1.0f
rename agea age
rename domicil residence
rename eduyrs education
rename hinctnta hh_income
recode lrscale (77 88 99 = .)
gen female = (gndr == 2)
label define female 0 "Male" 1 "Female", replace
label values female female
gen imm_attitude = 5 - imdfetn
label define imm_attitude 1 "Allow none" 2 "Allow a few" 3 "Allow some" 4 "Allow many", replace
label values imm_attitude imm_attitude
rename imbgeco econ_impact
keep if !missing(age, education, residence, lrscale)
save "data/ESS11_clean.dta", replace

display "ESS11 cleaned and saved"
