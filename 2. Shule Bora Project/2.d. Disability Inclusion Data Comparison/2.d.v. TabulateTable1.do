** 20231209
** TabulateTable1

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
** Table 1. Panel A.
*************************************

** Number of children ccovered
count if SbTanzania == 1
local D8 = r(N)
count if MicsSsa == 1
local D9 = r(N)
count if MicsWorld == 1
local D10 = r(N)

**  # of survey clusters
unique( ClusterCommon ) if SbTanzania == 1
local E8 = r(unique)
unique( ClusterCommon ) if MicsSsa == 1
local E9 = r(unique)
unique( ClusterCommon ) if MicsWorld == 1
local E10 = r(unique)

**  # of countries
unique( country ) if SbTanzania == 1
local F8 = r(unique)
unique( country ) if MicsSsa == 1
local F9 = r(unique)
unique( country ) if MicsWorld == 1
local F10 = r(unique)

** population represented
su SbTanzania [ aw = WeightPop ] if SbTanzania == 1
local G8 = round( r(sum_w) )
su MicsSsa [ aw = WeightPop ] if MicsSsa == 1
local G9 = round( r(sum_w) )
su MicsWorld [ aw = WeightPop ] if MicsWorld == 1
local G10 = round( r(sum_w) )

** ages
su AgeCommon [ aw = WeightPop ] if SbTanzania == 1
local H8 = r(mean)
su AgeCommon [ aw = WeightPop ] if MicsSsa == 1
local H9 = r(mean)
su AgeCommon [ aw = WeightPop ] if MicsWorld == 1
local H10 = r(mean)


*************************************
** Table 1. Panel B. Age restricted
*************************************

local AgeSegment ( 6 <= nAge & nAge <= 13 )

** Number of children ccovered
count if SbTanzania == 1 & `AgeSegment'
local D13 = r(N)
count if MicsSsa == 1 & `AgeSegment'
local D14 = r(N)
count if MicsWorld == 1 & `AgeSegment'
local D15 = r(N)

**  # of survey clusters
unique( ClusterCommon ) if SbTanzania == 1 & `AgeSegment'
local E13 = r(unique)
unique( ClusterCommon ) if MicsSsa == 1 & `AgeSegment'
local E14 = r(unique)
unique( ClusterCommon ) if MicsWorld == 1 & `AgeSegment'
local E15 = r(unique)

**  # of countries
unique( country ) if SbTanzania == 1 & `AgeSegment'
local F13 = r(unique)
unique( country ) if MicsSsa == 1 & `AgeSegment'
local F14 = r(unique)
unique( country ) if MicsWorld == 1 & `AgeSegment'
local F15 = r(unique)

** population represented
su SbTanzania [ aw = WeightPop ] if SbTanzania == 1 & `AgeSegment'
local G13 = round( r(sum_w) )
su MicsSsa [ aw = WeightPop ] if MicsSsa == 1 & `AgeSegment'
local G14 = round( r(sum_w) )
su MicsWorld [ aw = WeightPop ] if MicsWorld == 1 & `AgeSegment'
local G15 = round( r(sum_w) )

** ages
su AgeCommon [ aw = WeightPop ] if SbTanzania == 1 & `AgeSegment'
local H13 = r(mean)
su AgeCommon [ aw = WeightPop ] if MicsSsa == 1 & `AgeSegment'
local H14 = r(mean)
su AgeCommon [ aw = WeightPop ] if MicsWorld == 1 & `AgeSegment'
local H15 = r(mean)


*************************************
** Export
*************************************

putexcel set "${PathHome}\Writeup\01_BaselineUnicef\Tables.xlsx" ///
	, sheet( Table1Data, replace ) modify
	
** Panel A.
putexcel D8 = `D8'
putexcel D9 = `D9'
putexcel D10 = `D10'
putexcel E8 = `E8'
putexcel E9 = `E9'
putexcel E10 = `E10'
putexcel F8 = `F8'
putexcel F9 = `F9'
putexcel F10 = `F10'
putexcel G8 = `G8'
putexcel G9 = `G9'
putexcel G10 = `G10'
putexcel H8 = `H8'
putexcel H9 = `H9'
putexcel H10 = `H10'

** Panel B.
putexcel D13 = `D13'
putexcel D14 = `D14'
putexcel D15 = `D15'
putexcel E13 = `E13'
putexcel E14 = `E14'
putexcel E15 = `E15'
putexcel F13 = `F13'
putexcel F14 = `F14'
putexcel F15 = `F15'
putexcel G13 = `G13'
putexcel G14 = `G14'
putexcel G15 = `G15'
putexcel H13 = `H13'
putexcel H14 = `H14'
putexcel H15 = `H15'


*************************************
** Close workspace
*************************************
timer off 1
timer list 1
//     1:      13.29 /        1 =       13.29
** log close
*************************************

