global main "/Volumes/GoogleDrive/Shared drives/Senior Thesis (Aarushi)/DataWork/"
global rawdata "$main/RawData"
global datashridpop "$rawdata/shrug_pc01.dta"
global datashridrural "$rawdata/shrug_pc01r_key.dta"
global datashriddistrict "$rawdata/shrug_pc01_district_key.dta"
global crime2001to2012 "$rawdata/2001-2012.xls"
global crime2013 "$rawdata/2013.xls"

/*
use "$datashridpop", clear

duplicates report shrid

preserve

use "$datashriddistrict", clear
duplicates report shrid

restore

preserve

use "$datashridrural", clear
duplicates report shrid

restore

*/


use "$datashriddistrict", clear
keep if inlist(pc01_state_name, "chattisgarh", "madhya pradesh", "gujarat", "maharashtra", "orissa", "rajasthan" )

merge 1:1 shrid using "$datashridpop"

//Gretchen
replace mergepop = _merge
tab pc01_state_name mergepop, miss

keep if mergepop==3


* create district-level portion of villages with population above 1000

* Percentage villages with population greater than 1000 (distpctvgt1000)
//Gretchen
gen indic = 1
//replace indic =1
//Gretchen
//gen popgt1000 = pc01_pca_tot_p >=1000
replace popgt1000 = pc01_pca_tot_p >=1000
bysort pc01_district_id: egen distnumgt1000 = total(popgt1000)
bysort pc01_district_id: egen distnum       = total(indic)
gen distpctvgt1000 = (distnumgt1000 / distnum)*100

* Proportion of people who live in villages with population greater than 1000
bysort pc01_district_id: egen distpop = total(pc01_pca_tot_p)
bysort pc01_district_id: egen distpopgt1000 =  total(pc01_pca_tot_p*(popgt1000==1))
gen distpctpgt1000 =(distpopgt1000/distpop) *100

preserve

* Making treatment visual plots
save "$subpc01.dta", replace
keep pc01_state_name pc01_district_name distpctpgt1000 distpctvgt1000 
rename pc01_district_name district
rename pc01_state_name stateut
keep if inlist(stateut, "madhya pradesh")
duplicates drop
save "$subpc01.dta", replace

preserve

graph bar (asis) distpctpgt1000, over(pc01_district_name)
restore

* Making outcome variable visual plots
clear
import excel "$crime2013", firstrow clear
gen district = lower(DISTRICT)
gen stateut = lower(STATEUT)
preserve
	* Making the bar graph
	keep if inlist(stateut, "madhya pradesh") & district != "zz total"
	graph hbar (asis) TOTALIPCCRIMES, over(DISTRICT, label(labsize(vsmall)))

restore
keep if inlist(stateut, "madhya pradesh") & district != "zz total"
keep stateut TOTALIPCCRIMES district
merge 1:1 district using "$subpc01.dta"
replace mergedistrict = _merge

keep if mergedistrict == 3
sort distpctpgt1000
line TOTALIPCCRIMES distpctpgt1000, xtitle("Treatment of Roads") ///
ytitle("Total IPC Crimes") title("Madhya Pradesh")

* Gujarat
use "$datashriddistrict", clear
keep pc01_state_name pc01_district_name distpctpgt1000 distpctvgt1000 
rename pc01_district_name district
rename pc01_state_name stateut
keep if inlist(stateut, "gujarat")
duplicates drop
save "$subGUJ.dta", replace
import excel "$crime2013", firstrow clear
gen district = lower(DISTRICT)
gen stateut = lower(STATEUT)
keep if inlist(stateut, "gujarat") & district != "zz total"
keep stateut TOTALIPCCRIMES district
merge 1:1 district using "$subGUJ.dta", gen(mergedistrict)

keep if mergedistrict == 3
sort distpctpgt1000
line TOTALIPCCRIMES distpctpgt1000, xtitle("Treatment of Roads") ///
ytitle("Total IPC Crimes") title("Gujarat")

* Maharashtra
use "$datashriddistrict", clear
keep pc01_state_name pc01_district_name distpctpgt1000 distpctvgt1000 
rename pc01_district_name district
rename pc01_state_name stateut
keep if inlist(stateut, "maharashtra")
duplicates drop
save "$subMH.dta", replace
import excel "$crime2013", firstrow clear
gen district = lower(DISTRICT)
gen stateut = lower(STATEUT)
keep if inlist(stateut, "maharashtra") & district != "zz total"
keep stateut TOTALIPCCRIMES district
merge 1:1 district using "$subMH.dta", gen(mergedistrict)

keep if mergedistrict == 3
sort distpctpgt1000
line TOTALIPCCRIMES distpctpgt1000, xtitle("Treatment of Roads") ///
ytitle("Total IPC Crimes") title("Maharashtra")

* Orissa
use "$datashriddistrict", clear
keep pc01_state_name pc01_district_name distpctpgt1000 distpctvgt1000 
rename pc01_district_name district
rename pc01_state_name stateut
keep if inlist(stateut, "orissa")
duplicates drop
save "$subORS.dta", replace
import excel "$crime2013", firstrow clear
gen district = lower(DISTRICT)
gen stateut = lower(STATEUT)
replace stateut = "orissa" if stateut == "odisha"
keep if inlist(stateut, "odisha") & district != "zz total"
keep stateut TOTALIPCCRIMES district
merge 1:1 district using "$subORS.dta", gen(mergedistrict)

keep if mergedistrict == 3
sort distpctpgt1000
line TOTALIPCCRIMES distpctpgt1000, xtitle("Treatment of Roads") ///
ytitle("Total IPC Crimes") title("Orissa")

* Rajasthan
use "$datashriddistrict", clear
keep pc01_state_name pc01_district_name distpctpgt1000 distpctvgt1000 
rename pc01_district_name district
rename pc01_state_name stateut
keep if inlist(stateut, "rajasthan")
duplicates drop
save "$subRJ.dta", replace
import excel "$crime2013", firstrow clear
gen district = lower(DISTRICT)
gen stateut = lower(STATEUT)
keep if inlist(stateut, "rajasthan") & district != "zz total"
keep stateut TOTALIPCCRIMES district
merge 1:1 district using "$subRJ.dta", gen(mergedistrict)

keep if mergedistrict == 3
sort distpctpgt1000
line TOTALIPCCRIMES distpctpgt1000, xtitle("Treatment of Roads") ///
ytitle("Total IPC Crimes") title("Rajasthan")

