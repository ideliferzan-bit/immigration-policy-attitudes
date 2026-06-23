* 05_analysis.do
* Prepare predictors and estimate the multilevel models.

cd ".."
set more off

use "data/locked_final.dta", clear

* Label residence categories
label define residence_lbl 1 "Big city" 2 "Suburbs" 3 "Town" 4 "Village" 5 "Countryside", replace
label values residence residence_lbl

* Income preparation
gen income_cont = hh_income
replace income_cont = . if hh_income == 11
label variable income_cont "Household Income (Decile, continuous 1-10)"

egen income_country_mean = mean(income_cont), by(cntry)
gen income_c = income_cont - income_country_mean
label variable income_c "Income (centered within country)"

* Drop cases with missing key variables
drop if missing(income_cont)
drop if missing(imm_attitude)
drop if missing(econ_impact)

* Age and political orientation
gen age_c = age - r(mean)
label variable age_c "Age (mean-centered)"

summarize lrscale
gen lrscale_c = lrscale - r(mean)
label variable lrscale_c "Left-right self-placement (centered)"

* Drop variables not required for analysis
drop anweight pweight

* Create year indicator from ESS round
gen year = .
replace year = 2014 if essround == 7
replace year = 2016 if essround == 8
replace year = 2018 if essround == 9
replace year = 2020 if essround == 10
replace year = 2023 if essround == 11

* Calculate within-country centered wave predictors
egen country_wave = group(cntry essround)
label variable country_wave "Country-wave identifier"

bysort cntry: egen mipex_change_c = mean(mipex_change)
gen mipex_change_w = mipex_change - mipex_change_c
bysort cntry: egen fb_change_c = mean(fb_change)
gen fb_change_w = fb_change - fb_change_c

bysort cntry essround: assert mipex_change_w == mipex_change_w[1]
bysort cntry essround: assert fb_change_w == fb_change_w[1]

* Center absolute contextual variables
summarize mipex_score
gen mipex_c = mipex_score - r(mean)
summarize fb_share_pct
gen fb_c = fb_share_pct - r(mean)

* Descriptive statistics table
asdoc tabstat imm_attitude econ_impact hh_income age education residence female mipex_change fb_change mipex_score fb_share_pct, stats(mean sd min max count) save("output/descriptives.doc") replace

* Change trends graph
preserve
collapse (mean) mipex_change fb_change, by(year)
set scheme sj

twoway (line mipex_change year, sort lcolor(black) lwidth(medthick)) (line fb_change year, sort lcolor(gs8) lpattern(dash) lwidth(medthick)), yline(0, lcolor(gs15) lwidth(vthin)) yscale(range(0 2)) ylabel(0(0.5)2, nogrid noticks) xlabel(, noticks) ytitle("Change") xtitle("Year") legend(order(1 "MIPEX change" 2 "Foreign-born change") position(6) ring(1) cols(1) region(lstyle(none))) graphregion(color(white)) plotregion(style(none))
  graph export "output/mipex_fb_change.png", replace width(4000)
restore

* Analysis models
mixed imm_attitude || cntry: || country_wave:
estat icc
estimates store m0

mixed imm_attitude income_c lrscale_c female age_c education i.residence || cntry: || country_wave:
estimates store m1

mixed imm_attitude income_c lrscale_c female age_c education i.residence mipex_change_w fb_change_w || cntry: || country_wave:
estimates store m2

gen mipex_fb_interaction = mipex_change_w * fb_change_w

mixed imm_attitude income_c lrscale_c female age_c education i.residence mipex_change_w fb_change_w mipex_fb_interaction || cntry: || country_wave:
margins, at(mipex_change_w=(-2 0 2) fb_change_w=(-2 0 2))
marginsplot
estimates store m3

mixed imm_attitude income_c lrscale_c female age_c education i.residence mipex_change_w fb_change_w mipex_fb_interaction mipex_c fb_c || cntry: || country_wave:
estimates store m4

esttab m0 m1 m2 m3 m4 using "output/immigration_models.html", replace se star(* 0.05 ** 0.01 *** 0.001) label compress title("Multilevel Models Predicting Immigration Attitudes")

* Robustness check: Economic impact
mixed econ_impact || cntry: || country_wave:
estat icc
estimates store e0

mixed econ_impact income_c lrscale_c female age_c education i.residence || cntry: || country_wave:
estimates store e1

mixed econ_impact income_c lrscale_c female age_c education i.residence mipex_change_w fb_change_w || cntry: || country_wave:
estimates store e2

mixed econ_impact income_c lrscale_c female age_c education i.residence mipex_change_w fb_change_w mipex_fb_interaction || cntry: || country_wave:
margins, at(mipex_change_w=(-2 0 2) fb_change_w=(-2 0 2))
marginsplot
estimates store e3

mixed econ_impact income_c lrscale_c female age_c education i.residence mipex_change_w fb_change_w mipex_fb_interaction mipex_c fb_c || cntry: || country_wave:
estimates store e4

esttab e0 e1 e2 e3 e4 using "output/economic_threat_models.html", replace se star(* 0.05 ** 0.01 *** 0.001) label compress title("Multilevel Models Predicting Economic Impact of Immigration")
