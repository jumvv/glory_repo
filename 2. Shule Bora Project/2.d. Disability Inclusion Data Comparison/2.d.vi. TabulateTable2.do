** 20231209
** TabulateTable2

*************************************
** Set up workspace
*************************************
version 14.1
clear all
set more off

*************************************
** Start work here
*************************************
timer on 1

use "${PathDataFinal}\SbAndMicsCollatedV20240907.dta", clear

*************************************
** Table 2.
*************************************

** Specify AgeSegment
** local AgeSegment 1
local AgeSegment ( 6 <= nAge & nAge <= 13 ) //<----- CHANGE HERE

svyset ClusterCommon [ pw = WeightPop ], strata( StratumCommon ) singleunit( centered )

** Z scores
su CFM_Miss0 if ( SbTanzania | MicsWorldEnrolled ) & `AgeSegment' [ aw = WeightPop ]
gen CFM_Miss0_Zscore = ( CFM_Miss0 - r(mean) ) / r(sd)

local PanelAVariables CFM_Miss0 CFM_Miss0_Zscore //<----- CHANGE HERE
local PanelARowNumber 8
local PanelBVariables NoDisability_Miss0 MildDisability_Miss0 ModerateDisability_Miss0 SevereDisability_Miss0 //<----- CHANGE HERE
local PanelBRowNumber 20
local PanelCVariables FunctionalDifficulty_5to17_Miss0 //<----- CHANGE HERE
local PanelCRowNumber 29

** Estimate columns (1) - (3)
foreach ss in PanelA PanelB PanelC {
	local TheseVariables ``ss'Variables'
	local ThisRowNumber = ``ss'RowNumber'
	local NextRowNumber = `ThisRowNumber' + 1
	foreach vv of var `TheseVariables' ///
		{
		su `vv' [ aw = WeightPop ] if SbTanzania & `AgeSegment'
		local B`ThisRowNumber' = r(mean) // e.g., B8
		local B`NextRowNumber' = r(sd) // e.g., B9
		
		su `vv' [ aw = WeightPop ] if MicsSsaEnrolled & `AgeSegment'
		local C`ThisRowNumber' = r(mean) // e.g., C8
		local C`NextRowNumber' = r(sd) // e.g., C9
		
		su `vv' [ aw = WeightPop ] if MicsWorldEnrolled & `AgeSegment'
		local D`ThisRowNumber' = r(mean) // e.g., D8
		local D`NextRowNumber' = r(sd) // e.g., D9
		
		** reg `vv' Sb ///
			** i.nLocality i.nGender i.nAge LogGdppc /// Controls
			** if ( SbTanzania | MicsSsaEnrolled ) & `AgeSegment' /// Sample cut
			** [ aw = WeightPop ], vce( cluster ClusterCommon )
		svy: reg `vv' Sb ///
			i.nLocality i.nGender i.nAge LogGdppc /// Controls
			if ( SbTanzania | MicsSsaEnrolled ) & `AgeSegment' //
		lincom Sb
		local E`ThisRowNumber' = r(estimate) // e.g., E8
		local E`NextRowNumber' = r(se) // e.g., E9
		** significance stars
		local pE`ThisRowNumber' = 2*ttail(r(df),abs((r(estimate)/r(se)))) // p value
		di `pE`ThisRowNumber''
		local F`ThisRowNumber' ""
		if ( 0.05 <= `pE`ThisRowNumber'' & `pE`ThisRowNumber'' < 0.1 ) {
			local F`ThisRowNumber' "*"
		} 
		if ( 0.01 <= `pE`ThisRowNumber'' & `pE`ThisRowNumber'' < 0.05 ) {
			local F`ThisRowNumber' "**"
		} 
		if ( `pE`ThisRowNumber'' < 0.01 ) {
			local F`ThisRowNumber' "***"
		} 
		** di "`F`ThisRowNumber''"
		local ThisRowNumber = `ThisRowNumber' + 2
		local NextRowNumber = `ThisRowNumber' + 1
	}
}

putexcel set "${PathHome}\Writeup\01_BaselineUnicef\Tables.xlsx" ///
	, sheet( Table2Data, replace ) modify // //<----- CHANGE HERE
** Write columns (1) - (3)
foreach ss in PanelA PanelB PanelC {
	local TheseVariables ``ss'Variables'
	local ThisRowNumber = ``ss'RowNumber'
	local NextRowNumber = `ThisRowNumber' + 1
	foreach vv of var `TheseVariables' ///
		{
		putexcel B`ThisRowNumber' = `B`ThisRowNumber'' // e.g., B8
		putexcel B`NextRowNumber' = `B`NextRowNumber'' // e.g., B9
		putexcel C`ThisRowNumber' = `C`ThisRowNumber'' // e.g., C8
		putexcel C`NextRowNumber' = `C`NextRowNumber'' // e.g., C9
		putexcel D`ThisRowNumber' = `D`ThisRowNumber'' // e.g., D8
		putexcel D`NextRowNumber' = `D`NextRowNumber'' // e.g., D9
		putexcel E`ThisRowNumber' = `E`ThisRowNumber'' // e.g., E8
		putexcel E`NextRowNumber' = `E`NextRowNumber'' // e.g., E9
		putexcel F`ThisRowNumber' = "`F`ThisRowNumber''" // e.g., F8
		local ThisRowNumber = `ThisRowNumber' + 2
		local NextRowNumber = `ThisRowNumber' + 1
	}
}

svy: ologit CFM_Miss0 Sb if ( SbTanzania | MicsSsaEnrolled ) & `AgeSegment'

matrix V = get( VCE )
scalar v = el(V,1,1)
scalar coef = 0.6453 // See: https://www.fharrell.com/post/powilcoxon/
scalar c = (exp(coef*_b[Sb])/(1+exp(coef*_b[Sb])))
scalar cp = (coef*exp(coef*_b[Sb]))/(1+exp(coef*_b[Sb]))^2
scalar c_se = sqrt(cp*v*cp)

local ThisRowNumber = 13
local NextRowNumber = `ThisRowNumber' + 1
local E`ThisRowNumber' = c // e.g., E8
local E`NextRowNumber' = c_se // e.g., E9
** significance stars
local pE`ThisRowNumber' = 2*(1-normal(abs((c-0.5)/c_se))) // p value
di `pE`ThisRowNumber''
local F`ThisRowNumber' ""
if ( 0.05 <= `pE`ThisRowNumber'' & `pE`ThisRowNumber'' < 0.1 ) {
	local F`ThisRowNumber' "*"
} 
if ( 0.01 <= `pE`ThisRowNumber'' & `pE`ThisRowNumber'' < 0.05 ) {
	local F`ThisRowNumber' "**"
} 
if ( `pE`ThisRowNumber'' < 0.01 ) {
	local F`ThisRowNumber' "***"
} 
putexcel E`ThisRowNumber' = `E`ThisRowNumber''
putexcel E`NextRowNumber' = `E`NextRowNumber''
putexcel F`ThisRowNumber' = "`F`ThisRowNumber''"

local NextNextRowNumber = `NextRowNumber' + 1
local E`NextNextRowNumber' = c + c_se*invnormal(0.025) // LOWER CI
local F`NextNextRowNumber' = c + c_se*invnormal(0.975) // UPPER CI
putexcel E`NextNextRowNumber' = `E`NextNextRowNumber''
putexcel F`NextNextRowNumber' = `F`NextNextRowNumber''

** With controls
** ologit CFM_Miss0 Sb nLocality nGender nAge LogGdppc [ pw = WeightPop ] if ( SbTanzania | MicsSsaEnrolled ) & `AgeSegment', vce( cluster ClusterCommon )
svy: ologit CFM_Miss0 Sb nLocality nGender nAge LogGdppc if ( SbTanzania | MicsSsaEnrolled ) & `AgeSegment'

matrix V = get( VCE )
scalar v = el(V,1,1)
scalar coef = 0.6453 // See: https://www.fharrell.com/post/powilcoxon/
scalar c = (exp(coef*_b[Sb])/(1+exp(coef*_b[Sb])))
scalar cp = (coef*exp(coef*_b[Sb]))/(1+exp(coef*_b[Sb]))^2
scalar c_se = sqrt(cp*v*cp)

local ThisRowNumber = 16
local NextRowNumber = `ThisRowNumber' + 1
local E`ThisRowNumber' = c // e.g., E8
local E`NextRowNumber' = c_se // e.g., E9
** significance stars
local pE`ThisRowNumber' = 2*(1-normal(abs((c-0.5)/c_se))) // p value
di `pE`ThisRowNumber''
local F`ThisRowNumber' ""
if ( 0.05 <= `pE`ThisRowNumber'' & `pE`ThisRowNumber'' < 0.1 ) {
	local F`ThisRowNumber' "*"
} 
if ( 0.01 <= `pE`ThisRowNumber'' & `pE`ThisRowNumber'' < 0.05 ) {
	local F`ThisRowNumber' "**"
} 
if ( `pE`ThisRowNumber'' < 0.01 ) {
	local F`ThisRowNumber' "***"
} 
putexcel E`ThisRowNumber' = `E`ThisRowNumber''
putexcel E`NextRowNumber' = `E`NextRowNumber''
putexcel F`ThisRowNumber' = "`F`ThisRowNumber''"

local NextNextRowNumber = `NextRowNumber' + 1
local E`NextNextRowNumber' = c + c_se*invnormal(0.025) // LOWER CI
local F`NextNextRowNumber' = c + c_se*invnormal(0.975) // UPPER CI
putexcel E`NextNextRowNumber' = `E`NextNextRowNumber''
putexcel F`NextNextRowNumber' = `F`NextNextRowNumber''

*************************************
** Close workspace
*************************************
timer off 1
timer list 1
//   1:     96.28 /        1 =      96.2780
** log close
*************************************
