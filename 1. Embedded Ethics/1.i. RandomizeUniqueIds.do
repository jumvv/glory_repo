** 221001 
** Randomize students and make UniqueId

*************************************
** Set up workspace
*************************************
version 14.1
clear all
set more off
cd "${PathHome}"

*************************************
** Start work here
*************************************
timer on 1

use "${PathDataIntermediate}\AgsStudentList.dta"

/******* Sort *******/
** Set parameters: we need to sort by SortGroups ( SortNames )
local SortGroups Form Combination
local SortNames StudentName
isid `SortGroups' `SortNames' // Ensure uniqueness of sort
sort `SortGroups' `SortNames'

/******* Randomize into three InterventionGroups *******/
** Segment by Form and Combination
** (Randomize*2 so "NotEven remainders" also gets randomly assigned)
set seed 22100401
gen Random1 = runiform()
set seed 22100402
gen Random2 = runiform()
bys `SortGroups' ( Random1 ): gen n_SortGroup = _n
bys `SortGroups' ( Random1 ): gen N_SortGroup = _N
** Modulus 10 the student number in each group
gen n_Mod10 = mod( n_SortGroup, 10 )
** Identify NotEven10 remainders
gen N_Even10 = floor( N_SortGroup / 10 ) * 10 // for example, if 28 students, then this creates 20
gen NotEven10 = n_SortGroup > N_Even10 // this identifies the last 8 students
** Identify NotEven10NotEven3 remainders
bys `SortGroups' NotEven10: gen N_NotEven10NotEven3 = _N // this generates 8 for last 8 students (generates 20 for other students)
gen N_NotEven10Even3 = floor( N_NotEven10NotEven3 / 3 ) * 3 // this assigns 6 to all of the last 8 students
gen NotEven10NotEven3 = max( n_Mod10 - N_NotEven10Even3, 0 ) > 0 // this assigns 1 to students whose number modulus 10 is greater than 8 (e.g., 7 - 6 = 1 > 0 and 8 - 6 = 2 > 0)
** InterventionGroup
gen InterventionGroup = mod( n_Mod10, 3 )
replace InterventionGroup = 0 if NotEven10NotEven3 == 1
replace InterventionGroup = 1 if ( 1/3 < 0.3 ) & ( Random2 <= 0.6 ) & NotEven10NotEven3 == 1 // technically, this line is a mistake, the first parentheses should say ( 0.3 < Random2 )
replace InterventionGroup = 2 if ( Random2 <= 0.3 )& NotEven10NotEven3 == 1
gen Sn = InterventionGroup == 1
gen Ae = InterventionGroup == 2
drop n_SortGroup N_SortGroup

/*******  Randomize into eight SurveyVersionGroups *******/
** Randomize into Proposers/Responders etc.
** Segment by Form and InterventionGroup
local SortGroups Form InterventionGroup
local SortNames StudentName
isid `SortGroups' `SortNames' // Ensure uniqueness of sort
sort `SortGroups' `SortNames'
set seed 22100403
gen Random3 = runiform()
bys `SortGroups' ( Random3 ): gen n_SortGroup = _n
bys `SortGroups' ( Random3 ): gen N_SortGroup = _N
gen SurveyVersionGroup = 1
gen SurveyVersionLabel = "RTPA"
tokenize RTPA RTPR RTRA RTRR SHPA SHPR SHRA SHRR
foreach nn of num 2 / 8 {	
	local LowerBound N_SortGroup*( ( `nn' - 1 ) / 8 )
	local UpperBound N_SortGroup*( `nn'/8 )
	replace SurveyVersionGroup = `nn' ///
		if ( `LowerBound' < n_SortGroup ) & ( n_SortGroup <= `UpperBound' )
	replace SurveyVersionLabel = "``nn''" ///
		if ( `LowerBound' < n_SortGroup ) & ( n_SortGroup <= `UpperBound' )
}
** Road vs. Tree framing
gen RoadVsTree = SurveyVersionGroup <= 4
** Proposer or Responder
gen role = 1
replace role = 2 ///
	if SurveyVersionGroup == 1 ///
	| SurveyVersionGroup == 2 ///
	| SurveyVersionGroup == 5 ///
	| SurveyVersionGroup == 6 
** Rejection Framing
gen RejectionFraming = 0
replace RejectionFraming = 1 ///
	if SurveyVersionGroup == 2 ///
	| SurveyVersionGroup == 4 ///
	| SurveyVersionGroup == 6 ///
	| SurveyVersionGroup == 8 
drop N_SortGroup n_SortGroup

/******* Generate UniqueId *******/
** Set parameters: we need to sort by SortGroups ( SortNames )
local SortGroups Form InterventionGroup role
local SortNames StudentName
** How many total digits should there be?
local NDigits = ceil( log10( _N ) ) + 1
di `NDigits'
isid `SortGroups' `SortNames' // Ensure uniqueness of sort
sort `SortGroups' `SortNames'
egen SortGroups = concat( `SortGroups' ), decode
** Generate UniqueId
set seed 22100404
gen Random4 = runiform()
bys `SortGroups' ( Random4 ): gen n_SortGroup = _n
gen UniqueId = string( Form ) ///
	+ string( InterventionGroup ) + string( role  ) ///
	+ string( n_SortGroup, `"%0`NDigits'.0f"' ) //"
destring UniqueId, replace
order UniqueId

drop Random1 Random2 n_Mod10 N_Even10 NotEven10 N_NotEven10NotEven3 N_NotEven10Even3 NotEven10NotEven3 Random3 SortGroups Random4

/******* Save Data *******/
save "${PathDataIntermediate}\BaselineUids.dta", replace 

local VariableList Form SurveyVersionGroup SurveyVersionLabel StudentName UniqueId
order `VariableList'
sort `VariableList'

export excel using "${PathDataOut}\BaselineSurveyVersionGroups.xlsx" ///
	, firstrow( variables ) replace

timer off 1
timer list 1
//     1:      4.03 /        1 =       4.0290
*************************************
** Close workspace
*************************************
** log close
