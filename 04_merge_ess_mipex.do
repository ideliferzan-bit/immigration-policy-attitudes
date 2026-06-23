* 04_merge_ess_mipex.do
* Merge ESS data with MIPEX country-wave data and validate the merge.

cd ".."
set more off

use "data/ESS7-11_clean.dta", clear
merge m:1 cntry essround using "data/fb_change_MIPEX_clean.dta"

* Confirm that every case matched successfully
tab _merge
assert _merge == 3

drop _merge

* Validate that contextual variables are constant within each country-wave
bys cntry essround: egen mipex_sd = sd(mipex_score)
summ mipex_sd
bys cntry essround: egen sd_imm = sd(fb_share_pct)
summ sd_imm

drop mipex_sd sd_imm

compress
order cntry essround idno
save "data/locked_final.dta", replace

display "ESS and MIPEX merged final dataset saved"
