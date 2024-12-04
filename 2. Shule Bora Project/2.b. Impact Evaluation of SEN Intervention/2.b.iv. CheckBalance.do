** 230907
** Check Balance

*************************************
** Set up workspace
*************************************
version 14.1
clear all
set more off
cd "${PathHome}"
** log using C001ImportRaw.do, text replace
timer on 1

*************************************
** Merge SbPlan into AscData
*************************************

use "${PathDataIntermediate}\SenIeSchoolsRandomized.dta", clear

keep if InclusionIe == 1

*** Identify this table
local tn = string( 1, "%02.0f" )
local tname "T`tn'_balance_V20241028"
local out_table = 1
local block LgaBlock

set more off

** Set up empty matrix for recording sumstats;
cap matrix drop T
cap drop varnames
cap drop varlabs
set matsize 7000
mat T = J( 300, 30, . )

** A. Basic school-level demographics
** School size (number of students)
** Promotion rate
** Dropout rate
** Repeat rate
** Reenrollment rate

** B. SEN identification and inclusion outcomes
** Total number of identified children with disability
** Proportion of children with disability
** Proportion with physical disability
** Proportion with vision disability
** Proportion with hearing disability
** Proportion with intellectual disability
** Proportion with autism
** Proportion with albinism
** Proportion with multiple disabilities
** Reenrollment rate because of disability
** Repeat rate because of disability
** Dropout rate because of truancy
** Dropout rate because of "unfriendly learning environment at school"

local vars ///
	SchoolSizeAsc2024 ///
	PromotionRateAsc2024 DropoutRateAsc2024 RepeatRateAsc2024 ReenrollmentRateAsc2024 ///
	NDisability2024 PropDisability2024 ///
	PropPhysical2024 PropVision2024 PropHearing2024 ///
	PropIntellectual2024 PropAutism2024 PropAlbinism2024 PropMultiple2024 ///	
	AbsenteeismDropoutrateAsc2024

** Write a loop to write coefs for Control mean and T-C
gen varnames="" // these are meant for writestar
gen varlabs="" // these are meant for writestar

*** ******** these are for writestar don't delete ***
local row=1
local col=-1
local coefs=0
local rowgap=2
local colgap=2
*** ******** these are for writestar don't delete ***

foreach i of varlist `vars' {
	
	*** this is where columns begin for recording coefficients
	local col = -1
	
	** Control Mean: 
	su `i' if Treatment == 1
	local col= `col'+`colgap'		
	cap mat T[`row',`col']=r(mean)
	cap mat T[`row'+1,`col']=r(sd)
	** cap mat T[`row'+2,`col']=r(N)
	
	** All first stage
	local reg areg `i' Treatment, absorb( `block' ) vce( ols )
	di "`reg'"
	`reg'
	
	local col= `col'+`colgap'
	cap mat T[`row',`col']=_b[Treatment]
	cap mat T[`row'+1,`col']=_se[Treatment]
	** cap mat T[`row'+2,`col']=e(N)
		
	** N
	count
	local col = `col'+`colgap'
	cap mat T[`row',`col']=e(N)
	cap mat T[`row'+1,`col']=1-e(N)/r(N)
	** cap mat T[`row'+2,`col']=e(N)
	
	** Make rowlabels
	qui replace varnames = "`i'" in `row' // varname = "Z#"
	local varlab: variable label `i' // e.g. "(baseline) area planted"
	qui replace varlabs = "`varlab'" in `row'
	
	** debugging
	di "`i'"
	
	** this is for writestar don't delete
	local row = `row'+`rowgap'
	local coefs = `coefs'+1

}
writestar, table(T) columns(1(`colgap')`col') coefs(`coefs') rowgap(`rowgap') ///
	outsheet("${PathHome}/Codes/InclusionIe2024/`tname'") ///
	starcols( 0 1 0 ) ///
	formats( "%10.6f %10.6f %9.3g" )
** writestar, table(T) columns(1(`colgap')`col') coefs(`coefs') rowgap(`rowgap') ///
	** outsheet("C:/Users/samue/OneDrive/Desktop/`tname'") ///
	** starcols( 0 1 0 ) ///
	** formats( "%10.6f %10.6f %9.3g" )

timer off 1
timer list 1
//  1:     19.49 /        1 =      19.4880
*************************************
** Close workspace
*************************************
** log close
