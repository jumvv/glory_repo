** 241111
** PSSP PE HT Data Construct Variables

*************************************
** Set up workspace
*************************************
version 14.1
clear all	
set graphics off
set varlab on
timer on 1

***********************************************************
** Import SB monitoring data merged with ASC/SB baseline **
***********************************************************
use "${shule_bora_DB}\pssp\DataSets\Deidentified\HT PSSP Survey ENCRYPTED.dta", clear

************************************
** Clean & Construct pssp HT data **
************************************
destring survey_duration, replace
gen survey_duration_min = survey_duration/60
tab survey_duration_min

gen a7_board_1 = 0 if a7_board !=.
replace a7_board_1 = 1 if a7_board == 1
label var a7_board_1 "	  Boarding only"
gen a7_board_2 = 0 if a7_board !=.
replace a7_board_2 = 1 if a7_board == 2
label var a7_board_2 "	  Mixed"
gen a7_board_3 = 0 if a7_board !=.
replace a7_board_3 = 1 if a7_board == 3
label var a7_board_3 "	  Day only"
replace a7_board =.

gen a7_sen_1 = 0 if a7_sen !=.
replace a7_sen_1 = 1 if a7_sen == 1
label var a7_sen_1 "	  Ordinary"
gen a7_sen_2 = 0 if a7_sen !=.
replace a7_sen_2 = 1 if a7_sen == 2
label var a7_sen_2 "	  SEN"
gen a7_sen_3 = 0 if a7_sen !=.
replace a7_sen_3 = 1 if a7_sen == 3
label var a7_sen_3 "	  Mixed/integrated"
replace a7_sen =.

label var survey_duration_min "Total duration of survey"
label var a9   "a9. Consent"

**Reason for refusal
label var a10 "a10. Reason for refusal"

gen a10_1 = 0 if a10 !=.
replace a10_1 = 1 if a10 == 1
gen a10_2 = 0 if a10 !=.
replace a10_2 = 1 if a10 == 2
gen a10_3 = 0 if a10 !=.
replace a10_3 = 1 if a10 == 3
gen a10_4 = 0 if a10 !=.
replace a10_4 = 1 if a10 == 4
gen a10_5 = 0 if a10 !=.
replace a10_5 = 1 if a10 == -96
gen a10_6 = 0 if a10 !=.
replace a10_6 = 1 if a10 == -99

replace a10 =.

label var a10_1 "	Lack of time"
label var a10_2 "	Concern about privacy"
label var a10_3 "	Perceived lack of relevance"
label var a10_4 "	Disinterest"
label var a10_5 "	Other, specify"
label var a10_6	"   Don't answer"

foreach v in a b c d e f g h i k l j {
	destring `v'_duration_min, replace
	label var `v'_duration_min "Survey duration of Module `v'"
	}
*****************************************
** Module B: HT/School Characteristics **
*****************************************
gen b =.
label var b "Module B: HT/School Characteristics"


gen b1_m = 0 if b1 !=.
replace b1_m = 1 if b1 == 0
label variable b1_m   "		Male"
gen b1_f = 0 if b1 !=.
replace b1_f = 1 if b1 == 1
label variable b1_f   "		Female"
label var b1 "b1. Gender of the respondent"
replace b1 =.

replace b2 = b2_oth if b2 == 71
replace b2 =. if b2 == -99

gen b3_1 = 0 if b3 != .
replace b3_1 = 1 if b3 == 1
gen b3_2 = 0 if b3 != .
replace b3_2 = 1 if b3 == 2
gen b3_3 = 0 if b3 != .
replace b3_3 = 1 if b3 == 3
gen b3_4 = 0 if b3 != .
replace b3_4 = 1 if b3 == 4
gen b3_5 = 0 if b3 != .
replace b3_5 = 1 if b3 == 5
gen b3_6 = 0 if b3 != .
replace b3_6 = 1 if b3 == 6
gen b3_7 = 0 if b3 != .
replace b3_7 = 1 if b3 == 7
gen b3_8 = 0 if b3 != .
replace b3_8 = 1 if b3 == 8
gen b3_9 = 0 if b3 != .
replace b3_9 = 1 if b3 == 0
replace b3 =.

label variable b3_1   "		Primary complete"
label variable b3_2   "		Secondary (O-level)"
label variable b3_3   "		Secondary (A-level)"
label variable b3_4   "		Diploma/Certificate"
label variable b3_5   "		Postgraduate"
label variable b3_6   "		Bachelor"
label variable b3_7   "		Master"
label variable b3_8   "		PhD"
label variable b3_9   "		None"
replace b3 =.
label var b3 "b3. What is the highest level of education you have completed?"


replace b4 = b4_oth if b4 == -96
replace b5 = b5_oth if b5 == -96
replace b7 = b7_oth if b7 == -96
replace b8 = b8_oth if b8 == -96

gen total_t = b7 + b8
label var total_t "Total number of teachers"

label variable b10_1   "	Pre-primary"
label variable b10_2   "	Std 1"
label variable b10_3   "	Std 2"
label variable b10_4   "	Std 3"
label variable b10_5   "	Std 4"
label variable b10_6   "	Std 5"
label variable b10_7   "	Std 6"
label variable b10_8   "	Std 7"
label variable b10_9   "	All Stds"
label var b10__96	"	 Other"
rename b10__96 b10_96

*****************************************
** Module C: HT/School Characteristics **
*****************************************
gen c =.
label var c "Module C: HT/School Characteristics"

label var c1 "c1. Have you heard about PSSP?"
label var c2 "c2. Have you or your staff received training through PSSP?"

local staff ///
		c3 ///
		c9
		
foreach s in `staff' {
	label var `s'_1 "	Yourself(HT)"
	label var `s'_2 "	Assistant HT"
	label var `s'_3 "	Academic teacher"
	label var `s'_4 "	Regular teacher"	
	label var `s'_5 "	GC teacher"
	label var `s'__96 "	  Other"
	rename `s'__96 `s'_96
	replace `s' = ""
	}
label var c3 "(Multiple) c3. Who in your school received the PSSP training?"
label var c9 "(Multiple) c9. Who in your school received this other training?"	
	
rename v94 c3_aht
label var c3_aht "c3.aht Did the Assistant HT attend the training on your behalf?"

gen c3_why_1 = 0 if c3_why !=. 
replace c3_why_1 = 1 if c3_why == 1
label var c3_why_1 "	There was no training in my LGA that I am aware of"

gen c3_why_2 = 0 if c3_why !=.
replace c3_why_2 = 1 if c3_why == 2
label var c3_why_2 "	Could not attend due to other commitments in the school"

gen c3_why_3 = 0 if c3_why !=.
replace c3_why_3 = 1 if c3_why == 3
label var c3_why_3 "	Could not attend due to personal commitments"

gen c3_why_4 = 0 if c3_why !=.
replace c3_why_4 = 1 if c3_why == 4
label var c3_why_4 "	Could not afford to attend (due to cost of travel or lodging"

gen c3_why_5 = 0 if c3_why !=.
replace c3_why_5 = 1 if c3_why == -96
label var c3_why_5 "	Other"

replace c5 = ""
label var c5 "(Multiple) c5. Which government level delivered the PSSP training?"
label var c5_1 "	National government"
label var c5_2 "	Region government"
label var c5_3 "	Local government"
label var c5_4 "	WEOs"
label var c5__96 "	  Other"
label var c5__98 "	  DK"
rename (c5__96 c5__98) (c5_96 c5_98)

replace c6 = c6_oth if c6 == -96
label var c6 "c6. How many days did this training last?"
label var c6_hr "c6_hr. Training duration in hrs (if less than a full day)"

replace c7 = ""
label var c7 "(Multiple) c7. Which components were covered in the PSSP training?"
label var c7_1 "	GC services"
label var c7_2 "	Teachers CoC"
label var c7_3 "	Relations between schools, parents and communities (PTP)"
label var c7_4 "	Life skills"
label var c7_5 "	Safe passage to/from school"
label var c7_6 "	CRM"
label var c7_7 "	Monitoring dropouts (DEWS)"
label var c7_8 "	School feeding program"
label var c7_9 "	Monitoring of PSSP"
label var c7__96 "	  Other"
label var c7__98 "	  Don't know"	
rename (c7__96 c7__98) (c7_96 c7_98)

replace c11 =""
label var c11 "(Multiple) Which entity delivered/organized this training?"

label var c11_1 "	Other ministries (other than MoEST/PORALG)"
label var c11_2 "	Donors (UK aid, USAID, etc.)"
label var c11_3 "	ADEM"
label var c11_4 "	NGO"
label var c11_5 "	Teacher CoL (MEWAKA)"
label var c11__96 "	  Other"
label var c11__98 "	  Don't know"
rename (c11__96 c11__98) (c11_96 c11_98)

local copy ///
		c12 ///
		c14 
		
foreach c in `copy' {

	gen `c'_1 = 0 if `c' !=.
	replace `c'_1 = 1 if `c' == 1
	label var `c'_1 "	Yes, hard copy only"

	gen `c'_2 = 0 if `c' !=.
	replace `c'_2 = 1 if `c' == 2
	label var `c'_2 "	Yes, soft copy only"

	gen `c'_3 = 0 if `c' !=.
	replace `c'_3 = 1 if `c' == 3
	label var `c'_3 "	Yes, hard and soft copy"

	gen `c'_4 = 0 if `c' !=.
	replace `c'_4 = 1 if `c' == 0
	label var `c'_4 "	No"
	
	replace `c' = .
	}

rename (v244 v245) (d_manual d_manual_r)

local read ///
		c12_r ///
		c14_r ///
		e1_r ///
		j13 ///
	    i30 ///
		i32 ///
		d_manual_r
		
foreach r in `read' {
	
	gen `r'_1 = 0 if `r' !=.
	replace `r'_1 = 1 if `r' == 1
	label var `r'_1 "	Yes, fully"

	gen `r'_2 = 0 if `r' !=.
	replace `r'_2 = 1 if `r' == 2
	label var `r'_2 "	Yes, partially"

	gen `r'_3 = 0 if `r' !=.
	replace `r'_3 = 1 if `r' == 0
	label var `r'_3 "	No"
	
	gen `r'_4 = 0 if `r' !=.
	replace `r'_4 = 1 if `r' == -99
	label var `r'_4 "	DA"
	replace `r' =.
	}

local how ///
		c12_s ///
		c14_s ///
		e1_s
		
foreach h in `how' {
	gen `h'_1 = 0 if `h' !=.
	replace `h'_1 = 1 if `h' == 1
	label var `h'_1 "	Whatsapp"

	gen `h'_2 = 0 if `h' !=.
	replace `h'_2 = 1 if `h' == 2
	label var `h'_2 "	Email"

	gen `h'_3 = 0 if `h' !=.
	replace `h'_3 = 1 if `h' == -96
	label var `h'_3 "	Other"
	
	replace `h' =.
	}

local photo ///
		c13 ///
		c15	///
		f14 ///
		j2_v 
** maybe add g1_v	
	
foreach p in `photo' {
	gen `p'_1 = 0 if `p' !=.
	replace `p'_1 = 1 if `p' == 1
	label var `p'_1 "	Yes, can take a picture"

	gen `p'_2 = 0 if `p' !=.
	replace `p'_2 = 1 if `p' == 2
	label var `p'_2 "	Yes, cannot take a picture"

	gen `p'_3 = 0 if `p' !=.
	replace `p'_3 = 1 if `p' == 0
	label var `p'_3 "	No"
	
	gen `p'_4 = 0 if `p' !=.
	replace `p'_4 = 1 if `p' == -98
	label var `p'_4 "	DK"
	
	replace `p' =.
	}

***************************
** Module D: GC Services **
***************************
gen d =.
label var d "Module D: GC Services"

replace d2 = ""
label var d2 "(Multiple) d2. Why are GC services not offered?"
label var d2_1 "	No teacher that received the GC training in the school"
label var d2_2 "	Have not yet had time to select/elect GC teachers"
label var d2_3 "	There are not enough teachers to serve as GC teachers"
label var d2__96 "	  Other"
rename d2__96 d2_96

replace d3_m = d3_m_oth if d3_m == 6
replace d3_f = d3_f_oth if d3_f == 6
gen d3_total = d3_m + d3_f
label var d3_total "Total number of GC teachers"

replace d4 = ""
label var d4 "(Multiple) d4. Who selected the GC teachers?"
label var d4_1 "	HT"
label var d4_2 "	Teachers"
label var d4_3 "	Students"
label var d4__96 "	  Other"
rename d4__96 d4_96

replace d5 = d5_oth if d5 == 6
replace d6 = d6_oth if d6 == 6

gen d6_total = d5 + d6
label var d6_total "Total number of GC teachers that received PSSP training"

gen d6_prop = d6_total/d3_total
label var d6_prop "Proportion of GC teachers trained with PSSP training"

label var d7 "(Multiple) d7. What are the main reasons why some GC teachers did not receive the multi-day PSSP training on GC services?"
label var d7_1 "	GC teachers were unable to find time amidst teaching duties"
label var d7_2 "	Training was too far/too costly to get to"
label var d7_3 "	Did not think this training was necessary"
label var d7_4 "	Already received GC training in the past (prior to 2023/PSSP)"
label var d7_5 "	GC teachers moved from a different school where they did not receive the training"
label var d7_6 "	GC retired"
label var d7__96 "	Other"
rename d7__96 d7_96
replace d7 =""

label var d12 "(Multiple) d12. Why not have a special room/place?"
label var d12_1 "	Did not know a special room/place should be designated"
label var d12_2 "	Do not hink a special room/place is necessary for GC"
label var d12_3 "	Do not have such room/space in the school"
label var d12__96 "	  Other"
rename d12__96 d12_96
replace d12 = ""	

gen d13_1 = 0 if d13 !=.
replace d13_1 = 1 if d13 == 1
label var d13_1 "	Dedicated room with privacy (e.g. with a door)"

gen d13_2 = 0 if d13 !=.
replace d13_2 = 1 if d13 == 2
label var d13_2 "	Dedicated room without privacy (e.g. without a door)"

gen d13_3 = 0 if d13 !=.
replace d13_3 = 1 if d13 == 3
label var d13_3 "	Room that is also used for other purposes, but during GC hours it is private (library, study, classroom)"

gen d13_4 = 0 if d13 !=.
replace d13_4 = 1 if d13 == 4
label var d13_4 "	Room that is also used for other purposes and is not private"

gen d13_5 = 0 if d13 !=.
replace d13_5 = 1 if d13 == -96
label var d13_5 "	Other"
replace d13 =.

local YNDK ///
	d17 ///
	d21 ///
	e11 ///
	e14 ///
	f1 ///
	h4 ///
	k1 ///
	l6 ///
	j15 ///
	g1

foreach y in `YNDK' {
	gen `y'_1 = 0 if `y' !=.
	replace `y'_1 = 1 if `y' == 1
	label var `y'_1 "	Yes"

	gen `y'_2 = 0 if `y' !=.
	replace `y'_2 = 1 if `y' == 0
	label var `y'_2 "	No"

	gen `y'_3 = 0 if `y' !=.
	replace `y'_3 = 1 if `y' == -98
	label var `y'_3 "	DK"
	replace `y' =.
}

local com ///
	d18 ///
	d22

foreach c in `com' {	
	label var `c'_1 "	General meetings with all the school"
	label var `c'_2 "	Teachers in their classroom inform them"
	label var `c'_3 "	Bulletin boards"
	label var `c'_4 "	Social media school page"
	label var `c'_5 "	Email"
	label var `c'_6 "	Whatsapp"
	label var `c'__96 "	  Other"
	rename `c'__96 `c'_96
}
replace d18 = ""
label var d18 "(Multiple) Which media has the school used to communicate the GC service to students?"
replace d22 = ""
label var d22 "(Multiple) Which media has the school used to communicate the GC service to parents?"

*All variables about agreement

local agree ///
	d23_1 ///
	d23_2 ///
	d23_3 ///
	d23_4 ///
	e5_1 ///
	e5_2 ///
	e5_3 ///
	e5_4 ///
	i23_1 
	
foreach a in `agree' {
	gen `a'_1 = 0 if `a' !=.
	replace `a'_1 = 1 if `a' == 1
	label var `a'_1 "	Strongly agree"

	gen `a'_2 = 0 if `a' !=.
	replace `a'_2 = 1 if `a' == 2
	label var `a'_2 "	Agree"

	gen `a'_3 = 0 if `a' !=.
	replace `a'_3 = 1 if `a' == 3
	label var `a'_3 "	Neither agree nor disagree"

	gen `a'_4 = 0 if `a' !=.
	replace `a'_4 = 1 if `a' == 4
	label var `a'_4 "	Disagree"

	gen `a'_5 = 0 if `a' !=.
	replace `a'_5 = 1 if `a' == 5
	label var `a'_5 "	Strongly disagree"
	replace `a' =.
}
label var d_manual "Have you received the National Standard Child Protection Manual?"
label var d_manual_r "Have you read it?"

****************************************
** Module E: Teachers Code of Conduct **
****************************************
gen e =.
label var e "Module E: Teachers Code of Conduct"

local copy ///
	e1 ///
	f13
foreach c in `copy' {
		
	gen `c'_1 = 0 if `c' !=.
	replace `c'_1 = 1 if `c' == 1
	label var `c'_1 "	Hard copy only"

	gen `c'_2 = 0 if `c' !=.
	replace `c'_2 = 1 if `c' == 2
	label var `c'_2 "	Soft copy only"

	gen `c'_3 = 0 if `c' !=.
	replace `c'_3 = 1 if `c' == 3
	label var `c'_3 "	Both, hard and soft copy"

	gen `c'_4 = 0 if `c' !=.
	replace `c'_4 = 1 if `c' == 0
	label var `c'_4 "	No"
	
	gen `c'_5 = 0 if `c' !=.
	replace `c'_5 = 1 if `c' == -98
	label var `c'_5 "	DK"
	replace `c' =.
}

gen e1_v_1 = 0 if e1_v !=.
replace e1_v_1 = 1 if e1_v == 1
label var e1_v_1 "	Could see the CoC and can take a picture"

gen e1_v_2 = 0 if e1_v !=.
replace e1_v_2 = 1 if e1_v == 2
label var e1_v_2 "	Could see the CoC but cannot take a picture"

gen e1_v_3 = 0 if e1_v !=.
replace e1_v_3 = 1 if e1_v == 0
label var e1_v_3 "	Could not see the CoC"
replace e1_v =.

replace e3 = e3_oth if e3 == 61
gen e3_prop = e3 / total_t
label var e3_prop "Proportion of teachers that were trained on the updated CoC"

local frequency ///
	e6_1 ///
	e6_2
	
foreach f in `frequency' {
	gen `f'_1 = 0 if `f' !=.
	replace `f'_1 = 1 if `f' == 1
	label var `f'_1 "	Every time"
	
	gen `f'_2 = 0 if `f' !=.
	replace `f'_2 = 1 if `f' == 2
	label var `f'_2 "	Most of the time"
	
	gen `f'_3 = 0 if `f' !=.
	replace `f'_3 = 1 if `f' == 3
	label var `f'_3 "	Some of the time"
	
	gen `f'_4 = 0 if `f' !=.
	replace `f'_4 = 1 if `f' == 4
	label var `f'_4 "	Rarely"
	
	gen `f'_5 = 0 if `f' !=.
	replace `f'_5 = 1 if `f' == 0
	label var `f'_5 "	Never"
	
	gen `f'_6 = 0 if `f' !=.
	replace `f'_6 = 1 if `f' == -99
	label var `f'_6 "	Don't answer"
	replace `f' =.
	}
	
local challenge ///
	e8
foreach c in `challenge' {
	label var `c'_1 "	Absenteeism"
	label var `c'_2 "	Tardiness"
	label var `c'_3 "	Taking leave early"
	label var `c'_4 "	Not fulfilling teaching duties on time and with care"
	label var `c'_5 "	Chronic absenteeism (5 consecutive days or more)"
	label var `c'_6 "	Abuse of power (using students to work), using school resources for personal gain"
	label var `c'_7 "	Damage to property"
	label var `c'_8 "	Disrespectable actions"
	label var `c'_9 "	Disobeying orders"
	label var `c'_10 "	 Refusal to transfer"
	label var `c'_11 "	 Fraud during examinations"
	label var `c'_12 "	 Providing fake transfers to students/refusing to receive transfer students"
	label var `c'_13 "	 Drinking/drug use"
	label var `c'_14 "	 Criminal offense (treason, poaching, theft, corruption, forgery, abortion)"
	label var `c'_15 "	 Not following the dress code"	
	label var `c'__96 "	 Other"
	label var `c'__98 "	 Don't know"
	label var `c'__99 "	 Don't answer"
	rename (`c'__96 `c'__98 `c'__99) (`c'_96 `c'_98 `c'_99)
	replace `c' =""
	label var `c' "(Up to 3) e8. What are the most common violations of the teachers' CoC?"
}

local punish ///
	e9 ///
	e10
foreach p in `punish' {
	label var `p'_1 "	Warning"
	label var `p'_2 "	Dismissal"
	label var `p'_3 "	Reprimand"
	label var `p'_4 "	Prevent additions of salary"
	label var `p'_5 "	Demotion"
	label var `p'_6 "	Deduction of 15% of salary for 3 years"
	label var `p'_7 "	Taking classes/subjects away from the teacher"
	label var `p'_0 "	No punishment"
	label var `p'__96 "	  Other"
	label var `p'__99 "	  Don't know/Don't answer"
	rename (`p'__96 `p'__99) (`p'_96 `p'__99)
	replace `p' =""
}
label var e9 "(Multiple) e9. If a teacher gets absent from school between 1 and 5 days without permission"
label var e10 "(Multiple) e10. If a teacher is drinking alcohol during working, what type of punishment do"

local freq2 ///
	e12
foreach f in `freq2' {
	gen `f'_1 = 0 if `f' !=.
	replace `f'_1 = 1 if `f' == 1
	label var `f'_1 "	Always"
	
	gen `f'_2 = 0 if `f' !=.
	replace `f'_2 = 1 if `f' == 2
	label var `f'_2 "	Most of the time"

	gen `f'_3 = 0 if `f' !=.
	replace `f'_3 = 1 if `f' == 3
	label var `f'_3 "	Sometimes"
	
	gen `f'_4 = 0 if `f' !=.
	replace `f'_4 = 1 if `f' == 4
	label var `f'_4 "	The offenses were minor, so I did not issue any punishment"

	gen `f'_5 = 0 if `f' !=.
	replace `f'_5 = 1 if `f' == 5
	label var `f'_5 "	I have never had offenses by teachers that deserve a punishment"

	gen `f'_6 = 0 if `f' !=.
	replace `f'_6 = 1 if `f' == 0
	label var `f'_6 "	Never"	
	
	gen `f'_7 = 0 if `f' !=.
	replace `f'_7 = 1 if `f' == -98
	label var `f'_7 "	Don't know"	
	
	replace `f' =.
}
	
label var e13 "(Multiple) Why were you sometimes not able to issue the punishments?"
label var e13_1 "	I cannot effectively sanction teachers because there are not enough teachers in the school"
label var e13_2 "	Warnings/reprimands do not matter to teachers"
label var e13_3 "	In practice, the procedure to withhold salary increases or reduce salary is long/diffcult"
label var e13_4 "	In practice, the procedure to demote or dismiss a teacher is long/difficult"
label var e13__96 "	  Other"
label var e13__99 "	  DK/DA"
rename (e13__96 e13__99) (e13_96 e13_99)
replace e13 = ""

local freq3 ///
	e15
	
foreach f in `freq3' {
	gen `f'_1 = 0 if `f' !=.
	replace `f'_1 = 1 if `f' == 1
	label var `f'_1 "	Always"
	
	gen `f'_2 = 0 if `f' !=.
	replace `f'_2 = 1 if `f' == 2
	label var `f'_2 "	Most of the time"

	gen `f'_3 = 0 if `f' !=.
	replace `f'_3 = 1 if `f' == 3
	label var `f'_3 "	Sometimes"
	
	gen `f'_4 = 0 if `f' !=.
	replace `f'_4 = 1 if `f' == 0
	label var `f'_4 "	Never"	
	
	gen `f'_5 = 0 if `f' !=.
	replace `f'_5 = 1 if `f' == -98
	label var `f'_5 "	DK"	
	replace `f' =.
}

************************************************************************
** Module F: Relations between schools, parents and communities (PTP) **
************************************************************************
gen f =.
label var f "Module F: Relations between schools, parents and communities (PTP)"

label var f2 "(Multiple) f2. Which grades have parents and teachers' representation at the PTP?"
label variable f2_1   "		Std 1"
label variable f2_2   "		Std 2"
label variable f2_3   "		Std 3"
label variable f2_4   "		Std 4"
label variable f2_5   "		Std 5"
label variable f2_6   "		Std 6"
label variable f2_7   "		Std 7"
label variable f2_8   "		All Stds"
replace f2 = ""

label var f3 "(Multiple) f3. Why has a PTP not been established yet?"

label variable f3_1   "		Insufficient time to set up"
label variable f3_2   "		Insufficient resources/knowledge to set up"
label variable f3_3   "		Logistical challenges (i.e. agreement on a time and place to run a meeting)"
label variable f3_4   "		Poor attendance from parents"
label variable f3_5   "		Lack of commitment from teachers"
label variable f3__96   "	  Other"
label variable f3__98   "	  DK"
label variable f3__99   "	  DA"
 
rename (f3__96 f3__98 f3__99) (f3_96 f3_98 f3_99)
replace f3 = ""

local freq4 ///
	f4 ///
	f16
foreach f in `freq4' {
	gen `f'_1 = 0 if `f' !=.
	replace `f'_1 = 1 if `f' == 1
	label var `f'_1 "	Every week"
	
	gen `f'_2 = 0 if `f' !=.
	replace `f'_2 = 1 if `f' == 2
	label var `f'_2 "	Every two weeks"

	gen `f'_3 = 0 if `f' !=.
	replace `f'_3 = 1 if `f' == 3
	label var `f'_3 "	Every month"
	
	gen `f'_4 = 0 if `f' !=.
	replace `f'_4 = 1 if `f' == 4
	label var `f'_4 "	Twice per term"	
	
	gen `f'_5 = 0 if `f' !=.
	replace `f'_5 = 1 if `f' == 5
	label var `f'_5 "	Once per term"	
	
	gen `f'_6 = 0 if `f' !=.
	replace `f'_6 = 1 if `f' == 6
	label var `f'_6 "	Once a year"	
	
	gen `f'_7 = 0 if `f' !=.
	replace `f'_7 = 1 if `f' == 0
	label var `f'_7 "	Never"	

	gen `f'_8 = 0 if `f' !=.
	replace `f'_8 = 1 if `f' == -98
	label var `f'_8 "	DK"	
	
	gen `f'_9 = 0 if `f' !=.
	replace `f'_9 = 1 if `f' == -99
	label var `f'_9 "	DA"		
	replace `f' =.
}

local focus ///
	f5
foreach ff in `focus' {
	label var `ff' "(Multiple) f5. What are the PTPs' main focus/activities in your school?"
	label var `ff'_1 "	Helping children in need"
	label var `ff'_2 "	School feeding"
	label var `ff'_3 "	Safety of students in school"
	label var `ff'_4 "	Representing parent's views at school"	
	label var `ff'_5 "	Counseling and outreach to keep girls in school"	
	label var `ff'_6 "	Supporting children with disabilities"	
	label var `ff'__96 "	  Other"	
	rename `ff'__96 `ff'_96
	replace `ff' = ""
}
local focus2 ///
	f17
foreach ff in `focus2' {
	label var `ff' "(Multiple) f17. What is the main focus of meeting with the CDO?"
	label var `ff'_1 "	Helping children in need"
	label var `ff'_2 "	School feeding"
	label var `ff'_3 "	Safety of students in school"
	label var `ff'_4 "	Counseling and outreach to keep girls in school"	
	label var `ff'_5 "	Supporting children with disabilities"	
	label var `ff'__96 "	  Other"	
	rename `ff'__96 `ff'_96
	replace `ff' = ""
}

****************************
** Module G: Safe passage **
****************************
gen g =.
label var g "Module G: Safe passage"

label var g2 "(Multiple) g2. What activities have your school conducted this school year to reduce risk associated with traveling"
label var g2_1 "	Communication materials about safety on way to /from school (pictures, cartoons..)"
label var g2_2 "	Awareness meetings with community"
label var g2_3 "	Advocating for group walking or escorting pupils to and from school"
label var g2_4 "	Life skills clubs"
label var g2_5 "	Collaborating with different authorities on students' safety"
label var g2_6 "	Children security/gender desks"
label var g2_7 "	Junior councils"
label var g2_8 "	Fencing the school compound"
label var g2_9 "	Hiring school buses and bajaj"
label var g2_10 "	 Building hostels for children"
label var g2_0 "	Nothing"
label var g2__96 "	  Other"
label var g2__98 "	  DK"
rename (g2__96 g2__98) (g2_96 g2_98)
replace g2 = ""

****************************
** Module H: Life skills **
****************************
gen h =.
label var h "Module H: Life skills"

replace h1 = h1_num if h1 == 6
tab h1
gen h1_prop = h1 / total_t
label var h1_prop "Proportion of teachers that received training on life skills"

label var h6 "(Multiple) h6. Why are there no life skills clubs in your school?"
label var h6_1 "	Did not receive training on life skills clubs"
label var h6_2 "	Teachers do not have time to run the club"
label var h6_3 "	There are no resources to run the club"
label var h6_4 "	Do not think the club is helpful/good use of resources"
label var h6_5 "	Students are not interested in the club"
label var h6_6 "	Parents do not want students to stay at school after hours to attend the club"
label var h6__96 "	  Other"
label var h6__98 "	  DK"
rename (h6__96 h6__98) (h6_96 h6_98)
replace h6 = ""

label var h7 "(Multiple) h7. Which topics are taught in life skills clubs?"
label var h7_1 "	Self-awareness (knowing oneself)"
label var h7_2 "	Setting goals"
label var h7_3 "	Resilience"
label var h7_4 "	Time management"
label var h7_5 "	Confidence (Self-efficacy)"
label var h7_6 "	Stress management"
label var h7_7 "	Self-esteem"
label var h7_8 "	Decision-making and problem solving"
label var h7_9 "	Communication skills"
label var h7_10 "	 Building relationships (teamwork, negotiation, conflict)"
label var h7_11 "	 Behaving around other people (social skills)"
label var h7_12 "	 Creativity"
label var h7_13 "	 Gardening and farming"
label var h7_14 "	 Other productive activities skills"
label var h7_15 "	 Arts, music, and sports"
label var h7_16 "	 Personal hygiene and healthcare"
label var h7_17 "	 Care for the environment"
label var h7_18 "	 Entrepreneurship"
label var h7_19 "	 Being a good citizen (civic education)"
label var h7__96 "	  Other"
label var h7__98 "	  DK"
replace h7 = ""

rename (h7__96 h7__98) (h7_96 h7_98)

*******************
** Module I: CRM **
*******************
gen i =.
label var i "Module I: CRM"

label var i2 "(Multiple) i2. What kind of complaint and response mechanisms to log, track and act on complaints related to students' violence"
label var i2_1 "	Complaint box (suggestion or comment box)"
label var i2_2 "	Focal points"
label var i2_3 "	Student committee"
label var i2_4 "	Trained community members"
label var i2_5 "	Hotlines"
label var i2_6 "	Security and safety desk"
label var i2__96 "	  Other"
rename i2__96 i2_96
replace i2 = ""

label var i3 "(Multiple) i3. Why does your school not have a security and safety desk for reporting concerns?"
label var i3_1 "	Not aware the school should have security and safety desk"
label var i3_2 "	Did not receive training on how to set up and run the desk"
label var i3_3 "	Did not have time to set one up yet"
label var i3_4 "	Do not have qualified staff to run the desk"
label var i3__96 "	  Other"
rename i3__96 i3_96
replace i3 = ""

local charge ///
		i4
		
foreach s in `charge' {
	gen `s'_1 = 0 if `s' !=.
	replace `s'_1 = 1 if `s' == 1
	label var `s'_1 "	HT"
	
	gen `s'_2 = 0 if `s' !=.
	replace `s'_2 = 1 if `s' == 2	
	label var `s'_2 "	Assistant HT"
	
	gen `s'_3 = 0 if `s' !=.
	replace `s'_3 = 1 if `s' == 3		
	label var `s'_3 "	Academic teacher"
	
	gen `s'_4 = 0 if `s' !=.
	replace `s'_4 = 1 if `s' == 4		
	label var `s'_4 "	Regular teacher"	
	
	gen `s'_5 = 0 if `s' !=.
	replace `s'_5 = 1 if `s' == 5		
	label var `s'_5 "	GC teacher"
	
	gen `s'_6 = 0 if `s' !=.
	replace `s'_6 = 1 if `s' == -96			
	label var `s'_6 "	  Other"
	
	replace `s' =.
	}

local freq5 ///
	i5
	
foreach f in `freq5' {
	gen `f'_1 = 0 if `f' !=.
	replace `f'_1 = 1 if `f' == 1
	label var `f'_1 "	Multiple times a week"
	
	gen `f'_2 = 0 if `f' !=.
	replace `f'_2 = 1 if `f' == 2
	label var `f'_2 "	Once a week"
	
	gen `f'_3 = 0 if `f' !=.
	replace `f'_3 = 1 if `f' == 3
	label var `f'_3 "	Every other week"
	
	gen `f'_4 = 0 if `f' !=.
	replace `f'_4 = 1 if `f' == 4
	label var `f'_4 "	Once a month"
	
	gen `f'_5 = 0 if `f' !=.
	replace `f'_5 = 1 if `f' == 5
	label var `f'_5 "	Every other month"
	
	gen `f'_6 = 0 if `f' !=.
	replace `f'_6 = 1 if `f' == 6
	label var `f'_6 "	Less than every other moth"
	
	gen `f'_7 = 0 if `f' !=.
	replace `f'_7 = 1 if `f' == 0
	label var `f'_7 "	Never"
	
	gen `f'_8 = 0 if `f' !=.
	replace `f'_8 = 1 if `f' == -99
	label var `f'_8 "	DK"
	
	replace `f' =.
	}

gen i6_1 = 0 if i6 !=.
replace i6_1 = 1 if i6 == 1
label var i6_1 "	Yes, can take a picture"
gen i6_2 = 0 if i6 !=.	
replace i6_2 = 1 if i6 == 2
label var i6_2 "	Yes, cannot take a picture"
gen i6_3 = 0 if i6 !=.
replace i6_3 = 1 if i6 == 0
label var i6_3 "	Yes, it is the same book as the GC record book"
gen i6_4 = 0 if i6 !=.
replace i6_4 = 1 if i6 == -98
label var i6_4 "	No"

replace i6 =.	
	
gen i7_1 = 0 if i7 == .
replace i7_1 = 1 if i7 == 1
label var i7_1 "	Complaint box (suggestion or comment box)"

gen i7_2 = 0 if i7 == .
replace i7_2 = 1 if i7 == 2
label var i7_2 "	Focal points"

gen i7_3 = 0 if i7 == .
replace i7_3 = 1 if i7 == 3
label var i7_3 "	Student committee"

gen i7_4 = 0 if i7 == .
replace i7_4 = 1 if i7 == 4
label var i7_4 "	Trained community members"

gen i7_5 = 0 if i7 == .
replace i7_5 = 1 if i7 == 5
label var i7_5 "	Hotlines"

gen i7_6 = 0 if i7 == .
replace i7_6 = 1 if i7 == 6
label var i7_6 "	Security and safety desk"

gen i7_7 = 0 if i7 == .
replace i7_7 = 1 if i7 == -96
label var i7_7 "	  Other"
replace i7 =.

gen i8_prop = i8/total_t
label var i8_prop "Proportion of teachers trained on the CRM"

gen i9_1 = 0 if i9 !=.
replace i9_1 = 1 if i9 == 1
label var i9_1 "	In the past six months"

gen i9_2 = 0 if i9 !=.
replace i9_2 = 1 if i9 == 2
label var i9_2 "	Within the past year"

gen i9_3 = 0 if i9 !=.
replace i9_3 = 1 if i9 == 3
label var i9_3 "	More than a year ago"

gen i9_4 = 0 if i9 !=.
replace i9_4 = 1 if i9 == -98
label var i9_4 "	DK"
replace i9 =.

label var i10 "(Multiple) i10. Who provided the training?"

replace i11 = i11_oth if i11 == 41
replace i12 = i12_oth if i12 == 41
replace i13 = i13_oth if i13 == 41

foreach i in i11 i12 i13 {
	replace `i' =. if `i' == -98
	replace `i' =. if `i' == -99
	}
	
replace i8 = i8_oth if i8 == 61
	
label var i15 "(Multiple) i15. Who are invovled in the committee?"
label var i15_1 "	School Management Committee members"
label var i15_2 "	Teachers"
label var i15_3 "	Students"
label var i15_4 "	Head Teacher"
label var i15_5 "	GC teachers"
label var i15__96 "	  Other"
rename i15__96 i15_96
replace i15 = ""

label var i17 "(Multiple) i17. How did your school conduct the orientation for students?"
label var i17_1 "	In a general meeting with all students"
label var i17_2 "	Teachers conducted the orientation in their classrooms"
label var i17_3 "	Displayed information in writing in the school/on the bulletin board"
label var i17_4 "	Shared information via Whatsapp"
label var i17__96 "	  Other"
rename i17__96 i17_96
replace i17 = ""

label var i19 "(Multiple) i19. How did your school conduct the orientation for parents?"
label var i19_1 "	In a general meeting with parents whose children are in their class"
label var i19_2 "	Teachers conducted the orientation in their classrooms"
label var i19_3 "	Displayed information in writing in the school/on the bulletin board"
label var i19_4 "	PTP representatives were oriented during PTP meetings and passed on information to other parents"
label var i19_5 "	Shared information via Whatsapp"
label var i19__96 "	  Other"
rename i19__96 i19_96
replace i19 = ""


gen i20_1 = 0 if i20 != .
replace i20_1 = 1 if i20 == 1
label var i20_1 "	Yes, a written document"

gen i20_2 = 0 if i20 != .
replace i20_2 = 1 if i20 == 2
label var i20_2 "	Yes, a referral mapping"

gen i20_3 = 0 if i20 != .
replace i20_3 = 1 if i20 == 3
label var i20_3 "	Yes, a written document and a referral mapping"

gen i20_4 = 0 if i20 != .
replace i20_4 = 1 if i20 == 0
label var i20_4 "	No"
replace i20 =.

label var i21 "(Multiple) i21. Where is this document or service referral mapping available for anyone to consult?"
label var i21_1 "	Posted in the school"
label var i21_2 "	At the HT's office"
label var i21_3 "	GC teachers have one"
label var i21__96 "	  Other"
rename i21__96 i21_96
replace i21 = ""

gen i22_v_1 = 0 if i22_v != .
replace i22_v_1 = 1 if i22_v == 1
label var i22_v_1 "	Yes, of the document"

gen i22_v_2 = 0 if i22_v != .
replace i22_v_2 = 1 if i22_v == 2
label var i22_v_2 "	Yes, of the referral mapping"

gen i22_v_3 = 0 if i22_v != .
replace i22_v_3 = 1 if i22_v == 3
label var i22_v_3 "	Yes, of both"

gen i22_v_4 = 0 if i22_v != .
replace i22_v_4 = 1 if i22_v == 0
label var i22_v_4 "	No"
replace i22_v =.

gen i24_1 = 0 if i24 != .
replace i24_1 = 1 if i24 == 1
label var i24_1 "	Not capable at all"

gen i24_2 = 0 if i24 != .
replace i24_2 = 1 if i24 == 2
label var i24_2 "	Cannot continue and maintain without external support"

gen i24_3 = 0 if i24 != .
replace i24_3 = 1 if i24 == 3
label var i24_3 "	Somewhat capable but need some degree of external support to strengthen maintenance ability"

gen i24_4 = 0 if i24 != .
replace i24_4 = 1 if i24 == 4
label var i24_4 "	Capable on its own"

gen i24_5 = 0 if i24 != .
replace i24_5 = 1 if i24 == -98
label var i24_5 "	DK"
replace i24 =.

gen i25_1 = 0 if i25 != .
replace i25_1 = 1 if i25 == 1
label var i25_1 "	Very likely"

gen i25_2 = 0 if i25 != .
replace i25_2 = 1 if i25 == 2
label var i25_2 "	Likely"

gen i25_3 = 0 if i25 != .
replace i25_3 = 1 if i25 == 3
label var i25_3 "	Unlikely"

gen i25_4 = 0 if i25 != .
replace i25_4 = 1 if i25 == 4
label var i25_4 "	Very unlikely"

gen i25_5 = 0 if i25 != .
replace i25_5 = 1 if i25 == -98
label var i25_5 "	DK"

gen i25_6 = 0 if i25 != .
replace i25_6 = 1 if i25 == -99
label var i25_6 "	DA"
replace i25 =.

replace i25 =.
gen i26_1 = 0 if i26 != .
replace i26_1 = 1 if i26 == 1
label var i26_1 "	Very confident"

gen i26_2 = 0 if i26 != .
replace i26_2 = 1 if i26 == 2
label var i26_2 "	Somewhat confident"

gen i26_3 = 0 if i26 != .
replace i26_3 = 1 if i26 == 3
label var i26_3 "	Not confident at all"

gen i26_4 = 0 if i26 != .
replace i26_4 = 1 if i26 == -98
label var i26_4 "	DK"
replace i26 =.

gen i26_5 = 0 if i26 != .
replace i26_5 = 1 if i26 == -99
label var i26_5 "	DA"
replace i26 =.

label var i28 "(Up to 3) What would you say are the most common problems related to violence that students at your school may face?"
label var i28_1 "	Verbal abuse from other students (including texting, emailing)"
label var i28_2 "	Verbal abuse from school staff (including texting, emailing)"
label var i28_3 "	Hitting, kicking or pushing from other students"
label var i28_4 "	Hitting (other than allowed forms of corporal punishment) from staff"
label var i28_5 "	Sexual harrassment from students"
label var i28_6 "	Sexual harrassment from staff"
label var i28__96 "	  Other"
label var i28__98 "	  DK"
label var i28__99 "	  DA"
rename (i28__96 i28__98 i28__99) (i28_96 i28_98 i28_99)
replace i28 = ""

label var i36 "(Up to 3)  In your opinion, what are the main challenges facing the proper use of the CRM in your school?"
label var i36_1 "	Lack of confidentiality"
label var i36_2 "	Little knowledge of the existence of those reporting mechanisms"
label var i36_3 "	Information not being acted upon"
label var i36_4 "	Lack of training"
label var i36_5 "	STudents fear to report"
label var i36__96 "	  Other"
label var i36__98 "	  DK"
label var i36__99 "	  DA"
rename (i36__96 i36__98 i36__99) (i36_96 i36_98 i236_99)

replace i36 = ""
	
***********************************************************
** Module K: Monitoring students at risk of dropping out **
***********************************************************
gen k =.
label var k "Module K: Monitoring students at risk of dropping out"

replace k9_m = k9_m_oth if k9_m == 16
replace k9_m = . if k9_m == -98
replace k9_f = k9_f_oth if k9_f == 16
replace k9_f = . if k9_f == -98
replace k6_m = k6_m_oth if k6_m == 16
replace k6_m = . if k6_m == -98
replace k6_f = k6_f_oth if k6_f == 16
replace k6_f = . if k6_f == -98

local dropout ///
	k2 ///
	k4	
	
foreach d in `dropout' {
	label var `d'_1 "	Sickness (chronic or non-chronic)"
	label var `d'_2 "	Hunger"
	label var `d'_3 "	Menstruation"
	label var `d'_4 "	Household responsibilities"
	label var `d'_5 "	Taking care of siblings"
	label var `d'_6 "	Taking care of a sick family"
	label var `d'_7 "	Family funeral"
	label var `d'_8 "	Traditional practices (e.e. initiation ceremony or after circumcision rite of passage)"
	label var `d'_9 "	Need to make money"
	label var `d'_10 "	 No school supplies"
	label var `d'_11 "	 Unpaid school fees (incl. exam fees)"
	label var `d'_12 "	 Lack of adequate amenities in school (e.g., toilets)"
	label var `d'_13 "	 Teachers absent"
	label var `d'_14 "	 Corporal punishment"
	label var `d'_15 "	 Long distance to school"
	label var `d'_16 "	 Unsafe journey to and from school"
	label var `d'_17 "	 Student sent away for discipline reasons"
	label var `d'_18 "	 Student's parents/guardian don't value education"
	label var `d'_19 "	 Pregnancy"
	label var `d'_20 "	 Student is an orphan"
	label var `d'_21 "	 There is conflict/violence in the family"
	label var `d'_22 "	 Student has a disability"
	label var `d'__96 "	  Other"
	label var `d'__98 "	  Other"
	rename (`d'__96 `d'__98) (`d'_96 `d'_98)
	replace `d' = ""
	}

label var k2 "(Up to 3) What are the top three reasons for these dropouts?"
label var k4 "(Up to 3) What are the top three reasons for absenteeism?"

gen k3_1 = 0 if k3 !=.
replace k3_1 = 1 if k3 == 1
label var k3_1 "	<5% regularly miss school"
	
gen k3_2 = 0 if k3 !=.
replace k3_2 = 1 if k3 == 2
label var k3_2 "	5-10% regularly miss school"

gen k3_3 = 0 if k3 !=. 
replace k3_3 = 1 if k3 == 3
label var k3_3 "	11-15% regularly miss school"

gen k3_4 = 0 if k3 !=.
replace k3_4 = 1 if k3 == 4
label var k3_4 "	16-20% regularly miss school"

gen k3_5 = 0 if k3 !=. 
replace k3_5 = 1 if k3 == 5
label var k3_5 "	21-25% regularly miss school"

gen k3_6 = 0 if k3 !=. 
replace k3_6 = 1 if k3 == 6
label var k3_6 "	More than 25% regularly miss school"

gen k3_7 = 0 if k3 !=.
replace k3_7 = 1 if k3 == 0
label var k3_7 "	None"

gen k3_8 = 0 if k3 !=.
replace k3_8 = 1 if k3 == -98
label var k3_8 "	DK"
replace k3 =.

local freq6 ///
	k5
	
foreach f in `freq6' {
	gen `f'_1 = 0 if `f' !=.
	replace `f'_1 = 1 if `f' == 1
	label var `f'_1 "	Always"
	
	gen `f'_2 = 0 if `f' !=.
	replace `f'_2 = 1 if `f' == 2
	label var `f'_2 "	Most of the time"
	
	gen `f'_3 = 0 if `f' !=.
	replace `f'_3 = 1 if `f' == 3
	label var `f'_3 "	Sometimes"
	
	gen `f'_4 = 0 if `f' !=.
	replace `f'_4 = 1 if `f' == 4
	label var `f'_4 "	Rarely"
	
	gen `f'_5 = 0 if `f' !=.
	replace `f'_5 = 1 if `f' == 5
	label var `f'_5 "	Almost never"

	gen `f'_6 = 0 if `f' !=.
	replace `f'_6 = 1 if `f' == 0
	label var `f'_6 "	Never"
	
	gen `f'_7 = 0 if `f' !=.
	replace `f'_7 = 1 if `f' == -98
	label var `f'_7 "	DK"
	
	gen `f'_8 = 0 if `f' !=.
	replace `f'_8 = 1 if `f' ==-99
	label var `f'_8 "	DA"
	replace `f' =.	
	}

label var k11 "(Multiple) k11. What type of data does your school regularly collect to identify students"
label var k11_1 "	Student attendance rates"
label var k11_2 "	Discipline incidents"
label var k11_3 "	Transfer students"
label var k11_4 "	Academic assessment/performance results"
label var k11_0 "	No data is collected"
label var k11__96 "	  Other"
label var k11__98 "	  DK"
rename (k11__96 k11__98) (k11_96 k11_98)
replace k11 = ""

label var k10 "(Multiple) k10. Can you name a few signs that a child is at risk of dropping out?"
label var k10_1 "	Child is frequently absent"
label var k10_2 "	Child does not engage in school"
label var k10_3 "	Child is failing examinations"
label var k10_4 "	Child is bullied at school/does not get along with peers"
label var k10_5 "	Child has behavioral problems"
label var k10_6 "	Child has a disability"
label var k10_7 "	Child comes from a struggling family"
label var k10_8 "	Pregnancy"
label var k10_9 "	Child is frequently late to class"
label var k10__96 "	 Other"
label var k10__98 "	  DK"
rename (k10__96 k10__98) (k10_96 k10_98)
replace k10 = ""
	
label var k13 "(Multiple) k13. What would you do if you think one of your students is at risk of dropping out?"
label var k13_1 "	Communicate with parent/caregiver"
label var k13_2 "	Communicate with school management committee"
label var k13_3 "	Talk to the child"
label var k13_4 "	Communicate with the PTPs"
label var k13_5 "	Communicate with the HT"
label var k13_6 "	Communicate with the Guiding and Disciplinary Committee"
label var k13_7 "	Communicate with class teacher"
label var k13_8 "	Communicate with GC teacher"
label var k13_9 "	Link the student to peer groups"
label var k13_10 "	Involve the government in counseling the student/parents"
label var k13_11 "	Advise on where to get material support (e.g. LIMCA)"
label var k13_12 "	Advise student/parent for student to stay nearby school"
label var k13_13 "	Demand student to report teacher's office frequently"
label var k13_14 "	Provide peer mentoring on good behavior and classwork performance"
label var k13_15 "	Provide academic assistance and tutoring"
label var k13__96 "	 Other"
label var k13__98 "	  DK"
rename (k13__96 k13__98) (k13_96 k13_98)
replace k13 = ""

****************************************************
** Module L: Nutrition and School Feeding Program **
****************************************************
gen l =.
label var l "Module L: Nutrition and School Feeding Program"

local prop ///
	l1 ///
	l5
foreach p in `prop' {
	
	gen `p'_1 = 0 if `p' != 0
	replace `p'_1 = 1 if `p' == 1
	label var `p'_1 "	10-20% (1-2 in 10 kids)"

	gen `p'_2 = 0 if `p' != 0
	replace `p'_2 = 1 if `p' == 2
	label var `p'_2 "	21-50% (3-5 in 10 kids)"

	gen `p'_3 = 0 if `p' != 0
	replace `p'_3 = 1 if `p' == 3
	label var `p'_3 "	51-70% (6-7 in 10 kids)"

	gen `p'_4 = 0 if `p' != 0
	replace `p'_4 = 1 if `p' == 4
	label var `p'_4 "	71-90% (8-9 in 10 kids)"

	gen `p'_5 = 0 if `p' != 0
	replace `p'_5 = 1 if `p' == 5
	label var `p'_5 "	>90% (Most/All)"

	gen `p'_6 = 0 if `p' != 0
	replace `p'_6 = 1 if `p' == -98
	label var `p'_6 "	DK"
	replace `p' =.
	}
	
label var l2 "(Multiple) l2. Does your school provide meals to students and or money to buy food?"	
label var l2_1 "	Meal"
label var l2_2 "	Money"
label var l2_0 "	Nothing"
replace l2 = ""

label var l3_1 "	Breakfast"
label var l3_2 "	Lunch"
label var l3_3 "	Snack"
label var l3_4 "	Dinner"
label var l3_5 "	All of the above"
replace l3 = ""

label var l4_1 "	Central government"
label var l4_2 "	Local government"
label var l4_3 "	Parents"
label var l4_4 "	Teachers"
label var l4_5 "	Private sector"
label var l4_6 "	Donors/NGOs"
label var l4__96 "	Other"
rename l4__96 l4_96
replace l4 = ""
	
label var l8 "(Multiple) What activities have been conducted during this academic year to improve participation"
label var l8_1 "	Discussions in the PTPs"
label var l8_2 "	Sensitization meetings with the community"
label var l8_3 "	Banners, posters, flyers"
label var l8_4 "	Campaigns using TV, radio"
label var l8_5 "	Campaings using social media"
label var l8_6 "	Engagement with private sector"
label var l8_7 "	Engagement with donors/NGOs"
label var l8_0 "	None"
label var l8__96 "	  Other"
label var l8__98 "	  DK"
rename (l8__96 l8__98) (l8_96 l8_98)
replace l8 = ""

label var l9 "(Multiple) Did the activities improve school feeding at your school?"
label var l9_1 "	Yes, more food"
label var l9_2 "	Yes, better quality of food"
label var l9_3 "	Yes, better planning"
label var l9_0 "	No"
replace l9 = ""

	
***********************************************************
** Module J: Mechanisms to discipline students at school **
***********************************************************
gen j =.
label var j "Module J: Mechanisms to discipline students at school"

gen j2_1 = 0 if j2 != .
replace j2_1 = 1 if j2 == 1
label var j2_1 "	Yes, one for all the school"

gen j2_2 = 0 if j2 != .
replace j2_2 = 1 if j2 == 2
label var j2_2 "	Yes, one for each class"

gen j2_3 = 0 if j2 != .
replace j2_3 = 1 if j2 == 0
label var j2_3 "	No"

gen j2_4 = 0 if j2 != .
replace j2_4 = 1 if j2 == -98
label var j2_4 "	DK"
replace j2 =.

local behave ///
	j6 

foreach j in `behave' {
	label var `j' "		(Multiple) j6. Which student behaviors have been sanctioned with corporal punishment?"
	label var `j'_1 "	Using abusive language in a lesson"
	label var `j'_2 "	Damaging school property"
	label var `j'_3 "	Getting things wrong in a lesson"
	label var `j'_4 "	Bullying other students"
	label var `j'_5 "	Failing to complete homework"
	label var `j'_6 "	Disrupting class order, for example by interrupting the teacher or speaking with classmates"
	label var `j'_7 "	Arriving late to class"
	label var `j'_8 "	Hitting other student(s)"
	label var `j'__96 "     Other"
	label var `j'__98 "	  DK"
	label var `j'__99 "	  DA"
	rename (`j'__96 `j'__98 `j'__99) (`j'_96 `j'_98 `j'_99)
	replace `j' = ""
}	

gen j7_1 = 0 if j7 !=. 
replace j7_1 = 1 if j7 == 1
label var j7_1 "	Using abusive language in a lesson"

gen j7_2 = 0 if j7 !=. 
replace j7_2 = 1 if j7 == 2
label var j7_2 "	Damaging school property"

gen j7_3 = 0 if j7 !=.  
replace j7_3 = 1 if j7 == 3
label var j7_3 "	Getting things wrong in a lesson"

gen j7_4 = 0 if j7 !=.  
replace j7_4 = 1 if j7 == 4
label var j7_4 "	Bullying other students"

gen j7_5 = 0 if j7 !=.  
replace j7_5 = 1 if j7 == 5
label var j7_5 "	Failing to complete homework"

gen j7_6 = 0 if j7 !=.  
replace j7_6 = 1 if j7 == 6
label var j7_6 "	Disrupting class order, for example by interrupting the teacher or speaking with classmates"

gen j7_7 = 0 if j7 !=.  
replace j7_7 = 1 if j7 == 7
label var j7_7 "	Arriving late to class"

gen j7_8 = 0 if j7 !=.  
replace j7_8 = 1 if j7 == 8
label var j7_8 "	Hitting other student(s)"

gen j7_9 = 0 if j7 !=.  
replace j7_9 = 1 if j7 == -96
label var j7_9 "   Other"
replace j7 =.

label var j8 "(Multiple) j8. Which types of corporal punishment have been used at your school in this academic year?"
label var j8_1 "	Beating"
label var j8_2 "	Work in school (farm work, gardening, digging, cleaning, bringing water, slashing grass)"
label var j8_3 "	Kneeling"
label var j8_4 "	Holding ears"
label var j8_5 "	Physical exercise (push-up)"
label var j8_6 "	Jumping like a frog"
label var j8_7 "	Sitting in the sun"
label var j8__96 "       Other"
label var j8__98 "	  DK"
label var j8__99 "	  DA"
rename (j8__96 j8__98 j8__99) (j8_96 j8_98 j8_99)
replace j8 = ""

label var j8_how "(Multiple) j8_how. What tool is used to deliver the beating?"
label var j8_how_1 "	Hand"
label var j8_how_2 "	Cane, thin stick"
label var j8_how_3 "	Strap"
label var j8_how_4 "	Ruler"
label var j8_how__96 "	  Other"
label var j8_how__98 "	  DK"
label var j8_how__99 "	  DA"
rename (j8_how__96 j8_how__98 j8_how__99) (j8_how_96 j8_how_98 j8_how_99)
replace j8_how = ""
	
label var j8_where "(Multiple) j8_where. Which part(s) of the body is the beating typically applied to?"
label var j8_where_1 "	Hand"
label var j8_where_2 "	Back (clothed)"
label var j8_where_3 "	Back (unclothed)"
label var j8_where_4 "	Buttocks (clothed)"
label var j8_where_5 "	Buttocks (unclothed)"
label var j8_where_6 "	Heels"
label var j8_where__96 "	Other"
label var j8_where__98 "	DK"
label var j8_where__99 "	DA"
rename (j8_where__96 j8_where__98 j8_where__99) (j8_where_96 j8_where_98 j8_where_99)
replace j8_where = ""

gen j8_num_1 = 0 if j8_num !=.
replace j8_num_1 = 1 if j8_num == 1
label var j8_num_1 "	4 or less"
gen j8_num_2 = 0 if j8_num !=.
replace j8_num_2 = 1 if j8_num == 2
label var j8_num_2 "	5-6"
gen j8_num_3 = 0 if j8_num !=.
replace j8_num_3 = 1 if j8_num == 3
label var j8_num_3 "	7-8"
gen j8_num_4 = 0 if j8_num !=.
replace j8_num_4 = 1 if j8_num == 4
label var j8_num_4 "	9-10"
gen j8_num_5 = 0 if j8_num !=.
replace j8_num_5 = 1 if j8_num == 5
label var j8_num_5 "	More than 10"
gen j8_num_6 = 0 if j8_num !=.
replace j8_num_6 = 1 if j8_num == -98
label var j8_num_6 "	DK"
gen j8_num_7 = 0 if j8_num !=.
replace j8_num_7 = 1 if j8_num == -99
label var j8_num_7 "	DA"
replace j8_num =.

local staff2 ///
	j8_who

foreach s in `staff2' {
	label var `s'_1 "	HT"
	label var `s'_2 "	Academic teacher"
	label var `s'_3 "	GC teachers"
	label var `s'_4 "	Reuglar teacher"
	label var `s'__96 "	Other"
	label var `s'__98 "	DK"
	label var `s'__99 "	DA"
	rename (`s'__96 `s'__98 `s'__99) (`s'_96 `s'_98 `s'_99)
	replace `s' = ""
	}
	
label var j9_1 "	HT"
label var j9_2 "	Assistant HT"
label var j9_3 "	Academic teacher"
label var j9_4 "	Regular teacher"
label var j9_5 "	GC teachers"
label var j9__96 "	  Other"
label var j9__98 "	  DK"
label var j9__99 "	  DA"
rename (j9__96 j9__98 j9__99) (j9_96 j9_98 j9_99)
	
label var j8_who "(Multiple) j8_who. Who delivers the beating?"
label var j9 "(Multiple) j9. Which staff have used corporal punishment on students?"
	
label var j14 "(Multiple) j14. To the best of your recollection, what are some of the key elements of the guidelines?"
label var j14_1 "	Corporal punishment should be given for severe offenses"
label var j14_2 "	The maximum number of strokes is 4"
label var j14_3 "	Female students must be punished by female teachers (exceptions must be authorized by HT)"
label var j14_4 "	HT is responsible or administering punishment (or authorize another teacher to do it)"
label var j14_5 "	Punishment must correspond to the gravity of offense, age, sex and health of the pupils"
label var j14_6 "	Only allowed form is striking a pupil on his hand or on his normally clothed buttocks with a light, flexible stick"
label var j14__96 "	  Other"
label var j14__98 "	  DK"
rename (j14__96 j14__98) (j14_96 j14_98)
replace j14 = ""

label var j16 "(Multiple) j16. To the best of your knowledge, what information does the corporal punishment record book typically contain?"
label var j16_1 "	name of the pupil"
label var j16_2 "	the offence or breach of discipline"
label var j16_3 "	the number of strokes"
label var j16_4 "	name of the teacher who administered the punishment"
label var j16__96 "	  Other"
label var j16__98 "	  DK"
rename (j16__96 j16__98) (j16_96 j16_98)
replace j16 = ""

*********************************************
** Module M: Quality of training materials **
*********************************************
gen m =.
label var m "Module M: Quality of training materials"

local quality ///
	m1 m2 m3 m4 m5 m6 m7 m8 m9 m10

foreach q in `quality' {
	gen `q'_1 = 0 if `q' !=.
	replace `q'_1 = 1 if `q' == 1
	label var `q'_1 "	Very poorly prepared and equipped"
	gen `q'_2 = 0 if `q' !=.
	replace `q'_2 = 1 if `q' == 2
	label var `q'_2 "	Poorly prepared and equipped"
	gen `q'_3 = 0 if `q' !=.
	replace `q'_3 = 1 if `q' == 3
	label var `q'_3 "	Somewhat prepared and equipped"
	gen `q'_4 = 0 if `q' !=.
	replace `q'_4 = 1 if `q' == 4
	label var `q'_4 "	Well prepared and equipped"
	gen `q'_5 = 0 if `q' !=.
	replace `q'_5 = 1 if `q' == 5
	label var `q'_5 "	Very well prepared and equipped"
	replace `q' =.
}
	
local why ///
	m1_why m2_why m3_why m4_why m5_why m6_why m7_why m8_why m9_why m10_why

foreach w in `why' {
	label var `w'_1 "	Training was too short"
	label var `w'_2 "	Training did not cover topics in enough detail"
	label var `w'_3 "	Training covered (some) topics that are not relevant/useful"
	label var `w'_4 "	Training did not focus enough on practical implementation"
	label var `w'_5 "	Trainers were not well-prepared"
	label var `w'_6 "	I did not receive (all) the materials"
	label var `w'_7 "	Materials were not of good quality"
	label var `w'_8 "	Materials lacked detail on practical implementation"
	label var `w'__96 "	Other"
	rename `w'__96 	`w'_96
	replace `w' = ""
}

save "${shule_bora_DB}/pssp/DataSets/Intermediate/HT PSSP_cleaned.dta", replace

		
timer off 1
timer list 1
