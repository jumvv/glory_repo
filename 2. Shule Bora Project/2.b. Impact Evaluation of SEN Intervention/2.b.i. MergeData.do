** 230907
** Merge Data

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

use "${PathDataIntermediate}\D2023PrimarySchoolsInclusion.dta", clear

merge m:1 Council using "${PathDataIntermediate}\D2024SbPlan.dta"

    ** Result                           # of obs.
    ** -----------------------------------------
    ** not matched                        13,466
        ** from master                    13,466  (_merge==1)
        ** from using                          0  (_merge==2)

    ** matched                             6,267  (_merge==3)
    ** -----------------------------------------

drop _merge

save "${PathDataIntermediate}\AscDataAndSbPlan.dta", replace

*************************************
** Merge the following 8 new government documents:
** Consolidated Primary Education Data (2024)
** Primary Dropouts by Grade and Sex (2023)
** Primary Enrolment by Age and Sex (2024)
** Primary Re-Enrolment by Grade and Sex (2024)
** Primary Repeaters by Grade and Sex (2024)
** Primary Transfers_In and Out (2023, 2024)
** (From Richard)
** Pupils with Disabilities in Primary Schools, 2024_2
** Dropouts in Primary Schools by Reasons, 2023
*************************************
use "${PathDataRaw}\Consolidated Primary Education Data, 2024.dta", clear

merge 1:1 Region Council Ward School using "${PathDataRaw}\Primary Dropouts by Grade and Sex, 2023.dta"

drop _merge

merge 1:1 Region Council Ward School using "${PathDataRaw}\Primary Enrolment by Age and Sex, 2024.dta"

drop _merge

merge 1:1 Region Council Ward School using "${PathDataRaw}\Primary Re-Enrolment by Grade and Sex, 2024.dta"

drop _merge

merge 1:1 Region Council Ward School using "${PathDataRaw}\Primary Repeaters by Grade and Sex, 2024.dta"

drop _merge

merge 1:1 Region Council Ward School using "${PathDataRaw}\Primary Transfers-In and Out, 2023,2024.dta"

drop _merge

merge 1:1 Region Council Ward School using "${PathDataRaw}\Pupils with Disabilities in Primary Schools, 2024_2.dta"

drop _merge

merge 1:1 Region Council Ward School using "${PathDataRaw}\Dropouts in Primary Schools by Reasons, 2023.dta"

rename _merge _mergeAsc2024

gen ShuleBoraRegion2024 = 0
replace ShuleBoraRegion2024 = 1 if Region == "Dodoma" ///
								| Region == "Tanga" ///
								| Region == "Pwani" ///
								| Region == "Rukwa" ///
								| Region == "Katavi" ///
								| Region == "Simiyu" ///
								| Region == "Kigoma" ///
								| Region == "Mara" ///
								| Region == "Singida"
tab ShuleBoraRegion2024 //6,558

save "${PathDataRaw}\merge_eight_documents", replace

*************************************
** Merge with D2024SbPlan
*************************************
use "${PathDataRaw}\merge_eight_documents", clear


merge m:1 Council using "${PathDataIntermediate}\D2024SbPlan.dta"

    ** Result                           # of obs.
    ** -----------------------------------------
    ** not matched                        13,975
    **    from master                     13,975  (_merge==1)
    **    from using                           0  (_merge==2)
    **
    ** matched                             6,558  (_merge==3)
    ** -----------------------------------------
	
tab _merge ShuleBoraRegion2024
/*
                      |  ShuleBoraRegion2024
               _merge |         0          1 |     Total
----------------------+----------------------+----------
      master only (1) |    13,975          0 |    13,975 
          matched (3) |         0      6,558 |     6,558 
----------------------+----------------------+----------
                Total |    13,975      6,558 |    20,533 
*/

rename _merge _mergeSbPlan2024

*************************************
** Merge with Primary Repeaters by Grade and Sex, 2023
*************************************
** merge 1:1 Region Council Ward School using "${PathDataRaw}\Primary Repeaters by Grade and Sex, 2023.dta"
    ** ** Result                           # of obs.
    ** ** -----------------------------------------
    ** ** not matched                         1,010
        ** ** from master                       905  (_merge==1)
        ** ** from using                        105  (_merge==2)

    ** ** matched                            19,628  (_merge==3)
    ** ** -----------------------------------------
** rename _merge _mergeAscRepeaters2023

merge 1:1 Region Council RegNo using "${PathDataRaw}\Primary Repeaters by Grade and Sex, 2023.dta"
    ** Result                           # of obs.
    ** -----------------------------------------
    ** not matched                           828
        ** from master                       814  (_merge==1)
        ** from using                         14  (_merge==2)

    ** matched                            19,719  (_merge==3)
    ** -----------------------------------------
rename _merge _mergeAscRepeaters2023

** => 89 schools changing Ward and SchoolName
compare School2023 School
compare Ward2023 Ward

*************************************
** Merge with D2023PrimarySchoolInclusion_renamed.dta
*************************************
merge 1:1 Region Council RegNo using "${PathDataIntermediate}\D2023PrimarySchoolsInclusion_renamed.dta"
    ** Result                           # of obs.
    ** -----------------------------------------
    ** not matched                           814
        ** from master                       814  (_merge==1)
        ** from using                          0  (_merge==2)

    ** matched                            19,733  (_merge==3)
    ** -----------------------------------------

tab _merge ShuleBoraRegion2024
/*
                      |  ShuleBoraRegion2024
               _merge |         0          1 |     Total
----------------------+----------------------+----------
      master only (1) |       521        292 |       813 
          matched (3) |    13,454      6,266 |    19,720 
----------------------+----------------------+----------
                Total |    13,975      6,558 |    20,533 
*/

rename _merge _mergeAsc2023

*************************************
** Merge with List of schools - SB sampling strategy.dta
*************************************

merge 1:1 Region Council RegNo using "${PathDataRaw}\List of schools - SB sampling strategy.dta"

    ** Result                           # of obs.
    ** -----------------------------------------
    ** not matched                         3,377
    **     from master                     3,371  (_merge==1)
    **     from using                          6  (_merge==2)

    ** matched                            17,175  (_merge==3)

replace Locality_2022 = "Rural" if Locality_2022 == "KIJIJINI"
replace Locality_2022 = "Urban" if Locality_2022 == "MJINI"

tab _merge ShuleBoraRegion2024

/*
                      |  ShuleBoraRegion2024
               _merge |         0          1 |     Total
----------------------+----------------------+----------
      master only (1) |     2,465        897 |     3,362 
          matched (3) |    11,510      5,661 |    17,171 
----------------------+----------------------+----------
                Total |    13,975      6,558 |    20,533 
*/


rename _merge _mergeSbSampling2022

tab ShuleBoraRegion2023 ShuleBoraRegion2024

/*
ShuleBoraR |  ShuleBoraRegion2024
 egion2023 |         0          1 |     Total
-----------+----------------------+----------
         0 |    13,454          0 |    13,454 
         1 |         0      6,266 |     6,266 
-----------+----------------------+----------
     Total |    13,454      6,266 |    19,720 
*/

tab Ownership_2023 Ownership_2024
/*
               |       Ownership
     Ownership | Governm..  Non-Gov.. |     Total
---------------+----------------------+----------
    Government |    17,459          0 |    17,459 
Non-Government |         6      2,255 |     2,261 
---------------+----------------------+----------
         Total |    17,465      2,255 |    19,720 
*/


gen ShuleBoraRegion = 0
replace ShuleBoraRegion = 1 if ShuleBoraRegion2023 == 1 ///
							| ShuleBoraRegion2024 == 1
							
tab ShuleBoraRegion

/*
ShuleBoraRe |
       gion |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     13,993       68.09       68.09
          1 |      6,559       31.91      100.00
------------+-----------------------------------
      Total |     20,552      100.00
*/

gen Ownership = ""
replace Ownership = "Government" if Ownership_2023 == "Government" ///
							| Ownership_2024 == "Government"						
replace Ownership = "Non-Government" if Ownership_2023 == "Non-Government" ///
							| Ownership_2024 == "Non-Government"

tab Ownership
/*
     Ownership |      Freq.     Percent        Cum.
---------------+-----------------------------------
    Government |     18,053       87.87       87.87
Non-Government |      2,493       12.13      100.00
---------------+-----------------------------------
         Total |     20,546      100.00
*/


save "${PathDataIntermediate}\Inclusion_Data_Merged_All_2024", replace

*************************************
** Subset SB regions
*************************************

use "${PathDataIntermediate}\Inclusion_Data_Merged_All_2024", clear


keep if Region == "Dodoma" ///
	| Region == "Tanga" ///
	| Region == "Pwani" ///
	| Region == "Rukwa" ///
	| Region == "Katavi" ///
	| Region == "Simiyu" ///
	| Region == "Kigoma" ///
	| Region == "Mara" ///
	| Region == "Singida"


save "${PathDataIntermediate}\Inclusion_Data_Merged_SB_2024", replace

timer off 1
timer list 1
//  1:     19.49 /        1 =      19.4880
*************************************
** Close workspace
*************************************
** log close
