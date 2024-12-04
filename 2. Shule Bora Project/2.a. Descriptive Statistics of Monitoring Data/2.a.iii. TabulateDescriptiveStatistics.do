** 240529
** SB Monitoring Data Descriptive Tabulation/Analysis

*************************************
** Set up workspace
*************************************
version 14.1
clear all	
set graphics off
timer on 1

use "${shule_bora_DB}\Baseline\Monitoring_2023_HT_constructed.dta", clear

**************************
** Tabulate data: Safety**
**************************

putexcel set "${shule_bora_DB}\Descriptive_analyses\Monitoring\Output\SB_monitoring_descriptive.xlsx", replace sheet(Monitoring_HT_Safety)


	putexcel A1 = "SB_Monitoring_Data_Descriptives"
	putexcel A2 = "Source of data: SB monitoring data, Months: Nov 2023 - Mar 2024, HT responses, N = 682, 9 SB regions, 26 councils/147 wards, Level of Observation (School)"
	putexcel B2 = "HTs/Teachers"
	putexcel H2 = "Students"
	
	putexcel A3 = "Variable"
	putexcel B3 = "Min"
	putexcel C3 = "Mean"
	putexcel D3 = "Median"
	putexcel E3 = "Max" 
	putexcel F3 = "N" 
	
	putexcel H3 = "Variable"
	putexcel I3 = "Min"
	putexcel J3 = "Mean"
	putexcel K3 = "Median"
	putexcel L3 = "Max" 
	putexcel M3 = "N" 
	
	putexcel A4 = "School safety"
	
	putexcel A1 A2 H2 A3 A4 B3 C3 D3 E3 F3 H3 I3 J3 K3 L3 M3, bold

	global safety_1 ///
		safety_1 s_1_1 s_1_2 s_1_3 s_1_4 s_1_5 s_1_6 s_1_7 s_1_8 s_1_s
		
	global safety_2 ///
		safety_2 s_2_1 s_2_2 s_2_3 s_2_4 s_2_s
	
	global safety_3 ///
		safety_3 prop_emotional prop_m_emotional prop_f_emotional prop_physical prop_m_physical ///
		prop_f_physical prop_sexual prop_m_sexual prop_f_sexual prop_neglect prop_m_neglect ///
		prop_f_neglect prop_emotional_unc prop_m_emotional_unc prop_f_emotional_unc  ///
		prop_physical_unc prop_m_physical_unc prop_f_physical_unc prop_sexual_unc prop_m_sexual_unc ///
		prop_f_sexual_unc prop_neglect_unc prop_m_neglect_unc prop_f_neglect_unc 
	
	global safety_5 ///
		safety_5 safety_5_1
	
	global safety_6 ///
		safety_6 safety_6_unc safety_6_1 Socialwelfareoffice Policegenderdesk LGAoffice ///
		Healthfacility Other Socialwelfareoffice_unc Policegenderdesk_unc LGAoffice_unc ///
		Healthfacility_unc Other_unc safety_6_a_other
	
	global safety_8 ///
		safety_8 safety_8a safety_8a_unc safety_8b safety_8b_unc
	
	global safety_9 ///
		safety_9 prop_dis_all prop_dis_m prop_dis_f  prop_dis_all_unc ///
		prop_dis_m_unc prop_dis_f_unc 

	global safety_10 ///
		safety_10 safety_10_1 safety_10_2 safety_10_3 safety_10_4 ///
		safety_10_1_unc safety_10_2_unc safety_10_3_unc safety_10_4_unc ///
		safety_10a_1 safety_10a Observe_and_assess Screening_tool Classroom_assess Other_method Observe_and_assess_unc ///
		Screening_tool_unc Classroom_assess_unc Other_method_unc
		
	global safety_11 ///
		safety_11a  safety_11_1 safety_11_2 safety_11_3 safety_11a_1 ///
		Ramp Inclusive_toilet Special_ed_teacher Other_facility Pleasementionother Ramp_unc ///
		Inclusive_toilet_unc Special_ed_teacher_unc Other_facility_unc ///
		safety_11b Separate_gender_toilet Menstrual_hygiene_room Inclusive_toilets ///
		Inclusive_building Inclusive_chairs_tables Other_facilities CM

	global safety_12a ///
		safety_12a safety_12a_option1 safety_12a_option2 safety_12a_option3 ///
		safety_12a1 safety_12a2 safety_13
		
	global psle ///
		hi_school lo_school med_school totalstudents_23
	
	global number_s ///
		student50 student100 student300 student500 student1000 student2000 student4000 Total_teacher
	
	global number_t ///
		teacher10 teacher30 teacher50 teacher65
		
	global ptr ///
		ptr_23 ptr60 ptr80 ptr100 ptr150 ptr200 ptr10000
		
	global distance ///
		road1 road10 road50 road100 road1000 airport10 airport50 airport100 airport200 airport1000
	
	local row = 5
	
	foreach var in  $safety_1 $safety_2 $safety_3 safety_4 $safety_5 ///
			$safety_6 safety_7 $safety_8 $safety_9 $safety_10 $safety_11 $safety_12a ///
			school_rank Perm_teacher Temp_teacher $psle $number_s $number_t $ptr $distance {
		
		cap confirm var `var'
		if !_rc { // if the variable exists 
		
			global `var'_lab : variable label `var'

			sum `var', d 
			
			gl `var'min `r(min)'
			gl `var'mean `r(mean)'
			gl `var'med `r(p50)'
			gl `var'max `r(max)'
			gl `var'n `r(N)'
			
			* Results 
			sleep 500
			putexcel A`row' = "${`var'_lab}"
			sleep 500
			putexcel B`row' = "${`var'min}"
			sleep 500
			putexcel C`row' = "${`var'mean}"
			sleep 500
			putexcel D`row' = "${`var'med}"
			sleep 500
			putexcel E`row' = "${`var'max}"
			sleep 500
			putexcel F`row' = "${`var'n}"
			sleep 500
			
			local row = 	`row' + 1
			}
		} 

**************************
** Tabulate data: TCPD**
**************************

putexcel set "${shule_bora_DB}\Descriptive_analyses\Monitoring\Output\SB_monitoring_descriptive_HT_TCPD.xlsx", replace sheet(Monitoring_HT_TCPD)


	putexcel A1 = "SB_Monitoring_Data_Descriptives"
	putexcel A2 = "Source of data: SB monitoring data, Months: Nov 2023 - Mar 2024, HT responses, N = 682, 9 SB regions, 26 councils/147 wards, Level of Observation (School)"
	putexcel B2 = "HTs/Teachers"
	putexcel A4 = "TCPD"
	
	putexcel A3 = "Variable"
	putexcel B3 = "Min"
	putexcel C3 = "Mean"
	putexcel D3 = "Median"
	putexcel E3 = "Max" 
	putexcel F3 = "N" 

	putexcel A1 A2 H2 A3 A4 B3 C3 D3 E3 F3 H3 I3 J3 K3 L3 M3, bold

	global TCPD_1 ///
		qn_1a qn_1b qn_1c qn_2 qn_3
	
	global TCPD_4 ///
		qn_4a qn_4a_1 qn_4a_2 qn_4a_3 qn_4a_4 qn_4a_5 qn_4a_1_unc qn_4a_2_unc ///
		qn_4a_3_unc qn_4a_4_unc qn_4a_5_unc qn_4b qn_4b_1 qn_4b_2 qn_4b_3 ///
		qn_4b_1_unc qn_4b_2_unc qn_4b_3_unc qn_4c
		
	global TCPD_5 ///
		qn_5 qn_5_1 qn_5_2 qn_5_3 qn_5_4 qn_5_5 qn_5_6 qn_5_7 qn_5_1_unc qn_5_2_unc ///
		qn_5_3_unc qn_5_4_unc qn_5_5_unc qn_5_6_unc qn_5_7_unc qn_5_8 qn_6a qn_6b
	
	global TCPD_7 ///
		qn_7 qn_7_1 qn_7_2 qn_7_3 qn_7_1_unc qn_7_2_unc qn_7_3_unc
	
	global TCPD_8 ///
		qn_8a qn_8a1 qn_8a_1 prop_3R1 prop_3R2 prop_3R3 prop_3R1_unc prop_3R2_unc prop_3R3_unc ///
		qn_8b qn_8b_1 qn_8b_2 qn_8b_3 qn_8b_4 qn_8b_1_unc qn_8b_2_unc qn_8b_3_unc qn_8b_4_unc

	global TCPD_9 ///
		qn_9 qn_9a_1 qn_9a_2 qn_9a_3 qn_9a_1_unc qn_9a_2_unc qn_9a_3_unc qn_9a1 qn_9a2 qn_9b

	local row = 5
	
	foreach var in  $TCPD_1 $TCPD_4 $TCPD_5 $TCPD_7 $TCPD_8 $TCPD_9 {
		
		cap confirm var `var'
		if !_rc { // if the variable exists 
		
			global `var'_lab : variable label `var'

			sum `var', d 
			
			gl `var'min `r(min)'
			gl `var'mean `r(mean)'
			gl `var'med `r(p50)'
			gl `var'max `r(max)'
			gl `var'n `r(N)'
			
			* Results 
			sleep 500
			putexcel A`row' = "${`var'_lab}"
			sleep 500
			putexcel B`row' = "${`var'min}"
			sleep 500
			putexcel C`row' = "${`var'mean}"
			sleep 500
			putexcel D`row' = "${`var'med}"
			sleep 500
			putexcel E`row' = "${`var'max}"
			sleep 500
			putexcel F`row' = "${`var'n}"
			sleep 500
			
			local row = 	`row' + 1
			}
		} 

		
		
		
timer off 1
timer list 1
//     1:    293.49 /        1 =     293.4910

*************************************
** Close workspace
*************************************
** log close
