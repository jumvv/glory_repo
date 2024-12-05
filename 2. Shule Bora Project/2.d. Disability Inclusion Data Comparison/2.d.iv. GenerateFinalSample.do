** 20231209
** GenerateFinalSample

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

** use "${PathDataIntermediate}\Globe_append.dta", clear
** append using "${PathDataIntermediate}\Africa_append.dta"
use "${PathDataIntermediate}\Globe_append_new.dta", clear
append using "${PathDataIntermediate}\Africa_append_new.dta"

append using "${PathDataIntermediate}\..\ShuleBoraCambEdBaseline\SB_Total_weighted.dta" 

merge m:1 country using "${PathDataIntermediate}\\Mics_population_clean.dta" ///
	, update

gen SbWeight = sbweight

*************************************
** Specify weighting
*************************************
** 1. Population representation
** SbWeight stays as SbWeight
** fsweight transformation to MicsWeight
** by country total( fsweight ) |> fsweightCountryTotal => how many children are representing all children in the country?
bys country: egen long fsweightCountryTotal = total( fsweight )
** UnWppCountryTotal => how many children are in the country?
gen UnWppTotal = total
** UnWppTotal / fsweightCountryTotal => multiplier we should apply to fsweight to generate MicsWeight 
gen MicsWeight = fsweight * UnWppTotal / fsweightCountryTotal
** If we do this, then when we total( MicsWeight ) we will get the number of total population represented
** Normalized population representation so that the total sums to 1 for each sample
** NormalizedSbWeight1 = SbWeight / total( SbWeight )
egen long SbWeightTotal = total( SbWeight )
gen double NormalizedSbWeight1 = SbWeight / SbWeightTotal
** NormalizedMicsWeight1 = MicsWeight / total( MicsWeight )
egen long MicsWeightTotal = total( MicsWeight )
gen double NormalizedMicsWeight1 = MicsWeight / MicsWeightTotal
** Will this lead to numbers that are too small?
** Normalize so that total sums to unweighted number of children surveyed
** NormalizedSbWeightN = SbWeight * SbN / total( SbWeight )
qui su SbWeight if country == "Tanzania"
gen SbN = r( N )
gen double NormalizedSbWeightN = SbWeight * SbN / SbWeightTotal
** SbN = 3,246 (children who took the survey)
** NormalizedMicsWeightN = fsweight
qui su MicsWeight 
gen MicsN = r( N )
gen double NormalizedMicsWeightN = MicsWeight * MicsN / MicsWeightTotal

** Generate weights based on above preparation
gen double WeightPop = SbWeight
replace WeightPop = MicsWeight if WeightPop == .

gen double Weight1 = NormalizedSbWeight1
replace Weight1 = NormalizedMicsWeight1 if Weight1 == .

gen double WeightN = NormalizedSbWeightN
replace WeightN = NormalizedMicsWeightN if WeightN == .

gen double WeightFs = NormalizedSbWeightN
replace WeightFs = fsweight if WeightFs == .

*************************************
** Specify clusters
*************************************
** Generate common cluster Id
gen ClusterNumber = hh1
gen int school_number = real( schoolID )
replace ClusterNumber = school_number if ClusterNumber == .
egen ClusterCommon = group( country ClusterNumber )

*************************************
** Specify strata
*************************************
** Generate common strata Id (StratumCommon & StratumCommon_robust)
egen TempStratumMics = group( country stratum ) //547,709
replace TempStratumMics =. if country == "Tanzania"

egen TempStratumSb = group( Region LocalityCommon SchoolType )

gen TempStratum = TempStratumMics // (92,646 missing values generated) 
replace TempStratum = TempStratumSb if TempStratum == .
egen StratumCommon = group( country TempStratum )

*************************************
** Define school enrollment
*************************************
*** cb3: Age of child
gen MicsAge6to13 = ( 6 <= cb3 & cb3 <= 13 )
replace MicsAge6to13 = . if missing( cb3 )

*** cb7: Attended school or early childhood programme during current school year 
gen MicsAttendedSchool =  ( cb7 == 1 )
replace MicsAttendedSchool = . if missing( cb7 )

*** cb8a: Level of education attended current school year
** gen MicsAttendedPrimary =  ( cb8a == 1 ) 
gen MicsAttendedPrimary =  ( cb8a == 1 ) & ( cb8a == 2 ) & ( cb8a == 3 ) & ( cb8a == 4 ) 
replace MicsAttendedPrimary = . if missing( cb8a )

*** cb8b:  Grade attended during current schoool year 
** gen MicsGrade1to7 =  ( 1 <= cb8b & cb8b <= 7 )
gen MicsGrade1to7 =  ( 1 <= cb8b & cb8b <= 14 )
replace MicsGrade1to7 = . if missing( cb8b )

gen MicsEnrolled = MicsAttendedPrimary == 1 | MicsGrade1to7 == 1
replace MicsEnrolled = . if missing( MicsAttendedPrimary ) & missing( MicsGrade1to7 )

drop if country != "Tanzania" & missing( fsweight )

** Check if any country is missing both cb8a and cb8b
gen MicsCountry = !missing( MicsWeight )
bys country: egen TotalMicsCountry = total( MicsCountry )

local Stub AttendedPrimary
gen MissingMics`Stub' = missing( Mics`Stub' )
bys country: egen TotalMissingMics`Stub' = total( MissingMics`Stub' )
gen AllMissingMics`Stub' = TotalMissingMics`Stub' == TotalMicsCountry

local Stub Grade1to7
gen MissingMics`Stub' = missing( Mics`Stub' )
bys country: egen TotalMissingMics`Stub' = total( MissingMics`Stub' )
gen AllMissingMics`Stub' = TotalMissingMics`Stub' == TotalMicsCountry

tab country AllMissingMicsGrade1to7 
tab country AllMissingMicsAttendedPrimary // Nepal missing  AllMissingMicsAttendedPrimary

*************************************
** Examine enrollment statistics
*************************************
*** cb7: Attended school or early childhood programme during current school year 
gen MicsEnrolledCb7 = cb7 == 1 // 
*** cb8a: Level of education attended current school year
*** cb8b:  Class attended during current schoool year 
gen MicsEnrolledCb8 = ( cb8a == 1 ) | ( 1 <= cb8b & cb8b <= 7 )

*** Examine enrollment by age group
**** Cb7
su MicsEnrolledCb7 [ aw = MicsWeight ] if ( 6 <= cb3 & cb3 <= 13 )

**** Cb8
su MicsEnrolledCb8 [ aw = MicsWeight ] if ( 6 <= cb3 & cb3 <= 13 )

**** Cb7
su MicsEnrolledCb7 [ aw = MicsWeight ] if ( 6 <= cb3 & cb3 <= 13 ) & region == "Africa"

**** Cb8
su MicsEnrolledCb8 [ aw = MicsWeight ] if ( 6 <= cb3 & cb3 <= 13 ) & region == "Africa"

*************************************
** Statiatical summaries
*************************************
*** Generate numerical covariates
gen Sb = region == "Tanzania" // for regression analysis later

replace LocalityCommon = "Urban" if country == "Argentina" // All of Argentina is urban
encode LocalityCommon, gen( nLocality )

replace GenderCommon = "" if GenderCommon == "."
encode GenderCommon, gen( nGender )

gen AgeCommonOriginal = AgeCommon
gen nAge = AgeCommon
replace nAge = . if AgeCommon == 99
replace AgeCommon = . if AgeCommon == 99

gen Gdppc = GDP 
replace Gdppc = 1326.62 if region == "Tanzania"
gen LogGdppc = log( Gdppc )

*************************************
** Population segments
*************************************
gen SbTanzania = 0
replace SbTanzania = 1 if Sb == 1
gen MicsSsa = 0
replace MicsSsa = 1 if ( region == "Africa" ) 
gen MicsWorld = 0
replace MicsWorld = 1 if ( region == "World" ) 
gen MicsSsaEnrolled = 0
replace MicsSsaEnrolled = 1 if ( region == "Africa" ) & ( MicsEnrolled == 1 )
gen MicsWorldEnrolled = 0
replace MicsWorldEnrolled = 1 if ( region == "World" ) & ( MicsEnrolled == 1 )

** Generate Africa so we can distinguish Africa within World
local Countries ///
	Central_African_Republic ///
	Chad ///
	Sierra_Leone ///
	Togo ///
	Ghana ///
	Sao_Tome_and_Principe ///
	DRCongo ///
	Guinea_Bissau ///
	Benin ///
	Nigeria ///
	Madagascar ///
	Malawi ///
	Eswatini ///
	The_Gambia ///
	Zimbabwe ///
	Lesotho
gen Africa = 0
foreach ss in `Countries' {
replace Africa = 1 if country == "`ss'"
}

*************************************
** Save data
*************************************

save "${PathDataFinal}\SbAndMicsCollatedV20240907.dta", replace

*************************************
** Close workspace
*************************************
timer off 1
timer list 1

** log close
*************************************
