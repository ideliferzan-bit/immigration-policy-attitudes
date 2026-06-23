* 03_calculate_fb_change_mipex.do
* Create the immigrant share change variable from cleaned MIPEX data.

cd ".."
set more off

use "data/raw/EuroData_MIPEX_clean.dta", clear

sort cntry essround
by cntry: gen fb_change = fb_share_pct - fb_share_pct[_n-1]
label variable fb_change "Change in immigrant share since previous ESS wave"

* Verify change values for one country example
list cntry essround fb_share_pct fb_change if cntry == "FR", sepby(cntry)

save "data/fb_change_MIPEX_clean.dta", replace

display "fb_change MIPEX file saved"
