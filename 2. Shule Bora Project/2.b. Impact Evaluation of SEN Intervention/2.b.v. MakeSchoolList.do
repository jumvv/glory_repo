** 230907
** Make a randomized school list

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
** Make a list of Treatment schools
*************************************

use "${PathDataIntermediate}\SenIeSchoolsRandomized.dta", clear

keep if Treatment == 1

local Identifiers Region Council Ward School RegNo
keep `Identifiers'
sort `Identifiers'
gen N = _n
order N `Identifiers'

export excel using "${PathDataFinal}\SenSchoolListV2024November.xlsx" ///
	, sheet( "Sheet1Data" ) firstrow( variables ) sheetmodify

timer off 1
timer list 1
//    1:      0.56 /        1 =       0.5630
*************************************
** Close workspace
*************************************
** log close
