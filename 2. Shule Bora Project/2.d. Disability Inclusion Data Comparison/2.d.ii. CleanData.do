** 20231209
** Clean UNICEF MICS data

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


**Translate Benin
use "${PathHome}\Data\Intermediate\UnicefMics\\Benin_cfm.dta", clear
	
	label variable hh1 "Cluster Number"
	label variable hh6 "Area"
	label variable hl4 "Sex"
	label variable fs10 "Consent"
	label variable cb3 "Age of child"
	label variable cb4 "Ever attended school or early childhood programme"
	label variable cb7 "Attended school or early childhood programme during current school year"
	label variable cb8a "Level of education attended current school year"
	label variable cb8b "Class attended during current schoool year"
	label variable fcf1 "Child wear glasses or contact lenses"
	label variable fcf2 "Child uses hearing aid"
	label variable fcf3 "Child uses any equipment or receive assistance for walking"
	label variable fcf6 "Child has difficulty seeing"
	label variable fcf8 "Child has difficulty hearing sounds like people voices or music"
	label variable fcf10 "Without using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf11 "Without using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf12 "When using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf13 "When using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf14 "Compared with children of the same age, child has difficulty walking 100 yards"
	label variable fcf15 "Compared with children of the same age, child has difficulty walking 500 yards"
	label variable fcf16 "Child has difficulty with self-care such as feeding or dressing"
	label variable fcf17 "Child has difficulty being understood by people inside of this household"
	label variable fcf18 "Child has difficulty being understood by people outside of this household"
	label variable fcf19 "Compared with children of the same age, child has difficulty learning things"
	label variable fcf20 "Compared with children of the same age, child has difficulty remembering things"
	label variable fcf21 "Child has difficulty concentrating on an activity that he/she enjoys"
	label variable fcf22 "Child has difficulty accepting changes in his/her routine"
	label variable fcf23 "Compared with children of the same age, child have difficulty controlling his/her behaviour"
	label variable fcf24 "Child has difficulty making friends"
	label variable fcf25 "How often child seems very anxious, nervous or worried"
	label variable fcf26 "How often child seems very sad or depressed"
	label variable wscore "Combined wealth score"
	label variable fsweight "Children 5-17's sample weight"
	label variable fshweight "Children 5-17's household sample weight"
	label variable psu "Primary sampling unit"
	
	keep hh1 hh6 hl4 fs10 cb3 cb4 cb7 cb8a cb8b fcf* wscore fsweight fshweight psu stratum
	save "${PathHome}\Data\Intermediate\UnicefMics\\Benin_cfm.dta", replace


local New ///
	Benin ///
	Eswatini ///
	Trinidad_and_Tobago ///
	Jamaica ///
	Yemen

foreach c in `New' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	count
}

foreach c in `New' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	rename (fcf1 fcf2 fcf3 fcf6 ///
		fcf8 fcf10 fcf11 fcf12 ///
		fcf13 fcf14 fcf15 fcf16 ///
		fcf17 fcf18 fcf19 fcf20 ///
		fcf21 fcf22 fcf23 fcf24 ///
		fcf25 fcf26) ///
		(cf1 cf4 cf7 cf3 ///
		cf6 cf8 cf9 cf10 ///
		cf11 cf12 cf13 cf14 ///
		cf15 cf16 cf17 cf18 ///
		cf19 cf20 cf21 cf22 ///
		cf23 cf24)

	order cf1 cf3 cf4 cf6 cf7 ///
		cf8 cf9 cf10 cf11 cf12 ///
		cf13 cf14 cf15 cf16 cf17 ///
		cf18 cf19 cf20 cf21 cf22 ///
		cf23 cf24

** * SEEING DOMAIN *
	gen SEE_IND = .
	replace SEE_IND = cf3
	
	gen Seeing_5to17 = 9
	replace Seeing_5to17 = 0 if inrange(SEE_IND, 1, 2)
	replace Seeing_5to17 = 1 if inrange(SEE_IND, 3, 4)
	label define see 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Seeing_5to17 see

** * HEARING DOMAIN *
	gen HEAR_IND = cf6
	tab HEAR_IND

	gen Hearing_5to17 = 9
	replace Hearing_5to17 = 0 if inrange(HEAR_IND, 1, 2)
	replace Hearing_5to17 = 1 if inrange(HEAR_IND, 3, 4)
	label define hear 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Hearing_5to17 hear

** * WALKING DOMAIN *
	gen WALK_IND1 = cf8
	replace WALK_IND1 = cf9 if cf8 == 2
	tab WALK_IND1

	gen WALK_IND2 = cf12
	replace WALK_IND2 = cf13 if (cf12 == 1 | cf12 == 2)
	tab WALK_IND2

	gen WALK_IND = WALK_IND1
	replace WALK_IND = WALK_IND2 if WALK_IND1 == .

	gen Walking_5to17 = 9
	replace Walking_5to17 = 0 if inrange(WALK_IND, 1, 2)
	replace Walking_5to17 = 1 if inrange(WALK_IND, 3, 4)
	label define walk 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Walking_5to17 walk 

** * SELFCARE DOMAIN *
	gen Selfcare_5to17 = 9
	replace Selfcare_5to17 = 0 if inrange(cf14, 1, 2)
	replace Selfcare_5to17 = 1 if inrange(cf14, 3, 4)
	label define selfcare 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Selfcare_5to17 selfcare

** * COMMUNICATING DOMAIN *
	gen COM_IND = 0
	replace COM_IND = 4 if (cf15 == 4 | cf16 == 4)
	replace COM_IND = 3 if (COM_IND != 4 & (cf15 == 3 | cf16 == 3))
	replace COM_IND = 2 if (COM_IND != 4 & COM_IND != 3 & (cf15 == 2 | cf16 == 2))
	replace COM_IND = 1 if (COM_IND != 4 & COM_IND != 3 & COM_IND != 1 & (cf15 == 1 | cf16 == 1))
	replace COM_IND = 9 if ((COM_IND == 2 | COM_IND == 1) & (cf15 == 9 | cf16 == 9))
	tab COM_IND

	gen Communication_5to17 = 9
	replace Communication_5to17 = 0 if inrange(COM_IND, 1, 2) 
	replace Communication_5to17 = 1 if inrange(COM_IND, 3, 4)
	label define communicate 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Communication_5to17 communicate

** * LEARNING DOMAIN *
	gen Learning_5to17 = 9
	replace Learning_5to17 = 0 if inrange(cf17, 1, 2)
	replace Learning_5to17 = 1 if inrange(cf17, 3, 4)
	label define learning 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Learning_5to17 learning

** * REMEMBERING DOMAIN *
	gen Remembering_5to17 = 9
	replace Remembering_5to17 = 0 if inrange(cf18, 1, 2)
	replace Remembering_5to17 = 1 if inrange(cf18, 3, 4)
	label define remembering 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Remembering_5to17 remembering

** * CONCENTRATING DOMAIN *
	gen Concentrating_5to17 = 9
	replace Concentrating_5to17 = 0 if inrange(cf19, 1, 2)
	replace Concentrating_5to17 = 1 if inrange(cf19, 3, 4)
	label define concentrating 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Concentrating_5to17 concentrating 

** * ACCEPTING CHANGE DOMAIN *
	gen AcceptingChange_5to17 = 9
	replace AcceptingChange_5to17 = 0 if inrange(cf20, 1, 2)
	replace AcceptingChange_5to17 = 1 if inrange(cf20, 3, 4)
	label define accepting 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value AcceptingChange_5to17 accepting

** * BEHAVIOUR DOMAIN *
	gen Behaviour_5to17 = 9
	replace Behaviour_5to17 = 0 if inrange(cf21, 1, 2)
	replace Behaviour_5to17 = 1 if inrange(cf21, 3, 4)
	label define behaviour 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Behaviour_5to17 behaviour

** * MAKING FRIENDS DOMAIN *
	gen MakingFriends_5to17 = 9
	replace MakingFriends_5to17 = 0 if inrange(cf22, 1, 2)
	replace MakingFriends_5to17 = 1 if inrange(cf22, 3, 4)
	label define friends 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value MakingFriends_5to17 friends

** * ANXIETY DOMAIN *
	gen Anxiety_5to17 = 9
	replace Anxiety_5to17 = 0 if inrange(cf23, 2, 5)
	replace Anxiety_5to17 = 1 if (cf23 == 1)
	label define anxiety 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Anxiety_5to17 anxiety

** * DEPRESSION DOMAIN *
	gen Depression_5to17 = 9
	replace Depression_5to17 = 0 if inrange(cf24, 2, 5)
	replace Depression_5to17 = 1 if (cf24 == 1)
	label define depression 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Depression_5to17 depression

** * PART TWO: Creating disability indicator for children age 5-17 years *

	gen FunctionalDifficulty_5to17 = 0
	replace FunctionalDifficulty_5to17 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
	replace FunctionalDifficulty_5to17 = 9 if (FunctionalDifficulty_5to17 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
	label define difficulty 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value FunctionalDifficulty_5to17 difficulty
	
** Create FunctionalDifficulty_5to17_Miss0, treating missing as '0'.

gen FunctionalDifficulty_5to17_Miss0 = 0
replace FunctionalDifficulty_5to17_Miss0 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
replace FunctionalDifficulty_5to17_Miss0 = 0 if (FunctionalDifficulty_5to17_Miss0 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
tab FunctionalDifficulty_5to17_Miss0

local variables ///
	Seeing_5to17 /// 
	Hearing_5to17 ///
	Walking_5to17 ///
	Selfcare_5to17 ///
	Communication_5to17 ///
	Learning_5to17 ///
	Remembering_5to17 ///
	Concentrating_5to17 ///
	AcceptingChange_5to17 ///
	Behaviour_5to17 ///
	Anxiety_5to17 ///
	Depression_5to17

foreach var in `variables' {
    gen `var'_IND_Miss0 = 0
    replace `var'_IND_Miss0 = 1 if `var' == 1
}

** Create FunctionalDifficulty_without, treating missing as '0' and removing anxiety/depression

gen FunctionalDifficulty_without = 0

replace FunctionalDifficulty_without = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1) 
replace FunctionalDifficulty_without = 0 if (FunctionalDifficulty_without != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9)) 
tab FunctionalDifficulty_without

/*---------------------------------------
** End: Code from 
** https://data.unicef.org/wp-content/uploads/2020/02/Stata-Syntax-for-the-Child-Functioning-Module_2020.02.25.docx
-----------------------------------------*/

/*---------------------------------------
** Local variables
-----------------------------------------*/
** cfM Domains - order of prevalence according to UNICEF (2021)
** https://data.unicef.org/resources/children-with-disabilities-report-2021/
	local CfmDomains ///
		01Anxiety ///
		02Depression ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability score ranges from 0 to 3
	local CfmScores
	local CfmScores_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Disability indicator is 0 or 1
	local CfmIndicators
	local CfmIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `CfmDomains' {
		local CfmScores `CfmScores' S`Str'Score
		local CfmScores_Miss0 `CfmScores_Miss0' S`Str'Score_Miss0
		local CfmIndicators `CfmIndicators' D`Str'
		local CfmIndicators_Miss0 `CfmIndicators_Miss0' D`Str'_Miss0
	}
	di "`CfmScores'"
	di "`CfmScores_Miss0'"
	di "`CfmIndicators'"
	di "`CfmIndicators_Miss0'"

** SS Domains
	local SsDomains ///
		05Walking ///
		07Remembering ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability indicator is 0 or 1
	local SsIndicators
	local SsIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `SsDomains' {
		local SsIndicators `SsIndicators' D`Str'
		local SsIndicators_Miss0 `SsIndicators_Miss0' D`Str'_Miss0
	}

*** cfM Domain Ids (which cf-IDs correspond to which domain) 
	local 01AnxietyIds cf23
	local 02DepressionIds cf24
	local 03BehaviourIds cf21
	local 04AcceptingChangeIds cf20
	local 05WalkingIds cf8 cf9 cf10 cf11 cf12 cf13
	local 06LearningIds cf17
	local 07RememberingIds cf18
	local 08MakingFriendsIds cf22
	local 09ConcentratingIds cf19
	local 10SelfcareIds cf14
	local 11CommunicationIds cf15 cf16
	local 12SeeingIds cf1 cf3
	local 13HearingIds cf4 cf6

/*----------------------
** S01 - S02: Anxiety and Depression scores
-----------------------*/
	foreach Dm in 01Anxiety 02Depression { // Dm stands for domain
	*** [1] First, generate S01AnxietyScore:
	**** ranges from 0 to 3 and set to missing if underlying resopnse is 
	**** 6 = "Refused", 7 = "Don't know", 999 = "Survey ended"
	**** , or refused survey altogether (19 students did not take survey).
		gen S`Dm'Score = .
		replace S`Dm'Score = 3 if ``Dm'Ids' == 1 // "Daily"
		replace S`Dm'Score = 2 if ``Dm'Ids' == 2 // "Weekly"
		replace S`Dm'Score = 1 if ``Dm'Ids' == 3 // "Monthly"
	** 4 = "A few times a year", 5 = "Never"
		replace S`Dm'Score = 0 if inrange( ``Dm'Ids', 4, 5 )
	*** [2] Generate S01AnxietyScore_Miss0:
	**** treats values 6, 7, and 999 as 0
		gen S`Dm'Score_Miss0 = S`Dm'Score
		replace S`Dm'Score_Miss0 = 0 if missing( S`Dm'Score ) & !missing( cf1 )
	*** [3] Generate D01Anxiety: indicator for daily suffering
		gen D`Dm' = ( S`Dm'Score == 3 ) if !missing( S`Dm'Score )
	*** [4] Generate D01Anxiety_Miss0: indicator for daily suffering
	****, treating responses 6-999 as 0
		gen D`Dm'_Miss0 = D`Dm' == 1 if !missing( cf1 )
	}
/*----------------------
** S03 - S13: Other scores
-----------------------*/
	foreach Dm in ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing { // Dm stands for DOMAIN
	*** [1] Generate S05WalkingScore
	**** Loop through cf responses belonging to this domain
		local `Dm'CfScores // Initialize 05WalkingCfScores variable list
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
		** Populate 05WalkingCfScores variable list
			local `Dm'CfScores ``Dm'CfScores' `Vb'Score
			gen `Vb'Score = `Vb' - 1
		** Variables before cf23: 5 = "Refused", 6 = "Don't know" - to missing
			replace `Vb'Score = . if inrange( `Vb', 5, 6 ) 
		}
		egen S`Dm'Score = rowmax( ``Dm'CfScores' )
	*** [2] Generate S05WalkingScore_Miss0
		local `Dm'CfScores_Miss0
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13'
			local `Dm'CfScores_Miss0 ``Dm'CfScores_Miss0' `Vb'Score_Miss0
			gen `Vb'Score_Miss0 = `Vb'Score
			replace `Vb'Score_Miss0 = 0 if inrange( `Vb', 5, 6 )		
		}
		egen S`Dm'Score_Miss0 = rowmax( ``Dm'CfScores_Miss0' )
	*** [3] Generate D05Walking
		gen D`Dm' = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13		
			replace D`Dm' = . if ( `Vb' == 5 ) | ( `Vb' == 6 )		
		}
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm' = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	*** [3] Generate D05Walking_Miss0
		gen D`Dm'_Miss0 = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm'_Miss0 = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	}
/*----------------------
** Total cfM score, max cfM score, severity
-----------------------*/
	order `CfmScores'
	egen TotalCfmScore = rowtotal( `CfmScores' ) if !missing( cf1 )
	egen MaxCfmScore = rowmax( `CfmScores' ) if !missing( cf1 )
	gen NoDisability = MaxCfmScore == 0 if !missing( cf1 )
	gen MildDisability = MaxCfmScore == 1 if !missing( cf1 )
	gen ModerateDisability = MaxCfmScore == 2 if !missing( cf1 )
	gen SevereDisability = MaxCfmScore == 3 if !missing( cf1 )

/*----------------------
** Match FunctionalDifficulty_5to17 = Moderate/Severe Disability_Miss0
-----------------------*/
gen ANXIETY_S = 0
replace ANXIETY_S = 3 if cf23 == 1
replace ANXIETY_S = 1 if cf23 == 2 | cf23 == 3 | cf23 == 4

gen DEPRESSION_S = 0
replace DEPRESSION_S = 3 if cf24 == 1
replace DEPRESSION_S = 1 if cf24 == 2 | cf24 == 3 | cf24 == 4

rename SEE_IND SEE_S
rename HEAR_IND HEAR_S
rename WALK_IND WALK_S
rename cf14 SELFCARE_S
rename COM_IND COMMUNICATION_S
rename cf17 LEARNING_S
rename cf18 REMEMBERING_S
rename cf19 CONCENTRATING_S
rename cf20 ACCEPTINGCHANGE_S
rename cf21 BEHAVIOUR_S
rename cf22 MAKINGFRIENDS_S

local rescore ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach r in `rescore' {
	replace `r' = 0 if `r' == 1
	replace `r' = 1 if `r' == 2
	replace `r' = 2 if `r' == 3
	replace `r' = 3 if `r' == 4
	replace `r' = 0 if `r' == 5 | `r' == 6 | `r' == 9 | `r' == 97
}

local CfmScores_Miss0 /// 
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S ///
	ANXIETY_S ///
	DEPRESSION_S 

egen TotalCfmScore_Miss0 = rowtotal( `CfmScores_Miss0' )
egen MaxCfmScore_Miss0 = rowmax( `CfmScores_Miss0' )
gen NoDisability_Miss0 = MaxCfmScore_Miss0 == 0
gen MildDisability_Miss0 = MaxCfmScore_Miss0 == 1
gen ModerateDisability_Miss0 = MaxCfmScore_Miss0 == 2
gen SevereDisability_Miss0 = MaxCfmScore_Miss0 == 3 

/*----------------------
** Match FunctionalDifficulty_without = Moderate/Severe Disability_without
-----------------------*/
local rescore_without ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach a in `rescore_without' {
	gen `a'_without = 0
	replace `a'_without = 0 if `a' == 0
	replace `a'_without = 1 if `a' == 1
	replace `a'_without = 2 if `a' == 2
	replace `a'_without = 3 if `a' == 3
}

local CfmScores_without /// 
	SEE_S_without ///
	HEAR_S_without ///
	WALK_S_without ///
	SELFCARE_S_without ///
	COMMUNICATION_S_without ///
	LEARNING_S_without ///
	REMEMBERING_S_without ///
	CONCENTRATING_S_without ///
	ACCEPTINGCHANGE_S_without ///
	BEHAVIOUR_S_without ///
	MAKINGFRIENDS_S_without
	
egen TotalCfmScore_without = rowtotal( `CfmScores_without' )	
egen MaxCfmScore_without = rowmax( `CfmScores_without' )
gen NoDisability_without = MaxCfmScore_without == 0
gen MildDisability_without = MaxCfmScore_without == 1
gen ModerateDisability_without = MaxCfmScore_without == 2
gen SevereDisability_without = MaxCfmScore_without == 3

/*----------------------
** Total cfM Indicator, max cfM indicator
-----------------------*/
	order `CfmIndicators'
	egen TotalCfmIndicator = rowtotal( `CfmIndicators' ) if !missing( cf1 )
	egen MaxCfmIndicator = rowmax( `CfmIndicators' ) if !missing( cf1 )
/*----------------------
** Harmonizing with ASC
-----------------------*/

	gen Physical = 0 if !missing( cf1 )
	replace Physical = 1 if (D05Walking == 1) | (D10Selfcare ==1)

	gen Lowvision = 0 if !missing( cf1 )
	replace Lowvision = 1 if S12SeeingScore == 2

	gen Blind = 0 if !missing( cf1 )
	replace Blind = 1 if S12SeeingScore == 3

	gen Lowhearing = 0 if !missing( cf1 )
	replace Lowhearing = 1 if S13HearingScore == 2

	gen Deaf = 0 if !missing( cf1 )
	replace Deaf = 1 if S13HearingScore == 3

	gen Deafblind = 0 if !missing( cf1 )
	replace Deafblind = 1 if (Blind == 1) & (Deaf == 1)

	tab D02Depression
	gen Intellectual = 0 if !missing( cf1 )
	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// 
		| ( D04AcceptingChange == 1 & D01Anxiety != 1 ) /// 
		| ( D04AcceptingChange != 1 & D01Anxiety == 1 ) // mood & behavior

/*
Autism is constrcted by the combintaion of daily anxiety 
and inacapacity to accepting changes in the routine.
*/

	gen Autism = 0 if !missing( cf1 )
	replace Autism = 1 if (D04AcceptingChange ==1) & (D01Anxiety ==1) 

	gen Multiple = 0 if !missing( cf1 )
	replace Multiple = Physical + Lowvision + Blind + Lowhearing + Deaf > 1
	replace Multiple = . if missing( cf1 )

**Generating exclusive indicators
	gen exPhysical = Physical == 1 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exLowvision = Physical == 0 & Lowvision == 1 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exBlind = Physical == 0 & Lowvision == 0 & Blind == 1 & Lowhearing == 0 & Deaf == 0
	gen exLowhearing = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 1 & Deaf == 0
	gen exDeaf = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 1
	gen exAutism = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 1
	gen exIntellectual = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 0 & Intellectual == 1

	local exlist ///
		exPhysical ///
		exLowvision ///
		exBlind ///
		exLowhearing ///
		exDeaf ///
		exAutism ///
		exIntellectual
	
	foreach vb in `exlist' {
		replace `vb'=. if missing( cf1 )
	}


	gen exCognitive = 0 if !missing( cf1 )
	replace exCognitive = 1 if exIntellectual == 1 & (0 ///
		| ( D06Learning == 1 ) /// cognitive
		| ( D07Remembering == 1 ) /// cognitive
		| ( D09Concentrating == 1) ///
		| ( D11Communication == 1))
	
	gen exMoodBehavioral = 0 if !missing( cf1 )
	replace exMoodBehavioral = 1 if exIntellectual == 1 & exCognitive == 0

	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// cognitive
		| ( D04AcceptingChange == 1 & D01Anxiety !=1 ) /// mood & behavior
		| ( D04AcceptingChange != 1 & D01Anxiety ==1 ) // mood & behavior


**Generating exclusive total and comparing with original total
	gen exTotal = 0 if !missing( cf1 )
	replace exTotal = 1 if 0 ///
		| (exPhysical == 1) ///
		| (exLowvision == 1) ///
		| (exBlind == 1) ///
		| (exLowhearing == 1) ///
		| (exDeaf == 1) ///
		| (Deafblind == 1) ///
		| (exIntellectual == 1) ///
		| (exAutism == 1) ///
		| (Multiple == 1)

	gen Total = 0 if !missing( cf1 )
	replace Total = 1 if 0 ///
		| (Physical ==1) ///
		| (Lowvision ==1) ///
		| (Blind ==1) ///
		| (Lowhearing ==1) ///
		| (Deaf ==1) ///
		| (Deafblind ==1) ///
		| (Intellectual ==1) ///
		| (Autism == 1) ///
		| (Multiple == 1)

	compare Total exTotal

	tab FunctionalDifficulty_5to17

	local Indicators ///
		D01Anxiety ///
		D02Depression ///
		D03Behaviour ///
		D04AcceptingChange ///
		D05Walking ///
		D06Learning ///
		D07Remembering ///
		D08MakingFriends ///
		D09Concentrating ///
		D10Selfcare ///
		D11Communication ///
		D12Seeing ///
		D13Hearing
	
	tokenize ///
		Anxiety ///
		Depression ///
		Behaviour ///
		AcceptingChange ///
		Walking ///
		Learning ///
		Remembering ///
		MakingFriends ///
		Concentrating ///
		Selfcare ///
		Communication ///
		Seeing ///
		Hearing 
	
	local Nb = 0

	foreach i in `Indicators' {
		local Nb = `Nb' + 1
		gen ``Nb'' = `i' * 100
	}
		
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
	
**Generate country name
	gen country = "`c'"
	save "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_`c'.dta", replace
}

*************************************
** Translate French version to English
*************************************
**Countries need translation: Algeria, Madagascar, Sao Tome and Principe,
**Central African Republic, Guinea Bissau, Togo, Chad, DRCongo

local Translation ///
	Algeria ///
	Madagascar ///
	Sao_Tome_and_Principe ///
	Central_African_Republic ///
	Guinea_Bissau ///
	Togo ///
	Chad ///
	DRCongo 

foreach t in `Translation' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`t'_cfm.dta", clear
	
	label variable hh1 "Cluster Number"
	label variable hh6 "Area"
	label variable hl4 "Sex"
	label variable fs10 "Consent"
	label variable cb3 "Age of child"
	label variable cb4 "Ever attended school or early childhood programme"
	label variable cb7 "Attended school or early childhood programme during current school year"
	label variable cb8a "Level of education attended current school year"
	label variable cb8b "Class attended during current schoool year"
	label variable fcf1 "Child wear glasses or contact lenses"
	label variable fcf2 "Child uses hearing aid"
	label variable fcf3 "Child uses any equipment or receive assistance for walking"
	label variable fcf6 "Child has difficulty seeing"
	label variable fcf8 "Child has difficulty hearing sounds like people voices or music"
	label variable fcf10 "Without using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf11 "Without using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf12 "When using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf13 "When using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf14 "Compared with children of the same age, child has difficulty walking 100 yards"
	label variable fcf15 "Compared with children of the same age, child has difficulty walking 500 yards"
	label variable fcf16 "Child has difficulty with self-care such as feeding or dressing"
	label variable fcf17 "Child has difficulty being understood by people inside of this household"
	label variable fcf18 "Child has difficulty being understood by people outside of this household"
	label variable fcf19 "Compared with children of the same age, child has difficulty learning things"
	label variable fcf20 "Compared with children of the same age, child has difficulty remembering things"
	label variable fcf21 "Child has difficulty concentrating on an activity that he/she enjoys"
	label variable fcf22 "Child has difficulty accepting changes in his/her routine"
	label variable fcf23 "Compared with children of the same age, child have difficulty controlling his/her behaviour"
	label variable fcf24 "Child has difficulty making friends"
	label variable fcf25 "How often child seems very anxious, nervous or worried"
	label variable fcf26 "How often child seems very sad or depressed"
	label variable wscore "Combined wealth score"
	label variable fsweight "Children 5-17's sample weight"
	label variable fshweight "Children 5-17's household sample weight"
	label variable psu "Primary sampling unit"
	
	keep hh1 hh6 hl4 fs10 cb3 cb4 cb7 cb8a cb8b fcf* wscore fsweight fshweight psu stratum
	save "${PathHome}\Data\Intermediate\UnicefMics\\`t'_cfm.dta", replace
}

*************************************
** ESA (Eastern and Southern Africa) & 
** WCA (West and Central Africa) & North Africa
*************************************
local Africa ///
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
	DRCongo 

foreach c in `Africa' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	count
}


foreach c in `Africa' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	rename (fcf1 fcf2 fcf3 fcf6 ///
		fcf8 fcf10 fcf11 fcf12 ///
		fcf13 fcf14 fcf15 fcf16 ///
		fcf17 fcf18 fcf19 fcf20 ///
		fcf21 fcf22 fcf23 fcf24 ///
		fcf25 fcf26) ///
		(cf1 cf4 cf7 cf3 ///
		cf6 cf8 cf9 cf10 ///
		cf11 cf12 cf13 cf14 ///
		cf15 cf16 cf17 cf18 ///
		cf19 cf20 cf21 cf22 ///
		cf23 cf24)

	order cf1 cf3 cf4 cf6 cf7 ///
		cf8 cf9 cf10 cf11 cf12 ///
		cf13 cf14 cf15 cf16 cf17 ///
		cf18 cf19 cf20 cf21 cf22 ///
		cf23 cf24

** * SEEING DOMAIN *
	gen SEE_IND = .
	replace SEE_IND = cf3
	
	gen Seeing_5to17 = 9
	replace Seeing_5to17 = 0 if inrange(SEE_IND, 1, 2)
	replace Seeing_5to17 = 1 if inrange(SEE_IND, 3, 4)
	label define see 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Seeing_5to17 see

** * HEARING DOMAIN *
	gen HEAR_IND = cf6
	tab HEAR_IND

	gen Hearing_5to17 = 9
	replace Hearing_5to17 = 0 if inrange(HEAR_IND, 1, 2)
	replace Hearing_5to17 = 1 if inrange(HEAR_IND, 3, 4)
	label define hear 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Hearing_5to17 hear

** * WALKING DOMAIN *
	gen WALK_IND1 = cf8
	replace WALK_IND1 = cf9 if cf8 == 2
	tab WALK_IND1

	gen WALK_IND2 = cf12
	replace WALK_IND2 = cf13 if (cf12 == 1 | cf12 == 2)
	tab WALK_IND2

	gen WALK_IND = WALK_IND1
	replace WALK_IND = WALK_IND2 if WALK_IND1 == .

	gen Walking_5to17 = 9
	replace Walking_5to17 = 0 if inrange(WALK_IND, 1, 2)
	replace Walking_5to17 = 1 if inrange(WALK_IND, 3, 4)
	label define walk 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Walking_5to17 walk 

** * SELFCARE DOMAIN *
	gen Selfcare_5to17 = 9
	replace Selfcare_5to17 = 0 if inrange(cf14, 1, 2)
	replace Selfcare_5to17 = 1 if inrange(cf14, 3, 4)
	label define selfcare 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Selfcare_5to17 selfcare

** * COMMUNICATING DOMAIN *
	gen COM_IND = 0
	replace COM_IND = 4 if (cf15 == 4 | cf16 == 4)
	replace COM_IND = 3 if (COM_IND != 4 & (cf15 == 3 | cf16 == 3))
	replace COM_IND = 2 if (COM_IND != 4 & COM_IND != 3 & (cf15 == 2 | cf16 == 2))
	replace COM_IND = 1 if (COM_IND != 4 & COM_IND != 3 & COM_IND != 1 & (cf15 == 1 | cf16 == 1))
	replace COM_IND = 9 if ((COM_IND == 2 | COM_IND == 1) & (cf15 == 9 | cf16 == 9))
	tab COM_IND

	gen Communication_5to17 = 9
	replace Communication_5to17 = 0 if inrange(COM_IND, 1, 2) 
	replace Communication_5to17 = 1 if inrange(COM_IND, 3, 4)
	label define communicate 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Communication_5to17 communicate

** * LEARNING DOMAIN *
	gen Learning_5to17 = 9
	replace Learning_5to17 = 0 if inrange(cf17, 1, 2)
	replace Learning_5to17 = 1 if inrange(cf17, 3, 4)
	label define learning 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Learning_5to17 learning

** * REMEMBERING DOMAIN *
	gen Remembering_5to17 = 9
	replace Remembering_5to17 = 0 if inrange(cf18, 1, 2)
	replace Remembering_5to17 = 1 if inrange(cf18, 3, 4)
	label define remembering 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Remembering_5to17 remembering

** * CONCENTRATING DOMAIN *
	gen Concentrating_5to17 = 9
	replace Concentrating_5to17 = 0 if inrange(cf19, 1, 2)
	replace Concentrating_5to17 = 1 if inrange(cf19, 3, 4)
	label define concentrating 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Concentrating_5to17 concentrating 

** * ACCEPTING CHANGE DOMAIN *
	gen AcceptingChange_5to17 = 9
	replace AcceptingChange_5to17 = 0 if inrange(cf20, 1, 2)
	replace AcceptingChange_5to17 = 1 if inrange(cf20, 3, 4)
	label define accepting 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value AcceptingChange_5to17 accepting

** * BEHAVIOUR DOMAIN *
	gen Behaviour_5to17 = 9
	replace Behaviour_5to17 = 0 if inrange(cf21, 1, 2)
	replace Behaviour_5to17 = 1 if inrange(cf21, 3, 4)
	label define behaviour 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Behaviour_5to17 behaviour

** * MAKING FRIENDS DOMAIN *
	gen MakingFriends_5to17 = 9
	replace MakingFriends_5to17 = 0 if inrange(cf22, 1, 2)
	replace MakingFriends_5to17 = 1 if inrange(cf22, 3, 4)
	label define friends 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value MakingFriends_5to17 friends

** * ANXIETY DOMAIN *
	gen Anxiety_5to17 = 9
	replace Anxiety_5to17 = 0 if inrange(cf23, 2, 5)
	replace Anxiety_5to17 = 1 if (cf23 == 1)
	label define anxiety 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Anxiety_5to17 anxiety

** * DEPRESSION DOMAIN *
	gen Depression_5to17 = 9
	replace Depression_5to17 = 0 if inrange(cf24, 2, 5)
	replace Depression_5to17 = 1 if (cf24 == 1)
	label define depression 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Depression_5to17 depression

** * PART TWO: Creating disability indicator for children age 5-17 years *

	gen FunctionalDifficulty_5to17 = 0
	replace FunctionalDifficulty_5to17 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
	replace FunctionalDifficulty_5to17 = 9 if (FunctionalDifficulty_5to17 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
	label define difficulty 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value FunctionalDifficulty_5to17 difficulty
	
** Create FunctionalDifficulty_5to17_Miss0, treating missing as '0'.

gen FunctionalDifficulty_5to17_Miss0 = 0
replace FunctionalDifficulty_5to17_Miss0 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
replace FunctionalDifficulty_5to17_Miss0 = 0 if (FunctionalDifficulty_5to17_Miss0 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
tab FunctionalDifficulty_5to17_Miss0

local variables ///
	Seeing_5to17 /// 
	Hearing_5to17 ///
	Walking_5to17 ///
	Selfcare_5to17 ///
	Communication_5to17 ///
	Learning_5to17 ///
	Remembering_5to17 ///
	Concentrating_5to17 ///
	AcceptingChange_5to17 ///
	Behaviour_5to17 ///
	Anxiety_5to17 ///
	Depression_5to17

foreach var in `variables' {
    gen `var'_IND_Miss0 = 0
    replace `var'_IND_Miss0 = 1 if `var' == 1
}

** Create FunctionalDifficulty_without, treating missing as '0' and removing anxiety/depression

gen FunctionalDifficulty_without = 0

replace FunctionalDifficulty_without = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1) 
replace FunctionalDifficulty_without = 0 if (FunctionalDifficulty_without != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9)) 
tab FunctionalDifficulty_without

/*---------------------------------------
** End: Code from 
** https://data.unicef.org/wp-content/uploads/2020/02/Stata-Syntax-for-the-Child-Functioning-Module_2020.02.25.docx
-----------------------------------------*/

/*---------------------------------------
** Local variables
-----------------------------------------*/
** cfM Domains - order of prevalence according to UNICEF (2021)
** https://data.unicef.org/resources/children-with-disabilities-report-2021/
	local CfmDomains ///
		01Anxiety ///
		02Depression ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability score ranges from 0 to 3
	local CfmScores
	local CfmScores_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Disability indicator is 0 or 1
	local CfmIndicators
	local CfmIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `CfmDomains' {
		local CfmScores `CfmScores' S`Str'Score
		local CfmScores_Miss0 `CfmScores_Miss0' S`Str'Score_Miss0
		local CfmIndicators `CfmIndicators' D`Str'
		local CfmIndicators_Miss0 `CfmIndicators_Miss0' D`Str'_Miss0
	}
	di "`CfmScores'"
	di "`CfmScores_Miss0'"
	di "`CfmIndicators'"
	di "`CfmIndicators_Miss0'"

** SS Domains
	local SsDomains ///
		05Walking ///
		07Remembering ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability indicator is 0 or 1
	local SsIndicators
	local SsIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `SsDomains' {
		local SsIndicators `SsIndicators' D`Str'
		local SsIndicators_Miss0 `SsIndicators_Miss0' D`Str'_Miss0
	}

*** cfM Domain Ids (which cf-IDs correspond to which domain) 
	local 01AnxietyIds cf23
	local 02DepressionIds cf24
	local 03BehaviourIds cf21
	local 04AcceptingChangeIds cf20
	local 05WalkingIds cf8 cf9 cf10 cf11 cf12 cf13
	local 06LearningIds cf17
	local 07RememberingIds cf18
	local 08MakingFriendsIds cf22
	local 09ConcentratingIds cf19
	local 10SelfcareIds cf14
	local 11CommunicationIds cf15 cf16
	local 12SeeingIds cf1 cf3
	local 13HearingIds cf4 cf6

/*----------------------
** S01 - S02: Anxiety and Depression scores
-----------------------*/
	foreach Dm in 01Anxiety 02Depression { // Dm stands for domain
	*** [1] First, generate S01AnxietyScore:
	**** ranges from 0 to 3 and set to missing if underlying resopnse is 
	**** 6 = "Refused", 7 = "Don't know", 999 = "Survey ended"
	**** , or refused survey altogether (19 students did not take survey).
		gen S`Dm'Score = .
		replace S`Dm'Score = 3 if ``Dm'Ids' == 1 // "Daily"
		replace S`Dm'Score = 2 if ``Dm'Ids' == 2 // "Weekly"
		replace S`Dm'Score = 1 if ``Dm'Ids' == 3 // "Monthly"
	** 4 = "A few times a year", 5 = "Never"
		replace S`Dm'Score = 0 if inrange( ``Dm'Ids', 4, 5 )
	*** [2] Generate S01AnxietyScore_Miss0:
	**** treats values 6, 7, and 999 as 0
		gen S`Dm'Score_Miss0 = S`Dm'Score
		replace S`Dm'Score_Miss0 = 0 if missing( S`Dm'Score ) & !missing( cf1 )
	*** [3] Generate D01Anxiety: indicator for daily suffering
		gen D`Dm' = ( S`Dm'Score == 3 ) if !missing( S`Dm'Score )
	*** [4] Generate D01Anxiety_Miss0: indicator for daily suffering
	****, treating responses 6-999 as 0
		gen D`Dm'_Miss0 = D`Dm' == 1 if !missing( cf1 )
	}
/*----------------------
** S03 - S13: Other scores
-----------------------*/
	foreach Dm in ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing { // Dm stands for DOMAIN
	*** [1] Generate S05WalkingScore
	**** Loop through cf responses belonging to this domain
		local `Dm'CfScores // Initialize 05WalkingCfScores variable list
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
		** Populate 05WalkingCfScores variable list
			local `Dm'CfScores ``Dm'CfScores' `Vb'Score
			gen `Vb'Score = `Vb' - 1
		** Variables before cf23: 5 = "Refused", 6 = "Don't know" - to missing
			replace `Vb'Score = . if inrange( `Vb', 5, 6 ) 
		}
		egen S`Dm'Score = rowmax( ``Dm'CfScores' )
	*** [2] Generate S05WalkingScore_Miss0
		local `Dm'CfScores_Miss0
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13'
			local `Dm'CfScores_Miss0 ``Dm'CfScores_Miss0' `Vb'Score_Miss0
			gen `Vb'Score_Miss0 = `Vb'Score
			replace `Vb'Score_Miss0 = 0 if inrange( `Vb', 5, 6 )		
		}
		egen S`Dm'Score_Miss0 = rowmax( ``Dm'CfScores_Miss0' )
	*** [3] Generate D05Walking
		gen D`Dm' = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13		
			replace D`Dm' = . if ( `Vb' == 5 ) | ( `Vb' == 6 )		
		}
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm' = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	*** [3] Generate D05Walking_Miss0
		gen D`Dm'_Miss0 = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm'_Miss0 = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	}
/*----------------------
** Total cfM score, max cfM score, severity
-----------------------*/
	order `CfmScores'
	egen TotalCfmScore = rowtotal( `CfmScores' ) if !missing( cf1 )
	egen MaxCfmScore = rowmax( `CfmScores' ) if !missing( cf1 )
	gen NoDisability = MaxCfmScore == 0 if !missing( cf1 )
	gen MildDisability = MaxCfmScore == 1 if !missing( cf1 )
	gen ModerateDisability = MaxCfmScore == 2 if !missing( cf1 )
	gen SevereDisability = MaxCfmScore == 3 if !missing( cf1 )

/*----------------------
** Match FunctionalDifficulty_5to17 = Moderate/Severe Disability_Miss0
-----------------------*/
gen ANXIETY_S = 0
replace ANXIETY_S = 3 if cf23 == 1
replace ANXIETY_S = 1 if cf23 == 2 | cf23 == 3 | cf23 == 4

gen DEPRESSION_S = 0
replace DEPRESSION_S = 3 if cf24 == 1
replace DEPRESSION_S = 1 if cf24 == 2 | cf24 == 3 | cf24 == 4

rename SEE_IND SEE_S
rename HEAR_IND HEAR_S
rename WALK_IND WALK_S
rename cf14 SELFCARE_S
rename COM_IND COMMUNICATION_S
rename cf17 LEARNING_S
rename cf18 REMEMBERING_S
rename cf19 CONCENTRATING_S
rename cf20 ACCEPTINGCHANGE_S
rename cf21 BEHAVIOUR_S
rename cf22 MAKINGFRIENDS_S

local rescore ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach r in `rescore' {
	replace `r' = 0 if `r' == 1
	replace `r' = 1 if `r' == 2
	replace `r' = 2 if `r' == 3
	replace `r' = 3 if `r' == 4
	replace `r' = 0 if `r' == 5 | `r' == 6 | `r' == 9 | `r' == 97
}

local CfmScores_Miss0 /// 
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S ///
	ANXIETY_S ///
	DEPRESSION_S 

egen TotalCfmScore_Miss0 = rowtotal( `CfmScores_Miss0' )
egen MaxCfmScore_Miss0 = rowmax( `CfmScores_Miss0' )
gen NoDisability_Miss0 = MaxCfmScore_Miss0 == 0
gen MildDisability_Miss0 = MaxCfmScore_Miss0 == 1
gen ModerateDisability_Miss0 = MaxCfmScore_Miss0 == 2
gen SevereDisability_Miss0 = MaxCfmScore_Miss0 == 3 

/*----------------------
** Match FunctionalDifficulty_without = Moderate/Severe Disability_without
-----------------------*/
local rescore_without ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach a in `rescore_without' {
	gen `a'_without = 0
	replace `a'_without = 0 if `a' == 0
	replace `a'_without = 1 if `a' == 1
	replace `a'_without = 2 if `a' == 2
	replace `a'_without = 3 if `a' == 3
}

local CfmScores_without /// 
	SEE_S_without ///
	HEAR_S_without ///
	WALK_S_without ///
	SELFCARE_S_without ///
	COMMUNICATION_S_without ///
	LEARNING_S_without ///
	REMEMBERING_S_without ///
	CONCENTRATING_S_without ///
	ACCEPTINGCHANGE_S_without ///
	BEHAVIOUR_S_without ///
	MAKINGFRIENDS_S_without
	
egen TotalCfmScore_without = rowtotal( `CfmScores_without' )	
egen MaxCfmScore_without = rowmax( `CfmScores_without' )
gen NoDisability_without = MaxCfmScore_without == 0
gen MildDisability_without = MaxCfmScore_without == 1
gen ModerateDisability_without = MaxCfmScore_without == 2
gen SevereDisability_without = MaxCfmScore_without == 3

/*----------------------
** Total cfM Indicator, max cfM indicator
-----------------------*/
	order `CfmIndicators'
	egen TotalCfmIndicator = rowtotal( `CfmIndicators' ) if !missing( cf1 )
	egen MaxCfmIndicator = rowmax( `CfmIndicators' ) if !missing( cf1 )
/*----------------------
** Harmonizing with ASC
-----------------------*/

	gen Physical = 0 if !missing( cf1 )
	replace Physical = 1 if (D05Walking == 1) | (D10Selfcare ==1)

	gen Lowvision = 0 if !missing( cf1 )
	replace Lowvision = 1 if S12SeeingScore == 2

	gen Blind = 0 if !missing( cf1 )
	replace Blind = 1 if S12SeeingScore == 3

	gen Lowhearing = 0 if !missing( cf1 )
	replace Lowhearing = 1 if S13HearingScore == 2

	gen Deaf = 0 if !missing( cf1 )
	replace Deaf = 1 if S13HearingScore == 3

	gen Deafblind = 0 if !missing( cf1 )
	replace Deafblind = 1 if (Blind == 1) & (Deaf == 1)

	tab D02Depression
	gen Intellectual = 0 if !missing( cf1 )
	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// 
		| ( D04AcceptingChange == 1 & D01Anxiety != 1 ) /// 
		| ( D04AcceptingChange != 1 & D01Anxiety == 1 ) // mood & behavior

/*
Autism is constrcted by the combintaion of daily anxiety 
and inacapacity to accepting changes in the routine.
*/

	gen Autism = 0 if !missing( cf1 )
	replace Autism = 1 if (D04AcceptingChange ==1) & (D01Anxiety ==1) 

	gen Multiple = 0 if !missing( cf1 )
	replace Multiple = Physical + Lowvision + Blind + Lowhearing + Deaf > 1
	replace Multiple = . if missing( cf1 )

**Generating exclusive indicators
	gen exPhysical = Physical == 1 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exLowvision = Physical == 0 & Lowvision == 1 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exBlind = Physical == 0 & Lowvision == 0 & Blind == 1 & Lowhearing == 0 & Deaf == 0
	gen exLowhearing = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 1 & Deaf == 0
	gen exDeaf = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 1
	gen exAutism = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 1
	gen exIntellectual = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 0 & Intellectual == 1

	local exlist ///
		exPhysical ///
		exLowvision ///
		exBlind ///
		exLowhearing ///
		exDeaf ///
		exAutism ///
		exIntellectual
	
	foreach vb in `exlist' {
		replace `vb'=. if missing( cf1 )
	}


	gen exCognitive = 0 if !missing( cf1 )
	replace exCognitive = 1 if exIntellectual == 1 & (0 ///
		| ( D06Learning == 1 ) /// cognitive
		| ( D07Remembering == 1 ) /// cognitive
		| ( D09Concentrating == 1) ///
		| ( D11Communication == 1))
	
	gen exMoodBehavioral = 0 if !missing( cf1 )
	replace exMoodBehavioral = 1 if exIntellectual == 1 & exCognitive == 0

	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// cognitive
		| ( D04AcceptingChange == 1 & D01Anxiety !=1 ) /// mood & behavior
		| ( D04AcceptingChange != 1 & D01Anxiety ==1 ) // mood & behavior


**Generating exclusive total and comparing with original total
	gen exTotal = 0 if !missing( cf1 )
	replace exTotal = 1 if 0 ///
		| (exPhysical == 1) ///
		| (exLowvision == 1) ///
		| (exBlind == 1) ///
		| (exLowhearing == 1) ///
		| (exDeaf == 1) ///
		| (Deafblind == 1) ///
		| (exIntellectual == 1) ///
		| (exAutism == 1) ///
		| (Multiple == 1)

	gen Total = 0 if !missing( cf1 )
	replace Total = 1 if 0 ///
		| (Physical ==1) ///
		| (Lowvision ==1) ///
		| (Blind ==1) ///
		| (Lowhearing ==1) ///
		| (Deaf ==1) ///
		| (Deafblind ==1) ///
		| (Intellectual ==1) ///
		| (Autism == 1) ///
		| (Multiple == 1)

	compare Total exTotal

	tab FunctionalDifficulty_5to17

	local Indicators ///
		D01Anxiety ///
		D02Depression ///
		D03Behaviour ///
		D04AcceptingChange ///
		D05Walking ///
		D06Learning ///
		D07Remembering ///
		D08MakingFriends ///
		D09Concentrating ///
		D10Selfcare ///
		D11Communication ///
		D12Seeing ///
		D13Hearing
	
	tokenize ///
		Anxiety ///
		Depression ///
		Behaviour ///
		AcceptingChange ///
		Walking ///
		Learning ///
		Remembering ///
		MakingFriends ///
		Concentrating ///
		Selfcare ///
		Communication ///
		Seeing ///
		Hearing 
	
	local Nb = 0

	foreach i in `Indicators' {
		local Nb = `Nb' + 1
		gen ``Nb'' = `i' * 100
	}
		
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
	
**Generate country name
	gen country = "`c'"
	save "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_`c'.dta", replace
}


*************************************
** ME (Middle East)
** & ECA (Europe and Central Asia)
*************************************

local MEECA ///
	State_of_Palestine ///
	Iraq ///
	Uzbekistan /// 2
	Kosovo_(UNSCR_1244) /// Kosovo under UNSC res. 1244
	Kosovo_(UNSCR_1244)_(Roma,_Ashkali_and_Egyptian_Communities) /// Kosovo under UNSC res. 1244 (Roma, Ashkali, and Egyptian Communities)
	Belarus ///
	Serbia /// Serbia
	Serbia_(Roma_Settlements) /// Serbia (Roma Settlements)
	Turkmenistan ///
	Republic_of_North_Macedonia /// Rep. of North Macedonia
	Republic_of_North_Macedonia_(Roma_Settlements) /// Roma Settlements
	Georgia ///
	Kyrgyzstan ///
	Montenegro /// Montenegro
	Montenegro_(Roma_Settlements) /// Roma Settlements

foreach c in `MEECA' {
	use "${PathDataIntermediate}\\`c'_cfm.dta", clear
	count
}

foreach c in `MEECA' {
	use "${PathDataIntermediate}\\`c'_cfm.dta", clear
	rename (fcf1 fcf2 fcf3 fcf6 ///
		fcf8 fcf10 fcf11 fcf12 ///
		fcf13 fcf14 fcf15 fcf16 ///
		fcf17 fcf18 fcf19 fcf20 ///
		fcf21 fcf22 fcf23 fcf24 ///
		fcf25 fcf26) ///
		(cf1 cf4 cf7 cf3 ///
		cf6 cf8 cf9 cf10 ///
		cf11 cf12 cf13 cf14 ///
		cf15 cf16 cf17 cf18 ///
		cf19 cf20 cf21 cf22 ///
		cf23 cf24)

	order cf1 cf3 cf4 cf6 cf7 ///
		cf8 cf9 cf10 cf11 cf12 ///
		cf13 cf14 cf15 cf16 cf17 ///
		cf18 cf19 cf20 cf21 cf22 ///
		cf23 cf24

** * SEEING DOMAIN *
	gen SEE_IND = .
	replace SEE_IND = cf3
	

	gen Seeing_5to17 = 9
	replace Seeing_5to17 = 0 if inrange(SEE_IND, 1, 2)
	replace Seeing_5to17 = 1 if inrange(SEE_IND, 3, 4)
	label define see 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Seeing_5to17 see

** * HEARING DOMAIN *
	gen HEAR_IND = cf6
	tab HEAR_IND

	gen Hearing_5to17 = 9
	replace Hearing_5to17 = 0 if inrange(HEAR_IND, 1, 2)
	replace Hearing_5to17 = 1 if inrange(HEAR_IND, 3, 4)
	label define hear 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Hearing_5to17 hear

** * WALKING DOMAIN *
	gen WALK_IND1 = cf8
	replace WALK_IND1 = cf9 if cf8 == 2
	tab WALK_IND1

	gen WALK_IND2 = cf12
	replace WALK_IND2 = cf13 if (cf12 == 1 | cf12 == 2)
	tab WALK_IND2

	gen WALK_IND = WALK_IND1
	replace WALK_IND = WALK_IND2 if WALK_IND1 == .

	gen Walking_5to17 = 9
	replace Walking_5to17 = 0 if inrange(WALK_IND, 1, 2)
	replace Walking_5to17 = 1 if inrange(WALK_IND, 3, 4)
	label define walk 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Walking_5to17 walk 

** * SELFCARE DOMAIN *
	gen Selfcare_5to17 = 9
	replace Selfcare_5to17 = 0 if inrange(cf14, 1, 2)
	replace Selfcare_5to17 = 1 if inrange(cf14, 3, 4)
	label define selfcare 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Selfcare_5to17 selfcare

** * COMMUNICATING DOMAIN *
	gen COM_IND = 0
	replace COM_IND = 4 if (cf15 == 4 | cf16 == 4)
	replace COM_IND = 3 if (COM_IND != 4 & (cf15 == 3 | cf16 == 3))
	replace COM_IND = 2 if (COM_IND != 4 & COM_IND != 3 & (cf15 == 2 | cf16 == 2))
	replace COM_IND = 1 if (COM_IND != 4 & COM_IND != 3 & COM_IND != 1 & (cf15 == 1 | cf16 == 1))
	replace COM_IND = 9 if ((COM_IND == 2 | COM_IND == 1) & (cf15 == 9 | cf16 == 9))
	tab COM_IND

	gen Communication_5to17 = 9
	replace Communication_5to17 = 0 if inrange(COM_IND, 1, 2) 
	replace Communication_5to17 = 1 if inrange(COM_IND, 3, 4)
	label define communicate 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Communication_5to17 communicate

** * LEARNING DOMAIN *
	gen Learning_5to17 = 9
	replace Learning_5to17 = 0 if inrange(cf17, 1, 2)
	replace Learning_5to17 = 1 if inrange(cf17, 3, 4)
	label define learning 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Learning_5to17 learning

** * REMEMBERING DOMAIN *
	gen Remembering_5to17 = 9
	replace Remembering_5to17 = 0 if inrange(cf18, 1, 2)
	replace Remembering_5to17 = 1 if inrange(cf18, 3, 4)
	label define remembering 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Remembering_5to17 remembering

** * CONCENTRATING DOMAIN *
	gen Concentrating_5to17 = 9
	replace Concentrating_5to17 = 0 if inrange(cf19, 1, 2)
	replace Concentrating_5to17 = 1 if inrange(cf19, 3, 4)
	label define concentrating 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Concentrating_5to17 concentrating 

** * ACCEPTING CHANGE DOMAIN *
	gen AcceptingChange_5to17 = 9
	replace AcceptingChange_5to17 = 0 if inrange(cf20, 1, 2)
	replace AcceptingChange_5to17 = 1 if inrange(cf20, 3, 4)
	label define accepting 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value AcceptingChange_5to17 accepting

** * BEHAVIOUR DOMAIN *
	gen Behaviour_5to17 = 9
	replace Behaviour_5to17 = 0 if inrange(cf21, 1, 2)
	replace Behaviour_5to17 = 1 if inrange(cf21, 3, 4)
	label define behaviour 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Behaviour_5to17 behaviour

** * MAKING FRIENDS DOMAIN *
	gen MakingFriends_5to17 = 9
	replace MakingFriends_5to17 = 0 if inrange(cf22, 1, 2)
	replace MakingFriends_5to17 = 1 if inrange(cf22, 3, 4)
	label define friends 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value MakingFriends_5to17 friends

** * ANXIETY DOMAIN *
	gen Anxiety_5to17 = 9
	replace Anxiety_5to17 = 0 if inrange(cf23, 2, 5)
	replace Anxiety_5to17 = 1 if (cf23 == 1)
	label define anxiety 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Anxiety_5to17 anxiety

** * DEPRESSION DOMAIN *
	gen Depression_5to17 = 9
	replace Depression_5to17 = 0 if inrange(cf24, 2, 5)
	replace Depression_5to17 = 1 if (cf24 == 1)
	label define depression 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Depression_5to17 depression

** * PART TWO: Creating disability indicator for children age 5-17 years *

	gen FunctionalDifficulty_5to17 = 0
	replace FunctionalDifficulty_5to17 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
	replace FunctionalDifficulty_5to17 = 9 if (FunctionalDifficulty_5to17 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
	label define difficulty 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value FunctionalDifficulty_5to17 difficulty
	
** Create FunctionalDifficulty_5to17_Miss0, treating missing as '0'.

gen FunctionalDifficulty_5to17_Miss0 = 0
replace FunctionalDifficulty_5to17_Miss0 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
replace FunctionalDifficulty_5to17_Miss0 = 0 if (FunctionalDifficulty_5to17_Miss0 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
tab FunctionalDifficulty_5to17_Miss0

local variables ///
	Seeing_5to17 /// 
	Hearing_5to17 ///
	Walking_5to17 ///
	Selfcare_5to17 ///
	Communication_5to17 ///
	Learning_5to17 ///
	Remembering_5to17 ///
	Concentrating_5to17 ///
	AcceptingChange_5to17 ///
	Behaviour_5to17 ///
	Anxiety_5to17 ///
	Depression_5to17

foreach var in `variables' {
    gen `var'_IND_Miss0 = 0
    replace `var'_IND_Miss0 = 1 if `var' == 1
}

** Create FunctionalDifficulty_without, treating missing as '0' and removing anxiety/depression

gen FunctionalDifficulty_without = 0

replace FunctionalDifficulty_without = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1) 
replace FunctionalDifficulty_without = 0 if (FunctionalDifficulty_without != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9)) 
tab FunctionalDifficulty_without

/*---------------------------------------
** End: Code from 
** https://data.unicef.org/wp-content/uploads/2020/02/Stata-Syntax-for-the-Child-Functioning-Module_2020.02.25.docx
-----------------------------------------*/

/*---------------------------------------
** Local variables
-----------------------------------------*/
** cfM Domains - order of prevalence according to UNICEF (2021)
** https://data.unicef.org/resources/children-with-disabilities-report-2021/
	local CfmDomains ///
		01Anxiety ///
		02Depression ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability score ranges from 0 to 3
	local CfmScores
	local CfmScores_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Disability indicator is 0 or 1
	local CfmIndicators
	local CfmIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `CfmDomains' {
		local CfmScores `CfmScores' S`Str'Score
		local CfmScores_Miss0 `CfmScores_Miss0' S`Str'Score_Miss0
		local CfmIndicators `CfmIndicators' D`Str'
		local CfmIndicators_Miss0 `CfmIndicators_Miss0' D`Str'_Miss0
	}
	di "`CfmScores'"
	di "`CfmScores_Miss0'"
	di "`CfmIndicators'"
	di "`CfmIndicators_Miss0'"

** SS Domains
	local SsDomains ///
		05Walking ///
		07Remembering ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability indicator is 0 or 1
	local SsIndicators
	local SsIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `SsDomains' {
		local SsIndicators `SsIndicators' D`Str'
		local SsIndicators_Miss0 `SsIndicators_Miss0' D`Str'_Miss0
	}

*** cfM Domain Ids (which cf-IDs correspond to which domain) 
	local 01AnxietyIds cf23
	local 02DepressionIds cf24
	local 03BehaviourIds cf21
	local 04AcceptingChangeIds cf20
	local 05WalkingIds cf8 cf9 cf10 cf11 cf12 cf13
	local 06LearningIds cf17
	local 07RememberingIds cf18
	local 08MakingFriendsIds cf22
	local 09ConcentratingIds cf19
	local 10SelfcareIds cf14
	local 11CommunicationIds cf15 cf16
	local 12SeeingIds cf1 cf3
	local 13HearingIds cf4 cf6

/*----------------------
** S01 - S02: Anxiety and Depression scores
-----------------------*/
	foreach Dm in 01Anxiety 02Depression { // Dm stands for domain
	*** [1] First, generate S01AnxietyScore:
	**** ranges from 0 to 3 and set to missing if underlying resopnse is 
	**** 6 = "Refused", 7 = "Don't know", 999 = "Survey ended"
	**** , or refused survey altogether (19 students did not take survey).
		gen S`Dm'Score = .
		replace S`Dm'Score = 3 if ``Dm'Ids' == 1 // "Daily"
		replace S`Dm'Score = 2 if ``Dm'Ids' == 2 // "Weekly"
		replace S`Dm'Score = 1 if ``Dm'Ids' == 3 // "Monthly"
	** 4 = "A few times a year", 5 = "Never"
		replace S`Dm'Score = 0 if inrange( ``Dm'Ids', 4, 5 )
	*** [2] Generate S01AnxietyScore_Miss0:
	**** treats values 6, 7, and 999 as 0
		gen S`Dm'Score_Miss0 = S`Dm'Score
		replace S`Dm'Score_Miss0 = 0 if missing( S`Dm'Score ) & !missing( cf1 )
	*** [3] Generate D01Anxiety: indicator for daily suffering
		gen D`Dm' = ( S`Dm'Score == 3 ) if !missing( S`Dm'Score )
	*** [4] Generate D01Anxiety_Miss0: indicator for daily suffering
	****, treating responses 6-999 as 0
		gen D`Dm'_Miss0 = D`Dm' == 1 if !missing( cf1 )
	}
/*----------------------
** S03 - S13: Other scores
-----------------------*/
	foreach Dm in ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing { // Dm stands for DOMAIN
	*** [1] Generate S05WalkingScore
	**** Loop through cf responses belonging to this domain
		local `Dm'CfScores // Initialize 05WalkingCfScores variable list
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
		** Populate 05WalkingCfScores variable list
			local `Dm'CfScores ``Dm'CfScores' `Vb'Score
			gen `Vb'Score = `Vb' - 1
		** Variables before cf23: 5 = "Refused", 6 = "Don't know" - to missing
			replace `Vb'Score = . if inrange( `Vb', 5, 6 ) 
		}
		egen S`Dm'Score = rowmax( ``Dm'CfScores' )
	*** [2] Generate S05WalkingScore_Miss0
		local `Dm'CfScores_Miss0
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13'
			local `Dm'CfScores_Miss0 ``Dm'CfScores_Miss0' `Vb'Score_Miss0
			gen `Vb'Score_Miss0 = `Vb'Score
			replace `Vb'Score_Miss0 = 0 if inrange( `Vb', 5, 6 )		
		}
		egen S`Dm'Score_Miss0 = rowmax( ``Dm'CfScores_Miss0' )
	*** [3] Generate D05Walking
		gen D`Dm' = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13		
			replace D`Dm' = . if ( `Vb' == 5 ) | ( `Vb' == 6 )		
		}
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm' = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	*** [3] Generate D05Walking_Miss0
		gen D`Dm'_Miss0 = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm'_Miss0 = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	}

/*----------------------
** Total cfM score, max cfM score, severity
-----------------------*/
	order `CfmScores'
	egen TotalCfmScore = rowtotal( `CfmScores' ) if !missing( cf1 )
	egen MaxCfmScore = rowmax( `CfmScores' ) if !missing( cf1 )
	gen NoDisability = MaxCfmScore == 0 if !missing( cf1 )
	gen MildDisability = MaxCfmScore == 1 if !missing( cf1 )
	gen ModerateDisability = MaxCfmScore == 2 if !missing( cf1 )
	gen SevereDisability = MaxCfmScore == 3 if !missing( cf1 )
/*----------------------
** Match FunctionalDifficulty_5to17 = Moderate/Severe Disability_Miss0
-----------------------*/
gen ANXIETY_S = 0
replace ANXIETY_S = 3 if cf23 == 1
replace ANXIETY_S = 1 if cf23 == 2 | cf23 == 3 | cf23 == 4

gen DEPRESSION_S = 0
replace DEPRESSION_S = 3 if cf24 == 1
replace DEPRESSION_S = 1 if cf24 == 2 | cf24 == 3 | cf24 == 4

rename SEE_IND SEE_S
rename HEAR_IND HEAR_S
rename WALK_IND WALK_S
rename cf14 SELFCARE_S
rename COM_IND COMMUNICATION_S
rename cf17 LEARNING_S
rename cf18 REMEMBERING_S
rename cf19 CONCENTRATING_S
rename cf20 ACCEPTINGCHANGE_S
rename cf21 BEHAVIOUR_S
rename cf22 MAKINGFRIENDS_S

local rescore ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach r in `rescore' {
	replace `r' = 0 if `r' == 1
	replace `r' = 1 if `r' == 2
	replace `r' = 2 if `r' == 3
	replace `r' = 3 if `r' == 4
	replace `r' = 0 if `r' == 5 | `r' == 6 | `r' == 9
}

local CfmScores_Miss0 /// 
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S ///
	ANXIETY_S ///
	DEPRESSION_S 
	
egen TotalCfmScore_Miss0 = rowtotal( `CfmScores_Miss0' )
egen MaxCfmScore_Miss0 = rowmax( `CfmScores_Miss0' )
gen NoDisability_Miss0 = MaxCfmScore_Miss0 == 0
gen MildDisability_Miss0 = MaxCfmScore_Miss0 == 1
gen ModerateDisability_Miss0 = MaxCfmScore_Miss0 == 2
gen SevereDisability_Miss0 = MaxCfmScore_Miss0 == 3 

/*----------------------
** Match FunctionalDifficulty_without = Moderate/Severe Disability_without
-----------------------*/
local rescore_without ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach a in `rescore_without' {
	gen `a'_without = 0
	replace `a'_without = 0 if `a' == 0
	replace `a'_without = 1 if `a' == 1
	replace `a'_without = 2 if `a' == 2
	replace `a'_without = 3 if `a' == 3
}

local CfmScores_without /// 
	SEE_S_without ///
	HEAR_S_without ///
	WALK_S_without ///
	SELFCARE_S_without ///
	COMMUNICATION_S_without ///
	LEARNING_S_without ///
	REMEMBERING_S_without ///
	CONCENTRATING_S_without ///
	ACCEPTINGCHANGE_S_without ///
	BEHAVIOUR_S_without ///
	MAKINGFRIENDS_S_without
	
egen TotalCfmScore_without = rowtotal( `CfmScores_without' )	
egen MaxCfmScore_without = rowmax( `CfmScores_without' )
gen NoDisability_without = MaxCfmScore_without == 0
gen MildDisability_without = MaxCfmScore_without == 1
gen ModerateDisability_without = MaxCfmScore_without == 2
gen SevereDisability_without = MaxCfmScore_without == 3

/*----------------------
** Total cfM Indicator, max cfM indicator
-----------------------*/
	order `CfmIndicators'
	egen TotalCfmIndicator = rowtotal( `CfmIndicators' ) if !missing( cf1 )
	egen MaxCfmIndicator = rowmax( `CfmIndicators' ) if !missing( cf1 )
/*----------------------
** Harmonizing with ASC
-----------------------*/

	gen Physical = 0 if !missing( cf1 )
	replace Physical = 1 if (D05Walking == 1) | (D10Selfcare ==1)

	gen Lowvision = 0 if !missing( cf1 )
	replace Lowvision = 1 if S12SeeingScore == 2

	gen Blind = 0 if !missing( cf1 )
	replace Blind = 1 if S12SeeingScore == 3

	gen Lowhearing = 0 if !missing( cf1 )
	replace Lowhearing = 1 if S13HearingScore == 2

	gen Deaf = 0 if !missing( cf1 )
	replace Deaf = 1 if S13HearingScore == 3

	gen Deafblind = 0 if !missing( cf1 )
	replace Deafblind = 1 if (Blind == 1) & (Deaf == 1)

	tab D02Depression
	gen Intellectual = 0 if !missing( cf1 )
	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// 
		| ( D04AcceptingChange == 1 & D01Anxiety != 1 ) /// 
		| ( D04AcceptingChange != 1 & D01Anxiety == 1 ) // mood & behavior

/*
Autism is constrcted by the combintaion of daily anxiety 
and inacapacity to accepting changes in the routine.
*/

	gen Autism = 0 if !missing( cf1 )
	replace Autism = 1 if (D04AcceptingChange ==1) & (D01Anxiety ==1) 

	gen Multiple = 0 if !missing( cf1 )
	replace Multiple = Physical + Lowvision + Blind + Lowhearing + Deaf > 1
	replace Multiple = . if missing( cf1 )

**Generating exclusive indicators
	gen exPhysical = Physical == 1 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exLowvision = Physical == 0 & Lowvision == 1 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exBlind = Physical == 0 & Lowvision == 0 & Blind == 1 & Lowhearing == 0 & Deaf == 0
	gen exLowhearing = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 1 & Deaf == 0
	gen exDeaf = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 1
	gen exAutism = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 1
	gen exIntellectual = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 0 & Intellectual == 1

	local exlist ///
		exPhysical ///
		exLowvision ///
		exBlind ///
		exLowhearing ///
		exDeaf ///
		exAutism ///
		exIntellectual
	
	foreach vb in `exlist' {
		replace `vb'=. if missing( cf1 )
	}


	gen exCognitive = 0 if !missing( cf1 )
	replace exCognitive = 1 if exIntellectual == 1 & (0 ///
		| ( D06Learning == 1 ) /// cognitive
		| ( D07Remembering == 1 ) /// cognitive
		| ( D09Concentrating == 1) ///
		| ( D11Communication == 1))
	
	gen exMoodBehavioral = 0 if !missing( cf1 )
	replace exMoodBehavioral = 1 if exIntellectual == 1 & exCognitive == 0

	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// cognitive
		| ( D04AcceptingChange == 1 & D01Anxiety !=1 ) /// mood & behavior
		| ( D04AcceptingChange != 1 & D01Anxiety ==1 ) // mood & behavior


**Generating exclusive total and comparing with original total
	gen exTotal = 0 if !missing( cf1 )
	replace exTotal = 1 if 0 ///
		| (exPhysical == 1) ///
		| (exLowvision == 1) ///
		| (exBlind == 1) ///
		| (exLowhearing == 1) ///
		| (exDeaf == 1) ///
		| (Deafblind == 1) ///
		| (exIntellectual == 1) ///
		| (exAutism == 1) ///
		| (Multiple == 1)

	gen Total = 0 if !missing( cf1 )
	replace Total = 1 if 0 ///
		| (Physical ==1) ///
		| (Lowvision ==1) ///
		| (Blind ==1) ///
		| (Lowhearing ==1) ///
		| (Deaf ==1) ///
		| (Deafblind ==1) ///
		| (Intellectual ==1) ///
		| (Autism == 1) ///
		| (Multiple == 1)

	compare Total exTotal

	tab FunctionalDifficulty_5to17

	local Indicators ///
		D01Anxiety ///
		D02Depression ///
		D03Behaviour ///
		D04AcceptingChange ///
		D05Walking ///
		D06Learning ///
		D07Remembering ///
		D08MakingFriends ///
		D09Concentrating ///
		D10Selfcare ///
		D11Communication ///
		D12Seeing ///
		D13Hearing
	
	tokenize ///
		Anxiety ///
		Depression ///
		Behaviour ///
		AcceptingChange ///
		Walking ///
		Learning ///
		Remembering ///
		MakingFriends ///
		Concentrating ///
		Selfcare ///
		Communication ///
		Seeing ///
		Hearing 
	
	local Nb = 0

	foreach i in `Indicators' {
		local Nb = `Nb' + 1
		gen ``Nb'' = `i' * 100
	}
		
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
	gen country = "`c'"
	save "${PathDataIntermediate}\\UNICEF_Cfm_`c'.dta", replace
}
/*
**Find var for stratum
use "${PathDataIntermediate}\\UNICEF_Cfm_Iraq.dta", clear
rename strata stratum
unique stratum
save "${PathDataIntermediate}\\UNICEF_Cfm_Iraq.dta", replace
*/

local ECAsingle ///
	Uzbekistan /// 
	Belarus ///
	Turkmenistan ///
	Georgia ///
	Kyrgyzstan 

foreach cc in `ECAsingle' {
	use "${PathDataIntermediate}\\UNICEF_Cfm_`cc'.dta", clear
	count
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
}

**Create stratum
	use "${PathDataIntermediate}\\UNICEF_Cfm_Kyrgyzstan.dta", clear // No stratum; create one
/*
Kyrgyzstan: at the national level, for urban and rural areas, and for the seven
regions and two cities of the country: Batken, Jalal-abad, Issyk-kul, Naryn, Talas, Chui region and
Bishkek, Osh cities. Urban and rural areas in each of the 9 regions were defined as the sampling strata. 
*/
egen stratum = group (hh7 hh6)
unique stratum // 16 unique strata
	save "${PathDataIntermediate}\\UNICEF_Cfm_Kyrgyzstan.dta", replace 

**Rename stratum var
use "${PathDataIntermediate}\\UNICEF_Cfm_Iraq.dta", clear // 
rename strata stratum
save "${PathDataIntermediate}\\UNICEF_Cfm_Iraq.dta", replace 

	




**Check missin stratum for Rep of North Macedonia and Montenegro

use "${PathDataIntermediate}\UNICEF_Cfm_Republic_of_North_Macedonia.dta", clear
tab hh6 hh7
unique stratum //16 unique stratum
count
use "${PathDataIntermediate}\UNICEF_Cfm_Republic_of_North_Macedonia_(Roma_Settlements).dta", clear
tab hh6 hh7
egen stratum = group(hh7 hh6)
unique stratum //11 unique stratum
save "${PathDataIntermediate}\UNICEF_Cfm_Republic_of_North_Macedonia_(Roma_Settlements).dta", replace

use "${PathDataIntermediate}\UNICEF_Cfm_Montenegro.dta", clear
tab hh6 hh7a
unique stratum //8 unique stratum
count
use "${PathDataIntermediate}\UNICEF_Cfm_Montenegro_(Roma_Settlements).dta", clear
tab hh6 hh7
egen stratum = group(hh7 hh6)
unique stratum //6 unique stratum
save "${PathDataIntermediate}\UNICEF_Cfm_Montenegro_(Roma_Settlements).dta", replace
/*
North Maedonia: . Urban and rural areas in each of the eight regions were defined as the sampling strata. In designing the sample for the 2018-2019 North Macedonia MICS,

Montenegro: this reason stratification and allocation were made based on 4 regions (South, Centre excl. Podgorica, Podgorica and North)
and urban and rural areas. U
*/

*************************************
** Merge different regional data for Kosovo, 
**Serbia, Republic of North Macedonia and Montenegro
*************************************
**********
**Kosovo**
**********

use "${PathDataIntermediate}\UNICEF_Cfm_Kosovo_(UNSCR_1244).dta", clear
append using "${PathDataIntermediate}\UNICEF_Cfm_Kosovo_(UNSCR_1244)_(Roma,_Ashkali_and_Egyptian_Communities).dta"
count
*3,530
replace country = "Kosovo"
save "${PathDataIntermediate}\UNICEF_Cfm_Kosovo.dta", replace

**********
**Serbia**
**********

use "${PathDataIntermediate}\UNICEF_Cfm_Serbia.dta", clear
append using "${PathDataIntermediate}\UNICEF_Cfm_Serbia_(Roma_Settlements).dta"
count
*2,834
replace country = "Serbia"
save "${PathDataIntermediate}\UNICEF_Cfm_Serbia.dta", replace

*******************************
**Republic of North Macedonia**
*******************************

use "${PathDataIntermediate}\UNICEF_Cfm_Republic_of_North_Macedonia.dta", clear
append using "${PathDataIntermediate}\UNICEF_Cfm_Republic_of_North_Macedonia_(Roma_Settlements).dta"
count
*2,263
replace country = "Republic_of_North_Macedonia"
save "${PathDataIntermediate}\UNICEF_Cfm_Republic_of_North_Macedonia.dta", replace


**************
**Montenegro**
**************

use "${PathDataIntermediate}\UNICEF_Cfm_Montenegro.dta", clear
append using "${PathDataIntermediate}\UNICEF_Cfm_Montenegro_(Roma_Settlements).dta"
count
replace country = "Montenegro"
*1,958
save "${PathDataIntermediate}\UNICEF_Cfm_Montenegro.dta", replace


local ECAdouble ///
	Kosovo /// 
	Serbia ///
	Republic_of_North_Macedonia ///
	Montenegro

	
foreach cc in `ECAdouble' {
	use "${PathDataIntermediate}\\UNICEF_Cfm_`cc'.dta", clear
	count
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
}

*************************************
** LAC (Latin America and Carribean)
*************************************

*************************************
** Translate Spanish version to English
*************************************

**Countries need translation: Argentina, Cuba, Dominican Republic, Honduras, Costa Rica

use "${PathHome}\Data\Intermediate\UnicefMics\\Argentina_cfm.dta", clear
	
	label variable hh1 "Cluster Number"
	label variable hh7 "Area"
	label variable hl4 "Sex"
	label variable fs10 "Consent"
	label variable cb3 "Age of child"
	label variable cb4 "Ever attended school or early childhood programme"
	label variable cb7 "Attended school or early childhood programme during current school year"
	label variable cb8a "Level of education attended current school year"
	label variable cb8b "Class attended during current schoool year"
	label variable fcf1 "Child wear glasses or contact lenses"
	label variable fcf2 "Child uses hearing aid"
	label variable fcf3 "Child uses any equipment or receive assistance for walking"
	label variable fcf6 "Child has difficulty seeing"
	label variable fcf8 "Child has difficulty hearing sounds like people voices or music"
	label variable fcf10 "Without using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf11 "Without using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf12 "When using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf13 "When using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf14 "Compared with children of the same age, child has difficulty walking 100 yards"
	label variable fcf15 "Compared with children of the same age, child has difficulty walking 500 yards"
	label variable fcf16 "Child has difficulty with self-care such as feeding or dressing"
	label variable fcf17 "Child has difficulty being understood by people inside of this household"
	label variable fcf18 "Child has difficulty being understood by people outside of this household"
	label variable fcf19 "Compared with children of the same age, child has difficulty learning things"
	label variable fcf20 "Compared with children of the same age, child has difficulty remembering things"
	label variable fcf21 "Child has difficulty concentrating on an activity that he/she enjoys"
	label variable fcf22 "Child has difficulty accepting changes in his/her routine"
	label variable fcf23 "Compared with children of the same age, child have difficulty controlling his/her behaviour"
	label variable fcf24 "Child has difficulty making friends"
	label variable fcf25 "How often child seems very anxious, nervous or worried"
	label variable fcf26 "How often child seems very sad or depressed"
	label variable wscore "Combined wealth score"
	label variable fsweight "Children 5-17's sample weight"
	label variable fshweight "Children 5-17's household sample weight (MICS)"
	label variable psu "Primary sampling unit"
	label var stratum "Stratum"
	keep hh1 hh7 hl4 fs10 cb3 cb4 cb7 cb8a cb8b fcf* wscore fsweight fshweight psu stratum

	save "${PathHome}\Data\Intermediate\UnicefMics\\Argentina_cfm.dta", replace

local Translation ///
	Cuba ///
	Dominican_Republic ///
	Honduras

foreach c in `Translation' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	
	label variable hh1 "Cluster Number"
	label variable hh6 "Area"
	label variable hl4 "Sex"
	label variable fs10 "Consent"
	label variable cb3 "Age of child"
	label variable cb4 "Ever attended school or early childhood programme"
	label variable cb7 "Attended school or early childhood programme during current school year"
	label variable cb8a "Level of education attended current school year"
	label variable cb8b "Class attended during current schoool year"
	label variable fcf1 "Child wear glasses or contact lenses"
	label variable fcf2 "Child uses hearing aid"
	label variable fcf3 "Child uses any equipment or receive assistance for walking"
	label variable fcf6 "Child has difficulty seeing"
	label variable fcf8 "Child has difficulty hearing sounds like people voices or music"
	label variable fcf10 "Without using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf11 "Without using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf12 "When using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf13 "When using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf14 "Compared with children of the same age, child has difficulty walking 100 yards"
	label variable fcf15 "Compared with children of the same age, child has difficulty walking 500 yards"
	label variable fcf16 "Child has difficulty with self-care such as feeding or dressing"
	label variable fcf17 "Child has difficulty being understood by people inside of this household"
	label variable fcf18 "Child has difficulty being understood by people outside of this household"
	label variable fcf19 "Compared with children of the same age, child has difficulty learning things"
	label variable fcf20 "Compared with children of the same age, child has difficulty remembering things"
	label variable fcf21 "Child has difficulty concentrating on an activity that he/she enjoys"
	label variable fcf22 "Child has difficulty accepting changes in his/her routine"
	label variable fcf23 "Compared with children of the same age, child have difficulty controlling his/her behaviour"
	label variable fcf24 "Child has difficulty making friends"
	label variable fcf25 "How often child seems very anxious, nervous or worried"
	label variable fcf26 "How often child seems very sad or depressed"
	label variable wscore "Combined wealth score"
	label variable fsweight "Children 5-17's sample weight"
	label variable fshweight "Children 5-17's household sample weight (MICS)"
	label variable psu "Primary sampling unit"
	label var stratum "Stratum"
	keep hh1 hh6 hl4 fs10 cb3 cb4 cb7 cb8a cb8b fcf* wscore fsweight fshweight psu stratum
	save "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", replace
}

*Costa Rica Translation (There is no fshweight but zfsweight)
use "${PathHome}\Data\Intermediate\UnicefMics\\Costa_Rica_cfm.dta", clear
	
	label variable hh1 "Cluster Number"
	label variable hh6 "Area"
	label variable hl4 "Sex"
	label variable fs10 "Consent"
	label variable cb3 "Age of child"
	label variable cb4 "Ever attended school or early childhood programme"
	label variable cb7 "Attended school or early childhood programme during current school year"
	label variable cb8a "Level of education attended current school year"
	label variable cb8b "Class attended during current schoool year"
	label variable fcf1 "Child wear glasses or contact lenses"
	label variable fcf2 "Child uses hearing aid"
	label variable fcf3 "Child uses any equipment or receive assistance for walking"
	label variable fcf6 "Child has difficulty seeing"
	label variable fcf8 "Child has difficulty hearing sounds like people voices or music"
	label variable fcf10 "Without using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf11 "Without using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf12 "When using equipment or assistance child has difficulty walking 100 yards"
	label variable fcf13 "When using equipment or assistance child has difficulty walking 500 yards"
	label variable fcf14 "Compared with children of the same age, child has difficulty walking 100 yards"
	label variable fcf15 "Compared with children of the same age, child has difficulty walking 500 yards"
	label variable fcf16 "Child has difficulty with self-care such as feeding or dressing"
	label variable fcf17 "Child has difficulty being understood by people inside of this household"
	label variable fcf18 "Child has difficulty being understood by people outside of this household"
	label variable fcf19 "Compared with children of the same age, child has difficulty learning things"
	label variable fcf20 "Compared with children of the same age, child has difficulty remembering things"
	label variable fcf21 "Child has difficulty concentrating on an activity that he/she enjoys"
	label variable fcf22 "Child has difficulty accepting changes in his/her routine"
	label variable fcf23 "Compared with children of the same age, child have difficulty controlling his/her behaviour"
	label variable fcf24 "Child has difficulty making friends"
	label variable fcf25 "How often child seems very anxious, nervous or worried"
	label variable fcf26 "How often child seems very sad or depressed"
	label variable wscore "Combined wealth score"
	label variable fsweight "Children 5-17's sample weight"
	label variable psu "Primary sampling unit"
	label var stratum "Stratum"
	keep hh1 hh6 hl4 fs10 cb3 cb4 cb7 cb8a cb8b fcf* wscore fsweight psu stratum
	save "${PathHome}\Data\Intermediate\UnicefMics\\Costa_Rica_cfm.dta", replace

**Confirm stratum for Turks and Caicos Islands and Suriname

use "${PathHome}\Data\Intermediate\UnicefMics\\Turks_and_Caicos_Islands_cfm.dta", clear //stratum exists
use "${PathHome}\Data\Intermediate\UnicefMics\\Suriname_cfm.dta", clear //stratum does not exist so create one.
/*
Suriname:for the ten districts of the country: Paramaribo,Wanica, Nickerie, Coronie, 
Saramacca, Commewijne, Marowijne, Para, Brokopondo and Sipalwini. Urban (1) and
rural (2: Coastal 3: Interior) “ressorten” in each of the ten districts were defined as the sampling strata.
*/
tab hh6
replace hh6 = 2 if hh6 == 3
egen stratum = group (hh7 hh6)
unique stratum //12 unique strata
label var stratum "Stratum"
save "${PathHome}\Data\Intermediate\UnicefMics\\Suriname_cfm.dta", replace 



local LAC ///
	Argentina ///
	Guyana ///
	Turks_and_Caicos_Islands ///
	Cuba ///
	Dominican_Republic ///
	Honduras ///
	Costa_Rica ///
	Suriname

foreach c in `LAC' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	count
}

foreach c in `LAC' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\`c'_cfm.dta", clear
	rename (fcf1 fcf2 fcf3 fcf6 ///
		fcf8 fcf10 fcf11 fcf12 ///
		fcf13 fcf14 fcf15 fcf16 ///
		fcf17 fcf18 fcf19 fcf20 ///
		fcf21 fcf22 fcf23 fcf24 ///
		fcf25 fcf26) ///
		(cf1 cf4 cf7 cf3 ///
		cf6 cf8 cf9 cf10 ///
		cf11 cf12 cf13 cf14 ///
		cf15 cf16 cf17 cf18 ///
		cf19 cf20 cf21 cf22 ///
		cf23 cf24)

	order cf1 cf3 cf4 cf6 cf7 ///
		cf8 cf9 cf10 cf11 cf12 ///
		cf13 cf14 cf15 cf16 cf17 ///
		cf18 cf19 cf20 cf21 cf22 ///
		cf23 cf24

** * SEEING DOMAIN *
	gen SEE_IND = .
	replace SEE_IND = cf3
	

	gen Seeing_5to17 = 9
	replace Seeing_5to17 = 0 if inrange(SEE_IND, 1, 2)
	replace Seeing_5to17 = 1 if inrange(SEE_IND, 3, 4)
	label define see 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Seeing_5to17 see

** * HEARING DOMAIN *
	gen HEAR_IND = cf6
	tab HEAR_IND

	gen Hearing_5to17 = 9
	replace Hearing_5to17 = 0 if inrange(HEAR_IND, 1, 2)
	replace Hearing_5to17 = 1 if inrange(HEAR_IND, 3, 4)
	label define hear 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Hearing_5to17 hear

** * WALKING DOMAIN *
	gen WALK_IND1 = cf8
	replace WALK_IND1 = cf9 if cf8 == 2
	tab WALK_IND1

	gen WALK_IND2 = cf12
	replace WALK_IND2 = cf13 if (cf12 == 1 | cf12 == 2)
	tab WALK_IND2

	gen WALK_IND = WALK_IND1
	replace WALK_IND = WALK_IND2 if WALK_IND1 == .

	gen Walking_5to17 = 9
	replace Walking_5to17 = 0 if inrange(WALK_IND, 1, 2)
	replace Walking_5to17 = 1 if inrange(WALK_IND, 3, 4)
	label define walk 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Walking_5to17 walk 

** * SELFCARE DOMAIN *
	gen Selfcare_5to17 = 9
	replace Selfcare_5to17 = 0 if inrange(cf14, 1, 2)
	replace Selfcare_5to17 = 1 if inrange(cf14, 3, 4)
	label define selfcare 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Selfcare_5to17 selfcare

** * COMMUNICATING DOMAIN *
	gen COM_IND = 0
	replace COM_IND = 4 if (cf15 == 4 | cf16 == 4)
	replace COM_IND = 3 if (COM_IND != 4 & (cf15 == 3 | cf16 == 3))
	replace COM_IND = 2 if (COM_IND != 4 & COM_IND != 3 & (cf15 == 2 | cf16 == 2))
	replace COM_IND = 1 if (COM_IND != 4 & COM_IND != 3 & COM_IND != 1 & (cf15 == 1 | cf16 == 1))
	replace COM_IND = 9 if ((COM_IND == 2 | COM_IND == 1) & (cf15 == 9 | cf16 == 9))
	tab COM_IND

	gen Communication_5to17 = 9
	replace Communication_5to17 = 0 if inrange(COM_IND, 1, 2) 
	replace Communication_5to17 = 1 if inrange(COM_IND, 3, 4)
	label define communicate 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Communication_5to17 communicate

** * LEARNING DOMAIN *
	gen Learning_5to17 = 9
	replace Learning_5to17 = 0 if inrange(cf17, 1, 2)
	replace Learning_5to17 = 1 if inrange(cf17, 3, 4)
	label define learning 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Learning_5to17 learning

** * REMEMBERING DOMAIN *
	gen Remembering_5to17 = 9
	replace Remembering_5to17 = 0 if inrange(cf18, 1, 2)
	replace Remembering_5to17 = 1 if inrange(cf18, 3, 4)
	label define remembering 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Remembering_5to17 remembering

** * CONCENTRATING DOMAIN *
	gen Concentrating_5to17 = 9
	replace Concentrating_5to17 = 0 if inrange(cf19, 1, 2)
	replace Concentrating_5to17 = 1 if inrange(cf19, 3, 4)
	label define concentrating 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Concentrating_5to17 concentrating 

** * ACCEPTING CHANGE DOMAIN *
	gen AcceptingChange_5to17 = 9
	replace AcceptingChange_5to17 = 0 if inrange(cf20, 1, 2)
	replace AcceptingChange_5to17 = 1 if inrange(cf20, 3, 4)
	label define accepting 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value AcceptingChange_5to17 accepting

** * BEHAVIOUR DOMAIN *
	gen Behaviour_5to17 = 9
	replace Behaviour_5to17 = 0 if inrange(cf21, 1, 2)
	replace Behaviour_5to17 = 1 if inrange(cf21, 3, 4)
	label define behaviour 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Behaviour_5to17 behaviour

** * MAKING FRIENDS DOMAIN *
	gen MakingFriends_5to17 = 9
	replace MakingFriends_5to17 = 0 if inrange(cf22, 1, 2)
	replace MakingFriends_5to17 = 1 if inrange(cf22, 3, 4)
	label define friends 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value MakingFriends_5to17 friends

** * ANXIETY DOMAIN *
	gen Anxiety_5to17 = 9
	replace Anxiety_5to17 = 0 if inrange(cf23, 2, 5)
	replace Anxiety_5to17 = 1 if (cf23 == 1)
	label define anxiety 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Anxiety_5to17 anxiety

** * DEPRESSION DOMAIN *
	gen Depression_5to17 = 9
	replace Depression_5to17 = 0 if inrange(cf24, 2, 5)
	replace Depression_5to17 = 1 if (cf24 == 1)
	label define depression 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Depression_5to17 depression

** * PART TWO: Creating disability indicator for children age 5-17 years *

	gen FunctionalDifficulty_5to17 = 0
	replace FunctionalDifficulty_5to17 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
	replace FunctionalDifficulty_5to17 = 9 if (FunctionalDifficulty_5to17 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
	label define difficulty 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value FunctionalDifficulty_5to17 difficulty
	
** Create FunctionalDifficulty_5to17_Miss0, treating missing as '0'.

gen FunctionalDifficulty_5to17_Miss0 = 0
replace FunctionalDifficulty_5to17_Miss0 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
replace FunctionalDifficulty_5to17_Miss0 = 0 if (FunctionalDifficulty_5to17_Miss0 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
tab FunctionalDifficulty_5to17_Miss0

local variables ///
	Seeing_5to17 /// 
	Hearing_5to17 ///
	Walking_5to17 ///
	Selfcare_5to17 ///
	Communication_5to17 ///
	Learning_5to17 ///
	Remembering_5to17 ///
	Concentrating_5to17 ///
	AcceptingChange_5to17 ///
	Behaviour_5to17 ///
	Anxiety_5to17 ///
	Depression_5to17

foreach var in `variables' {
    gen `var'_IND_Miss0 = 0
    replace `var'_IND_Miss0 = 1 if `var' == 1
}

** Create FunctionalDifficulty_without, treating missing as '0' and removing anxiety/depression

gen FunctionalDifficulty_without = 0

replace FunctionalDifficulty_without = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1) 
replace FunctionalDifficulty_without = 0 if (FunctionalDifficulty_without != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9)) 
tab FunctionalDifficulty_without

/*---------------------------------------
** End: Code from 
** https://data.unicef.org/wp-content/uploads/2020/02/Stata-Syntax-for-the-Child-Functioning-Module_2020.02.25.docx
-----------------------------------------*/

/*---------------------------------------
** Local variables
-----------------------------------------*/
** cfM Domains - order of prevalence according to UNICEF (2021)
** https://data.unicef.org/resources/children-with-disabilities-report-2021/
	local CfmDomains ///
		01Anxiety ///
		02Depression ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability score ranges from 0 to 3
	local CfmScores
	local CfmScores_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Disability indicator is 0 or 1
	local CfmIndicators
	local CfmIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `CfmDomains' {
		local CfmScores `CfmScores' S`Str'Score
		local CfmScores_Miss0 `CfmScores_Miss0' S`Str'Score_Miss0
		local CfmIndicators `CfmIndicators' D`Str'
		local CfmIndicators_Miss0 `CfmIndicators_Miss0' D`Str'_Miss0
	}
	di "`CfmScores'"
	di "`CfmScores_Miss0'"
	di "`CfmIndicators'"
	di "`CfmIndicators_Miss0'"

** SS Domains
	local SsDomains ///
		05Walking ///
		07Remembering ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability indicator is 0 or 1
	local SsIndicators
	local SsIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `SsDomains' {
		local SsIndicators `SsIndicators' D`Str'
		local SsIndicators_Miss0 `SsIndicators_Miss0' D`Str'_Miss0
	}

*** cfM Domain Ids (which cf-IDs correspond to which domain) 
	local 01AnxietyIds cf23
	local 02DepressionIds cf24
	local 03BehaviourIds cf21
	local 04AcceptingChangeIds cf20
	local 05WalkingIds cf8 cf9 cf10 cf11 cf12 cf13
	local 06LearningIds cf17
	local 07RememberingIds cf18
	local 08MakingFriendsIds cf22
	local 09ConcentratingIds cf19
	local 10SelfcareIds cf14
	local 11CommunicationIds cf15 cf16
	local 12SeeingIds cf1 cf3
	local 13HearingIds cf4 cf6

/*----------------------
** S01 - S02: Anxiety and Depression scores
-----------------------*/
	foreach Dm in 01Anxiety 02Depression { // Dm stands for domain
	*** [1] First, generate S01AnxietyScore:
	**** ranges from 0 to 3 and set to missing if underlying resopnse is 
	**** 6 = "Refused", 7 = "Don't know", 999 = "Survey ended"
	**** , or refused survey altogether (19 students did not take survey).
		gen S`Dm'Score = .
		replace S`Dm'Score = 3 if ``Dm'Ids' == 1 // "Daily"
		replace S`Dm'Score = 2 if ``Dm'Ids' == 2 // "Weekly"
		replace S`Dm'Score = 1 if ``Dm'Ids' == 3 // "Monthly"
	** 4 = "A few times a year", 5 = "Never"
		replace S`Dm'Score = 0 if inrange( ``Dm'Ids', 4, 5 )
	*** [2] Generate S01AnxietyScore_Miss0:
	**** treats values 6, 7, and 999 as 0
		gen S`Dm'Score_Miss0 = S`Dm'Score
		replace S`Dm'Score_Miss0 = 0 if missing( S`Dm'Score ) & !missing( cf1 )
	*** [3] Generate D01Anxiety: indicator for daily suffering
		gen D`Dm' = ( S`Dm'Score == 3 ) if !missing( S`Dm'Score )
	*** [4] Generate D01Anxiety_Miss0: indicator for daily suffering
	****, treating responses 6-999 as 0
		gen D`Dm'_Miss0 = D`Dm' == 1 if !missing( cf1 )
	}
/*----------------------
** S03 - S13: Other scores
-----------------------*/
	foreach Dm in ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing { // Dm stands for DOMAIN
	*** [1] Generate S05WalkingScore
	**** Loop through cf responses belonging to this domain
		local `Dm'CfScores // Initialize 05WalkingCfScores variable list
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
		** Populate 05WalkingCfScores variable list
			local `Dm'CfScores ``Dm'CfScores' `Vb'Score
			gen `Vb'Score = `Vb' - 1
		** Variables before cf23: 5 = "Refused", 6 = "Don't know" - to missing
			replace `Vb'Score = . if inrange( `Vb', 5, 6 ) 
		}
		egen S`Dm'Score = rowmax( ``Dm'CfScores' )
	*** [2] Generate S05WalkingScore_Miss0
		local `Dm'CfScores_Miss0
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13'
			local `Dm'CfScores_Miss0 ``Dm'CfScores_Miss0' `Vb'Score_Miss0
			gen `Vb'Score_Miss0 = `Vb'Score
			replace `Vb'Score_Miss0 = 0 if inrange( `Vb', 5, 6 )		
		}
		egen S`Dm'Score_Miss0 = rowmax( ``Dm'CfScores_Miss0' )
	*** [3] Generate D05Walking
		gen D`Dm' = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13		
			replace D`Dm' = . if ( `Vb' == 5 ) | ( `Vb' == 6 )		
		}
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm' = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	*** [3] Generate D05Walking_Miss0
		gen D`Dm'_Miss0 = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm'_Miss0 = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	}

/*----------------------
** Total cfM score, max cfM score, severity
-----------------------*/
	order `CfmScores'
	egen TotalCfmScore = rowtotal( `CfmScores' ) if !missing( cf1 )
	egen MaxCfmScore = rowmax( `CfmScores' ) if !missing( cf1 )
	gen NoDisability = MaxCfmScore == 0 if !missing( cf1 )
	gen MildDisability = MaxCfmScore == 1 if !missing( cf1 )
	gen ModerateDisability = MaxCfmScore == 2 if !missing( cf1 )
	gen SevereDisability = MaxCfmScore == 3 if !missing( cf1 )

/*----------------------
** Match FunctionalDifficulty_5to17 = Moderate/Severe Disability_Miss0
-----------------------*/
gen ANXIETY_S = 0
replace ANXIETY_S = 3 if cf23 == 1
replace ANXIETY_S = 1 if cf23 == 2 | cf23 == 3 | cf23 == 4

gen DEPRESSION_S = 0
replace DEPRESSION_S = 3 if cf24 == 1
replace DEPRESSION_S = 1 if cf24 == 2 | cf24 == 3 | cf24 == 4

rename SEE_IND SEE_S
rename HEAR_IND HEAR_S
rename WALK_IND WALK_S
rename cf14 SELFCARE_S
rename COM_IND COMMUNICATION_S
rename cf17 LEARNING_S
rename cf18 REMEMBERING_S
rename cf19 CONCENTRATING_S
rename cf20 ACCEPTINGCHANGE_S
rename cf21 BEHAVIOUR_S
rename cf22 MAKINGFRIENDS_S

local rescore ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach r in `rescore' {
	replace `r' = 0 if `r' == 1
	replace `r' = 1 if `r' == 2
	replace `r' = 2 if `r' == 3
	replace `r' = 3 if `r' == 4
	replace `r' = 0 if `r' == 5 | `r' == 6 | `r' == 9
}

local CfmScores_Miss0 /// 
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S ///
	ANXIETY_S ///
	DEPRESSION_S 
	
egen TotalCfmScore_Miss0 = rowtotal( `CfmScores_Miss0' )
egen MaxCfmScore_Miss0 = rowmax( `CfmScores_Miss0' )
gen NoDisability_Miss0 = MaxCfmScore_Miss0 == 0
gen MildDisability_Miss0 = MaxCfmScore_Miss0 == 1
gen ModerateDisability_Miss0 = MaxCfmScore_Miss0 == 2
gen SevereDisability_Miss0 = MaxCfmScore_Miss0 == 3 

/*----------------------
** Match FunctionalDifficulty_without = Moderate/Severe Disability_without
-----------------------*/
local rescore_without ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach a in `rescore_without' {
	gen `a'_without = 0
	replace `a'_without = 0 if `a' == 0
	replace `a'_without = 1 if `a' == 1
	replace `a'_without = 2 if `a' == 2
	replace `a'_without = 3 if `a' == 3
}

local CfmScores_without /// 
	SEE_S_without ///
	HEAR_S_without ///
	WALK_S_without ///
	SELFCARE_S_without ///
	COMMUNICATION_S_without ///
	LEARNING_S_without ///
	REMEMBERING_S_without ///
	CONCENTRATING_S_without ///
	ACCEPTINGCHANGE_S_without ///
	BEHAVIOUR_S_without ///
	MAKINGFRIENDS_S_without
	
egen TotalCfmScore_without = rowtotal( `CfmScores_without' )	
egen MaxCfmScore_without = rowmax( `CfmScores_without' )
gen NoDisability_without = MaxCfmScore_without == 0
gen MildDisability_without = MaxCfmScore_without == 1
gen ModerateDisability_without = MaxCfmScore_without == 2
gen SevereDisability_without = MaxCfmScore_without == 3

/*----------------------
** Total cfM Indicator, max cfM indicator
-----------------------*/
	order `CfmIndicators'
	egen TotalCfmIndicator = rowtotal( `CfmIndicators' ) if !missing( cf1 )
	egen MaxCfmIndicator = rowmax( `CfmIndicators' ) if !missing( cf1 )
/*----------------------
** Harmonizing with ASC
-----------------------*/

	gen Physical = 0 if !missing( cf1 )
	replace Physical = 1 if (D05Walking == 1) | (D10Selfcare ==1)

	gen Lowvision = 0 if !missing( cf1 )
	replace Lowvision = 1 if S12SeeingScore == 2

	gen Blind = 0 if !missing( cf1 )
	replace Blind = 1 if S12SeeingScore == 3

	gen Lowhearing = 0 if !missing( cf1 )
	replace Lowhearing = 1 if S13HearingScore == 2

	gen Deaf = 0 if !missing( cf1 )
	replace Deaf = 1 if S13HearingScore == 3

	gen Deafblind = 0 if !missing( cf1 )
	replace Deafblind = 1 if (Blind == 1) & (Deaf == 1)

	tab D02Depression
	gen Intellectual = 0 if !missing( cf1 )
	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// 
		| ( D04AcceptingChange == 1 & D01Anxiety != 1 ) /// 
		| ( D04AcceptingChange != 1 & D01Anxiety == 1 ) // mood & behavior

/*
Autism is constrcted by the combintaion of daily anxiety 
and inacapacity to accepting changes in the routine.
*/

	gen Autism = 0 if !missing( cf1 )
	replace Autism = 1 if (D04AcceptingChange ==1) & (D01Anxiety ==1) 

	gen Multiple = 0 if !missing( cf1 )
	replace Multiple = Physical + Lowvision + Blind + Lowhearing + Deaf > 1
	replace Multiple = . if missing( cf1 )

**Generating exclusive indicators
	gen exPhysical = Physical == 1 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exLowvision = Physical == 0 & Lowvision == 1 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exBlind = Physical == 0 & Lowvision == 0 & Blind == 1 & Lowhearing == 0 & Deaf == 0
	gen exLowhearing = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 1 & Deaf == 0
	gen exDeaf = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 1
	gen exAutism = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 1
	gen exIntellectual = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 0 & Intellectual == 1

	local exlist ///
		exPhysical ///
		exLowvision ///
		exBlind ///
		exLowhearing ///
		exDeaf ///
		exAutism ///
		exIntellectual
	
	foreach vb in `exlist' {
		replace `vb'=. if missing( cf1 )
	}


	gen exCognitive = 0 if !missing( cf1 )
	replace exCognitive = 1 if exIntellectual == 1 & (0 ///
		| ( D06Learning == 1 ) /// cognitive
		| ( D07Remembering == 1 ) /// cognitive
		| ( D09Concentrating == 1) ///
		| ( D11Communication == 1))
	
	gen exMoodBehavioral = 0 if !missing( cf1 )
	replace exMoodBehavioral = 1 if exIntellectual == 1 & exCognitive == 0

	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// cognitive
		| ( D04AcceptingChange == 1 & D01Anxiety !=1 ) /// mood & behavior
		| ( D04AcceptingChange != 1 & D01Anxiety ==1 ) // mood & behavior


**Generating exclusive total and comparing with original total
	gen exTotal = 0 if !missing( cf1 )
	replace exTotal = 1 if 0 ///
		| (exPhysical == 1) ///
		| (exLowvision == 1) ///
		| (exBlind == 1) ///
		| (exLowhearing == 1) ///
		| (exDeaf == 1) ///
		| (Deafblind == 1) ///
		| (exIntellectual == 1) ///
		| (exAutism == 1) ///
		| (Multiple == 1)

	gen Total = 0 if !missing( cf1 )
	replace Total = 1 if 0 ///
		| (Physical ==1) ///
		| (Lowvision ==1) ///
		| (Blind ==1) ///
		| (Lowhearing ==1) ///
		| (Deaf ==1) ///
		| (Deafblind ==1) ///
		| (Intellectual ==1) ///
		| (Autism == 1) ///
		| (Multiple == 1)

	compare Total exTotal

	tab FunctionalDifficulty_5to17

	local Indicators ///
		D01Anxiety ///
		D02Depression ///
		D03Behaviour ///
		D04AcceptingChange ///
		D05Walking ///
		D06Learning ///
		D07Remembering ///
		D08MakingFriends ///
		D09Concentrating ///
		D10Selfcare ///
		D11Communication ///
		D12Seeing ///
		D13Hearing
	
	tokenize ///
		Anxiety ///
		Depression ///
		Behaviour ///
		AcceptingChange ///
		Walking ///
		Learning ///
		Remembering ///
		MakingFriends ///
		Concentrating ///
		Selfcare ///
		Communication ///
		Seeing ///
		Hearing 
	
	local Nb = 0

	foreach i in `Indicators' {
		local Nb = `Nb' + 1
		gen ``Nb'' = `i' * 100
	}
		
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17

	gen country = "`c'"
	save "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_`c'.dta", replace
}
	use "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_Turks_and_Caicos_Islands.dta", clear 
	label var stratum "Stratum"
	save "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_Turks_and_Caicos_Islands.dta", replace 
	tab stratum
*************************************
** SA (South Asia)
*************************************
local SA ///
	Afghanistan ///
	Pakistan_Punjab ///
	Pakistan_Sindh ///
	Pakistan_Khyber_Pakhtunkhwa ///
	Pakistan_(Baluchistan) ///
	Bangladesh ///
	Nepal 

foreach c in `SA' {
	use "${PathDataIntermediate}\\`c'_cfm.dta", clear
	count
}

foreach c in `SA' {
	use "${PathDataIntermediate}\\`c'_cfm.dta", clear
	rename (fcf1 fcf2 fcf3 fcf6 ///
		fcf8 fcf10 fcf11 fcf12 ///
		fcf13 fcf14 fcf15 fcf16 ///
		fcf17 fcf18 fcf19 fcf20 ///
		fcf21 fcf22 fcf23 fcf24 ///
		fcf25 fcf26) ///
		(cf1 cf4 cf7 cf3 ///
		cf6 cf8 cf9 cf10 ///
		cf11 cf12 cf13 cf14 ///
		cf15 cf16 cf17 cf18 ///
		cf19 cf20 cf21 cf22 ///
		cf23 cf24)

	order cf1 cf3 cf4 cf6 cf7 ///
		cf8 cf9 cf10 cf11 cf12 ///
		cf13 cf14 cf15 cf16 cf17 ///
		cf18 cf19 cf20 cf21 cf22 ///
		cf23 cf24

** * SEEING DOMAIN *
	gen SEE_IND = .
	replace SEE_IND = cf3
	
	gen Seeing_5to17 = 9
	replace Seeing_5to17 = 0 if inrange(SEE_IND, 1, 2)
	replace Seeing_5to17 = 1 if inrange(SEE_IND, 3, 4)
	label define see 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Seeing_5to17 see

** * HEARING DOMAIN *
	gen HEAR_IND = cf6
	tab HEAR_IND

	gen Hearing_5to17 = 9
	replace Hearing_5to17 = 0 if inrange(HEAR_IND, 1, 2)
	replace Hearing_5to17 = 1 if inrange(HEAR_IND, 3, 4)
	label define hear 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Hearing_5to17 hear

** * WALKING DOMAIN *
	gen WALK_IND1 = cf8
	replace WALK_IND1 = cf9 if cf8 == 2
	tab WALK_IND1

	gen WALK_IND2 = cf12
	replace WALK_IND2 = cf13 if (cf12 == 1 | cf12 == 2)
	tab WALK_IND2

	gen WALK_IND = WALK_IND1
	replace WALK_IND = WALK_IND2 if WALK_IND1 == .

	gen Walking_5to17 = 9
	replace Walking_5to17 = 0 if inrange(WALK_IND, 1, 2)
	replace Walking_5to17 = 1 if inrange(WALK_IND, 3, 4)
	label define walk 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Walking_5to17 walk 

** * SELFCARE DOMAIN *
	gen Selfcare_5to17 = 9
	replace Selfcare_5to17 = 0 if inrange(cf14, 1, 2)
	replace Selfcare_5to17 = 1 if inrange(cf14, 3, 4)
	label define selfcare 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Selfcare_5to17 selfcare

** * COMMUNICATING DOMAIN *
	gen COM_IND = 0
	replace COM_IND = 4 if (cf15 == 4 | cf16 == 4)
	replace COM_IND = 3 if (COM_IND != 4 & (cf15 == 3 | cf16 == 3))
	replace COM_IND = 2 if (COM_IND != 4 & COM_IND != 3 & (cf15 == 2 | cf16 == 2))
	replace COM_IND = 1 if (COM_IND != 4 & COM_IND != 3 & COM_IND != 1 & (cf15 == 1 | cf16 == 1))
	replace COM_IND = 9 if ((COM_IND == 2 | COM_IND == 1) & (cf15 == 9 | cf16 == 9))
	tab COM_IND

	gen Communication_5to17 = 9
	replace Communication_5to17 = 0 if inrange(COM_IND, 1, 2) 
	replace Communication_5to17 = 1 if inrange(COM_IND, 3, 4)
	label define communicate 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Communication_5to17 communicate

** * LEARNING DOMAIN *
	gen Learning_5to17 = 9
	replace Learning_5to17 = 0 if inrange(cf17, 1, 2)
	replace Learning_5to17 = 1 if inrange(cf17, 3, 4)
	label define learning 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Learning_5to17 learning

** * REMEMBERING DOMAIN *
	gen Remembering_5to17 = 9
	replace Remembering_5to17 = 0 if inrange(cf18, 1, 2)
	replace Remembering_5to17 = 1 if inrange(cf18, 3, 4)
	label define remembering 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Remembering_5to17 remembering

** * CONCENTRATING DOMAIN *
	gen Concentrating_5to17 = 9
	replace Concentrating_5to17 = 0 if inrange(cf19, 1, 2)
	replace Concentrating_5to17 = 1 if inrange(cf19, 3, 4)
	label define concentrating 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Concentrating_5to17 concentrating 

** * ACCEPTING CHANGE DOMAIN *
	gen AcceptingChange_5to17 = 9
	replace AcceptingChange_5to17 = 0 if inrange(cf20, 1, 2)
	replace AcceptingChange_5to17 = 1 if inrange(cf20, 3, 4)
	label define accepting 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value AcceptingChange_5to17 accepting

** * BEHAVIOUR DOMAIN *
	gen Behaviour_5to17 = 9
	replace Behaviour_5to17 = 0 if inrange(cf21, 1, 2)
	replace Behaviour_5to17 = 1 if inrange(cf21, 3, 4)
	label define behaviour 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Behaviour_5to17 behaviour

** * MAKING FRIENDS DOMAIN *
	gen MakingFriends_5to17 = 9
	replace MakingFriends_5to17 = 0 if inrange(cf22, 1, 2)
	replace MakingFriends_5to17 = 1 if inrange(cf22, 3, 4)
	label define friends 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value MakingFriends_5to17 friends

** * ANXIETY DOMAIN *
	gen Anxiety_5to17 = 9
	replace Anxiety_5to17 = 0 if inrange(cf23, 2, 5)
	replace Anxiety_5to17 = 1 if (cf23 == 1)
	label define anxiety 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Anxiety_5to17 anxiety

** * DEPRESSION DOMAIN *
	gen Depression_5to17 = 9
	replace Depression_5to17 = 0 if inrange(cf24, 2, 5)
	replace Depression_5to17 = 1 if (cf24 == 1)
	label define depression 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Depression_5to17 depression

** * PART TWO: Creating disability indicator for children age 5-17 years *

	gen FunctionalDifficulty_5to17 = 0
	replace FunctionalDifficulty_5to17 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
	replace FunctionalDifficulty_5to17 = 9 if (FunctionalDifficulty_5to17 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
	label define difficulty 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value FunctionalDifficulty_5to17 difficulty

** Create FunctionalDifficulty_5to17_Miss0, treating missing as '0'.

gen FunctionalDifficulty_5to17_Miss0 = 0
replace FunctionalDifficulty_5to17_Miss0 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
replace FunctionalDifficulty_5to17_Miss0 = 0 if (FunctionalDifficulty_5to17_Miss0 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
tab FunctionalDifficulty_5to17_Miss0

local variables ///
	Seeing_5to17 /// 
	Hearing_5to17 ///
	Walking_5to17 ///
	Selfcare_5to17 ///
	Communication_5to17 ///
	Learning_5to17 ///
	Remembering_5to17 ///
	Concentrating_5to17 ///
	AcceptingChange_5to17 ///
	Behaviour_5to17 ///
	Anxiety_5to17 ///
	Depression_5to17

foreach var in `variables' {
    gen `var'_IND_Miss0 = 0
    replace `var'_IND_Miss0 = 1 if `var' == 1
}

** Create FunctionalDifficulty_without, treating missing as '0' and removing anxiety/depression

gen FunctionalDifficulty_without = 0

replace FunctionalDifficulty_without = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1) 
replace FunctionalDifficulty_without = 0 if (FunctionalDifficulty_without != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9)) 
tab FunctionalDifficulty_without

/*---------------------------------------
** End: Code from 
** https://data.unicef.org/wp-content/uploads/2020/02/Stata-Syntax-for-the-Child-Functioning-Module_2020.02.25.docx
-----------------------------------------*/

/*---------------------------------------
** Local variables
-----------------------------------------*/
** cfM Domains - order of prevalence according to UNICEF (2021)
** https://data.unicef.org/resources/children-with-disabilities-report-2021/
	local CfmDomains ///
		01Anxiety ///
		02Depression ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability score ranges from 0 to 3
	local CfmScores
	local CfmScores_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Disability indicator is 0 or 1
	local CfmIndicators
	local CfmIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `CfmDomains' {
		local CfmScores `CfmScores' S`Str'Score
		local CfmScores_Miss0 `CfmScores_Miss0' S`Str'Score_Miss0
		local CfmIndicators `CfmIndicators' D`Str'
		local CfmIndicators_Miss0 `CfmIndicators_Miss0' D`Str'_Miss0
	}
	di "`CfmScores'"
	di "`CfmScores_Miss0'"
	di "`CfmIndicators'"
	di "`CfmIndicators_Miss0'"

** SS Domains
	local SsDomains ///
		05Walking ///
		07Remembering ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability indicator is 0 or 1
	local SsIndicators
	local SsIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `SsDomains' {
		local SsIndicators `SsIndicators' D`Str'
		local SsIndicators_Miss0 `SsIndicators_Miss0' D`Str'_Miss0
	}

*** cfM Domain Ids (which cf-IDs correspond to which domain) 
	local 01AnxietyIds cf23
	local 02DepressionIds cf24
	local 03BehaviourIds cf21
	local 04AcceptingChangeIds cf20
	local 05WalkingIds cf8 cf9 cf10 cf11 cf12 cf13
	local 06LearningIds cf17
	local 07RememberingIds cf18
	local 08MakingFriendsIds cf22
	local 09ConcentratingIds cf19
	local 10SelfcareIds cf14
	local 11CommunicationIds cf15 cf16
	local 12SeeingIds cf1 cf3
	local 13HearingIds cf4 cf6

/*----------------------
** S01 - S02: Anxiety and Depression scores
-----------------------*/
	foreach Dm in 01Anxiety 02Depression { // Dm stands for domain
	*** [1] First, generate S01AnxietyScore:
	**** ranges from 0 to 3 and set to missing if underlying resopnse is 
	**** 6 = "Refused", 7 = "Don't know", 999 = "Survey ended"
	**** , or refused survey altogether (19 students did not take survey).
		gen S`Dm'Score = .
		replace S`Dm'Score = 3 if ``Dm'Ids' == 1 // "Daily"
		replace S`Dm'Score = 2 if ``Dm'Ids' == 2 // "Weekly"
		replace S`Dm'Score = 1 if ``Dm'Ids' == 3 // "Monthly"
	** 4 = "A few times a year", 5 = "Never"
		replace S`Dm'Score = 0 if inrange( ``Dm'Ids', 4, 5 )
	*** [2] Generate S01AnxietyScore_Miss0:
	**** treats values 6, 7, and 999 as 0
		gen S`Dm'Score_Miss0 = S`Dm'Score
		replace S`Dm'Score_Miss0 = 0 if missing( S`Dm'Score ) & !missing( cf1 )
	*** [3] Generate D01Anxiety: indicator for daily suffering
		gen D`Dm' = ( S`Dm'Score == 3 ) if !missing( S`Dm'Score )
	*** [4] Generate D01Anxiety_Miss0: indicator for daily suffering
	****, treating responses 6-999 as 0
		gen D`Dm'_Miss0 = D`Dm' == 1 if !missing( cf1 )
	}
/*----------------------
** S03 - S13: Other scores
-----------------------*/
	foreach Dm in ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing { // Dm stands for DOMAIN
	*** [1] Generate S05WalkingScore
	**** Loop through cf responses belonging to this domain
		local `Dm'CfScores // Initialize 05WalkingCfScores variable list
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
		** Populate 05WalkingCfScores variable list
			local `Dm'CfScores ``Dm'CfScores' `Vb'Score
			gen `Vb'Score = `Vb' - 1
		** Variables before cf23: 5 = "Refused", 6 = "Don't know" - to missing
			replace `Vb'Score = . if inrange( `Vb', 5, 6 ) 
		}
		egen S`Dm'Score = rowmax( ``Dm'CfScores' )
	*** [2] Generate S05WalkingScore_Miss0
		local `Dm'CfScores_Miss0
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13'
			local `Dm'CfScores_Miss0 ``Dm'CfScores_Miss0' `Vb'Score_Miss0
			gen `Vb'Score_Miss0 = `Vb'Score
			replace `Vb'Score_Miss0 = 0 if inrange( `Vb', 5, 6 )		
		}
		egen S`Dm'Score_Miss0 = rowmax( ``Dm'CfScores_Miss0' )
	*** [3] Generate D05Walking
		gen D`Dm' = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13		
			replace D`Dm' = . if ( `Vb' == 5 ) | ( `Vb' == 6 )		
		}
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm' = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	*** [3] Generate D05Walking_Miss0
		gen D`Dm'_Miss0 = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm'_Miss0 = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	}

/*----------------------
** Total cfM score, max cfM score, severity
-----------------------*/
	order `CfmScores'
	egen TotalCfmScore = rowtotal( `CfmScores' ) if !missing( cf1 )
	egen MaxCfmScore = rowmax( `CfmScores' ) if !missing( cf1 )
	gen NoDisability = MaxCfmScore == 0 if !missing( cf1 )
	gen MildDisability = MaxCfmScore == 1 if !missing( cf1 )
	gen ModerateDisability = MaxCfmScore == 2 if !missing( cf1 )
	gen SevereDisability = MaxCfmScore == 3 if !missing( cf1 )

/*----------------------
** Match FunctionalDifficulty_5to17 = Moderate/Severe Disability_Miss0
-----------------------*/
gen ANXIETY_S = 0
replace ANXIETY_S = 3 if cf23 == 1
replace ANXIETY_S = 1 if cf23 == 2 | cf23 == 3 | cf23 == 4

gen DEPRESSION_S = 0
replace DEPRESSION_S = 3 if cf24 == 1
replace DEPRESSION_S = 1 if cf24 == 2 | cf24 == 3 | cf24 == 4

rename SEE_IND SEE_S
rename HEAR_IND HEAR_S
rename WALK_IND WALK_S
rename cf14 SELFCARE_S
rename COM_IND COMMUNICATION_S
rename cf17 LEARNING_S
rename cf18 REMEMBERING_S
rename cf19 CONCENTRATING_S
rename cf20 ACCEPTINGCHANGE_S
rename cf21 BEHAVIOUR_S
rename cf22 MAKINGFRIENDS_S

local rescore ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach r in `rescore' {
	replace `r' = 0 if `r' == 1
	replace `r' = 1 if `r' == 2
	replace `r' = 2 if `r' == 3
	replace `r' = 3 if `r' == 4
	replace `r' = 0 if `r' == 5 | `r' == 6 | `r' == 9
}

local CfmScores_Miss0 /// 
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S ///
	ANXIETY_S ///
	DEPRESSION_S 
	
egen TotalCfmScore_Miss0 = rowtotal( `CfmScores_Miss0' )
egen MaxCfmScore_Miss0 = rowmax( `CfmScores_Miss0' )
gen NoDisability_Miss0 = MaxCfmScore_Miss0 == 0
gen MildDisability_Miss0 = MaxCfmScore_Miss0 == 1
gen ModerateDisability_Miss0 = MaxCfmScore_Miss0 == 2
gen SevereDisability_Miss0 = MaxCfmScore_Miss0 == 3 

/*----------------------
** Match FunctionalDifficulty_without = Moderate/Severe Disability_without
-----------------------*/
local rescore_without ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach a in `rescore_without' {
	gen `a'_without = 0
	replace `a'_without = 0 if `a' == 0
	replace `a'_without = 1 if `a' == 1
	replace `a'_without = 2 if `a' == 2
	replace `a'_without = 3 if `a' == 3
}

local CfmScores_without /// 
	SEE_S_without ///
	HEAR_S_without ///
	WALK_S_without ///
	SELFCARE_S_without ///
	COMMUNICATION_S_without ///
	LEARNING_S_without ///
	REMEMBERING_S_without ///
	CONCENTRATING_S_without ///
	ACCEPTINGCHANGE_S_without ///
	BEHAVIOUR_S_without ///
	MAKINGFRIENDS_S_without
	
egen TotalCfmScore_without = rowtotal( `CfmScores_without' )	
egen MaxCfmScore_without = rowmax( `CfmScores_without' )
gen NoDisability_without = MaxCfmScore_without == 0
gen MildDisability_without = MaxCfmScore_without == 1
gen ModerateDisability_without = MaxCfmScore_without == 2
gen SevereDisability_without = MaxCfmScore_without == 3
 

/*----------------------
** Total cfM Indicator, max cfM indicator
-----------------------*/
	order `CfmIndicators'
	egen TotalCfmIndicator = rowtotal( `CfmIndicators' ) if !missing( cf1 )
	egen MaxCfmIndicator = rowmax( `CfmIndicators' ) if !missing( cf1 )
/*----------------------
** Harmonizing with ASC
-----------------------*/

	gen Physical = 0 if !missing( cf1 )
	replace Physical = 1 if (D05Walking == 1) | (D10Selfcare ==1)

	gen Lowvision = 0 if !missing( cf1 )
	replace Lowvision = 1 if S12SeeingScore == 2

	gen Blind = 0 if !missing( cf1 )
	replace Blind = 1 if S12SeeingScore == 3

	gen Lowhearing = 0 if !missing( cf1 )
	replace Lowhearing = 1 if S13HearingScore == 2

	gen Deaf = 0 if !missing( cf1 )
	replace Deaf = 1 if S13HearingScore == 3

	gen Deafblind = 0 if !missing( cf1 )
	replace Deafblind = 1 if (Blind == 1) & (Deaf == 1)

	tab D02Depression
	gen Intellectual = 0 if !missing( cf1 )
	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// 
		| ( D04AcceptingChange == 1 & D01Anxiety != 1 ) /// 
		| ( D04AcceptingChange != 1 & D01Anxiety == 1 ) // mood & behavior

/*
Autism is constrcted by the combintaion of daily anxiety 
and inacapacity to accepting changes in the routine.
*/

	gen Autism = 0 if !missing( cf1 )
	replace Autism = 1 if (D04AcceptingChange ==1) & (D01Anxiety ==1) 

	gen Multiple = 0 if !missing( cf1 )
	replace Multiple = Physical + Lowvision + Blind + Lowhearing + Deaf > 1
	replace Multiple = . if missing( cf1 )

**Generating exclusive indicators
	gen exPhysical = Physical == 1 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exLowvision = Physical == 0 & Lowvision == 1 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exBlind = Physical == 0 & Lowvision == 0 & Blind == 1 & Lowhearing == 0 & Deaf == 0
	gen exLowhearing = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 1 & Deaf == 0
	gen exDeaf = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 1
	gen exAutism = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 1
	gen exIntellectual = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 0 & Intellectual == 1

	local exlist ///
		exPhysical ///
		exLowvision ///
		exBlind ///
		exLowhearing ///
		exDeaf ///
		exAutism ///
		exIntellectual
	
	foreach vb in `exlist' {
		replace `vb'=. if missing( cf1 )
	}


	gen exCognitive = 0 if !missing( cf1 )
	replace exCognitive = 1 if exIntellectual == 1 & (0 ///
		| ( D06Learning == 1 ) /// cognitive
		| ( D07Remembering == 1 ) /// cognitive
		| ( D09Concentrating == 1) ///
		| ( D11Communication == 1))
	
	gen exMoodBehavioral = 0 if !missing( cf1 )
	replace exMoodBehavioral = 1 if exIntellectual == 1 & exCognitive == 0

	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// cognitive
		| ( D04AcceptingChange == 1 & D01Anxiety !=1 ) /// mood & behavior
		| ( D04AcceptingChange != 1 & D01Anxiety ==1 ) // mood & behavior


**Generating exclusive total and comparing with original total
	gen exTotal = 0 if !missing( cf1 )
	replace exTotal = 1 if 0 ///
		| (exPhysical == 1) ///
		| (exLowvision == 1) ///
		| (exBlind == 1) ///
		| (exLowhearing == 1) ///
		| (exDeaf == 1) ///
		| (Deafblind == 1) ///
		| (exIntellectual == 1) ///
		| (exAutism == 1) ///
		| (Multiple == 1)

	gen Total = 0 if !missing( cf1 )
	replace Total = 1 if 0 ///
		| (Physical ==1) ///
		| (Lowvision ==1) ///
		| (Blind ==1) ///
		| (Lowhearing ==1) ///
		| (Deaf ==1) ///
		| (Deafblind ==1) ///
		| (Intellectual ==1) ///
		| (Autism == 1) ///
		| (Multiple == 1)

	compare Total exTotal

	tab FunctionalDifficulty_5to17

	local Indicators ///
		D01Anxiety ///
		D02Depression ///
		D03Behaviour ///
		D04AcceptingChange ///
		D05Walking ///
		D06Learning ///
		D07Remembering ///
		D08MakingFriends ///
		D09Concentrating ///
		D10Selfcare ///
		D11Communication ///
		D12Seeing ///
		D13Hearing
	
	tokenize ///
		Anxiety ///
		Depression ///
		Behaviour ///
		AcceptingChange ///
		Walking ///
		Learning ///
		Remembering ///
		MakingFriends ///
		Concentrating ///
		Selfcare ///
		Communication ///
		Seeing ///
		Hearing 
	
	local Nb = 0

	foreach i in `Indicators' {
		local Nb = `Nb' + 1
		gen ``Nb'' = `i' * 100
	}
		
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
	gen country = "`c'"
	save "${PathDataIntermediate}\\UNICEF_Cfm_`c'.dta", replace
}

*******************************************************************
**Merge Pakistan Balochistan, Khyber Pakhtunkhwa, Sindh, and Punjab
*******************************************************************
use "${PathDataIntermediate}\UNICEF_Cfm_Pakistan_Punjab.dta", clear

append using "${PathDataIntermediate}\UNICEF_Cfm_Pakistan_Sindh.dta"
append using "${PathDataIntermediate}\UNICEF_Cfm_Pakistan_Khyber_Pakhtunkhwa.dta"
append using "${PathDataIntermediate}\UNICEF_Cfm_Pakistan_(Baluchistan).dta"
count
*88,665
replace country = "Pakistan"
save "${PathDataIntermediate}\UNICEF_Cfm_Pakistan.dta", replace

local SA ///
	Afghanistan ///
	Pakistan ///
	Bangladesh ///
	Nepal
	
foreach cc in `SA' {
	use "${PathHome}\Data\Intermediate\UnicefMics\\UNICEF_Cfm_`cc'.dta", clear
	count
	
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
}

*****************************
**EAP (East Asian and Pacific)
*****************************

local EAP ///
	Fiji ///
	Viet_Nam ///
	Samoa ///
	Tuvalu ///
	Tonga ///
	Kiribati ///
	Mongolia
	
foreach c in `EAP' {
	use "${PathDataIntermediate}\\`c'_cfm.dta", clear
	count
}

foreach c in `EAP' {
	use "${PathDataIntermediate}\\`c'_cfm.dta", clear
	rename (fcf1 fcf2 fcf3 fcf6 ///
		fcf8 fcf10 fcf11 fcf12 ///
		fcf13 fcf14 fcf15 fcf16 ///
		fcf17 fcf18 fcf19 fcf20 ///
		fcf21 fcf22 fcf23 fcf24 ///
		fcf25 fcf26) ///
		(cf1 cf4 cf7 cf3 ///
		cf6 cf8 cf9 cf10 ///
		cf11 cf12 cf13 cf14 ///
		cf15 cf16 cf17 cf18 ///
		cf19 cf20 cf21 cf22 ///
		cf23 cf24)

	order cf1 cf3 cf4 cf6 cf7 ///
		cf8 cf9 cf10 cf11 cf12 ///
		cf13 cf14 cf15 cf16 cf17 ///
		cf18 cf19 cf20 cf21 cf22 ///
		cf23 cf24

** * SEEING DOMAIN *
	gen SEE_IND = .
	replace SEE_IND = cf3
	
	gen Seeing_5to17 = 9
	replace Seeing_5to17 = 0 if inrange(SEE_IND, 1, 2)
	replace Seeing_5to17 = 1 if inrange(SEE_IND, 3, 4)
	label define see 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Seeing_5to17 see

** * HEARING DOMAIN *
	gen HEAR_IND = cf6
	tab HEAR_IND

	gen Hearing_5to17 = 9
	replace Hearing_5to17 = 0 if inrange(HEAR_IND, 1, 2)
	replace Hearing_5to17 = 1 if inrange(HEAR_IND, 3, 4)
	label define hear 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Hearing_5to17 hear

** * WALKING DOMAIN *
	gen WALK_IND1 = cf8
	replace WALK_IND1 = cf9 if cf8 == 2
	tab WALK_IND1

	gen WALK_IND2 = cf12
	replace WALK_IND2 = cf13 if (cf12 == 1 | cf12 == 2)
	tab WALK_IND2

	gen WALK_IND = WALK_IND1
	replace WALK_IND = WALK_IND2 if WALK_IND1 == .

	gen Walking_5to17 = 9
	replace Walking_5to17 = 0 if inrange(WALK_IND, 1, 2)
	replace Walking_5to17 = 1 if inrange(WALK_IND, 3, 4)
	label define walk 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Walking_5to17 walk 

** * SELFCARE DOMAIN *
	gen Selfcare_5to17 = 9
	replace Selfcare_5to17 = 0 if inrange(cf14, 1, 2)
	replace Selfcare_5to17 = 1 if inrange(cf14, 3, 4)
	label define selfcare 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Selfcare_5to17 selfcare

** * COMMUNICATING DOMAIN *
	gen COM_IND = 0
	replace COM_IND = 4 if (cf15 == 4 | cf16 == 4)
	replace COM_IND = 3 if (COM_IND != 4 & (cf15 == 3 | cf16 == 3))
	replace COM_IND = 2 if (COM_IND != 4 & COM_IND != 3 & (cf15 == 2 | cf16 == 2))
	replace COM_IND = 1 if (COM_IND != 4 & COM_IND != 3 & COM_IND != 1 & (cf15 == 1 | cf16 == 1))
	replace COM_IND = 9 if ((COM_IND == 2 | COM_IND == 1) & (cf15 == 9 | cf16 == 9))
	tab COM_IND

	gen Communication_5to17 = 9
	replace Communication_5to17 = 0 if inrange(COM_IND, 1, 2) 
	replace Communication_5to17 = 1 if inrange(COM_IND, 3, 4)
	label define communicate 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Communication_5to17 communicate

** * LEARNING DOMAIN *
	gen Learning_5to17 = 9
	replace Learning_5to17 = 0 if inrange(cf17, 1, 2)
	replace Learning_5to17 = 1 if inrange(cf17, 3, 4)
	label define learning 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Learning_5to17 learning

** * REMEMBERING DOMAIN *
	gen Remembering_5to17 = 9
	replace Remembering_5to17 = 0 if inrange(cf18, 1, 2)
	replace Remembering_5to17 = 1 if inrange(cf18, 3, 4)
	label define remembering 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Remembering_5to17 remembering

** * CONCENTRATING DOMAIN *
	gen Concentrating_5to17 = 9
	replace Concentrating_5to17 = 0 if inrange(cf19, 1, 2)
	replace Concentrating_5to17 = 1 if inrange(cf19, 3, 4)
	label define concentrating 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Concentrating_5to17 concentrating 

** * ACCEPTING CHANGE DOMAIN *
	gen AcceptingChange_5to17 = 9
	replace AcceptingChange_5to17 = 0 if inrange(cf20, 1, 2)
	replace AcceptingChange_5to17 = 1 if inrange(cf20, 3, 4)
	label define accepting 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value AcceptingChange_5to17 accepting

** * BEHAVIOUR DOMAIN *
	gen Behaviour_5to17 = 9
	replace Behaviour_5to17 = 0 if inrange(cf21, 1, 2)
	replace Behaviour_5to17 = 1 if inrange(cf21, 3, 4)
	label define behaviour 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Behaviour_5to17 behaviour

** * MAKING FRIENDS DOMAIN *
	gen MakingFriends_5to17 = 9
	replace MakingFriends_5to17 = 0 if inrange(cf22, 1, 2)
	replace MakingFriends_5to17 = 1 if inrange(cf22, 3, 4)
	label define friends 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value MakingFriends_5to17 friends

** * ANXIETY DOMAIN *
	gen Anxiety_5to17 = 9
	replace Anxiety_5to17 = 0 if inrange(cf23, 2, 5)
	replace Anxiety_5to17 = 1 if (cf23 == 1)
	label define anxiety 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Anxiety_5to17 anxiety

** * DEPRESSION DOMAIN *
	gen Depression_5to17 = 9
	replace Depression_5to17 = 0 if inrange(cf24, 2, 5)
	replace Depression_5to17 = 1 if (cf24 == 1)
	label define depression 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value Depression_5to17 depression

** * PART TWO: Creating disability indicator for children age 5-17 years *

	gen FunctionalDifficulty_5to17 = 0
	replace FunctionalDifficulty_5to17 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
	replace FunctionalDifficulty_5to17 = 9 if (FunctionalDifficulty_5to17 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
	label define difficulty 0 "No functional difficulty" 1 "With functional difficulty" 9 "Missing" 
	label value FunctionalDifficulty_5to17 difficulty

** Create FunctionalDifficulty_5to17_Miss0, treating missing as '0'.

gen FunctionalDifficulty_5to17_Miss0 = 0
replace FunctionalDifficulty_5to17_Miss0 = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1 | Anxiety_5to17 == 1 | Depression_5to17 == 1) 
replace FunctionalDifficulty_5to17_Miss0 = 0 if (FunctionalDifficulty_5to17_Miss0 != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9 | Anxiety_5to17 == 9 | Depression_5to17 == 9)) 
tab FunctionalDifficulty_5to17_Miss0

local variables ///
	Seeing_5to17 /// 
	Hearing_5to17 ///
	Walking_5to17 ///
	Selfcare_5to17 ///
	Communication_5to17 ///
	Learning_5to17 ///
	Remembering_5to17 ///
	Concentrating_5to17 ///
	AcceptingChange_5to17 ///
	Behaviour_5to17 ///
	Anxiety_5to17 ///
	Depression_5to17

foreach var in `variables' {
    gen `var'_IND_Miss0 = 0
    replace `var'_IND_Miss0 = 1 if `var' == 1
}

** Create FunctionalDifficulty_without, treating missing as '0' and removing anxiety/depression

gen FunctionalDifficulty_without = 0

replace FunctionalDifficulty_without = 1 if (Seeing_5to17 == 1 | Hearing_5to17 == 1 | Walking_5to17 == 1 | Selfcare_5to17 == 1 | Communication_5to17 == 1 | Learning_5to17 == 1 | Remembering_5to17 == 1 | Concentrating_5to17 == 1 | AcceptingChange_5to17 == 1 | Behaviour_5to17 == 1 | MakingFriends_5to17 == 1) 
replace FunctionalDifficulty_without = 0 if (FunctionalDifficulty_without != 1 & (Seeing_5to17 == 9 | Hearing_5to17 == 9 | Walking_5to17 == 9 | Selfcare_5to17 == 9 | Communication_5to17 == 9 | Learning_5to17 == 9 | Remembering_5to17 == 9 | Concentrating_5to17 == 9 | AcceptingChange_5to17 == 9 | Behaviour_5to17 == 9 | MakingFriends_5to17 == 9)) 
tab FunctionalDifficulty_without

/*---------------------------------------
** End: Code from 
** https://data.unicef.org/wp-content/uploads/2020/02/Stata-Syntax-for-the-Child-Functioning-Module_2020.02.25.docx
-----------------------------------------*/

/*---------------------------------------
** Local variables
-----------------------------------------*/
** cfM Domains - order of prevalence according to UNICEF (2021)
** https://data.unicef.org/resources/children-with-disabilities-report-2021/
	local CfmDomains ///
		01Anxiety ///
		02Depression ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability score ranges from 0 to 3
	local CfmScores
	local CfmScores_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Disability indicator is 0 or 1
	local CfmIndicators
	local CfmIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `CfmDomains' {
		local CfmScores `CfmScores' S`Str'Score
		local CfmScores_Miss0 `CfmScores_Miss0' S`Str'Score_Miss0
		local CfmIndicators `CfmIndicators' D`Str'
		local CfmIndicators_Miss0 `CfmIndicators_Miss0' D`Str'_Miss0
	}
	di "`CfmScores'"
	di "`CfmScores_Miss0'"
	di "`CfmIndicators'"
	di "`CfmIndicators_Miss0'"

** SS Domains
	local SsDomains ///
		05Walking ///
		07Remembering ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing
*** Disability indicator is 0 or 1
	local SsIndicators
	local SsIndicators_Miss0 // Miss0: missing values coded as 0 (Don't Know, Refused, Declined)
*** Step through the domains loop to create variable lists 
	foreach Str in `SsDomains' {
		local SsIndicators `SsIndicators' D`Str'
		local SsIndicators_Miss0 `SsIndicators_Miss0' D`Str'_Miss0
	}

*** cfM Domain Ids (which cf-IDs correspond to which domain) 
	local 01AnxietyIds cf23
	local 02DepressionIds cf24
	local 03BehaviourIds cf21
	local 04AcceptingChangeIds cf20
	local 05WalkingIds cf8 cf9 cf10 cf11 cf12 cf13
	local 06LearningIds cf17
	local 07RememberingIds cf18
	local 08MakingFriendsIds cf22
	local 09ConcentratingIds cf19
	local 10SelfcareIds cf14
	local 11CommunicationIds cf15 cf16
	local 12SeeingIds cf1 cf3
	local 13HearingIds cf4 cf6

/*----------------------
** S01 - S02: Anxiety and Depression scores
-----------------------*/
	foreach Dm in 01Anxiety 02Depression { // Dm stands for domain
	*** [1] First, generate S01AnxietyScore:
	**** ranges from 0 to 3 and set to missing if underlying resopnse is 
	**** 6 = "Refused", 7 = "Don't know", 999 = "Survey ended"
	**** , or refused survey altogether (19 students did not take survey).
		gen S`Dm'Score = .
		replace S`Dm'Score = 3 if ``Dm'Ids' == 1 // "Daily"
		replace S`Dm'Score = 2 if ``Dm'Ids' == 2 // "Weekly"
		replace S`Dm'Score = 1 if ``Dm'Ids' == 3 // "Monthly"
	** 4 = "A few times a year", 5 = "Never"
		replace S`Dm'Score = 0 if inrange( ``Dm'Ids', 4, 5 )
	*** [2] Generate S01AnxietyScore_Miss0:
	**** treats values 6, 7, and 999 as 0
		gen S`Dm'Score_Miss0 = S`Dm'Score
		replace S`Dm'Score_Miss0 = 0 if missing( S`Dm'Score ) & !missing( cf1 )
	*** [3] Generate D01Anxiety: indicator for daily suffering
		gen D`Dm' = ( S`Dm'Score == 3 ) if !missing( S`Dm'Score )
	*** [4] Generate D01Anxiety_Miss0: indicator for daily suffering
	****, treating responses 6-999 as 0
		gen D`Dm'_Miss0 = D`Dm' == 1 if !missing( cf1 )
	}
/*----------------------
** S03 - S13: Other scores
-----------------------*/
	foreach Dm in ///
		03Behaviour ///
		04AcceptingChange ///
		05Walking ///
		06Learning ///
		07Remembering ///
		08MakingFriends ///
		09Concentrating ///
		10Selfcare ///
		11Communication ///
		12Seeing ///
		13Hearing { // Dm stands for DOMAIN
	*** [1] Generate S05WalkingScore
	**** Loop through cf responses belonging to this domain
		local `Dm'CfScores // Initialize 05WalkingCfScores variable list
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
		** Populate 05WalkingCfScores variable list
			local `Dm'CfScores ``Dm'CfScores' `Vb'Score
			gen `Vb'Score = `Vb' - 1
		** Variables before cf23: 5 = "Refused", 6 = "Don't know" - to missing
			replace `Vb'Score = . if inrange( `Vb', 5, 6 ) 
		}
		egen S`Dm'Score = rowmax( ``Dm'CfScores' )
	*** [2] Generate S05WalkingScore_Miss0
		local `Dm'CfScores_Miss0
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13'
			local `Dm'CfScores_Miss0 ``Dm'CfScores_Miss0' `Vb'Score_Miss0
			gen `Vb'Score_Miss0 = `Vb'Score
			replace `Vb'Score_Miss0 = 0 if inrange( `Vb', 5, 6 )		
		}
		egen S`Dm'Score_Miss0 = rowmax( ``Dm'CfScores_Miss0' )
	*** [3] Generate D05Walking
		gen D`Dm' = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13		
			replace D`Dm' = . if ( `Vb' == 5 ) | ( `Vb' == 6 )		
		}
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm' = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	*** [3] Generate D05Walking_Miss0
		gen D`Dm'_Miss0 = 0 if !missing( cf1 ) // e.g., D05Walking
		foreach Vb of var ``Dm'Ids' { // e.g., cf8 cf9 cf10 cf11 cf12 cf13
			replace D`Dm'_Miss0 = 1 if ( `Vb' == 3 ) | ( `Vb' == 4 )
		}
	}

/*----------------------
** Total cfM score, max cfM score, severity
-----------------------*/
	order `CfmScores'
	egen TotalCfmScore = rowtotal( `CfmScores' ) if !missing( cf1 )
	egen MaxCfmScore = rowmax( `CfmScores' ) if !missing( cf1 )
	gen NoDisability = MaxCfmScore == 0 if !missing( cf1 )
	gen MildDisability = MaxCfmScore == 1 if !missing( cf1 )
	gen ModerateDisability = MaxCfmScore == 2 if !missing( cf1 )
	gen SevereDisability = MaxCfmScore == 3 if !missing( cf1 )

/*----------------------
** Match FunctionalDifficulty_5to17 = Moderate/Severe Disability_Miss0
-----------------------*/
gen ANXIETY_S = 0
replace ANXIETY_S = 3 if cf23 == 1
replace ANXIETY_S = 1 if cf23 == 2 | cf23 == 3 | cf23 == 4

gen DEPRESSION_S = 0
replace DEPRESSION_S = 3 if cf24 == 1
replace DEPRESSION_S = 1 if cf24 == 2 | cf24 == 3 | cf24 == 4

rename SEE_IND SEE_S
rename HEAR_IND HEAR_S
rename WALK_IND WALK_S
rename cf14 SELFCARE_S
rename COM_IND COMMUNICATION_S
rename cf17 LEARNING_S
rename cf18 REMEMBERING_S
rename cf19 CONCENTRATING_S
rename cf20 ACCEPTINGCHANGE_S
rename cf21 BEHAVIOUR_S
rename cf22 MAKINGFRIENDS_S

local rescore ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach r in `rescore' {
	replace `r' = 0 if `r' == 1
	replace `r' = 1 if `r' == 2
	replace `r' = 2 if `r' == 3
	replace `r' = 3 if `r' == 4
	replace `r' = 0 if `r' == 5 | `r' == 6 | `r' == 9
}

local CfmScores_Miss0 /// 
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S ///
	ANXIETY_S ///
	DEPRESSION_S 
	
egen TotalCfmScore_Miss0 = rowtotal( `CfmScores_Miss0' )
egen MaxCfmScore_Miss0 = rowmax( `CfmScores_Miss0' )
gen NoDisability_Miss0 = MaxCfmScore_Miss0 == 0
gen MildDisability_Miss0 = MaxCfmScore_Miss0 == 1
gen ModerateDisability_Miss0 = MaxCfmScore_Miss0 == 2
gen SevereDisability_Miss0 = MaxCfmScore_Miss0 == 3 

/*----------------------
** Match FunctionalDifficulty_without = Moderate/Severe Disability_without
-----------------------*/
local rescore_without ///
	SEE_S ///
	HEAR_S ///
	WALK_S ///
	SELFCARE_S ///
	COMMUNICATION_S ///
	LEARNING_S ///
	REMEMBERING_S ///
	CONCENTRATING_S ///
	ACCEPTINGCHANGE_S ///
	BEHAVIOUR_S ///
	MAKINGFRIENDS_S 
	
foreach a in `rescore_without' {
	gen `a'_without = 0
	replace `a'_without = 0 if `a' == 0
	replace `a'_without = 1 if `a' == 1
	replace `a'_without = 2 if `a' == 2
	replace `a'_without = 3 if `a' == 3
}

local CfmScores_without /// 
	SEE_S_without ///
	HEAR_S_without ///
	WALK_S_without ///
	SELFCARE_S_without ///
	COMMUNICATION_S_without ///
	LEARNING_S_without ///
	REMEMBERING_S_without ///
	CONCENTRATING_S_without ///
	ACCEPTINGCHANGE_S_without ///
	BEHAVIOUR_S_without ///
	MAKINGFRIENDS_S_without
	
egen TotalCfmScore_without = rowtotal( `CfmScores_without' )	
egen MaxCfmScore_without = rowmax( `CfmScores_without' )
gen NoDisability_without = MaxCfmScore_without == 0
gen MildDisability_without = MaxCfmScore_without == 1
gen ModerateDisability_without = MaxCfmScore_without == 2
gen SevereDisability_without = MaxCfmScore_without == 3

/*----------------------
** Total cfM Indicator, max cfM indicator
-----------------------*/
	order `CfmIndicators'
	egen TotalCfmIndicator = rowtotal( `CfmIndicators' ) if !missing( cf1 )
	egen MaxCfmIndicator = rowmax( `CfmIndicators' ) if !missing( cf1 )
/*----------------------
** Harmonizing with ASC
-----------------------*/

	gen Physical = 0 if !missing( cf1 )
	replace Physical = 1 if (D05Walking == 1) | (D10Selfcare ==1)

	gen Lowvision = 0 if !missing( cf1 )
	replace Lowvision = 1 if S12SeeingScore == 2

	gen Blind = 0 if !missing( cf1 )
	replace Blind = 1 if S12SeeingScore == 3

	gen Lowhearing = 0 if !missing( cf1 )
	replace Lowhearing = 1 if S13HearingScore == 2

	gen Deaf = 0 if !missing( cf1 )
	replace Deaf = 1 if S13HearingScore == 3

	gen Deafblind = 0 if !missing( cf1 )
	replace Deafblind = 1 if (Blind == 1) & (Deaf == 1)

	tab D02Depression
	gen Intellectual = 0 if !missing( cf1 )
	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// 
		| ( D04AcceptingChange == 1 & D01Anxiety != 1 ) /// 
		| ( D04AcceptingChange != 1 & D01Anxiety == 1 ) // mood & behavior

/*
Autism is constrcted by the combintaion of daily anxiety 
and inacapacity to accepting changes in the routine.
*/

	gen Autism = 0 if !missing( cf1 )
	replace Autism = 1 if (D04AcceptingChange ==1) & (D01Anxiety ==1) 

	gen Multiple = 0 if !missing( cf1 )
	replace Multiple = Physical + Lowvision + Blind + Lowhearing + Deaf > 1
	replace Multiple = . if missing( cf1 )

**Generating exclusive indicators
	gen exPhysical = Physical == 1 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exLowvision = Physical == 0 & Lowvision == 1 & Blind == 0 & Lowhearing == 0 & Deaf == 0
	gen exBlind = Physical == 0 & Lowvision == 0 & Blind == 1 & Lowhearing == 0 & Deaf == 0
	gen exLowhearing = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 1 & Deaf == 0
	gen exDeaf = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 1
	gen exAutism = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 1
	gen exIntellectual = Physical == 0 & Lowvision == 0 & Blind == 0 & Lowhearing == 0 & Deaf == 0 & Autism == 0 & Intellectual == 1

	local exlist ///
		exPhysical ///
		exLowvision ///
		exBlind ///
		exLowhearing ///
		exDeaf ///
		exAutism ///
		exIntellectual
	
	foreach vb in `exlist' {
		replace `vb'=. if missing( cf1 )
	}


	gen exCognitive = 0 if !missing( cf1 )
	replace exCognitive = 1 if exIntellectual == 1 & (0 ///
		| ( D06Learning == 1 ) /// cognitive
		| ( D07Remembering == 1 ) /// cognitive
		| ( D09Concentrating == 1) ///
		| ( D11Communication == 1))
	
	gen exMoodBehavioral = 0 if !missing( cf1 )
	replace exMoodBehavioral = 1 if exIntellectual == 1 & exCognitive == 0

	replace Intellectual = 1 if 0 ///
		| ( D02Depression == 1 ) /// mood & behavior
		| ( D03Behaviour == 1 ) /// mood & behavior
		| ( D06Learning == 1 ) /// cognitive 
		| ( D07Remembering == 1 ) /// cognitive 
		| ( D08MakingFriends == 1 ) /// mood & behavior
		| ( D09Concentrating == 1 ) /// cognitive 
		| ( D11Communication == 1 ) /// cognitive
		| ( D04AcceptingChange == 1 & D01Anxiety !=1 ) /// mood & behavior
		| ( D04AcceptingChange != 1 & D01Anxiety ==1 ) // mood & behavior


**Generating exclusive total and comparing with original total
	gen exTotal = 0 if !missing( cf1 )
	replace exTotal = 1 if 0 ///
		| (exPhysical == 1) ///
		| (exLowvision == 1) ///
		| (exBlind == 1) ///
		| (exLowhearing == 1) ///
		| (exDeaf == 1) ///
		| (Deafblind == 1) ///
		| (exIntellectual == 1) ///
		| (exAutism == 1) ///
		| (Multiple == 1)

	gen Total = 0 if !missing( cf1 )
	replace Total = 1 if 0 ///
		| (Physical ==1) ///
		| (Lowvision ==1) ///
		| (Blind ==1) ///
		| (Lowhearing ==1) ///
		| (Deaf ==1) ///
		| (Deafblind ==1) ///
		| (Intellectual ==1) ///
		| (Autism == 1) ///
		| (Multiple == 1)

	compare Total exTotal

	tab FunctionalDifficulty_5to17

	local Indicators ///
		D01Anxiety ///
		D02Depression ///
		D03Behaviour ///
		D04AcceptingChange ///
		D05Walking ///
		D06Learning ///
		D07Remembering ///
		D08MakingFriends ///
		D09Concentrating ///
		D10Selfcare ///
		D11Communication ///
		D12Seeing ///
		D13Hearing
	
	tokenize ///
		Anxiety ///
		Depression ///
		Behaviour ///
		AcceptingChange ///
		Walking ///
		Learning ///
		Remembering ///
		MakingFriends ///
		Concentrating ///
		Selfcare ///
		Communication ///
		Seeing ///
		Hearing 
	
	local Nb = 0

	foreach i in `Indicators' {
		local Nb = `Nb' + 1
		gen ``Nb'' = `i' * 100
	}
		
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
	gen country = "`c'"

	save "${PathDataIntermediate}\\UNICEF_Cfm_`c'.dta", replace
}

local EAP ///
	Fiji ///
	Viet_Nam ///
	Samoa ///
	Tuvalu ///
	Tonga ///
	Kiribati ///
	Mongolia
	
foreach cc in `EAP' {
	use "${PathDataIntermediate}\\UNICEF_Cfm_`cc'.dta", clear
	count
	
	asdoc sum Anxiety Depression Behaviour ///
		AcceptingChange Walking Learning Remembering ///
		MakingFriends Concentrating Selfcare Communication ///
		Seeing Hearing, stat(mean), column
		
	tab FunctionalDifficulty_5to17
}


*************************************
** Clean MICS_population
*************************************

**import excel ///
**	"${PathHome}/Data/Raw/UnicefMics/MICS_population.xlsx" ///
**	 , sheet( "Sheet1" ) cellrange( A1:F52 ) ///
**	firstrow clear
** save "${PathHome}/Data/Intermediate/UnicefMics/Mics_population.dta", replace

use "${PathDataIntermediate}\\Mics_population.dta", clear

egen total_ssa = total(total) if n < 17 
egen total_world = total(total) if n < 52 

format total_ssa %12.0fc
format total_world %12.0fc

replace country = "Sao_Tome_and_Principe" if country == "Sao Tome and Principe"
replace country = "Central_African_Republic" if country == "Central African Republic"
replace country = "Guinea_Bissau" if country == "Guinea Bissau"
replace country = "Sierra_Leone" if country == "Sierra Leone"
replace country = "The_Gambia" if country == "The Gambia"
replace country = "State_of_Palestine" if country == "State of Palestine"
replace country = "Republic_of_North_Macedonia" if country == "Republic of North Macedonia"
replace country = "Turks_and_Caicos_Islands" if country == "Turks and Caicos Islands"
replace country = "Dominican_Republic" if country == "Dominican Republic"
replace country = "Costa_Rica" if country == "Costa Rica"
replace country = "Viet_Nam" if country == "Vietnam"
replace country = "Georgia" if country == "Goergia"
replace country = "Trinidad_and_Tobago" if country == "Trinidad and Tobago"


*replace total = 14077000 in 36

*egen total1 = total if !missing( total_ssa )

*egen total1 = total( total ) if !missing( total_ssa )
*recast int total1
*total1:  14 values would be changed; not changed
*recast int total1, force
*total1:  14 values changed
*drop total1

egen long total1 = total( total ) if !missing( total_ssa )
*(32 missing values generated)

egen long total2 = total( total )

egen long total3 = total( total_6to13 ) if !missing( total_ssa )
egen long total4 = total( total_6to13 )

drop total_ssa total_world
rename total1 total_ssa
rename total2 total_world
rename total3 total_ssa_6to13
rename total4 total_world_6to13

generate log_gdp = ln(GDP)

save "${PathDataIntermediate}\\Mics_population_clean.dta", replace

timer off 1
timer list 1

//     1:      13.29 /        1 =       13.29
*************************************
** Close workspace
*************************************
