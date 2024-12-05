** 230525
** Run Regressions

*************************************
** Set up workspace
*************************************
version 14.2
clear all
set more off
cd "${PathHome}"

*************************************
** Start work here
*************************************
timer on 1

use "${PathDataFinal}\CleanedBaselineMidlineEndline.dta", clear

** --------------------------
** Regressions
** --------------------------

** --------------------------
** 1.a. Baseline balance - demographics
** --------------------------
local BalanceDemographics ///
	Base_age GuardianEducationHighSchoolPlus GuardianOccupationProfessional ///
	Base_siblings Base_distance /// 
	Base_study_hour_total	
foreach vv of var `BalanceDemographics' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
}

** --------------------------
** 1.b.i. Baseline balance - game offers
** --------------------------
local BalanceGameOffers ///
	Base_two_player_offer Base_three_player_sb_offer Base_three_player_sc_offer
foreach vv of var `BalanceGameOffers' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
}

** --------------------------
** 1.b.ii. Baseline balance - game acceptance/rejections
** --------------------------
foreach nn1 of num 1 / 3 {
	foreach nn2 of num 1 / 8 {
		local reg areg Base_sr`nn1'_option_`nn2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
		di "`reg'"
		`reg'
	}
}
foreach nn1 of num 1 / 3 {
	local reg areg Base_sr`nn1'_min_val_will_accept Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
	local reg areg Base_sr`nn1'_max_val_will_accept Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'	
}

** --------------------------
** 1.b.iii. Baseline balance - game expectations
** --------------------------
foreach nn1 of num 1 / 3 {
	foreach nn2 of num 1 / 8 {
		local reg areg Base_UG`nn1'_GuessedAcceptP_opt`nn2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
		di "`reg'"
		`reg'
	}
}

** --------------------------
** 1.c.i Baseline balance - charity & equity exercises
** --------------------------
local BalanceCharityEquity ///
	Base_CharityHealthy Base_CharityDisability Base_CharityEquity
foreach vv of var `BalanceCharityEquity' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
}

** --------------------------
** 1.c.ii Baseline balance - psychosocial wellbeing
** --------------------------
local BalancePsychosocial ///
	Base_wellbeing_z1 Base_wellbeing_z2
foreach vv of var `BalancePsychosocial' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
}

** --------------------------
** 1.d. Baseline balance - auxiliary
** --------------------------
** TODO TODO TODO
** Incides: Pro-sociality, gender, social desirability, digital
** TODO TODO TODO
local BalanceAuxiliary ///
	Base_interest_z
foreach vv of var `BalanceAuxiliary' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
}

** --------------------------
** 2. Treatment effects on main outcomes
** --------------------------
** 2.b.i. Game offers
local OutcomeGameOffers ///
	Mid_two_player_offer Mid_three_player_sb_offer Mid_three_player_sc_offer ///
	End_two_player_offer End_three_player_sb_offer End_three_player_sc_offer
foreach vv of var `OutcomeGameOffers' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
}

** 2.b.ii. Game conditional acceptance/rejections
foreach nn1 of num 1 / 3 {
	local reg areg Mid_sr`nn1'_min_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
	local reg areg Mid_sr`nn1'_max_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'	
}
foreach nn1 of num 1 / 3 {
	local reg areg End_sr`nn1'_min_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
	local reg areg End_sr`nn1'_max_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'	
}

** 2.b.iii. Game expectations
foreach ss in Mid End {
	foreach nn1 of num 1 / 3 {
		foreach nn2 of num 1 / 8 {
			local reg areg `ss'_UG`nn1'_GuessedAcceptP_opt`nn2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
			di "`reg'"
			`reg'
		}
	}
}

** --------------------------
** 4.a Treatment effects on main auxiliary outcomes - charity & equity
** --------------------------
foreach ss in Mid End {
	foreach ss2 in CharityHealthy CharityDisability CharityEquity {
		local reg areg `ss'_`ss2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
		di "`reg'"
		`reg'
	}
}

** --------------------------
** 4.b Treatment effects on main auxiliary outcomes - psychosocial
** --------------------------
foreach ss in Mid End {
	local reg areg `ss'_wellbeing_z1 Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
	local reg areg `ss'_wellbeing_z2 Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
}

** --------------------------
** 5.a. Treatment effects on "meta/awareness" section Z - Before
** --------------------------
** i. Made me more likely to accept unfair proposals
areg End_z_influence_ba Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 1, absorb( Block ) vce( robust )
** ii. Influence of programming made me upset
areg End_z_influence_bb Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 1, absorb( Block ) vce( robust )
** iii. Influence of programming made me happy
areg End_z_influence_bc Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 1, absorb( Block ) vce( robust )
** iv. Willingness to donate
areg End_z_willingness_to_pay Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 1, absorb( Block ) vce( robust )
areg End_z_fairness Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 1, absorb( Block ) vce( robust )
areg End_z_reasoning Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 1, absorb( Block ) vce( robust )

** --------------------------
** 5.b. Treatment effects on "meta/awareness" section Z - After
** --------------------------
** i. Made me more likely to accept unfair proposals
areg End_z_influence_aa Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 2, absorb( Block ) vce( robust )
** ii. Influence of programming made me upset
areg End_z_influence_ab Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 2, absorb( Block ) vce( robust )
** iii. Influence of programming made me happy
areg End_z_influence_ac Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 2, absorb( Block ) vce( robust )
** iv. Willingness to donate
areg End_z_willingness_to_pay Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 2, absorb( Block ) vce( robust )
areg End_z_fairness Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 2, absorb( Block ) vce( robust )
areg End_z_reasoning Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1 & End_group_z == 2, absorb( Block ) vce( robust )

** ** Test interaction
** reg End_z_wtp End_group_z##( Sn Ae ) End_group_z#( Base_story1 Base_frame1 c.Base_study_hour_total ) i.Block##i.End_group_z if HadTransferredOut ~= 1, vce( robust )

** 2.b.iv. Game realized acceptance/rejections
foreach ss in Base Mid End {
	foreach nn of num 1 / 3 {
		local reg areg `ss'_PC_Accepted0`nn' Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1, absorb( Block ) vce( robust )
		di "`reg'"
		`reg'
	}
}

** 2.b.v. Game received credits
foreach ss in Base Mid End {
	foreach nn of num 1 / 3 {
		local reg areg `ss'_PC_Received0`nn' Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1, absorb( Block ) vce( robust )
		di "`reg'"
		`reg'
	}
}

foreach ss in Base Mid End {
	local reg areg `ss'_PC_Received Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
	lincom Ae - Sn
	local reg areg `ss'_TotalReceived Sn Ae Base_story1 Base_frame1 Base_study_hour_total if HadTransferredOut ~= 1, absorb( Block ) vce( robust )
	di "`reg'"
	`reg'
}

timer off 1
timer list 1

//   1:     16.15 /        1 =      16.1490
*************************************
** Close workspace
*************************************
