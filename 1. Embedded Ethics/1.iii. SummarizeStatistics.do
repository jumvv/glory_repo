** 230601 
** SummarizeStatistics

*************************************
** Set up workspace
*************************************
version 14.2
clear all
set more off
cd "${PathHome}"

if 0 == 1 {
	ssc install blindschemes, replace 
	ssc install estout, replace
	ssc install parmest, replace 
}

*************************************
** Start work here
*************************************
timer on 1

use "${PathDataFinal}\CleanedBaselineMidlineEndline.dta", clear

** --------------------------
** 1.a. Baseline balance - demographics
** --------------------------
local BalanceDemographics ///
	Base_age GuardianEducationHighSchoolPlus GuardianOccupationProfessional ///
	Base_siblings Base_distance /// 
	Base_study_hour_total ///
	Base_digital_a Base_digital_b 	
foreach vv of var `BalanceDemographics' {
	local reg areg `vv' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( ols )
	di "`reg'"
	`reg'
}

** --------------------------
** 1.a.i Baseline balance - demographics - table
** --------------------------

local BalanceDemographics ///
	Base_age GuardianEducationHighSchoolPlus GuardianOccupationProfessional ///
	Base_siblings Base_distance /// 
	Base_study_hour_total ///
	Base_digital_a Base_digital_b Base_digital_hour_total 

label define edu 1 "No schooling" 2 "Primary" 3 "O-level" 4 "A-level" 5 "Diploma" 6 "Bachelor's" 7 "Master's or above"
la val Base_education_of_guardian Mid_education_of_guardian End_education_of_guardian edu 

label define scale 1 "Strongly disagree" 2 "Disagree" 3 "Slightly disagree" 4 "Do not agree nor disagree" 5 "Slightly agree" 6 "Agree" 7 "Strongly agree"
la val Base_interest_* Base_attitude_* Base_digital_* scale 

label define frequency 1 "Never" 2 "Almost never" 3 "Sometimes" 4 "Fairly often" 5 "Very often"
label define frequency1 1 "Every day" 2 "Once in 2 or 3 days" 3 "Once in a week" 4 "Once in 15 days" 5 "Once in a month" 6 "Rarely" 
la val Base_wellbeing_a-Base_wellbeing_f frequency1
la val Base_wellbeing_g-Base_wellbeing_k frequency

cap gen Base_digital_hour_total = Base_digital_c*Base_digital_d 
la var Base_digital_hour_total "When you are at home, how many hours per week do you use the Internet?"
su Base_digital_hour_total, d

** Relabel for table 
local i = 0 
foreach vv of var `BalanceDemographics' {
	local ++i 
	local v`i': variable label `vv' 
	if "`vv'"=="Base_age" lab var `vv' "Age" 
	if "`vv'"=="GuardianEducationHighSchoolPlus" lab var `vv' "Primary guardian education above high school" 
	if "`vv'"=="GuardianOccupationProfessional" lab var `vv' "Primary guardian occupation is professional"
	if "`vv'"=="Base_siblings" lab var `vv' "Number of siblings" 
	if "`vv'"=="Base_distance" lab var `vv' "Hours of travel from home to school" 
	if "`vv'"=="Base_study_hour_total" lab var `vv' "Hours per week studying math and science outside class" 	
	if "`vv'"=="Base_digital_a" lab var `vv' "Own a smartphone" 	
	if "`vv'"=="Base_digital_b" lab var `vv' "Use social media" 	
	if "`vv'"=="Base_digital_hour_total" lab var `vv' "Hours per week using the Internet" 	
}

eststo clear
eststo: estpost tabstat `BalanceDemographics', stats(mean sd min p25 p50 p75 max count) columns(stats)

esttab using "${PathCodesOut}/demographics_stats.tex", replace label f booktabs nonumbers noobs mlabels(none) collabels(none) cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) p25(fmt(0)) p50(fmt(0)) p75(fmt(0)) max(fmt(0)) count(fmt(0))") posthead("Variable & Mean & SD & Min & p25 & p50 & p75 & Max & N \\ \midrule")

** Replace with old labels 
local i = 0 
foreach vv of var `BalanceDemographics' {
	local ++i 
	lab var `vv' "`v`i''" 
}

eststo clear

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
** 1.b.i.i Baseline balance - game offers - histogram 
** --------------------------

foreach Survey in "Base" "Mid" "End" {
	** Place bars side by side 
	cap noi gen `Survey'_two_player_offerp = `Survey'_two_player_offer-0.25 
	cap noi gen `Survey'_three_player_sb_offerp = `Survey'_three_player_sb_offer
	cap noi gen `Survey'_three_player_sc_offerp = `Survey'_three_player_sc_offer+0.25 

	tw (histogram `Survey'_two_player_offerp, fcolor(orange%30) lcolor(orange) fraction width(0.25)) (histogram `Survey'_three_player_sb_offerp, fcolor(green%60) lcolor(green) fraction width(0.25)) (histogram `Survey'_three_player_sc_offerp, fcolor(blue%60) lcolor(blue) fraction width(0.25)), scheme(plotplainblind) legend(pos(6) col(3) lab(1 "Two-player") lab(2 "Three-player, social benefit") lab(3 "Three-player, social cost")) xla(0 1.5 3 4.5 6 7 8.5 10)

	** Alternative: bar to avoid histogram problems with placement of bars 
	local BalanceGameOffers ///
		`Survey'_two_player_offer `Survey'_three_player_sb_offer `Survey'_three_player_sc_offer
	foreach vv of var `BalanceGameOffers' {
		cap drop `vv'f 
		gen `vv'f = .
		cap drop `vv'c
		egen `vv'c = count(`vv')
		foreach val of numlist 0 1.5 3 4.5 6 7 8.5 10 {
			egen temp = count(`vv') if `vv' == `val'
			replace `vv'f = temp / `vv'c if `vv'==`val'
			drop temp 
		}
		drop `vv'c
	}


	tw (bar `Survey'_two_player_offerf `Survey'_two_player_offerp, fcolor(orange%30) fintensity(15) lcolor(orange) barwidth(0.25)) ///
	   (bar `Survey'_three_player_sb_offerf `Survey'_three_player_sb_offerp, fcolor(green%60) fintensity(30) lcolor(green) barwidth(0.25)) ///
	   (bar `Survey'_three_player_sc_offerf `Survey'_three_player_sc_offerp, fcolor(blue%60) fintensity(30) lcolor(blue) barwidth(0.25)), ///
	   scheme(plotplainblind) legend(pos(6) col(3) lab(1 "Two-player") lab(2 "Three-player, social benefit") lab(3 "Three-player, social cost")) xla(0 1.5 3 4.5 6 7 8.5 10) ytitle("Fraction") yla(0 .15 .3 .45 .6 .75 .9)
    graph export "${PathCodesOut}/`Survey'_all_games_offers.pdf", replace 
		
	   ** Adjust back to original
	   drop `Survey'_two_player_offerp `Survey'_three_player_sb_offerp `Survey'_three_player_sc_offerp
}

** Control vs. Sn vs. Ae 
foreach Survey in "Base" "Mid" "End" {

	** Alternative: bar to avoid histogram problems with placement of bars 
	local BalanceGameOffers ///
		`Survey'_two_player_offer `Survey'_three_player_sb_offer `Survey'_three_player_sc_offer
	** Calculate fraction of each choice within group 
	foreach vv of var `BalanceGameOffers' {
		cap drop `vv'f 
		gen `vv'f = .
		cap drop `vv'c
		egen `vv'c = count(`vv'), by(InterventionGroup)
		foreach val of numlist 0 1.5 3 4.5 6 7 8.5 10 {
			egen temp = count(`vv') if `vv' == `val', by(InterventionGroup)
			replace `vv'f = temp / `vv'c if `vv'==`val'
			drop temp 
		}
		drop `vv'c
	}

** Base vs. Mid vs. End by InterventionGroup
foreach group in 0 1 2 {
	foreach Game in "two_player" "three_player_sb" "three_player_sc" {
		cap drop Base_`Game'_offerp
		cap drop Mid_`Game'_offerp
		cap drop End_`Game'_offerp
		
		gen Base_`Game'_offerp = Base_`Game'_offer - 0.25 
		gen Mid_`Game'_offerp = Mid_`Game'_offer	
		gen End_`Game'_offerp = End_`Game'_offer + 0.25
		
		if `group' == 0 local gp_title "Control"
		if `group' == 1 local gp_title "Standard Nash"
		if `group' == 2 local gp_title "Altruistic Equitable"
		
		if "`Game'" == "two_player" local game_title "Two-player"
		if "`Game'" == "three_player_sb" local game_title "Three-player with social benefit"
		if "`Game'" == "three_player_sc" local game_title "Three-player with social cost"
		
		local xtitle "`game_title' offer, `gp_title'"

		tw (bar Base_`Game'_offerf Base_`Game'_offerp if InterventionGroup == `group', fcolor(orange%30) fintensity(15) lcolor(orange) barwidth(0.25)) ///
		   (bar Mid_`Game'_offerf Mid_`Game'_offerp if InterventionGroup == `group', fcolor(green%60) fintensity(30) lcolor(green) barwidth(0.25)) ///
		   (bar End_`Game'_offerf End_`Game'_offerp if InterventionGroup == `group', fcolor(blue%60) fintensity(30) lcolor(blue) barwidth(0.25)), ///
		   scheme(plotplainblind) legend(pos(6) col(3) lab(1 "Baseline") lab(2 "Midline") lab(3 "Endline")) xla(0 1.5 3 4.5 6 7 8.5 10) ytitle("Fraction") xtitle("`xtitle'") yla(0 .15 .3 .45 .6 .75 .9)		
		graph export "${PathCodesOut}/BaseMidEnd_`Game'_offers_InterventionGroup`group'.pdf", replace 
	}
}

drop Base_*_offerp Mid_*_offerp End_*_offerp
	   
** --------------------------
** 1.b.ii. Baseline balance - game acceptance/rejections - histogram 
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

** Histogram / bar chart 

gen Base_sr1_min_val_will_acceptp = Base_sr1_min_val_will_accept-0.25 
gen Base_sr2_min_val_will_acceptp = Base_sr2_min_val_will_accept
gen Base_sr3_min_val_will_acceptp = Base_sr3_min_val_will_accept+0.25 

gen Base_sr1_max_val_will_acceptp = Base_sr1_max_val_will_accept-0.25 
gen Base_sr2_max_val_will_acceptp = Base_sr2_max_val_will_accept
gen Base_sr3_max_val_will_acceptp = Base_sr3_max_val_will_accept+0.25 

foreach minmax in "min" "max" {
	tw (histogram Base_sr1_`minmax'_val_will_acceptp, fcolor(orange%30) lcolor(orange) fraction width(0.25)) (histogram Base_sr2_`minmax'_val_will_acceptp, fcolor(green%60) lcolor(green) fraction width(0.25)) (histogram Base_sr3_`minmax'_val_will_acceptp, fcolor(blue%60) lcolor(blue) fraction width(0.25)), scheme(plotplainblind) legend(pos(6) col(3) lab(1 "Two-player") lab(2 "Three-player, social benefit") lab(3 "Three-player, social cost")) xla(0 1.5 3 4.5 6 7 8.5 10)
}

** Control vs. Sn vs. Ae 
foreach Survey in "Base" "Mid" "End" {
	foreach nn1 of num 1 {
		foreach minmax in "min" "max" {

			** Alternative: bar to avoid histogram problems with placement of bars 
			local BalanceGameOffers ///
				`Survey'_sr1_`minmax'_val_will_accept 
			** `Survey'_sr2_`minmax'_val_will_accept `Survey'_sr3_`minmax'_val_will_accept `Survey'_sr1_max_val_will_accept `Survey'_sr2_max_val_will_accept `Survey'_sr3_max_val_will_accept
			foreach vv of var `BalanceGameOffers' {
				cap drop `vv'f 
				gen `vv'f = .
				cap drop `vv'c
				egen `vv'c = count(`vv'), by(InterventionGroup)
				foreach val of numlist 0 1.5 3 4.5 6 7 8.5 10 {
					egen temp = count(`vv') if `vv' == `val', by(InterventionGroup)
					replace `vv'f = temp / `vv'c if `vv'==`val'
					drop temp 
				}
				drop `vv'c
			}
			
			cap drop `Survey'_sr`nn1'_`minmax'_val_will_acceptp
			gen `Survey'_sr`nn1'_`minmax'_val_will_acceptp = `Survey'_sr`nn1'_`minmax'_val_will_accept - 0.25 if InterventionGroup == 0 
			replace `Survey'_sr`nn1'_`minmax'_val_will_acceptp = `Survey'_sr`nn1'_`minmax'_val_will_accept if InterventionGroup == 1 	
			replace `Survey'_sr`nn1'_`minmax'_val_will_acceptp = `Survey'_sr`nn1'_`minmax'_val_will_accept + 0.25 if InterventionGroup == 2 
			
			if "`minmax'"=="min" lab var `Survey'_sr`nn1'_`minmax'_val_will_acceptp "Minimum offer acceptance, `Survey'line"
			if "`minmax'"=="max" lab var `Survey'_sr`nn1'_`minmax'_val_will_acceptp "Maximum offer acceptance, `Survey'line"

			tw (bar `Survey'_sr`nn1'_`minmax'_val_will_acceptf `Survey'_sr`nn1'_`minmax'_val_will_acceptp if InterventionGroup == 0, fcolor(orange%30) fintensity(15) lcolor(orange) barwidth(0.25)) ///
			   (bar `Survey'_sr`nn1'_`minmax'_val_will_acceptf `Survey'_sr`nn1'_`minmax'_val_will_acceptp if InterventionGroup == 1, fcolor(green%60) fintensity(30) lcolor(green) barwidth(0.25)) ///
			   (bar `Survey'_sr`nn1'_`minmax'_val_will_acceptf `Survey'_sr`nn1'_`minmax'_val_will_acceptp if InterventionGroup == 2, fcolor(blue%60) fintensity(30) lcolor(blue) barwidth(0.25)), ///
			   scheme(plotplainblind) legend(pos(6) col(3) lab(1 "Control") lab(2 "Standard Nash (Sn)") lab(3 "Altruistic Equitable (Ae)")) xla(0 1.5 3 4.5 6 7 8.5 10) yla(0 .1 .2 .3 .4 .5) ytitle("Fraction")
			graph export "${PathCodesOut}/`Survey'_sr`nn1'_`minmax'_val_will_accept_InterventionGroup.pdf", replace		
			   
			drop `Survey'_sr`nn1'_`minmax'_val_will_acceptp
		}
	}
}

** Base vs. Mid vs. End by InterventionGroup
foreach minmax in "min" "max" {
	foreach nn1 of num 1 {
		foreach group in 0 1 2 {
		
			cap drop Base_sr`nn1'_`minmax'_val_will_acceptp
			cap drop Mid_sr`nn1'_`minmax'_val_will_acceptp
			cap drop End_sr`nn1'_`minmax'_val_will_acceptp
			
			gen Base_sr`nn1'_`minmax'_val_will_acceptp = Base_sr`nn1'_`minmax'_val_will_accept - 0.25 
			gen Mid_sr`nn1'_`minmax'_val_will_acceptp = Mid_sr`nn1'_`minmax'_val_will_accept	
			gen End_sr`nn1'_`minmax'_val_will_acceptp = End_sr`nn1'_`minmax'_val_will_accept + 0.25
		
			if `group' == 0 local xtitle "Control"
			if `group' == 1 local xtitle "Standard Nash (Sn)"
			if `group' == 2 local xtitle "Altruistic Equitable (Ae)"
		
			tw (bar Base_sr`nn1'_`minmax'_val_will_acceptf Base_sr`nn1'_`minmax'_val_will_acceptp if InterventionGroup == `group', fcolor(orange%30) fintensity(15) lcolor(orange) barwidth(0.25)) ///
			   (bar Mid_sr`nn1'_`minmax'_val_will_acceptf Mid_sr`nn1'_`minmax'_val_will_acceptp if InterventionGroup == `group', fcolor(green%60) fintensity(30) lcolor(green) barwidth(0.25)) ///
			   (bar End_sr`nn1'_`minmax'_val_will_acceptf End_sr`nn1'_`minmax'_val_will_acceptp if InterventionGroup == `group', fcolor(blue%60) fintensity(30) lcolor(blue) barwidth(0.25)), ///
			   scheme(plotplainblind) legend(pos(6) col(3) lab(1 "Baseline") lab(2 "Midline") lab(3 "Endline")) xla(0 1.5 3 4.5 6 7 8.5 10) ytitle("Fraction") xtitle("`xtitle'")
			graph export "${PathCodesOut}/BaseMidEnd_sr`nn1'_`minmax'_val_will_accept_InterventionGroup`group'.pdf", replace	
		}
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
eststo clear 
foreach vv of var `OutcomeGameOffers' {
	** Midline has baseline but endline does not because we switched the roles from midline to endline
	** if strpos("`vv'","Mid_") > 0 local Base_control = subinstr("`vv'","Mid_","Base_",.)
	** if strpos("`vv'","End_") > 0 local Base_control
	local reg areg `vv' Sn Ae `Base_control' Base_story1 Base_frame1, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'
	** Remove contamation bias 
	** multe `vv' InterventionGroup, control(`Base_control' Base_story1 Base_frame1 Block) decompo minmax 
	multe `vv' `Base_control' Base_story1 Base_frame1 Block, treatment(InterventionGroup)
}

** Numbers 
local numbers   
foreach i of numlist 1/$eststo_counter {
	local numbers `numbers' & (`i')
	** & (1) & (2) & (3) & ... & (n)
}

esttab using "${PathCodesOut}/OutcomeGameOffersO.tex", replace label f booktabs star(* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) ///
nonumbers prehead("`numbers' \\") /// 
mgroups("Midline" "Endline", lhs("Survey") pattern(1 0 0 1 0 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) ///
mlabels(none) ///
posthead("Game & 2-player & 3-player SB & 3-player SC & 2-player & 3-player SB & 3-player SC \\ \midrule \\") ///
varlabels(Sn "Standard Nash" Ae "Altruistic Equitable" _cons "Control Mean") ///
drop(Base_story1 Base_frame1) /// 
stats(N r2, fmt(0 3) labels(`"Observations"' `"R-squared"'))


** 2.b.ii. Game conditional acceptance/rejections
** Minimum acceptance 
eststo clear 
foreach nn1 of num 1 / 3 {
	local reg areg Mid_sr`nn1'_min_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'
	** multe Mid_sr`nn1'_min_val_will_accept InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
	multe Mid_sr`nn1'_min_val_will_accept Base_story1 Base_frame1 Block, treatment(InterventionGroup)
	
	local reg areg End_sr`nn1'_min_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'	
	** multe End_sr`nn1'_min_val_will_accept InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
	multe End_sr`nn1'_min_val_will_accept Base_story1 Base_frame1 Block, treatment(InterventionGroup)
	
	local reg areg ME_sr`nn1'_min_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'	
	** multe ME_sr`nn1'_min_val_will_accept InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
	multe ME_sr`nn1'_min_val_will_accept Base_story1 Base_frame1 Block, treatment(InterventionGroup)	
}

** Numbers 
local numbers   
foreach i of numlist 1/$eststo_counter {
	local numbers `numbers' & (`i')
	** & (1) & (2) & (3) & ... & (n)
}

esttab using "${PathCodesOut}/OutcomeGameAcceptancesMin.tex", replace label f booktabs star(* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) ///
nonumbers prehead("`numbers' \\") /// 
mgroups("2-player" "3-player SB" "3-player SC", lhs("Game") pattern(1 0 1 0 1 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) ///
mlabels(none) ///
posthead("Survey & Midline & Endline & Midline & Endline & Midline & Endline \\ \midrule \\") ///
varlabels(Sn "Standard Nash" Ae "Altruistic Equitable" _cons "Control Mean") ///
drop(Base_story1 Base_frame1 Base_study_hour_total) /// 
stats(N r2, fmt(0 3) labels(`"Observations"' `"R-squared"'))

if 0 == 1 {
	esttab using "${PathCodesOut}/OutcomeGameAcceptancesMin.tex", replace label f booktabs star(* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) ///
	nonumbers prehead("`numbers' \\") /// 
	mgroups("2-player" "3-player SB" "3-player SC", lhs("Game") pattern(1 0 0 1 0 0 1 0 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) ///
	mlabels(none) ///
	posthead("Survey & Midline & Endline & Pooled & Midline & Endline & Pooled & Midline & Endline & Pooled  \\ \midrule \\") ///
	varlabels(Sn "Standard Nash" Ae "Altruistic Equitable" _cons "Control Mean") ///
	drop(Base_story1 Base_frame1 Base_study_hour_total) /// 
	stats(N r2, fmt(0 3) labels(`"Observations"' `"R-squared"'))
}

** Maximum acceptance 
eststo clear 
foreach nn1 of num 1 / 3 {
	local reg areg Mid_sr`nn1'_max_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'	
	** multe Mid_sr`nn1'_max_val_will_accept InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
	multe Mid_sr`nn1'_max_val_will_accept Base_story1 Base_frame1 Block, treatment(InterventionGroup)
	
	local reg areg End_sr`nn1'_max_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'	
	** multe End_sr`nn1'_max_val_will_accept InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
	multe End_sr`nn1'_max_val_will_accept Base_story1 Base_frame1 Block, treatment(InterventionGroup)
	
	local reg areg ME_sr`nn1'_max_val_will_accept Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
	di "`reg'"
	eststo: `reg'	
	** multe End_sr`nn1'_max_val_will_accept InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
	multe ME_sr`nn1'_max_val_will_accept Base_story1 Base_frame1 Block, treatment(InterventionGroup)	
}

** Numbers 
local numbers   
foreach i of numlist 1/$eststo_counter {
	local numbers `numbers' & (`i')
	** & (1) & (2) & (3) & ... & (n)
}

esttab using "${PathCodesOut}/OutcomeGameAcceptancesMax.tex", replace label f booktabs star(* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) ///
nonumbers prehead("`numbers' \\") /// 
mgroups("2-player" "3-player SB" "3-player SC", lhs("Game") pattern(1 0 1 0 1 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) ///
mlabels(none) ///
posthead("Survey & Midline & Endline & Midline & Endline & Midline & Endline \\ \midrule \\") ///
varlabels(Sn "Standard Nash" Ae "Altruistic Equitable" _cons "Control Mean") ///
drop(Base_story1 Base_frame1 Base_study_hour_total) /// 
stats(N r2, fmt(0 3) labels(`"Observations"' `"R-squared"'))

if 0 == 1 {
	esttab using "${PathCodesOut}/OutcomeGameAcceptancesMax.tex", replace label f booktabs star(* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) ///
	nonumbers prehead("`numbers' \\") /// 
	mgroups("2-player" "3-player SB" "3-player SC", lhs("Game") pattern(1 0 0 1 0 0 1 0 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) ///
	mlabels(none) ///
	posthead("Survey & Midline & Endline & Pooled & Midline & Endline & Pooled & Midline & Endline & Pooled  \\ \midrule \\") ///
	varlabels(Sn "Standard Nash" Ae "Altruistic Equitable" _cons "Control Mean") ///
	drop(Base_story1 Base_frame1 Base_study_hour_total) /// 
	stats(N r2, fmt(0 3) labels(`"Observations"' `"R-squared"'))
}

** 2.b.ii.i Game conditional acceptance/rejections by offer amount 
foreach ss in Mid End {
	foreach nn1 of num 1 / 3 {
		foreach nn2 of num 1 / 8 {
			local reg areg `ss'_sr`nn1'_option_`nn2' Sn Ae Base_story1 Base_frame1 Base_study_hour_total, absorb( Block ) vce( robust )
			di "`reg'"
			`reg'
			** multe `ss'_sr`nn1'_option_`nn2' InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
			multe `ss'_sr`nn1'_option_`nn2' Base_story1 Base_frame1 Block, treatment(InterventionGroup)
		}
	}
}

** 2.b.iii. Game expectations
foreach ss in Mid End {
	foreach nn1 of num 1 / 3 {
		foreach nn2 of num 1 / 8 {
			local reg areg `ss'_UG`nn1'_GuessedAcceptP_opt`nn2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
			di "`reg'"
			`reg'
			** multe `ss'_UG`nn1'_GuessedAcceptP_opt`nn2' InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
			multe `ss'_UG`nn1'_GuessedAcceptP_opt`nn2' Base_story1 Base_frame1 Block, treatment(InterventionGroup)
		}
	}
}

** --------------------------
** 4.a Treatment effects on main auxiliary outcomes - charity & equity
** --------------------------
eststo clear 
foreach ss2 in CharityHealthy CharityDisability CharityEquity {
	foreach ss in Mid End ME {
		local reg areg `ss'_`ss2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
		di "`reg'"
		eststo: `reg'
		** multe `ss'_`ss2' InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
		multe `ss'_`ss2' Base_story1 Base_frame1 Block, treatment(InterventionGroup)	
	}
}

** --------------------------
** 4.b Treatment effects on main auxiliary outcomes - psychosocial
** --------------------------
foreach ss2 in wellbeing_z1 wellbeing_z2 {
	foreach ss in Mid End ME {
		local reg areg `ss'_`ss2' Sn Ae Base_story1 Base_frame1, absorb( Block ) vce( robust )
		di "`reg'"
		eststo: `reg'
		** multe `ss'_`ss2' InterventionGroup, control(Base_story1 Base_frame1 Block) decompo minmax 
		multe `ss'_`ss2' Base_story1 Base_frame1 Block, treatment(InterventionGroup)	
	}
}

** Numbers 
local numbers   
foreach i of numlist 1/$eststo_counter {
	local numbers `numbers' & (`i')
	** & (1) & (2) & (3) & ... & (n)
}

esttab using "${PathCodesOut}/AuxOutcomes.tex", replace label f booktabs star(* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) ///
nonumbers prehead("`numbers' \\") /// 
mgroups("Charity Healthy" "Charity Disability" "Charity Equity" "Wellbeing 1" "Wellbeing 2", lhs("Outcomes") pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) ///
mlabels(none) ///
posthead("Survey & Midline & Endline & Pooled & Midline & Endline & Pooled & Midline & Endline & Pooled & Midline & Endline & Pooled & Midline & Endline & Pooled \\ \midrule \\") ///
varlabels(Sn "Standard Nash" Ae "Altruistic Equitable" _cons "Control Mean") ///
drop(Base_story1 Base_frame1) /// 
stats(N r2, fmt(0 3) labels(`"Observations"' `"R-squared"'))

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


timer off 1
*************************************
** Close workspace
*************************************
