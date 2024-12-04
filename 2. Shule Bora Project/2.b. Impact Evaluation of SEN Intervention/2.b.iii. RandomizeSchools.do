** 20241028
** Randomize schools

*************************************
** Set up workspace
*************************************
version 14.1
clear all
set more off
cd "${PathHome}"
** log using C001ImportRaw.do, text replace
timer on 1

use "${PathDataIntermediate}\SbSchoolsAndLgaBudget2024", clear

*************************************
** Randomize
*************************************
set seed 20241028

** Placeholder variables
gen PreviousRandom = 0
gen PreviousRandomRankInLga = 0
gen PreviousTreatment = 0

** Perform the loop below while Balanced condition not met
local Balanced = 0
local LoopCount = 0
while ( `Balanced' == 0 ) {

	local LoopCount = `LoopCount' + 1
	di "--------------------------------------------------"
	di "------------------ LoopCount: `LoopCount' ------------------"
	di "--------------------------------------------------"
	
	gen Random = runiform()
	bys Region Council ( Random ) : gen RandomRankInLga = _n
	gen Treatment = RandomRankInLga <= NSchoolsTargeted

	** Specify list of variables to be Balanced
	local vars ///
	NDisability2024 PropDisability2024 ///
	PropPhysical2024 PropVision2024 PropHearing2024 ///
	PropIntellectual2024 PropAutism2024 PropAlbinism2024 PropMultiple2024 ///	
	AbsenteeismDropoutrateAsc2024

	** Check if any of the p-value is significant
	local SignificanceCount = 0
	foreach v of varlist `vars' {
		** Run regression
		local Regression areg `v' Treatment if InclusionIe == 1, absorb( LgaBlock ) vce( ols )
		di "`Regression'"
		`Regression'
		** Calculate p value
		local pValue = 2*ttail( e(df_r), abs( _b[Treatment]/_se[Treatment] ) )
		di `pValue'
		** Check if significant
		if ( `pValue' < 0.05 ) {
			local SignificanceCount = `SignificanceCount' + 1
		}
	}
	
	if ( `SignificanceCount' == 0 ) {
		local Balanced = 1
	}
	
	** Store the most recent randomization outcomes in memory
	replace PreviousRandom = Random
	replace PreviousRandomRankInLga = RandomRankInLga
	replace PreviousTreatment = Treatment	
	drop Random RandomRankInLga Treatment
}

di "--------------------------------------------------"
di "------------------ FinalCount: `LoopCount' ------------------"
di "--------------------------------------------------"

** Retrieve the stored randomization outcomes with balanced condition met
gen Random = PreviousRandom
gen RandomRankInLga = PreviousRandomRankInLga 
gen Treatment = PreviousTreatment
drop PreviousRandom PreviousRandomRankInLga PreviousTreatment

save "${PathDataIntermediate}\SenIeSchoolsRandomized.dta", replace

timer off 1
timer list 1
//  1:     19.49 /        1 =      19.4880
*************************************
** Close workspace
*************************************
** log close
