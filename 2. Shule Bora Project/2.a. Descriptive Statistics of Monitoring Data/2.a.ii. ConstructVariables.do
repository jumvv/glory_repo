** 240512
** SB Monitoring Data Construct variables

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
use "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_HT_merged.dta", clear

unique school_locationasc // 682 unique values

*************************************************
** Clean & Construct Safety and Inclusion data **
*************************************************

unique council //26 - SB baseline covered 27 councils 
**(Compared with SB baseline, HT Monitoring data added Korogwe Tc (Tanga), skipped Handeni (Tanga) and Bahi (Dodoma).)
unique ward //147

**Align QuestionID
*safety_1
rename Whichsafetyandinclusionel safety_1

label variable safety_1 "1. Safety/Inclusion elements applied to your school? (Select Multiple)"

rename (TheHTandallteachershave TheHTandsometeachershave Thereisateacherincharge ///
Theschoolhasacouncilofp Theschoolhasreportingmech Prizesaregiventowellbeha ///
Childrenhaveusedcreativea Others Pleasespecify) (s_1_1 s_1_2 s_1_3 ///
s_1_4 s_1_5 s_1_6 s_1_7 s_1_8 s_1_s)

label variable s_1_1   "	1.1 HT/ALL teachers trained on safety/inclusion"
label variable s_1_2   "	1.2 HT/SOME teachers trained on safety/inclusion"
label variable s_1_3   "	1.3 A teacher in charge of safety/inclusion elected by pupils"
label variable s_1_4   "	1.4 A council of pupils elected"
label variable s_1_5   "	1.5 The school has reporting mechanism for safety issue"
label variable s_1_6   "	1.6 Prizes given to well-behaved pupils"
label variable s_1_7   "	1.7 Children use creative arts(drama/songs/posters) to promote safety/inclusion"
label variable s_1_8   "	1.8 Others"
label variable s_1_s   "	(TEXT) Please specify if Others selected"

*safety_2
rename Whichreportingmechanismdoe safety_2
label variable safety_2 "2. Reporting mechanism for pupils to report safety issues? (Select Multiple)"

rename (Guidanceandcounsellingteac Childprotectionandsafetyd Suggestionbox ///
Other AI) (s_2_1 s_2_2 s_2_3 s_2_4 s_2_s)

label variable s_2_1 "	2.1 Guidance/Counselling teachers"
label variable s_2_2 "	2.2 Child protection and safety desk"
label variable s_2_3 "	2.3 Suggestion box"
label variable s_2_4 "	2.4 Other"
label variable s_2_s "	(TEXT) Please specify if Other is selected"

*safety_3
rename Aretheresafetycasesreport safety_3 //12.9%

gen safety = 1 if safety_3 == "Yes"
replace safety = 0 if safety_3 == "No"
drop safety_3
rename safety safety_3
label variable safety_3 "3. Are there safety cases reported in the past three months?"
label define yesno 1 "Yes" 0 "No"
label val safety_3 yesno

rename (Howmanycaseswithmalevictims Howmanycaseswithfemalevicti AM AN AO ///
AP AQ AR)  (victim_m_emotional victim_f_emotional victim_m_physical ///
victim_f_physical victim_m_sexual victim_f_sexual victim_m_neglect victim_f_neglect)

label variable victim_m_emotional 	"	3.1 How many cases with male victim were reported under emotional abuse?"
label variable victim_f_emotional 	"	3.2 How many cases with female victim were reported under emotional abuse?"
label variable victim_m_physical 	"	3.3 How many cases with male victim were reported under physical abuse?"
label variable victim_f_physical 	"	3.4 How many cases with female victim were reported under physical abuse?"
label variable victim_m_sexual 		"	3.5 How many cases with male victim were reported under sexual abuse?"
label variable victim_f_sexual 		"	3.6 How many cases with female victim were reported under sexual abuse?"
label variable victim_m_neglect 	"	3.7 How many cases with male victim were reported under neglect?"
label variable victim_f_neglect 	"	3.8 How many cases with female victim were reported under neglect?"


tab victim_m_emotional
tab victim_f_emotional

tab safety_3

egen check_emo = rsum(victim_m_emotional victim_f_emotional victim_m_physical ///
victim_f_physical victim_m_sexual victim_f_sexual victim_m_neglect victim_f_neglect), m
tab check_emo
tab check_emo if check_emo != 0 //75
tab school if check_emo == 0 & safety_3 == 1 // 13 schools reported abuse but responeded 0's to all follow-up abuse questions.
/*
                     Name of school |      Freq.     Percent        Cum.
------------------------------------+-----------------------------------
                           BIGABIRO |          1        7.69        7.69
                         CHAMWINO B |          1        7.69       15.38
                           CHATEMBO |          1        7.69       23.08
                            KASANDA |          1        7.69       30.77
                            KIKONKO |          1        7.69       38.46
                          MANGHWETA |          1        7.69       46.15
                          MASINYETI |          1        7.69       53.85
                              MWAFA |          1        7.69       61.54
                           NYANDUGA |          1        7.69       69.23
                            SHIRATI |          1        7.69       76.92
                              TUNGE |          1        7.69       84.62
                               YEYA |          1        7.69       92.31
                           ZABAZABA |          1        7.69      100.00
------------------------------------+-----------------------------------
                              Total |         13      100.00
*/

* This just puts 0 where there are missing values because there were no reports of violence - for calculating unconditionals later 
bys council ward school: egen emotional_m = total(victim_m_emotional)
bys council ward school: egen emotional_f = total(victim_f_emotional)
bys council ward school: egen physical_m  = total(victim_m_physical)
bys council ward school: egen physical_f  = total(victim_f_physical)
bys council ward school: egen sexual_m    = total(victim_m_sexual)
bys council ward school: egen sexual_f    = total(victim_f_sexual)
bys council ward school: egen neglect_m   = total(victim_m_neglect)
bys council ward school: egen neglect_f   = total(victim_f_neglect)

egen abuse_m_total = rowtotal(emotional_m physical_m sexual_m neglect_m), m
egen abuse_f_total = rowtotal(emotional_f physical_f sexual_f neglect_f), m
egen abuse_total = rowtotal(abuse_m_total abuse_f_total), m

total abuse_m_total //120
total abuse_f_total //198
total abuse_total //318

tab totalstudents_23

foreach var in emotional physical sexual neglect {
    gen prop_m_`var' = `var'_m / abuse_m_total
    gen prop_f_`var' = `var'_f / abuse_f_total 
}

label variable prop_m_emotional "		Male"
label variable prop_f_emotional "		Female"
label variable prop_m_physical  "		Male"
label variable prop_f_physical  "		Female"
label variable prop_m_sexual    "		Male"
label variable prop_f_sexual    "		Female"
label variable prop_m_neglect   "		Male"
label variable prop_f_neglect   "		Female"

foreach var in emotional physical sexual neglect {
    gen prop_`var' = (`var'_m + `var'_f) / abuse_total 
}

label variable prop_emotional "		Proportion of all victims with emotional abuse in the past three months?"
label variable prop_physical  "		Proportion of all victims with physical abuse in the past three months?"
label variable prop_sexual	  " 	Proportion of all victims with sexual abuse in the past three months?"
label variable prop_neglect	  "		Proportion of all victims with neglect in the past three months?"

sum prop_emotional prop_physical prop_sexual prop_neglect
sum prop_emotional prop_m_emotional prop_f_emotional

foreach var in emotional physical sexual neglect {
    gen prop_m_`var'_unc = `var'_m / TotalBoys_23
    gen prop_f_`var'_unc = `var'_f / TotalGirls_23
}

label variable prop_m_emotional_unc "		Male"
label variable prop_f_emotional_unc "		Female"
label variable prop_m_physical_unc  "		Male"
label variable prop_f_physical_unc  "		Female"
label variable prop_m_sexual_unc    "		Male"
label variable prop_f_sexual_unc    "		Female"
label variable prop_m_neglect_unc   "		Male"
label variable prop_f_neglect_unc   "		Female"

sum prop_m_emotional_unc prop_f_emotional_unc prop_m_physical_unc prop_f_physical_unc prop_m_sexual_unc ///
	prop_f_sexual_unc prop_m_neglect_unc prop_f_neglect_unc


foreach var in emotional physical sexual neglect {
    gen prop_`var'_unc = (`var'_m + `var'_f) / totalstudents_23
	}

label variable prop_emotional_unc "		(Unconditional) Proportion of all students with emotional abuse (within school) in the past three months?"
label variable prop_physical_unc  "		(Unconditional) Proportion of all students with physical abuse (within school) in the past three months?"
label variable prop_sexual_unc	  " 	(Unconditional) Proportion of all students with sexual abuse (within school) in the past three months?"
label variable prop_neglect_unc	  "		(Unconditional) Proportion of all all students with neglect (within school) in the past three months?"

sum prop_emotional_unc prop_physical_unc prop_sexual_unc prop_neglect_unc

sum totalstudents_23, d

gen abuse_prop = abuse_total/totalstudents_23 
sum abuse_prop // 0.06%
lab var abuse_prop "(Unconditional) Proportion of all students with all abuse categories (within school) in the past three months"

*safety_4
tab Whatmethodsdoesyourschool //Needs to be translated
rename Whatmethodsdoesyourschool safety_4
label variable safety_4 "(TEXT) 4. Methods used to encourage pupils to use existing reporting mechanisms?"

*safety_5
rename Doestheschoolhaveareferr safety_5
gen safety = 1 if safety_5 == "Yes"
replace safety = 0 if safety_5 == "No"
drop safety_5
rename safety safety_5
label variable safety_5 "5. Does the school have a referral system for safety cases?"
label val safety_5 yesno

rename aPleasementionavailablere safety_5_1
tab safety_5_1
label variable safety_5_1 "(TEXT) 5.a Please mention available referral system(s)"

*safety_6
rename Doestheschoolhaveaservic safety_6
tab safety_6
gen safety = 1 if safety_6 == "Yes"
replace safety = 0 if safety_6 == "No"
replace safety =.d if safety_6 == "Not sure" 
drop safety_6
rename safety safety_6 // Total is 634 (48 not sure)
label variable safety_6 "6. Have a service map to refer pupils who might need further help?"

count if safety_6 == .d
label define yesno1 1 "Yes" 0 "No" .d "Not sure"
label val safety_6 yesno1


gen safety_6_unc = safety_6
replace safety_6_unc = 0 if safety_6 == .d

label variable safety_6_unc "(Unconditional) 6. Have a service map to refer pupils who might need further help?"


rename aPleasementionserviceprov safety_6_1
label variable safety_6_1 "6.a. Please mention service providers mapped for referral" // if yes (245)

*safety_6: service providers
rename (aSocialwelfareoffice aPolicegenderdesk aLGAoffice aHealthfacility aOther) ///
  (Socialwelfareoffice Policegenderdesk LGAoffice Healthfacility Other) 

label variable Socialwelfareoffice "	6.a.1 Social welfare office"
label variable Policegenderdesk    "	6.a.2 Police gender desk"
label variable LGAoffice           "	6.a.3 LGA office"
label variable Healthfacility      "	6.a.4 Health facility"
label variable Other               "	6.a.5 Other"

local 6a ///
	Socialwelfareoffice ///
	Policegenderdesk ///
	LGAoffice ///
	Healthfacility ///
	Other
	
foreach v in `6a' {
	gen `v'_unc = `v'
	replace `v'_unc = 0 if safety_6_unc == 0
	}
 
label variable Socialwelfareoffice_unc "	(Unconditional) 6.a.1 Social welfare office"
label variable Policegenderdesk_unc    "	(Unconditional) 6.a.2 Police gender desk"
label variable LGAoffice_unc           "	(Unconditional) 6.a.3 LGA office"
label variable Healthfacility_unc      "	(Unconditional) 6.a.4 Health facility"
label variable Other_unc               "	(Unconditional) 6.a.5 Other"

rename Pleasementionotherservicepro safety_6_a_other
label variable safety_6_a_other 	   "	(TEXT) 6.a. Please mention other service providers"

*safety_6b 
rename bHowmanycaseswererefered safety_6b
tab safety_6b
label variable safety_6b "6.b. (If 'Not sure') How many cases were referred in the previous three months?"

graph bar (count), over(safety_6b)  ///
	blabel(bar) ///
    title("6.b. (If 'Not sure') How many cases were referred in the previous three months?", size (small))

*safety_7
rename Whatarethechallengesfacin safety_7
tab safety_7 // Needs to be translated
label variable safety_7 "(TEXT) 7. Challenges facing the use of the reporting mechanisms?"

*safety_8
rename Doteachersusecorporalpuni safety_8
gen safety = 1 if safety_8 == "Yes"
replace safety = 0 if safety_8 == "No"
drop safety_8
rename safety safety_8
label variable safety_8 "8. Do teachers use corporal punishment to discipline the pupils in this school?"
label val safety_8 yesno
tab safety_8

*safety_8a
rename aIsthereapunishmentlogb safety_8a // if safety_8 is yes
tab safety_8a
gen safety = 1 if safety_8a == "Yes" | safety_8a == "There is a book but it is not up to date"
replace safety = 0 if safety_8a == "No"
drop safety_8a
rename safety safety_8a
label variable safety_8a "8.a. Is there a punishment log book in the school that is up to date?"
label val safety_8a yesno
tab safety_8a

gen safety_8a_unc = safety_8a
replace safety_8a_unc = 0 if safety_8a == .
label val safety_8a_unc yesno
label variable safety_8a_unc "(Unconditional) 8.a. Is there a punishment log book in the school that is up to date?"

*safety_8b
rename bHowmanypunishmentsresult safety_8b
tab safety_8b
gen safety_8b_unc = safety_8b
replace safety_8b_unc = 0 if safety_8 == 0
replace safety_8b_unc = 0 if safety_8b == .
label variable safety_8b "8.b. How many corporal punishment were recorded in the PAST month?"

label variable safety_8b_unc "(Unconditional) 8.b. How many corporal punishment were recorded in the PAST month?"


*safety_9
rename Doestheschoolhavepupilsw safety_9
tab safety_9
gen safety = 1 if safety_9 == "Yes"
replace safety = 0 if safety_9 == "No"
drop safety_9
rename safety safety_9
label variable safety_9 "9. Does the school have pupils with disabilities?"
label val safety_9 yesno
tab safety_9

*safety_9a & b
rename (aNumberofboyswithdisabil bNumberofgirlswithdisabi) (dis_m ///
	dis_f)

label variable dis_m "	9.a. Number of boys with disability?"
label variable dis_f "	9.b. Number of girls with disability?"
	
gen prop_dis_m = dis_m / TotalBoys_23
gen prop_dis_f = dis_f / TotalGirls_23

label variable prop_dis_m "			Boys"
label variable prop_dis_f "			Girls"

gen prop_dis_all = (dis_m + dis_f) / (TotalBoys_23 + TotalGirls_23)
label variable prop_dis_all "	Proportion of all students with disabilities (within schools)"

tab prop_dis_all

gen prop_dis_m_unc = prop_dis_m
replace prop_dis_m_unc = 0 if prop_dis_m ==.
	
gen prop_dis_f_unc = prop_dis_f
replace prop_dis_f_unc = 0 if prop_dis_f ==.

label variable prop_dis_m_unc "			Boys"
label variable prop_dis_f_unc "			Girls"

gen prop_dis_all_unc = prop_dis_all
replace prop_dis_all_unc = 0 if prop_dis_all ==.
label variable prop_dis_all_unc "	(Unconditional) Proportion of all students with disabilities"

sum prop_dis_m_unc prop_dis_f_unc prop_dis_all_unc

*safety_10
rename Weretheenrolledpupilswit safety_10
tab safety_10
label variable safety_10 "10. Were the enrolled pupils with disability assessed before enrollment?"

gen safety_10_1 = 0 if safety_10 != ""
replace safety_10_1 = 1 if safety_10 == "All were assessed"

gen safety_10_2 = 0 if safety_10 != ""
replace safety_10_2 = 1 if safety_10 == "Some were not assessed"

gen safety_10_3 = 0 if safety_10 != ""
replace safety_10_3 = 1 if safety_10 == "All were not assessed"

gen safety_10_4 = 0 if safety_10 != ""
replace safety_10_4 = 1 if safety_10 == "Not sure"


gen safety_10_1_unc = safety_10_1
replace safety_10_1_unc = 0 if safety_10 == ""

gen safety_10_2_unc = safety_10_2
replace safety_10_2_unc = 0 if safety_10 == ""

gen safety_10_3_unc = safety_10_3
replace safety_10_3_unc = 0 if safety_10 == ""

gen safety_10_4_unc = safety_10_4
replace safety_10_4_unc = 0 if safety_10 == ""

label variable safety_10_1 "	10.1. 'All were assessed'"
label variable safety_10_2 "	10.2. 'Some were not assessed'"
label variable safety_10_3 "	10.3. 'All were not assessed'"
label variable safety_10_4 "	10.4. 'Not sure'"
label variable safety_10_1_unc "	(Unconditional) 10.1. 'All were assessed'"
label variable safety_10_2_unc "	(Unconditional) 10.2. 'Some were not assessed'"
label variable safety_10_3_unc "	(Unconditional) 10.3. 'All were not assessed'"
label variable safety_10_4_unc "	(Unconditional) 10.4. 'Not sure'"

*safety_10a
rename aWhatmethodswereusedf safety_10a
rename (aObserveandassesschildre aUseofscreeningandident aUseofclassroomassessmen ///
	BV) (Observe_and_assess Screening_tool Classroom_assess Other_method)

tab safety_10a
label variable safety_10a "10.a What method(s) were used for assessment?"

label variable Observe_and_assess "	10a.1 Observe and assess children during group or pair work"
label variable Screening_tool 	  "	10a.2 Use of screening and identification tools to understand learning needs"
label variable Classroom_assess   "	10a.3 Use of classroom assessment techniques"
label variable Other_method       "	10a.4 Other methods"

tab Observe_and_assess

gen Observe_and_assess_unc = Observe_and_assess
replace Observe_and_assess_unc = 0 if Observe_and_assess_unc == .

gen Screening_tool_unc = Screening_tool
replace Screening_tool_unc = 0 if Screening_tool_unc == .

gen Classroom_assess_unc = Classroom_assess
replace Classroom_assess_unc = 0 if Classroom_assess_unc == .

gen Other_method_unc = Other_method
replace Other_method_unc = 0 if Other_method_unc == .
	
label variable Observe_and_assess_unc "	(Unconditional) 10a.1 Observe and assess children during group or pair work"
label variable Screening_tool_unc 	  "	(Unconditional) 10a.2 Use of screening and identification tools to understand learning needs"
label variable Classroom_assess_unc   "	(Unconditional) 10a.3 Use of classroom assessment techniques"
label variable Other_method_unc       "	(Unconditional) 10a.4 Other methods"

rename aWhynotassessed safety_10a_1
label variable safety_10a_1 "	(TEXT)(If safety_10 = 2 or 3) Why not assessed?"

*safety_11a
rename aDoestheschoolhavefacil safety_11a
tab safety_11a

gen safety_11_1 = 0 if safety_11a != ""
replace safety_11_1 = 1 if safety_11a == "Sufficient facilities"

gen safety_11_2 = 0 if safety_11a != ""
replace safety_11_2 = 1 if safety_11a == "Insufficient facilities"

gen safety_11_3 = 0 if safety_11a != ""
replace safety_11_3 = 1 if safety_11a == "No facilities at all"

label variable safety_11_1 "		Sufficient facilities"
label variable safety_11_2 "		Insufficient facilities"
label variable safety_11_3 "		No facilities at all"


rename (a1Availabilityoframps a1Inclusivetoilets a1Teacherswithspecialne a1Other) ///
	(Ramp Inclusive_toilet Special_ed_teacher Other_facility)
	
rename a1Whichfacilitiesareava safety_11a_1
label variable safety_11a_1 "11a.1. Which facilities are available?"

tab safety_11a_1 

label variable Ramp 			  "	11a.1.1 Ramp"
label variable Inclusive_toilet   "	11a.1.2 Inclusive toilet"
label variable Special_ed_teacher "	11a.1.3 Special Ed teacher"
label variable Other_facility     "	11a.1.4. Other facility"
label variable Pleasementionother "	(TEXT) Please mention if chosen 'other facility'"

gen Ramp_unc = Ramp
replace Ramp_unc = 0 if Ramp_unc == .
gen Inclusive_toilet_unc = Inclusive_toilet
replace Inclusive_toilet_unc = 0 if Inclusive_toilet_unc == .
gen Special_ed_teacher_unc = Special_ed_teacher
replace Special_ed_teacher_unc = 0 if Special_ed_teacher_unc == .
gen Other_facility_unc = Other_facility
replace Other_facility_unc = 0 if Other_facility_unc == .


label variable Ramp_unc 			  "	(Unconditional) 11a.1.1 Ramp"
label variable Inclusive_toilet_unc   "	(Unconditional) 11a.1.2 Inclusive toilet"
label variable Special_ed_teacher_unc "	(Unconditional) 11a.1.3 Special Ed teacher"
label variable Other_facility_unc     "	(Unconditional) 11a.1.4. Other facility"


*safety_11b
rename bWhichgenderanddisabilit safety_11b
rename (bSeparatetoiletsforboys bSpecialroomformenstural bToiletsareuserfriendto ///
	bBuildingsareuserfriend bChairsandtablesareuser bOther) (Separate_gender_toilet ///
	Menstrual_hygiene_room Inclusive_toilets Inclusive_building Inclusive_chairs_tables ///
	Other_facilities)

tab Other
tab safety_11b
	
label variable Separate_gender_toilet  "	11b.1 Separate toilets for boys/girls"
label variable Menstrual_hygiene_room  "	11b.2 Special room for menstrual hygiene management (MHM)"
label variable Inclusive_toilets	   "	11b.3 Toilets are user-firendly to CwDs"
label variable Inclusive_building 	   "	11b.4. Buildings are user-friendly to CwDs"
label variable Inclusive_chairs_tables "	11b.5 Chairs/tables are user-friendly to CwDs"
label variable Other_facilities 	   "	11b.6 Other facility"
label variable CM 	   "	(TEXT)11b.7 Please mention if chosen 'other facility'"

sum Separate_gender_toilet Menstrual_hygiene_room Inclusive_toilets Inclusive_building Inclusive_chairs_tables Other_facilities
tab Other_facilities

*safety_12a
rename aHaveyouwitnessedanycha safety_12a
tab safety_12a

gen safety_12a_option1 = 0 if safety_12a != ""
replace safety_12a_option1 = 1 if safety_12a == "Yes, a lot"

gen safety_12a_option2 = 0 if safety_12a != ""
replace safety_12a_option2 = 1 if safety_12a == "Yes, a little"

gen safety_12a_option3 = 0 if safety_12a != ""
replace safety_12a_option3 = 1 if safety_12a == "No"

label variable safety_12a_option1 "	12a.1 Yes, a lot"
label variable safety_12a_option2 "	12a.2 Yes, a little"
label variable safety_12a_option3 "	12a.3 No"

rename (a1Explaininanarrativef a2Explaininanarrativef Whatchangesdoestheschool) ///
	(safety_12a1 safety_12a2 safety_13)
	
	
label variable safety_12a1 "(TEXT) 12.a.1. Explain the changes you have witnessed with practical examples."
label variable safety_12a2 "(TEXT) 12.a.2. Explain reasons explaining the lack of impact since the training."
label variable safety_13   "(TEXT) 13. What changes does the school need to imporve the safety and inclusion programme?"

encode Perm_teacher, gen(Perm_teacher_numeric)
drop Perm_teacher
rename Perm_teacher_numeric Perm_teacher

encode Temp_teacher, gen(Temp_teacher_numeric)
drop Temp_teacher
rename Temp_teacher_numeric Temp_teacher

encode Total_teacher, gen(Total_teacher_numeric)
drop Total_teacher
rename Total_teacher_numeric Total_teacher

*********************************
** Clean & Construct TCPD data **
*********************************

gen qn_1a = 1 if aDoestheschoolhaveTCPDp == "Yes"
replace qn_1a = 0 if aDoestheschoolhaveTCPDp == "No"
label variable qn_1a "1.a. Does the school have TCPD plan?"
label val qn_1a yesno

gen qn_1b = 1 if bHastheschoolformedaCom == "Yes"
replace qn_1b = 0 if bHastheschoolformedaCom == "No"
label variable qn_1b "1.b. Has the school formed CoL?"
label val qn_1b yesno

rename cWhynot qn_1c
label variable qn_1c "(TEXT) 1.c. Why not?"

rename Insummarylistthekeyacti qn_2
label variable qn_2 "(TEXT) 2. In summary, list key activities implemented by CoL"

gen qn_3 = 1 if IstheCoLtimetableavailabl == "Yes"
replace qn_3 = 0 if IstheCoLtimetableavailabl == "No"
label variable qn_3 "3. Is the CoL timetable available?"
label val qn_3 yesno


rename aHowfrequentlydotheCoL qn_4a
label variable qn_4a "4.a. How frequently do the CoL activities take place?"

gen qn_4a_1 = 0 if qn_1b == 1
replace qn_4a_1 = 1 if qn_4a == "Weekly"

gen qn_4a_2 = 0 if qn_1b == 1
replace qn_4a_2 = 1 if qn_4a == "Every two weeks"

gen qn_4a_3 = 0 if qn_1b == 1
replace qn_4a_3 = 1 if qn_4a == "Monthly"

gen qn_4a_4 = 0 if qn_1b == 1
replace qn_4a_4 = 1 if qn_4a == "Quarterly"

gen qn_4a_5 = 0 if qn_1b == 1
replace qn_4a_5 = 1 if qn_4a == "Not at all"

gen qn_4a_1_unc = qn_4a_1
replace qn_4a_1_unc = 0 if qn_1b == 0

gen qn_4a_2_unc = qn_4a_2
replace qn_4a_2_unc = 0 if qn_1b == 0

gen qn_4a_3_unc = qn_4a_3
replace qn_4a_3_unc = 0 if qn_1b == 0

gen qn_4a_4_unc = qn_4a_4
replace qn_4a_4_unc = 0 if qn_1b == 0

gen qn_4a_5_unc = qn_4a_5
replace qn_4a_5_unc = 0 if qn_1b == 0

label var qn_4a_1 "	4.a.1 Weekly"
label var qn_4a_2 "	4.a.2 Every two weeks"
label var qn_4a_3 "	4.a.3 Monthly"
label var qn_4a_4 "	4.a.4 Quarterly"
label var qn_4a_5 "	4.a.5 Not at all"
label var qn_4a_1_unc "	(Unconditional) 4.a.1 Weekly"
label var qn_4a_2_unc "	(Unconditional) 4.a.2 Every two weeks"
label var qn_4a_3_unc "	(Unconditional) 4.a.3 Monthly"
label var qn_4a_4_unc "	(Unconditional) 4.a.4 Quarterly"
label var qn_4a_5_unc "	(Unconditional) 4.a.5 Not at all"

rename bIfCoLactivitiesdotakep qn_4b
label variable qn_4b "4.b. If CoL takes place, are session minutes/records kept?"

tab qn_1b
tab qn_4a
tab qn_4b
tab qn_1a


gen qn_4b_1 = 0 if qn_1b == 1 & qn_4a_5 != 1
replace qn_4b_1 = 1 if qn_4b == "Available and complete"

gen qn_4b_2 = 0 if qn_1b == 1 & qn_4a_5 != 1
replace qn_4b_2 = 1 if qn_4b == "Available but incomplete"

gen qn_4b_3 = 0 if qn_1b == 1 & qn_4a_5 != 1
replace qn_4b_3 = 1 if qn_4b == "No record"

gen qn_4b_1_unc = qn_4b_1
replace qn_4b_1_unc = 0 if qn_1b == 0 | qn_4a_5 == 1

gen qn_4b_2_unc = qn_4b_2
replace qn_4b_2_unc = 0 if qn_1b == 0 | qn_4a_5 == 1

gen qn_4b_3_unc = qn_4b_3
replace qn_4b_3_unc = 0 if qn_1b == 0 | qn_4a_5 == 1

tab qn_4b_1_unc

label var qn_4b_1 "	4.b.1 Available and complete"
label var qn_4b_2 "	4.b.2 Available but incomplete"
label var qn_4b_3 "	4.b.3 No record"
label var qn_4b_1_unc "	(Unconditional) 4.b.1 Available and complete"
label var qn_4b_2_unc "	(Unconditional) 4.b.2 Available but incomplete"
label var qn_4b_3_unc "	(Unconditional) 4.b.3 No record"

sum qn_4b_1 qn_4b_2 qn_4b_3 qn_4b_1_unc qn_4b_2_unc qn_4b_3_unc

rename cWhyno qn_4c
label var qn_4c "	Why no?"

rename Whattopicswerediscussedin qn_5
label var qn_5 "5. What topics were discussed in the past three months? (Select Multiple)"

rename (AC Teachingandlearningtechniq Developmentandutilizationo TeachingApproachesofteachi ///
Formativeevaluationoflearn Summativeevaluationoflearn s_2_4 Pleasemention) ///
(qn_5_1 qn_5_2 qn_5_3 qn_5_4 qn_5_5 qn_5_6 qn_5_7 qn_5_8)

local topic ///
	qn_5_1 ///
	qn_5_2 ///
	qn_5_3 ///
	qn_5_4 ///
	qn_5_5 ///
	qn_5_6 ///
	qn_5_7 ///

foreach v in `topic' {
	label val `v' yesno
}

gen qn_5_1_unc = qn_5_1
replace qn_5_1_unc = 0 if qn_1b == 0 | qn_5_1 ==.

gen qn_5_2_unc = qn_5_2
replace qn_5_2_unc = 0 if qn_1b == 0 | qn_5_2 ==.

gen qn_5_3_unc = qn_5_3
replace qn_5_3_unc = 0 if qn_1b == 0 | qn_5_3 ==.

gen qn_5_4_unc = qn_5_4
replace qn_5_4_unc = 0 if qn_1b == 0 | qn_5_4 ==.

gen qn_5_5_unc = qn_5_5
replace qn_5_5_unc = 0 if qn_1b == 0 | qn_5_5 ==.

gen qn_5_6_unc = qn_5_6
replace qn_5_6_unc = 0 if qn_1b == 0 | qn_5_6 ==.

gen qn_5_7_unc = qn_5_7
replace qn_5_7_unc = 0 if qn_1b == 0 | qn_5_7 ==.

label var qn_5_1 "	5.1 3Rs"
label var qn_5_2 "	5.2 Teaching and learning techniques"
label var qn_5_3 "	5.3 Development and utilization of teaching and learning tools"
label var qn_5_4 "	5.4 Teaching/Approaches of teaching and managing inclusive classes"
label var qn_5_5 "	5.5 Formative evaluation of learning and teaching appraoches"
label var qn_5_6 "	5.6 Summative evaluation of learning and teaching appraoches"
label var qn_5_7 "	5.7 Other"
label var qn_5_1_unc "	(Unconditional) 5.1 3Rs"
label var qn_5_2_unc "	(Unconditional) 5.2 Teaching and learning techniques"
label var qn_5_3_unc "	(Unconditional) 5.3 Development and utilization of teaching and learning tools"
label var qn_5_4_unc "	(Unconditional) 5.4 Teaching/Approaches of teaching and managing inclusive classes"
label var qn_5_5_unc "	(Unconditional) 5.5 Formative evaluation of learning and teaching appraoches"
label var qn_5_6_unc "	(Unconditional) 5.6 Summative evaluation of learning and teaching appraoches"
label var qn_5_7_unc "	(Unconditional) 5.7 Other"
label var qn_5_8 "	(TEXT)Please mention if selected 'Other'"

rename (aNumberofmaleteacherswho bNumberoffemaleteachersw) (qn_6a qn_6b)

label var qn_6a "6.a. Number of male teachers in CoL in the past three months"
label var qn_6b "6.b. Number of female teachers in CoL in the past three months"

gen qn_6 = qn_6a + qn_6b
gen qn_6_prop = qn_6 / totalteachers_23
label var qn_6_prop "(Constructed) 6.c. Proportion of all teachers (within schools) in CoL"

sum qn_6_prop, d

rename (Whatotherparticipantsparti Noother WardEducationOfficerWEO Otherparticipants ///
Pleasementionotherparticipant) (qn_7 qn_7_3 qn_7_1 qn_7_2 qn_7_4)

label var qn_7 "7. What other participants participated in CoL in the past three months?(Select Multiple)"

local participant ///
	qn_7_1 ///
	qn_7_2 ///
	qn_7_3
	
foreach v in `participant' {
	label val `v' yesno
}

gen qn_7_1_unc = qn_7_1
replace qn_7_1_unc = 0 if qn_1b == 0 | qn_7_1 ==.

gen qn_7_2_unc = qn_7_2
replace qn_7_2_unc = 0 if qn_1b == 0 | qn_7_2 ==.

gen qn_7_3_unc = qn_7_3
replace qn_7_3_unc = 0 if qn_1b == 0 | qn_7_3 ==.

label var qn_7_1 "	7.1 WEO"
label var qn_7_2 "	7.2. Other participants"
label var qn_7_3 " 	7.3. No other"
label var qn_7_1_unc "	(Unconditional) 7.1 WEO"
label var qn_7_2_unc "	(Unconditional) 7.2. Other participants"
label var qn_7_3_unc " 	(Unconditional) 7.3. No other"

gen qn_8a = 1 if aArethereanyspecificstra == "Yes"
replace qn_8a = 0 if aArethereanyspecificstra == "No"
label variable qn_8a "8.a. Are there any specific strategies initiated by school to improve 3R?"
label val qn_8a yesno

rename (a1Explaingivingexamples a1Whynostrategyinitiated) (qn_8a1 qn_8a_1)
label variable qn_8a1 " (TEXT) 8.a.1 Explain the initiatives you have posted since you received training on 3R"
label variable qn_8a_1 "(TEXT) 8.a.2 Why no strategy initiated?"

rename (NumberofmaleStandardOnepupi NumberoffemaleStandardOnepu NumberofmaleStandardTwopupi ///
NumberoffemaleStandardTwopu NumberofmaleStandardThreepu NumberoffemaleStandardThree) ///
(qn_8a_1_m qn_8a_1_f qn_8a_2_m qn_8a_2_f qn_8a_3_m qn_8a_3_f)

label var qn_8a_1_m "Number of Std.I boys not mastering 3R"
label var qn_8a_1_f "Number of Std.I girls not mastering 3R"
label var qn_8a_2_m "Number of Std.II boys not mastering 3R"
label var qn_8a_2_f "Number of Std.II girls not mastering 3R"
label var qn_8a_3_m "Number of Std.III boys not mastering 3R"
label var qn_8a_3_f "Number of Std.III girls not mastering 3R"

sum qn_8a_1_m qn_8a_1_f qn_8a_2_m qn_8a_2_f qn_8a_3_m qn_8a_3_f, d

gen prop_3R1 = (qn_8a_1_m + qn_8a_1_f) / std1_23
gen prop_3R2 = (qn_8a_2_m + qn_8a_2_f) / std2_23
gen prop_3R3 = (qn_8a_3_m + qn_8a_3_f) / std3_23

label var prop_3R1 "Proportion of Std.I pupils not mastering 3R"
label var prop_3R2 "Proportion of Std.II pupils not mastering 3R"
label var prop_3R3 "Proportion of Std.III pupils not mastering 3R"


gen prop_3R1_unc = prop_3R1
replace prop_3R1_unc = 0 if prop_3R1 ==.
gen prop_3R2_unc = prop_3R2
replace prop_3R2_unc = 0 if prop_3R2 ==.
gen prop_3R3_unc = prop_3R3
replace prop_3R3_unc = 0 if prop_3R3 ==.

label var prop_3R1_unc "(Unconditional) Proportion of Std.I pupils not mastering 3R"
label var prop_3R2_unc "(Unconditional) Proportion of Std.II pupils not mastering 3R"
label var prop_3R3_unc "(Unconditional) Proportion of Std.III pupils not mastering 3R"

rename bTowhatextentdotheteach qn_8b
label variable qn_8b "8.b. To what extent do the teachers support each other through peer learning in CoL?"

gen qn_8b_1 = 0 if qn_1b == 1
replace qn_8b_1 = 1 if qn_8b == "Everytime we meet"

gen qn_8b_2 = 0 if qn_1b == 1
replace qn_8b_2 = 1 if qn_8b == "Regularly"

gen qn_8b_3 = 0 if qn_1b == 1
replace qn_8b_3 = 1 if qn_8b == "Sometimes"

gen qn_8b_4 = 0 if qn_1b == 1
replace qn_8b_4 = 1 if qn_8b == "Not at all"

gen qn_8b_1_unc = qn_8b_1
replace qn_8b_1_unc = 0 if qn_1b == 0

gen qn_8b_2_unc = qn_8b_2
replace qn_8b_2_unc = 0 if qn_1b == 0

gen qn_8b_3_unc = qn_8b_3
replace qn_8b_3_unc = 0 if qn_1b == 0

gen qn_8b_4_unc = qn_8b_4
replace qn_8b_4_unc = 0 if qn_1b == 0

label var qn_8b_1 "		8b.1 Everytime we meet"
label var qn_8b_2 "		8b.2 Regularly"
label var qn_8b_3 "		8b.3 Sometimes"
label var qn_8b_4 "		8b.4 Not at all"

label var qn_8b_1_unc "		(Unconditional) 8b.1 Everytime we meet"
label var qn_8b_2_unc "		(Unconditional) 8b.2 Regularly"
label var qn_8b_3_unc "		(Unconditional) 8b.3 Sometimes"
label var qn_8b_4_unc "		(Unconditional) 8b.4 Not at all"

gen qn_9 = 1 if Haveanyoftheteacherfrom == "Yes"
replace qn_9 = 0 if Haveanyoftheteacherfrom == "No"
label variable qn_9 "9. Have any of the teacher from this school attended TCPD training from Shule Bora?"
label val qn_9 yesno

rename aHaveyouwitnessedanychan qn_9a
label variable qn_9a "9.a. Have you witnessed any changes amongst teachers since the CPD training by Shule Bora?"

gen qn_9a_1 = 0 if qn_9 == 1
replace qn_9a_1 = 1 if qn_9a == "Yes, a lot"

gen qn_9a_2 = 0 if qn_9 == 1
replace qn_9a_2 = 1 if qn_9a == "Yes, a little"

gen qn_9a_3 = 0 if qn_9 == 1
replace qn_9a_3 = 1 if qn_9a == "No"

gen qn_9a_1_unc = qn_9a_1
replace qn_9a_1_unc = 0 if qn_9 == 0

gen qn_9a_2_unc = qn_9a_2
replace qn_9a_2_unc = 0 if qn_9 == 0

gen qn_9a_3_unc = qn_9a_3
replace qn_9a_3_unc = 0 if qn_9 == 0

label var qn_9a_1 "		9a.1 Yes, a lot"
label var qn_9a_2 "		9a.2 Yes, a little"
label var qn_9a_3 "		9a.3 No"
label var qn_9a_1_unc "		(Unconditional) 9a.1 Yes, a lot"
label var qn_9a_2_unc "		(Unconditional) 9a.2 Yes, a little"
label var qn_9a_3_unc "		(Unconditional) 9a.3 No"

sum qn_9a_1 qn_9a_2 qn_9a_3 qn_9a_1_unc qn_9a_2_unc qn_9a_3_unc

rename (a1Explaininanarrativefo a2Explaininanarrativefo bWhatchangesdoestheschoo) ///
(qn_9a1 qn_9a2 qn_9b)

label var qn_9a1 "(TEXT) Explain the changes you have witnessed with practical examples."
label var qn_9a2 "(TEXT) Exlain what reasons explain the lack of impact since the training."
label var qn_9b "(TEXT) What changes does the school need to make Col more effective."

save "${shule_bora_DB}\Descriptive_analyses\Monitoring\DataSets\Intermediate\Monitoring_2023_HT_constructed.dta", replace
save "${Monitoring_dtInt}\Monitoring_2023_HT_constructed.dta", replace 

timer off 1
timer list 1
//     1:      2.60 /        1 =       2.5970

*************************************
** Close workspace
*************************************
** log close
