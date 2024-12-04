** 241111
** PSSP PE HT Tabulate Variables

*************************************
** Set up workspace
*************************************
version 14.1
clear all	
set graphics off
set varlab on
timer on 1

***********************************************************
** Produce descriptive statistics for Head Teacher data **
***********************************************************

use "${shule_bora_DB}/pssp/DataSets/Intermediate/HT PSSP_cleaned.dta", clear


global a_vars survey_duration_min a7_board a7_board_1 a7_board_2 a7_board_3 ///
	a7_sen a7_sen_1 a7_sen_2 a7_sen_3 a8 a9 a10 a10_1 a10_2 a10_3 a10_4 a10_5 ///
	a10_6 a_duration_min

global b_vars b b1 b1_m b1_f b2 b3 b3_1 b3_2 b3_3 b3_4 b3_5 b3_6 b3_7 b3_8 ///
	b3_9 b4 b5 b6 b7 b8 total_t tot_teachers_check b9 b9_check b10 b10_1 ///
	b10_2 b10_3 b10_4 b10_5 b10_6 b10_7 b10_8 b10_9 b10_96 b_duration_min
	
global c_vars c c1 c2 c3 c3_1 c3_2 c3_3 c3_4 c3_5 c3_96 c3_aht c3_why ///
	c3_why_1 c3_why_2 c3_why_3 c3_why_4 c3_why_5 c4 ///
	c5 c5_1 c5_2 c5_3 c5_4 c5_96 c5_98 c6 c6_hr c7 c7_1 c7_2 c7_3 c7_4 c7_5 ///
	c7_6 c7_7 c7_8 c7_9 c7_96 c7_98 c8 c9 c9_1 c9_2 c9_3 c9_4 c9_5 ///
	c9_96 c10 c11 c11_1 c11_2 c11_3 c11_4 c11_5 c11_96 c11_98 c11_name c11_topic ///
	c12 c12_1 c12_2 c12_3 c12_4 c12_r c12_r_1 c12_r_2 c12_r_3 ///
	c12_s c12_s_1 c12_s_2 c12_s_3 c13 c13_1 c13_2 c13_3 c14 c14_1 c14_2 ///
	c14_3 c14_4 c14_r c14_r_1 c14_r_2 c14_r_3 c14_s c14_s_1 c14_s_2 c14_s_3 ///
	c15 c15_1 c15_2 c15_3 c_duration_min

global d_vars d d1 d2 d2_1 d2_2 d2_3 d2_96 d3_m d3_f d3_total ///
	d4 d4_1 d4_2 d4_3 d4_96 d5 d6 d6_total d6_prop d7 d7_1 d7_2 d7_3 d7_4 ///
	d7_5 d7_6 d7_96 d11 d23 d23_1 d23_1_1 ///
	d23_1_2 d23_1_3 d23_1_4 d23_1_5 d23_2 d23_2_1 d23_2_2 d23_2_3 d23_2_4 d23_2_5 d23_3 ///
	d23_3_1 d23_3_2 d23_3_3 d23_3_4 d23_3_5 d23_4 d23_4_1 d23_4_2 d23_4_3 d23_4_4 d23_4_5 ///
	d_manual d_manual_r d_manual_r_1 d_manual_r_2 d_manual_r_3 d_manual_r_4 d24 d_duration_min
	
global e_vars e e1 e1_1 e1_2 e1_3 e1_4 e1_5 e1_r e1_r_1 e1_r_2 e1_r_3 ///
	e2 e6_1 e6_1_1 e6_1_2 e6_1_3 e6_1_4 e6_1_5 e6_1_6 e6_2 e6_2_1 e6_2_2 ///
	e6_2_3 e6_2_4 e6_2_5 e6_2_6 e8 e8_1 e8_2 e8_3 e8_4 e8_5 e8_6 e8_7 e8_8 ///
	e8_9 e8_10 e8_11 e8_12 e8_12 e8_13 e8_14 e8_15 e8_96 e8_98 e8_99 e9 e9_1 ///
	e9_2 e9_3 e9_4 e9_5 e9_6 e9_7 e9_0 e9_96 e9_99 e10 e10_1 e10_2 e10_3 e10_4 e10_5 ///
	e10_6 e10_7 e10_0 e10_96 e10_99 e11 e11_1 e11_2 e11_3 ///
	e12 e12_1 e12_2 e12_3 e12_4 e12_5 e12_6 e12_7 e13 e13_1 e13_2 e13_3 e13_4 e13_96 ///
	e13_99 e14 e14_1 e14_2 e14_3 e15 e15_1 e15_2 e15_3 e15_4 e15_5 e16 e_duration_min
	
global f_vars f f1 f1_1 f1_2 f1_3 f2 f2_1 f2_2 f2_3 f2_4 f2_5 f2_6 f2_7 f2_8 f3 ///
	f3_1 f3_2 f3_3 f3_4 f3_5 f3_96 f3_98 f3_99 f4 f4_1 f4_2 f4_3 f4_4 f4_5 f4_6 ///
	f4_7 f4_8 f4_9 f7 f13 f13_1 f13_2 f13_3 f13_4 f13_5 f14 f14_1 f14_2 f14_3 ///
	f14_4 f14_v f15 f16 f16_1 f16_2 f16_3 f16_4 f16_5 ///
	f16_6 f16_7 f16_8 f16_9 f17 f17_1 f17_2 f17_3 f17_4 f17_5 f17_96 f19 f21 f_duration_min

global g_vars g g1 g1_1 g1_2 g1_3 g2 g2_1 g2_2 g2_3 g2_4 g2_5 g2_6 g2_7 g2_8 ///
	g2_9 g2_10 g2_0 g2_96 g2_98 g4 g_duration_min	

global h_vars h h4 h4_1 h4_2 h4_3 h5 h6 h6_1 h6_2 h6_3 h6_4 h6_5 h6_6 h6_96 h6_98 ///
	h7 h7_1 h7_2 h7_3 h7_4 h7_5 h7_6 h7_7 h7_8 h7_9 h7_10 h7_11 h7_12 h7_13 h7_14 ///
	h7_15 h7_16 h7_17 h7_18 h7_19 h7_96 h7_98 h9 h_duration_min	

global i_vars i i1 i2 i2_1 i2_2 i2_3 i2_4 i2_5 i2_6 i2_96 i4 i4_1 i4_2 i4_3 i4_4 i4_5 ///
	i4_6 i5_where i5_v i5 i5_1 i5_2 i5_3 i5_4 i5_5 i5_6 i5_7 i5_8 i6 i6_1 i6_2 i6_3 i6_4 ///
	i7 i7_1 i7_2 i7_3 i7_4 i7_5 i7_6 i7_7 i11 i12 i13 i20 i20_1 i20_2 i20_3 i20_4 ///
	i21 i21_1 i21_2 i21_3 i21_96 i22_v i22_v_1 i22_v_2 i22_v_3 i22_v_4 ///
	i25 i25_1 i25_2 i25_3 i25_4 i25_5 i26 i26_1 i26_2 i26_3 i26_4 i26_5 ///
	i28 i28_1 i28_2 i28_3 i28_4 i28_5 i28_6 i28_96 i28_98 i28_99 ///
	i29 i30 i30_1 i30_2 i30_3 i30_4 i31 i32 i32_1 i32_2 i32_3 i32_4 i36 i36_1 ///
	i36_2 i36_3 i36_4 i36_5 i36_96 i36_98 i36_99 i37 i_duration_min

global k_vars k k1 k1_1 k1_2 k1_3 k9_m k9_f k2 k2_1 k2_2 k2_3 k2_4 k2_5 k2_6 k2_7 k2_8 k2_9 k2_10 ///
	k2_11 k2_12 k2_13 k2_14 k2_15 k2_16 k2_17 k2_18 k2_19 k2_20 k2_21 k2_22 k2_96 ///
	k2_98 k5 k5_1 k5_2 k5_3 k5_4 k5_5 k5_6 k5_7 k5_8 k11 k11_1 k11_2 k11_3 ///
	k11_4 k11_5 k11_0 k11_96 k11_98 k12 k6_m k6_f k10 k10_1 k10_2 k10_3 k10_4 ///
	k10_5 k10_6 k10_7 k10_8 k10_9 k10_96 k10_98 k13 k13_1 k13_2 k13_3 k13_4 k13_5 ///
	k13_6 k13_7 k13_8 k13_9 k13_10 k13_11 k13_12 k13_13 k13_14 k13_15 k13_96 k13_98 ///
	k14 k_duration_min	
	
global l_vars l l1 l1_1 l1_2 l1_3 l1_4 l1_5 l1_6 l2 l2_1 l2_2 l2_0 l6 l6_1 ///
	l6_2 l6_3 l3 l3_1 l3_2 l3_3 l3_4 l3_5 l4 l4_1 ///
	l4_2 l4_3 l4_4 l4_5 l4_6 l4_96 l5 l5_1 l5_2 l5_3 l5_4 l5_5 l5_6 l7 ///
	l8 l8_1 l8_2 l8_3 l8_4 l8_5 l8_6 l8_7 l8_0 l8_96 l8_98 ///
	l9 l9_1 l9_2 l9_3 l9_0 l14 l_duration_min	
	
global j_vars j j1 j2 j2_1 j2_2 j2_3 j2_4 j2_v j2_v_1 j2_v_2 j2_v_3 j6 j6_1 j6_2 ///
	j6_3 j6_4 j6_5 j6_6 j6_7 j6_8 j6_96 j6_98 j6_99 ///
	j8 j8_1 j8_2 j8_3 j8_4 j8_5 j8_6 j8_7 j8_96 j8_98 j8_99 j8_how j8_how_1 j8_how_2 ///
	j8_how_3 j8_how_4 j8_how_96 j8_how_98 j8_how_99 j8_where j8_where_1 j8_where_2 ///
	j8_where_3 j8_where_4 j8_where_5 j8_where_6 j8_where_96 j8_where_98 j8_where_99 ///
	j8_num j8_num_1 j8_num_2 j8_num_3 j8_num_4 j8_num_5 j8_num_6 j8_num_7 ///
	j8_who j8_who_1 j8_who_2 j8_who_3 j8_who_4 j8_who_96 j8_who_98 j8_who_99 ///
	j9 j9_1 j9_2 j9_3 j9_4 j9_5 j9_96 j9_98 j9_99 ///
	j12 j13 j13_1 j13_2 j13_3 j13_4 j14 j14_1 j14_2 j14_3 j14_4 j14_5 j14_6 ///
	j14_96 j14_98 j15 j15_1 j15_2 j15_3 j16 j16_1 j16_2 j16_3 j16_4 j16_96 j16_98 j_duration_min

global m_vars m m1 m1_1 m1_2 m1_3 m1_4 m1_5 m1_why m1_why_1 m1_why_2 m1_why_3 m1_why_4 m1_why_5 m1_why_6 m1_why_7 m1_why_8 m1_why_96 ///
			m2 m2_1 m2_2 m2_3 m2_4 m2_5 m2_why m2_why_1 m2_why_2 m2_why_3 m2_why_4 m2_why_5 m2_why_6 m2_why_7 m2_why_8 m2_why_96 ///
			m3 m3_1 m3_2 m3_3 m3_4 m3_5 m3_why m3_why_1 m3_why_2 m3_why_3 m3_why_4 m3_why_5 m3_why_6 m3_why_7 m3_why_8 m3_why_96 ///
			m4 m4_1 m4_2 m4_3 m4_4 m4_5 m4_why m4_why_1 m4_why_2 m4_why_3 m4_why_4 m4_why_5 m4_why_6 m4_why_7 m4_why_8 m4_why_96 ///
			m5 m5_1 m5_2 m5_3 m5_4 m5_5 m5_why m5_why_1 m5_why_2 m5_why_3 m5_why_4 m5_why_5 m5_why_6 m5_why_7 m5_why_8 m5_why_96 ///
			m6 m6_1 m6_2 m6_3 m6_4 m6_5 m6_why m6_why_1 m6_why_2 m6_why_3 m6_why_4 m6_why_5 m6_why_6 m6_why_7 m6_why_8 m6_why_96 ///
			m7 m7_1 m7_2 m7_3 m7_4 m7_5 m7_why m7_why_1 m7_why_2 m7_why_3 m7_why_4 m7_why_5 m7_why_6 m7_why_7 m7_why_8 m7_why_96 ///
			m8 m8_1 m8_2 m8_3 m8_4 m8_5 m8_why m8_why_1 m8_why_2 m8_why_3 m8_why_4 m8_why_5 m8_why_6 m8_why_7 m8_why_8 m8_why_96 ///
			m9 m9_1 m9_2 m9_3 m9_4 m9_5 m9_why m9_why_1 m9_why_2 m9_why_3 m9_why_4 m9_why_5 m9_why_6 m9_why_7 m9_why_8 m9_why_96 ///
			m10 m10_1 m10_2 m10_3 m10_4 m10_5 m10_why m10_why_1 m10_why_2 m10_why_3 m10_why_4 m10_why_5 m10_why_6 m10_why_7 m10_why_8 m10_why_96 ///

putexcel set "${shule_bora_DB}/pssp/Output/pssp_descriptive_HT.xlsx", replace sheet(pssp_ht)


	putexcel A1 = "PSSP_PE_Data_Descriptives"
	putexcel A2 = "Months: Nov 2024 - Dec 2024, HT responses"
	
	putexcel A3 = "Variable"
	putexcel B3 = "Min"
	putexcel C3 = "Mean"
	putexcel D3 = "Median"
	putexcel E3 = "Max" 
	putexcel F3 = "N" 


	local row = 4
	
	foreach var in  $a_vars $b_vars $c_vars $d_vars ///
			$e_vars $f_vars $g_vars $h_vars $i_vars $k_vars $l_vars $j_vars $m_vars {
		
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
