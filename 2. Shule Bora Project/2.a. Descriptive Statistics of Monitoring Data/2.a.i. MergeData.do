** 240519
** Merge SB Monitoring Data with ASC/SB Baseline 

*********************
** Set up workspace**
*********************
version 14.1
clear all
set more off	

timer on 1

******************
**Input & Output**
******************
*Input: Tanzania Annual Census 2023: ASC_2023_merged_intermed.dta
*		SB_monitoring_safety_inclusion_HT.dta
*       SB_monitoring_TCPD_HT.dta

*Output: Monitoring_2023_HT_merged.dta


***********************************************************************************
** Import SB monitoring data and convert into .dta                               **
** 1. HT data on safety & inclusion (SB_monitoring_safety_inclusion_HT.dta)      **
** 2. HT data on TCPD (SB_monitoring_TCPD_HT.dta)                                **
***********************************************************************************
/*
import excel ///
	"${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Deidentified\Shule_Bora_School_Monitoring_Data_240312.xlsx" ///
	, sheet( "SB Monitoring Tool-Safetty&Incl" ) cellrange( A1:CQ3256 ) ///
	firstrow clear
save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Deidentified\SB_monitoring_safety_inclusion_HT.dta", replace
 
import excel ///
	"${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Deidentified\Shule_Bora_School_Monitoring_Data_240312.xlsx" ///
	, sheet( "SB Monitoring Tool-TCPD" ) cellrange( A1:BG3256 ) ///
	firstrow clear
save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Deidentified\SB_monitoring_TCPD_HT.dta", replace
*/

************************************************************
**Prepare merged ASC data to match with SB monitoring data**
************************************************************

	use "${shule_bora_DB}\Baseline\ASC_2023_merged_intermed.dta", clear
	drop _merge
	rename lga council

	decode region, gen(region_str)
	rename region region_num
	rename region_str region

	decode council, gen(council_str)
	rename council council_num
	rename council_str council

	decode ward, gen(ward_str)
	rename ward ward_num
	rename ward_str ward
	

	tempfile temp_file
	save "'temp_file'", replace

***************************************
**Merge safety/inclusion data for HTs**
***************************************

	use "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Deidentified\SB_monitoring_safety_inclusion_HT.dta", clear
	
	tab Whoisbeinginterviewed // HT/Teacher: 682, Pupil: 2,573

	rename (Region LGA Ward Nameofschool) (region council ward school)

	drop if Whoisbeinginterviewed == "Pupil"
	
	tab council

	**Harmonize matching observations
	
	replace ward = "Panzuo" if ward == "Kisegese" & school == "KIBESA" //Monitoring data might have the wrong ward. In process of confirming.
	replace ward = "Mipeko" if ward == "Mkuranga" & school == "KIBAMBA" //Monitoring data might have the wrong ward. In proess of confirming.

	gen school_locationasc = region + council + ward + school

	unique school_locationasc //uniuqe: 682, # of records: 682

	merge 1:1 region council ward school using "'temp_file'", assert(2 3) keep(3) nogen 
	 
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                               682  
    -----------------------------------------
*/
	export excel using "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_safety_ht.xlsx" ///
		,replace firstrow(variables)

	save "${Monitoring_dt}\Intermediate\Monitoring_2023_safety_inclusion_HT_merged.dta", replace
	save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_safety_inclusion_HT_merged.dta", replace



* Merge on 1000 Phase I PSSP schools (this is in ASC23_merged_allregions.dta file)
preserve 
	use "${shule_bora_DB}\Baseline\ASC23_merged_allregions.dta", clear 
	keep  region council ward school school_reg school_reg pssp_phase1

	tempfile ASC23_allreg
	save `ASC23_allreg', replace
restore 

	merge 1:1 region council ward school using `ASC23_allreg', assert(2 3) keep(3) nogen 
	/*
	Result                      Number of obs
    -----------------------------------------
    Not matched                             0
    Matched                               682  
    -----------------------------------------*/
	
/* Merge on 100 schools where CE did the GRM training (from Amani)

Original Excel from Amani here:
Dropbox\Tanzania Education - Shule Bora\Program Implementation\Shule Bora\Safe Schools\Documents_Amani_Sep2023 */

preserve 
	clear 
	import excel "${shule_bora_DB}\asc_and_merging\DataSets\Deidentified\100_SB_safety_schools.xls", firstrow
	rename Reg school_reg
	replace school_reg = stritrim(school_reg)
	
	gen sb_safety = 1 
	lab var sb_safety "Dummy for 100 SB schools where GRM training was implemented"
	
	tempfile 100schools
	save `100schools'
restore 

	
	/* FINIH THIS AFTER WE HAVE THE CORRECT FILE 
	merge 1:1 school_reg using `100schools' 
	
	FEW MERGE BC THE ALL_REGIONS FILE HAS SELECTED COUNCILS ONLY
	
	*/

	save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_safety_inclusion_HT_merged.dta", replace

***************************
**Merge TCPD data for HTs**
***************************

	use "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Deidentified\SB_monitoring_TCPD_HT.dta", clear
	
	tab Whoisbeinginterviewed // HT/Teacher: 682, Pupil: 2,573

	rename (Region LGA Ward Nameofschool) (region council ward school)

	drop if Whoisbeinginterviewed == "Pupil"

	**Harmonize matching observations

	replace ward = "Panzuo" if ward == "Kisegese" & school == "KIBESA" //Needs to confirm their ward.
	replace ward = "Mipeko" if ward == "Mkuranga" & school == "KIBAMBA" //Needs to confirm their ward.

	gen school_locationasc = region + council + ward + school

	unique school_locationasc //uniuqe: 682, # of records: 682

	merge 1:1 region council ward school using "'temp_file'", assert(2 3) keep(3) nogen 
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                               682  
    -----------------------------------------
*/
	export excel using "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_tcpd_ht.xlsx" ///
		,replace firstrow(variables)
		
	save "${Monitoring_dt}\Intermediate\Monitoring_2023_TCPD_HT_merged.dta", replace
	save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_TCPD_HT_merged.dta", replace
	
*************************************************
**Append Safety/Inclusion and TCPD data for HTs**
*************************************************
	use "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_TCPD_HT_merged.dta", clear
	merge 1:1 region council ward school using "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_safety_inclusion_HT_merged.dta", assert(2 3) keep(3) nogen 

	save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_HT_merged.dta", replace
	save "${Monitoring_dt}\Intermediate\Monitoring_2023_HT_merged.dta", replace

	unique school_locationasc //682
	

timer off 1
timer list 1
//     1:     13.91 /        1 =      13.9080

**********************************************
** Close workspace
**********************************************
** log close
