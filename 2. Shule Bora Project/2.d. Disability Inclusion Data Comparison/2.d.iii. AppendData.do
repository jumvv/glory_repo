** 20231209
** Append UNICEF MICS data (by SSA and World)

*************************************
** Set up workspace
*************************************
version 14.1
clear all
set more off
cd ${PathHome}
*************************************
** Start work here
*************************************
timer on 1

*************************************
** Append 16 countries for SSA (sub-Saharan Africa)
*************************************

local SSA ///
	Malawi ///
	Ghana ///
	Zimbabwe ///
	Lesotho ///
	Madagascar ///
	Nigeria ///
	Sao_Tome_and_Principe ///
	Central_African_Republic ///
	Guinea_Bissau ///
	Togo ///
	Chad ///
	Sierra_Leone ///
	The_Gambia ///
	DRCongo ///
	Benin ///
	Eswatini
	
foreach c in `SSA' {
	append using "${PathDataIntermediate}\\UNICEF_Cfm_`c'.dta", force
}


save "${PathDataIntermediate}\\Africa_cfm.dta", replace


*************************************
** Append Globe
*************************************
clear all
*************************************
** ME (Middle East)
** & ECA (Europe and Central Asia)
** & LAC (Latin America and Carribean)
** & SA (South Asia)
** & EAP (East Asian and Pacific)

*************************************
local Globe ///
	Algeria ///
	Tunisia ///
	Malawi ///
	Ghana ///
	Zimbabwe ///
	Lesotho ///
	Madagascar ///
	Nigeria ///
	Sao_Tome_and_Principe ///
	Central_African_Republic ///
	Guinea_Bissau ///
	Togo ///
	Chad ///
	Sierra_Leone ///
	The_Gambia ///
	DRCongo ///
	State_of_Palestine ///
	Iraq ///
	Uzbekistan /// 
	Kosovo ///
	Belarus ///
	Serbia /// 
	Turkmenistan ///
	Republic_of_North_Macedonia ///
	Georgia ///
	Kyrgyzstan ///
	Montenegro /// 
	Argentina ///
	Guyana ///
	Cuba ///
	Dominican_Republic ///
	Honduras ///
	Costa_Rica ///
	Turks_and_Caicos_Islands ///
	Suriname ///
	Afghanistan ///
	Pakistan ///
	Bangladesh ///
	Nepal ///
	Fiji ///
	Viet_Nam ///
	Samoa ///
	Tuvalu ///
	Tonga ///
	Kiribati ///
	Mongolia ///
	Yemen ///
	Jamaica ///
	Trinidad_and_Tobago ///
	Eswatini ///
	Benin
	
foreach c in `Globe' {
	append using "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_`c'.dta", force
}

timer off 1
timer list 1
//  1:     19.49 /        1 =      19.4880
*************************************
** Close workspace
*************************************
** log close
