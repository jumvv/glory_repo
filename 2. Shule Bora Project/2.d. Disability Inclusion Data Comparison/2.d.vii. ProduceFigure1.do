** 20231209
** ProduceFigure1

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
** Figure 1.
*************************************

** Specify AgeSegment
** local AgeSegment 1
local AgeSegment ( 6 <= nAge & nAge <= 13 ) //<----- CHANGE HERE

// ssc install blindschemes
set scheme plottig

*** I.1.1. CFM_Miss0
twoway ( ///
	kdensity CFM_Miss0 if region == "Tanzania" & `AgeSegment' [ weight = WeightPop ] ///
	, bwidth( 1 ) legend( label( 1 "SB Tanzania" ) ) ///
	) || ( ///
	kdensity CFM_Miss0 if region == "Africa" & `AgeSegment' [ weight = WeightPop ] ///
	, bwidth( 1 ) legend( label( 2 "MICS SSA" ) ) ///
	) || ( ///
	kdensity CFM_Miss0 if region == "World" & `AgeSegment' [ weight = WeightPop ] ///
	, bwidth( 1 ) legend( label( 3 "MICS World" ) ) ///
	) ///
	, ytitle( "Density" ) xtitle( "Disability score" )

graph export "${PathOverleafFigures}/Figure1.pdf", replace  //<----- CHANGE HERE

*************************************
** Close workspace
*************************************
timer off 1
timer list 1
//   1:     11.28 /        1 =      11.2790
** log close
*************************************

** ** Enrollment
** su MicsSsaEnrolled [ aw = WeightPop ] if MicsSsa & ( 6 <= nAge & nAge <= 13 )
** su MicsWorldEnrolled [ aw = WeightPop ] if MicsWorld & ( 6 <= nAge & nAge <= 13 )
