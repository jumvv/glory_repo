** 241111
** PSSP PE HT Text Data Aggregate

*************************************
** Set up workspace
*************************************
version 14.1
clear all	
set graphics off
set varlab on
timer on 1

********************************************************************************
** Aggregate all text data and produce an excel file for qualitative analysis **
********************************************************************************
clear
gen id =.
save "${shule_bora_DB}/pssp/Output/text_append.dta", replace

use "${shule_bora_DB}/pssp/DataSets/Intermediate/HT PSSP_cleaned.dta", clear

set seed 60000
gen random = runiform(60000, 75000)
sort random
gen id = _n

local text ///
	a10_oth b10_oth c3_oth c3_why_oth c5_oth c7_oth c9_oth c11_oth c11_name c11_topic ///
	c12_s_oth c14_s_oth	d2_oth d4_oth d7_oth ///
	d24 e8_oth e9_oth e13_oth e16 f3_oth f5_oth f7 f17_oth f19 f21 ///
	g2_oth g4 h6_oth h7_oth h9 i2_oth i3_oth i4_oth i5_where i5_where_oth i10_oth ///
	i21_oth i28_oth i36_oth i37 k2_oth k11_oth k10_oth k12 k13_oth k14 ///
	l4_oth l8_oth l14 j4 j5 j6_oth j8_oth j8_how_oth j8_where_oth j8_who_oth ///
	j9_oth j14_oth j16_oth m1_why_oth m2_why_oth m3_why_oth ///
	m4_why_oth m5_why_oth m6_why_oth m7_why_oth m8_why_oth m9_why_oth m10_why_oth

foreach t in `text' {
	preserve
	drop if `t' == ""
	keep id `t'
	gen var = "`t'"
	gen response = ""
	replace response = `t'
	gen lab = ""
	gen interviewee = "HT"
	order id var lab response interviewee
	keep id var lab response interviewee

	save "${shule_bora_DB}/pssp/Output/text_`t'.dta", replace

	restore
	}
	
local app ///
	a10_oth b10_oth c3_oth c3_why_oth c5_oth c7_oth c9_oth c11_oth c11_name c11_topic ///
	c12_s_oth c14_s_oth	d2_oth d4_oth d7_oth ///
	d24 e8_oth e9_oth e13_oth e16 f3_oth f5_oth f7 f17_oth f19 f21 ///
	g2_oth g4 h6_oth h7_oth h9 i2_oth i3_oth i4_oth i5_where i5_where_oth i10_oth ///
	i21_oth i28_oth i36_oth i37 k2_oth k11_oth k10_oth k12 k13_oth k14 ///
	l4_oth l8_oth l14 j4 j5 j6_oth j8_oth j8_how_oth j8_where_oth j8_who_oth ///
	j9_oth j14_oth j16_oth m1_why_oth m2_why_oth m3_why_oth ///
	m4_why_oth m5_why_oth m6_why_oth m7_why_oth m8_why_oth m9_why_oth m10_why_oth

	
foreach v in `app' {
    
    * Define the file path
    local file_path "${shule_bora_DB}/pssp/Output/text_`v'.dta"

    * Check if the file exists before attempting to append
    if (fileexists("`file_path'")) {
        display "Appending data from `file_path'..."

        * Use the first file in the list (or initialize it for the first iteration)
        if "`v'" == "a10_oth" {
            use "`file_path'", clear
        }
        else {
            append using "`file_path'"
        }
    }
    else {
        display "File `file_path' not found. Skipping."
    }
}

* After the loop, save the combined dataset
save "${shule_bora_DB}/pssp/Output/text_appended.dta", replace

	
use "${shule_bora_DB}/pssp/Output/text_appended", clear
keep id var lab response interviewee
replace lab = "a10_oth. Reason for refusal" if var == "a10_oth"
replace lab = "b10_oth. Specify classes you have at your school." if var == "b10_oth"
replace lab = "c3_oth. Who in your school received the training on the PSSP" if var == "c3_oth"
replace lab = "c3_why_oth. Why were you unable to attend the training?" if var == "c3_why_oth"
replace lab = "c5_oth. Which gov't level delivered the PSSP training?" if var == "c5_oth"
replace lab = "c7_oth. Which components were covered in the PSSP training?" if var == "c7_oth"
replace lab = "c9_oth. Who in your school received this training" if var == "c9_oth"
replace lab = "c11_oth. Which entity delivered/organized the training?" if var == "c11_oth"
replace lab = "c11_name. Please name the specific entity" if var == "c11_name"
replace lab = "c11_topic. What were some of the topics covered?" if var == "c11_topic"
replace lab = "c12_s_oth. How did you recieve the soft copy ('Safe School Plan for Early and Primary Education 2022')" if var == "c12_s_oth"
replace lab = "c14_s_oth. How did you receive the soft copy (PSSP training package)" if var == "c14_s_oth"
replace lab = "d2_oth. Why are GC services not offered?" if var == "d2_oth"
replace lab = "d4_oth. Who selected/elected the GC teachers?" if var == "d4_oth"
replace lab = "d7_oth. What is the main reason why some GC teachers did not recieve the multi-day PSSP training on GC services?" if var == "d7_oth"
replace lab = "d10_oth. Who delivered the training on GC services?" if var == "d10_oth"
replace lab = "d12_oth. Why not have a special room/place in the school for GC services?" if var == "d12_oth"
replace lab = "d13_oth. Which uses and privacy does the GC room offer?" if var == "d13_oth"
replace lab = "d18_oth. Which media has the school used to communicate the GC services to students?" if var == "d18_oth"
replace lab = "d22_oth. Which media has the school used to communicate the GC services to parents?" if var == "d22_oth"
replace lab = "d24. How do you think the GC services at your school could be strengthened?" if var == "d24"
replace lab = "e1_s_oth. How did you receive the soft copy (Teachers' CoC)" if var == "e1_s_oth"
replace lab = "e4_oth. Who conducted the CoC training?" if var == "e4_oth"
replace lab = "e8_oth. What are the most common violations of the teachers' CoC you have faced in your school?" if var == "e8_oth"
replace lab = "e9_oth. If a teacher gets absent from school, what type of punishment does the CoC allow HT to impose?" if var == "e9_oth"
replace lab = "e10_oth. If a teacher is drinking alcohol during working, what punishment does the CoC allow HT to impose?" if var == "e10_oth"
replace lab = "e13_oth. Why were you sometimes not able to issue punishments established in the CoC?" if var == "e13_oth"
replace lab = "e16. What challenges do you face in disciplining teachers when they commit violations of the CoC?" if var == "e16"
replace lab = "f3_oth. Why has PTP not been established?" if var == "f3_oth"
replace lab = "f5_oth. What are PTP's main focus/activities in your school?" if var == "f5_oth"
replace lab = "f7. Example of how the PTP is making active contribution to creating a safer school environment" if var == "f7"
replace lab = "f17_oth. What is the main focus of meeting with the CDO?" if var == "f17_oth"
replace lab = "f19. Example of how the CDO is making active contribution to creating a safer school environment" if var == "f19"
replace lab = "f21. What challenges do you face getting the community more involved in helping you address the causes of violence at your school?" if var == "f21"
replace lab = "g2_oth. What activities have your school conducted to reduce risk associated with traveling to and from school?" if var == "g2_oth"
replace lab = "g4. What would you think the school could do something else to improve the safety of passage to school?" if var == "g4"
replace lab = "h6_oth. Why are there no life skills clubs in your school?" if var == "h6_oth"
replace lab = "h7_oth. Which topics are taught in life skills clubs?" if var == "h7_oth"
replace lab = "h9. What are the most significant challenges for strengthening life skills education and clubs at your school?" if var == "h9"
replace lab = "i2_oth. What kind of CRM to log track and act on complaints you have?" if var == "i2_oth"
replace lab = "i3_oth. Why does your school not have a security and safety desk?" if var == "i3_oth"
replace lab = "i4_oth. Who is in charge of the security and safety desk?" if var == "i4_oth"
replace lab = "i5_where. Please comment on where the box is located, whether it has privacy, and whether it is easily reachable for students?" if var == "i5_where"
replace lab = "i5_where_oth. Please specify" if var == "i5_where_oth"
replace lab = "i10_oth. Who provided the training on CRM?" if var == "i10_oth"
replace lab = "i15_oth. Who are involved in the separate committee for handling students' complaints?" if var == "i15_oth"
replace lab = "i17_oth. How did your school conducte the orientation for students?" if var == "i17_oth"
replace lab = "i19_oth. How did you conduct the orientation for parents?" if var == "i19_oth"
replace lab = "i21_oth. Where is this document or service referral mapping available for anyone to consult?" if var == "i21_oth"
replace lab = "i28_oth. What would you say are the most common problems related to violence to students?" if var == "i28_oth"
replace lab = "i36_oth. What are the main challenges facing the proper use of the CRM?" if var == "i36_oth"
replace lab = "i37. How do you think the CRM could be strengthened?" if var == "i37"
replace lab = "k2_oth. What are the top three reasons for dropouts?" if var == "k2_oth"
replace lab = "k4_oth. What are the top three reasons for absenteesim?" if var == "k4_oth"
replace lab = "k11_oth. What type of data does your school or you regularly collect to identify students at risk of dropouts" if var == "k11_oth"
replace lab = "k10_oth. Can you name a few signs that a child is at risk of dropouts?" if var == "k10_oth"
replace lab = "k12. What challenges have been encountered in collecting this type of data regularly and with high quality?" if var == "k12"
replace lab = "k13_oth. What would you do if you think one of your students is at risk of dropouts?" if var == "k13_oth"
replace lab = "k14. What challenges are you facing at regularly monitoring students at risk of dropouts?" if var == "k14"
replace lab = "l4_oth. Who is currently providing financial or in-kind contributions to the SFP?" if var == "l4_oth"
replace lab = "l8_oth. What activities hae been conducted to improve the participation of stakeholders in strenghtening SFP?" if var == "l8_oth"
replace lab = "l14. What are the main challenges in providing meals to students?" if var == "l14"
replace lab = "j4. What other mechanisms do you use to discipline students?" if var == "j4"
replace lab = "j5. What is the most common type of corporal punishment used at your school to discipline students?" if var == "j5"
replace lab = "j6_oth. Which student behaviors have been sanctioned with corporal punishment at your school?" if var == "j6_oth"
replace lab = "j7_oth. What is the most common student behavior sanctioned with corporal punishment at your school?" if var == "j7_oth"
replace lab = "j8_oth. Which types of corporal punishments have been used at your school?" if var == "j8_oth"
replace lab = "j8_how_oth. what tool is used to deliver the beating?" if var == "j8_how_oth"
replace lab = "j8_where_oth. Which part(s) of the body is the beating typically applied to?" if var == "j8_where_oth"
replace lab = "j8_who_oth. Who delivers the beating?" if var == "j8_who_oth"
replace lab = "j9_oth. Whch school staff have used corporal punishment on students at your school this year?" if var == "j9_oth"
replace lab = "j14_oth. To the best of your recollection, what are some of the key elements of the guidelines?" if var == "j14_oth"
replace lab = "j16_oth. To the best of your knowledge, what information does the corporal punishment record book typically contain?" if var == "j16_oth"
replace lab = "m1_why_oth. Why did you not feel well-prepared? (GC)" if var == "m1_why_oth"
replace lab = "m2_why_oth. Why did you not feel well-prepared? (CoC)" if var == "m2_why_oth"
replace lab = "m3_why_oth. Why did you not feel well-prepared? (PTP)" if var == "m3_why_oth"
replace lab = "m4_why_oth. Why did you not feel well-prepared? (Life skills)" if var == "m4_why_oth"
replace lab = "m5_why_oth. Why did you not feel well-prepared? (Safe passages)" if var == "m5_why_oth"
replace lab = "m6_why_oth. Why did you not feel well-prepared? (CRM)" if var == "m6_why_oth"
replace lab = "m7_why_oth. Why did you not feel well-prepared? (DEWS)" if var == "m7_why_oth"
replace lab = "m8_why_oth. Why did you not feel well-prepared? (SFP)" if var == "m8_why_oth"
replace lab = "m9_why_oth. Why did you not feel well-prepared? (Monitoring and Reporting)" if var == "m9_why_oth"
replace lab = "m10_why_oth. How would you rate your preparedness for training others?" if var == "m10_why_oth"

export excel using "${shule_bora_DB}/pssp/Output/text_appended_translated_HT.xlsx", ///
    firstrow(variables) replace
		
timer off 1
timer list 1
