** 230907 
** Construct Baseline Variables

*************************************
** Set up workspace
*************************************
version 14.1
clear all
set more off
cd "${PathHome}"
** log using C001ImportRaw.do, text replace
timer on 1

use "${PathDataIntermediate}\Inclusion_Data_Merged_All_2024", clear

sort Region Council School

egen LgaBlock = group( Council )

*************************************
** 1. Promotion rate component variables
*************************************
/*

Promotion Rate = (Enrolment_g2_2024 - Repeater_g2_2024 - Reenrolled_g2_2024) /
							( Enrolment_g1_2023 )
							
Promotion Rate Upper Bound = (Enrolment_g2_2024 - Repeater_g2_2024 - Reenrolled_g2_2024) /
							(Enrolment_g1_2023 - TransfersOut_g1_2023)
							
Promotion Rate Lower Bound = (Enrolment_g2_2024 - Repeater_g2_2024- Reenrolled_g2_2024
							- TransferredIn_g2_2024) /
							(Enrolment_g1_2023 - TransfersOut_g1_2023)			
*/

rename ( ///
	transfer_out_StIBoys_2023 ///
	transfer_out_StIGirls_2023 ///
	transfer_out_StIBoys_2024 ///
	transfer_out_StIGirls_2024 ///
	transfer_in_StIBoys_2023 ///
	transfer_in_StIGirls_2023 ///
	transfer_in_StIBoys_2024 ///
	transfer_in_StIGirls_2024 ///
	) ( ///
	transfer_out_StdIBoys_2023 ///
	transfer_out_StdIGirls_2023 ///
	transfer_out_StdIBoys_2024 ///
	transfer_out_StdIGirls_2024 ///
	transfer_in_StdIBoys_2023 ///
	transfer_in_StdIGirls_2023 ///
	transfer_in_StdIBoys_2024 ///
	transfer_in_StdIGirls_2024 ///
	)

local variables ///
	StandardIBoys_2024 ///
	StandardIGirls_2024 ///
	StandardIIBoys_2024 ///
	StandardIIGirls_2024 ///
	StandardIIIBoys_2024 ///
	StandardIIIGirls_2024 ///
	StandardIVBoys_2024 ///
	StandardIVGirls_2024 ///
	StandardVBoys_2024 ///
	StandardVGirls_2024 ///
	StandardVIBoys_2024 ///
	StandardVIGirls_2024 ///
	StandardVIIBoys_2024 ///
	StandardVIIGirls_2024 ///
	StandardIBoys_2023 ///
	StandardIGirls_2023 ///
	StandardIIBoys_2023 ///
	StandardIIGirls_2023 ///
	StandardIIIBoys_2023 ///
	StandardIIIGirls_2023 ///
	StandardIVBoys_2023 ///
	StandardIVGirls_2023 ///
	StandardVBoys_2023 ///
	StandardVGirls_2023 ///
	StandardVIBoys_2023 ///
	StandardVIGirls_2023 ///
	StandardVIIBoys_2023 ///
	StandardVIIGirls_2023 ///
	repeater_StdIBoys_2023 ///
	repeater_StdIGirls_2023 ///
	repeater_StdIIBoys_2023 ///
	repeater_StdIIGirls_2023 ///
	repeater_StdIIIBoys_2023 ///
	repeater_StdIIIGirls_2023 ///
	repeater_StdIVBoys_2023 ///
	repeater_StdIVGirls_2023 ///
	repeater_StdVBoys_2023 ///
	repeater_StdVGirls_2023 ///
	repeater_StdVIBoys_2023 ///
	repeater_StdVIGirls_2023 ///	
	repeater_StdVIIBoys_2023 ///
	repeater_StdVIIGirls_2023 ///
	repeater_StdIBoys_2024 ///
	repeater_StdIGirls_2024 ///
	repeater_StdIIBoys_2024 ///
	repeater_StdIIGirls_2024 ///
	repeater_StdIIIBoys_2024 ///
	repeater_StdIIIGirls_2024 ///
	repeater_StdIVBoys_2024 ///
	repeater_StdIVGirls_2024 ///
	repeater_StdVBoys_2024 ///
	repeater_StdVGirls_2024 ///
	repeater_StdVIBoys_2024 ///
	repeater_StdVIGirls_2024 ///	
	repeater_StdVIIBoys_2024 ///
	repeater_StdVIIGirls_2024 ///
	reenrollment_StdIBoys_2024 ///
	reenrollment_StdIGirls_2024 ///
	reenrollment_StdIIBoys_2024 ///
	reenrollment_StdIIGirls_2024 ///
	reenrollment_StdIIIBoys_2024 ///
	reenrollment_StdIIIGirls_2024 ///
	reenrollment_StdIVBoys_2024 ///
	reenrollment_StdIVGirls_2024 ///
	reenrollment_StdVBoys_2024 ///
	reenrollment_StdVGirls_2024 ///
	reenrollment_StdVIBoys_2024 ///
	reenrollment_StdVIGirls_2024 ///
	reenrollment_StdVIIBoys_2024 ///
	reenrollment_StdVIIGirls_2024 ///
	transfer_out_StdIBoys_2023 ///
	transfer_out_StdIGirls_2023 ///
	transfer_out_StdIIBoys_2023 ///
	transfer_out_StdIIGirls_2023 ///
	transfer_out_StdIIIBoys_2023 ///
	transfer_out_StdIIIGirls_2023 ///
	transfer_out_StdIVBoys_2023 ///
	transfer_out_StdIVGirls_2023 ///	
	transfer_out_StdVBoys_2023 ///
	transfer_out_StdVGirls_2023 ///
	transfer_out_StdVIBoys_2023 ///
	transfer_out_StdVIGirls_2023 ///
	transfer_out_StdVIIBoys_2023 ///
	transfer_out_StdVIIGirls_2023 ///
	transfer_out_StdIBoys_2024 ///
	transfer_out_StdIGirls_2024 ///
	transfer_out_StdIIBoys_2024 ///
	transfer_out_StdIIGirls_2024 ///
	transfer_out_StdIIIBoys_2024 ///
	transfer_out_StdIIIGirls_2024 ///
	transfer_out_StdIVBoys_2024 ///
	transfer_out_StdIVGirls_2024 ///	
	transfer_out_StdVBoys_2024 ///
	transfer_out_StdVGirls_2024 ///
	transfer_out_StdVIBoys_2024 ///
	transfer_out_StdVIGirls_2024 ///
	transfer_out_StdVIIBoys_2024 ///
	transfer_out_StdVIIGirls_2024 ///
	transfer_in_StdIBoys_2023 ///
	transfer_in_StdIGirls_2023 ///
	transfer_in_StdIIBoys_2023 ///
	transfer_in_StdIIGirls_2023 ///
	transfer_in_StdIIIBoys_2023 ///
	transfer_in_StdIIIGirls_2023 ///
	transfer_in_StdIVBoys_2023 ///
	transfer_in_StdIVGirls_2023 ///
	transfer_in_StdVBoys_2023 ///
	transfer_in_StdVGirls_2023 ///
	transfer_in_StdVIBoys_2023 ///
	transfer_in_StdVIGirls_2023 ///
	transfer_in_StdVIIBoys_2023 ///
	transfer_in_StdVIIGirls_2023 ///
	transfer_in_StdIBoys_2024 ///
	transfer_in_StdIGirls_2024 ///
	transfer_in_StdIIBoys_2024 ///
	transfer_in_StdIIGirls_2024 ///
	transfer_in_StdIIIBoys_2024 ///
	transfer_in_StdIIIGirls_2024 ///
	transfer_in_StdIVBoys_2024 ///
	transfer_in_StdIVGirls_2024 ///
	transfer_in_StdVBoys_2024 ///
	transfer_in_StdVGirls_2024 ///
	transfer_in_StdVIBoys_2024 ///
	transfer_in_StdVIGirls_2024 ///
	transfer_in_StdVIIBoys_2024 ///
	transfer_in_StdVIIGirls_2024 ///
	dropout_StdIBoys_2023 ///
	dropout_StdIGirls_2023 ///
	dropout_StdIIBoys_2023 ///
	dropout_StdIIGirls_2023 ///
	dropout_StdIIIBoys_2023 ///
	dropout_StdIIIGirls_2023 ///
	dropout_StdIVBoys_2023 ///
	dropout_StdIVGirls_2023 ///
	dropout_StdVBoys_2023 ///
	dropout_StdVGirls_2023 ///
	dropout_StdVIBoys_2023 ///
	dropout_StdVIGirls_2023 ///
	dropout_StdVIIBoys_2023 ///
	dropout_StdVIIGirls_2023 ///	

foreach e in `variables' {
	replace `e' = 0 if missing( `e' )
}

local num I II III IV V VI VII

foreach n in `num' {
	gen Std`n'2024 = Standard`n'Boys_2024 + Standard`n'Girls_2024 // Enrollment 2024
	gen Std`n'2023 = Standard`n'Boys_2023 + Standard`n'Girls_2023 // Enrollment 2023
	gen RepeaterStd`n'2024 = repeater_Std`n'Boys_2024 + repeater_Std`n'Girls_2024 // Repeater 2024
	gen RepeaterStd`n'2023 = repeater_Std`n'Boys_2023 + repeater_Std`n'Girls_2023 // Repeater 2023
	gen ReenrollmentStd`n'2024 = reenrollment_Std`n'Boys_2024 + reenrollment_Std`n'Girls_2024 // Reenrollment 2024
	gen TransferOutStd`n'2024 = transfer_out_Std`n'Boys_2024 + transfer_out_Std`n'Girls_2024 // TrasferOut 2023
	gen TransferOutStd`n'2023 = transfer_out_Std`n'Boys_2023 + transfer_out_Std`n'Girls_2023 // TrasferOut 2023
	gen TransferInStd`n'2024 = transfer_in_Std`n'Boys_2024 + transfer_in_Std`n'Girls_2024 // TransferIn 2024
	gen TransferInStd`n'2023 = transfer_in_Std`n'Boys_2023 + transfer_in_Std`n'Girls_2023 // TransferIn 2023
	gen DroppedOutStd`n'2023 = dropout_Std`n'Boys_2023 + dropout_Std`n'Girls_2023 // TransferIn 2023
}

** CAND. PASSED 2023
gen PassedPsle2023 = real( CANDPASSED2023_2024 )
replace PassedPsle2023 = 0 if missing( PassedPsle2023 )
*** Expediently named placeholder variables
gen StdVIII2024 = PassedPsle2023
gen RepeaterStdVIII2024 = 0
gen ReenrollmentStdVIII2024 = 0
gen TransferInStdVIII2024 = 0

list School Ward Ward2023 if School == School2023 & Ward != Ward2023
replace Ward2023 = "Daraja II" if Ward2023 == "Daraja Ii"

*************************************
** 1.1 Promotion rates
*************************************
** Loop over grades to make grade-specific promotion rate variables
tokenize I II III IV V VI VII VIII
foreach n of num 2/8 {
	local nm1 = `n' - 1
	local g1 ``nm1''
	local g2 ``n''
	
	gen PrStd`g2'2023Num = Std`g2'2024 - RepeaterStd`g2'2024 - ReenrollmentStd`g2'2024 
	gen PrStd`g2'2023NumNeg = PrStd`g2'2023Num < 0
	replace PrStd`g2'2023Num = Std`g2'2024 if PrStd`g2'2023Num < 0
	
	gen PrStd`g2'2023Denom = Std`g1'2023
		
	gen PrStd`g2'2023 = PrStd`g2'2023Num / PrStd`g2'2023Denom

	gen PrStd`g2'2023Above1 = PrStd`g2'2023 > 1
	replace PrStd`g2'2023Num = PrStd`g2'2023Denom if PrStd`g2'2023 > 1
	replace PrStd`g2'2023 = 1 if PrStd`g2'2023 > 1
}

** Calculate aggregate rate
local Pr2023NumVarlist 
local Pr2023DenomVarlist
foreach n of num 2/8 {
	local g2 ``n'' 
	local Pr2023NumVarlist `Pr2023NumVarlist' PrStd`g2'2023Num
	local Pr2023DenomVarlist `Pr2023DenomVarlist' PrStd`g2'2023Denom
}
egen Pr2023Num = rowtotal( `Pr2023NumVarlist' )
egen Pr2023Denom = rowtotal( `Pr2023DenomVarlist' )
gen AvgPr2023 = Pr2023Num / Pr2023Denom

** Check why we get negative averages
** => School != School2023

su AvgPr2023, d
                          ** AvgPr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%     .5274336              0
 ** 5%     .6777188              0
** 10%     .7360406              0       Obs              19,729
** 25%     .8139183              0       Sum of Wgt.      19,729

** 50%     .8815331                      Mean            .862435
                        ** Largest       Std. Dev.      .1015427
** 75%     .9346405              1
** 90%       .96875              1       Variance       .0103109
** 95%     .9830097              1       Skewness      -1.804728
** 99%            1              1       Kurtosis       10.37056

su AvgPr2023 if School == School2023, d 
                          ** AvgPr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%     .5333334              0
 ** 5%     .6793558              0
** 10%     .7371601              0       Obs              19,629
** 25%     .8145604              0       Sum of Wgt.      19,629

** 50%     .8819876                      Mean           .8633864
                        ** Largest       Std. Dev.       .098847
** 75%     .9349315              1
** 90%     .9688013              1       Variance       .0097707
** 95%     .9830508              1       Skewness      -1.510465
** 99%            1              1       Kurtosis       7.506703

*************************************
** 1.2 Upper bound promotion rates
*************************************
** Loop over grades to make grade-specific promotion rate variables
tokenize I II III IV V VI VII VIII
foreach n of num 2/8 {
	local nm1 = `n' - 1
	local g1 ``nm1''
	local g2 ``n''
	
	gen UpperPrStd`g2'2023Num = Std`g2'2024 - RepeaterStd`g2'2024 - ReenrollmentStd`g2'2024 
	gen UpperPrStd`g2'2023NumNeg = UpperPrStd`g2'2023Num < 0
	replace UpperPrStd`g2'2023Num = Std`g2'2024 if UpperPrStd`g2'2023Num < 0
	
	gen UpperPrStd`g2'2023Denom = Std`g1'2023 + TransferInStd`g1'2023 - TransferOutStd`g1'2023
	gen UpperPrStd`g2'2023DenomNeg = UpperPrStd`g2'2023Denom < 0
	replace UpperPrStd`g2'2023Denom = Std`g1'2023 + TransferInStd`g1'2023 if UpperPrStd`g2'2023Denom < 0
	
	gen UpperPrStd`g2'2023 = UpperPrStd`g2'2023Num / UpperPrStd`g2'2023Denom

	gen UpperPrStd`g2'2023Above1 = UpperPrStd`g2'2023 > 1
	replace UpperPrStd`g2'2023Num = UpperPrStd`g2'2023Denom if UpperPrStd`g2'2023 > 1
	replace UpperPrStd`g2'2023 = 1 if UpperPrStd`g2'2023 > 1
}
** Calculate aggregate rate
local UpperPr2023NumVarlist 
local UpperPr2023DenomVarlist
foreach n of num 2/8 {
	local g2 ``n'' 
	local UpperPr2023NumVarlist `UpperPr2023NumVarlist' UpperPrStd`g2'2023Num
	local UpperPr2023DenomVarlist `UpperPr2023DenomVarlist' UpperPrStd`g2'2023Denom
}
egen UpperPr2023Num = rowtotal( `UpperPr2023NumVarlist' )
egen UpperPr2023Denom = rowtotal( `UpperPr2023DenomVarlist' )
gen AvgUpperPr2023 = UpperPr2023Num / UpperPr2023Denom

** Check why we get negative averages
** => School != School2023

su AvgUpperPr2023, d
                       ** AvgUpperPr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%     .5209677              0
 ** 5%     .6777493              0
** 10%     .7351097              0       Obs              19,865
** 25%     .8132678              0       Sum of Wgt.      19,865

** 50%     .8809981                      Mean           .8614088
                        ** Largest       Std. Dev.      .1033935
** 75%     .9337748              1
** 90%     .9671053              1       Variance       .0106902
** 95%      .981685              1       Skewness      -2.033746
** 99%            1              1       Kurtosis       12.38132

su AvgUpperPr2023 if School == School2023, d 
                       ** AvgUpperPr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%     .5359318              0
 ** 5%     .6820809              0
** 10%     .7374429              0       Obs              19,629
** 25%     .8146789              0       Sum of Wgt.      19,629

** 50%     .8814391                      Mean           .8629666
                        ** Largest       Std. Dev.      .0977459
** 75%     .9336824              1
** 90%     .9665493              1       Variance       .0095543
** 95%     .9808205              1       Skewness      -1.524896
** 99%            1              1       Kurtosis       7.664712

** ** ROBUSTNESS CHECK: aggregate rate v2
** gen AvgUpperPr2023Num2 = UpperPrStdII2023*UpperPrStdII2023Denom // for robustness check
** gen AvgUpperPr2023Denom2 = UpperPrStdII2023Denom // for robustness check
** foreach n of num 3/8 {
	** local g2 ``n'' 
	** replace AvgUpperPr2023Num2 = AvgUpperPr2023Num2 + UpperPrStd`g2'2023*UpperPrStd`g2'2023Denom
	** replace AvgUpperPr2023Denom2 = AvgUpperPr2023Denom2 + UpperPrStd`g2'2023Denom
** }
** gen AvgUpperPr2023_2 = AvgUpperPr2023Num2 / AvgUpperPr2023Denom2
** su AvgUpperPr2023_2
** su AvgUpperPr2023 if !missing( AvgUpperPr2023_2 )

*************************************
** 1.3 Lower bound promotion rates
*************************************
** Loop over grades to make grade-specific promotion rate variables
tokenize I II III IV V VI VII VIII
foreach n of num 2/8 {
	local nm1 = `n' - 1
	local g1 ``nm1''
	local g2 ``n''
	
	gen LowerPrStd`g2'2023Num = Std`g2'2024 - RepeaterStd`g2'2024 - ReenrollmentStd`g2'2024 - TransferInStd`g2'2024
	gen LowerPrStd`g2'2023NumNeg1  = LowerPrStd`g2'2023Num < 0
	replace LowerPrStd`g2'2023Num = Std`g2'2024 - RepeaterStd`g2'2024 - ReenrollmentStd`g2'2024 if LowerPrStd`g2'2023Num < 0
	gen LowerPrStd`g2'2023NumNeg2 = LowerPrStd`g2'2023Num < 0
	replace LowerPrStd`g2'2023Num = Std`g2'2024 if Std`g2'2024 - RepeaterStd`g2'2024 - ReenrollmentStd`g2'2024 < 0
	
	gen LowerPrStd`g2'2023Denom = Std`g1'2023 + TransferInStd`g1'2023 - TransferOutStd`g1'2023
	gen LowerPrStd`g2'2023DenomNeg = LowerPrStd`g2'2023Denom < 0
	replace LowerPrStd`g2'2023Denom = Std`g1'2023 + TransferInStd`g1'2023 if LowerPrStd`g2'2023Denom < 0
	
	gen LowerPrStd`g2'2023 = LowerPrStd`g2'2023Num / LowerPrStd`g2'2023Denom
	
	gen LowerPrStd`g2'2023Above1 = LowerPrStd`g2'2023 > 1
	replace LowerPrStd`g2'2023Num = 0 if LowerPrStd`g2'2023 > 1
	replace LowerPrStd`g2'2023Denom = 0 if LowerPrStd`g2'2023 > 1
	replace LowerPrStd`g2'2023 = . if LowerPrStd`g2'2023 > 1
}
** Calculate aggregate rate
local LowerPr2023NumVarlist 
local LowerPr2023DenomVarlist
foreach n of num 2/8 {
	local g2 ``n'' 
	local LowerPr2023NumVarlist `LowerPr2023NumVarlist' LowerPrStd`g2'2023Num
	local LowerPr2023DenomVarlist `LowerPr2023DenomVarlist' LowerPrStd`g2'2023Denom
}
egen LowerPr2023Num = rowtotal( `LowerPr2023NumVarlist' )
egen LowerPr2023Denom = rowtotal( `LowerPr2023DenomVarlist' )
gen AvgLowerPr2023 = LowerPr2023Num / LowerPr2023Denom

** Check why we get negative averages
** => School != School2023

su AvgLowerPr2023, d
                       ** AvgLowerPr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%     .4367089              0
 ** 5%     .6049383              0
** 10%     .6746411              0       Obs              19,775
** 25%     .7680723              0       Sum of Wgt.      19,775

** 50%     .8484849                      Mean           .8233562
                        ** Largest       Std. Dev.      .1204688
** 75%     .9074074              1
** 90%     .9453552              1       Variance       .0145127
** 95%     .9626437              1       Skewness       -1.87495
** 99%     .9918367              1       Kurtosis       10.14371

su AvgLowerPr2023 if School == School2023, d
                       ** AvgLowerPr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%      .462141              0
 ** 5%     .6116861              0
** 10%     .6782225              0       Obs              19,580
** 25%     .7696482              0       Sum of Wgt.      19,580

** 50%      .849315                      Mean           .8259143
                        ** Largest       Std. Dev.      .1133249
** 75%     .9077624              1
** 90%     .9453552              1       Variance       .0128425
** 95%     .9624602              1       Skewness      -1.435151
** 99%     .9911504              1       Kurtosis       6.883782

** ** Check why certain conditions appear
** local g2 III
** local g1 II
** local Condition LowerPrStd`g2'2023 > 5 & !missing( LowerPrStd`g2'2023 ) & School == School2023
** list Ward School LowerPrStd`g2'2023Num Std`g2'2024 RepeaterStd`g2'2024 ReenrollmentStd`g2'2024 TransferInStd`g2'2024 if `Condition'
** list LowerPrStd`g2'2023Denom Std`g1'2023 TransferInStd`g1'2023 TransferOutStd`g1'2023 if `Condition'

*************************************
** 2. Dropout rate component variables
*************************************
foreach s in DeathBoys_2023 DeathGirls_2023 ///
		PregnancyBoys_2023 PregnancyGirls_2023 ///
		TruancyBoys_2023 TruancyGirls_2023 ///
		IndesciplineBoys_2023 IndesciplineGirls_2023{
	replace `s' = 0 if missing( `s' )
}
gen TruancyTotal2023 = TruancyBoys_2023 + TruancyGirls_2023
gen DeathTotal2023 = DeathBoys_2023 + DeathGirls_2023
gen PregnancyTotal2023 = PregnancyBoys_2023 + PregnancyGirls_2023
gen IndesciplineTotal2023 = IndesciplineBoys_2023 + IndesciplineGirls_2023

gen DropoutTotal2023 = TruancyTotal2023 + DeathTotal2023 + PregnancyTotal2023 + IndesciplineTotal2023


gen dropout_compare = dropout_total_2023
replace dropout_compare = 0 if missing(dropout_total_2023)

compare DropoutTotal2023 dropout_compare
/*
                                        ---------- difference ----------
                            count       minimum      average     maximum
------------------------------------------------------------------------
Drop~2023=dropout~e         20552
                       ----------
jointly defined             20552             0            0           0
                       ----------
total                       20552
*/

lab var UpperPrStdII2023 "(Upper Bound)Promotion rate of Standard II students"
lab var UpperPrStdIII2023 "(Upper Bound)Promotion rate of Standard III students"
lab var UpperPrStdIV2023 "(Upper Bound)Promotion rate of Standard IV students"
lab var UpperPrStdV2023 "(Upper Bound)Promotion rate of Standard V students"
lab var UpperPrStdVI2023 "(Upper Bound)Promotion rate of Standard VI students"
lab var UpperPrStdVII2023 "(Upper Bound)Promotion rate of Standard VII students"
lab var AvgUpperPr2023 "(Upper Bound) Average promotion rate"


lab var LowerPrStdII2023 "(Lower Bound)Promotion rate of Standard II students"
lab var LowerPrStdIII2023 "(Lower Bound)Promotion rate of Standard III students"
lab var LowerPrStdIV2023 "(Lower Bound)Promotion rate of Standard IV students"
lab var LowerPrStdV2023 "(Lower Bound)Promotion rate of Standard V students"
lab var LowerPrStdVI2023 "(Lower Bound)Promotion rate of Standard VI students"
lab var LowerPrStdVII2023 "(Lower Bound)Promotion rate of Standard VII students"
lab var AvgLowerPr2023 "(Lower Bound) Average promotion rate"

*************************************
** 2.1 Dropout rates
*************************************
** Loop over grades to make grade-specific promotion rate variables
tokenize I II III IV V VI VII
foreach n of num 1/7 {
	local g2 ``n''
	
	gen DrStd`g2'2023Num = DroppedOutStd`g2'2023
	
	gen DrStd`g2'2023Denom = Std`g2'2023
		
	gen DrStd`g2'2023 = DrStd`g2'2023Num / DrStd`g2'2023Denom

	gen DrStd`g2'2023Above1 = DrStd`g2'2023 > 1
	replace DrStd`g2'2023Num = DrStd`g2'2023Denom if DrStd`g2'2023 > 1
	replace DrStd`g2'2023 = 1 if DrStd`g2'2023 > 1
}

** Calculate aggregate rate
local Dr2023NumVarlist 
local Dr2023DenomVarlist
foreach n of num 1/7 {
	local g2 ``n'' 
	local Dr2023NumVarlist `Dr2023NumVarlist' DrStd`g2'2023Num
	local Dr2023DenomVarlist `Dr2023DenomVarlist' DrStd`g2'2023Denom
}
egen Dr2023Num = rowtotal( `Dr2023NumVarlist' )
egen Dr2023Denom = rowtotal( `Dr2023DenomVarlist' )
gen AvgDr2023 = Dr2023Num / Dr2023Denom

** Check why we get negative averages
** => School != School2023

su AvgDr2023, d
                          ** AvgDr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,729
** 25%            0              0       Sum of Wgt.      19,729

** 50%            0                      Mean           .0117442
                        ** Largest       Std. Dev.      .0299006
** 75%     .0056711       .3727162
** 90%     .0409091       .3856209       Variance        .000894
** 95%     .0714286       .3954802       Skewness       4.151003
** 99%     .1441578       .4482759       Kurtosis       27.11833

su AvgDr2023 if School == School2023, d 
                          ** AvgDr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,629
** 25%            0              0       Sum of Wgt.      19,629

** 50%            0                      Mean           .0115989
                        ** Largest       Std. Dev.      .0296674
** 75%     .0054348       .3727162
** 90%     .0402235       .3856209       Variance       .0008802
** 95%     .0705882       .3954802       Skewness         4.1791
** 99%     .1434783       .4482759       Kurtosis       27.48997

*************************************
** 3 Repeat rates
*************************************
** Loop over grades to make grade-specific promotion rate variables
tokenize I II III IV V VI VII VIII
foreach n of num 2/8 {
	local nm1 = `n' - 1
	local g1 ``nm1''
	local g2 ``n''
	
	gen ReprStd`g2'2023Num = RepeaterStd`g2'2024
	gen ReprStd`g2'2023NumNeg = ReprStd`g2'2023Num < 0
	replace ReprStd`g2'2023Num = Std`g2'2024 if ReprStd`g2'2023Num < 0
	
	gen ReprStd`g2'2023Denom = Std`g1'2023
		
	gen ReprStd`g2'2023 = ReprStd`g2'2023Num / ReprStd`g2'2023Denom

	gen ReprStd`g2'2023Above1 = ReprStd`g2'2023 > 1
	replace ReprStd`g2'2023Num = ReprStd`g2'2023Denom if ReprStd`g2'2023 > 1
	replace ReprStd`g2'2023 = 1 if ReprStd`g2'2023 > 1
}

** Calculate aggregate rate
local Repr2023NumVarlist 
local Repr2023DenomVarlist
foreach n of num 2/8 {
	local g2 ``n'' 
	local Repr2023NumVarlist `Repr2023NumVarlist' ReprStd`g2'2023Num
	local Repr2023DenomVarlist `Repr2023DenomVarlist' ReprStd`g2'2023Denom
}
egen Repr2023Num = rowtotal( `Repr2023NumVarlist' )
egen Repr2023Denom = rowtotal( `Repr2023DenomVarlist' )
gen AvgRepr2023 = Repr2023Num / Repr2023Denom

** Check why we get negative averages
** => School != School2023

su AvgRepr2023, d
                         ** AvgRepr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,729
** 25%            0              0       Sum of Wgt.      19,729

** 50%      .010582                      Mean           .0233543
                        ** Largest       Std. Dev.      .0327488
** 75%     .0345369        .302589
** 90%     .0655022       .3094777       Variance       .0010725
** 95%     .0882353       .3521127       Skewness       2.366591
** 99%     .1458333       .3666667       Kurtosis       11.36342

su AvgRepr2023 if School == School2023, d 
                         ** AvgRepr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,629
** 25%            0              0       Sum of Wgt.      19,629

** 50%     .0104987                      Mean           .0232313
                        ** Largest       Std. Dev.      .0325965
** 75%      .034375        .302589
** 90%     .0652174       .3094777       Variance       .0010625
** 95%     .0878187       .3521127       Skewness        2.37548
** 99%     .1448087       .3666667       Kurtosis       11.47531

*************************************
** 4 Renrollment rates
*************************************
** Loop over grades to make grade-specific promotion rate variables
tokenize I II III IV V VI VII VIII
foreach n of num 2/8 {
	local nm1 = `n' - 1
	local g1 ``nm1''
	local g2 ``n''
	
	gen RenrStd`g2'2023Num = ReenrollmentStd`g2'2024 
	gen RenrStd`g2'2023NumNeg = RenrStd`g2'2023Num < 0
	replace RenrStd`g2'2023Num = Std`g2'2024 if RenrStd`g2'2023Num < 0
	
	gen RenrStd`g2'2023Denom = Std`g1'2023
		
	gen RenrStd`g2'2023 = RenrStd`g2'2023Num / RenrStd`g2'2023Denom

	gen RenrStd`g2'2023Above1 = RenrStd`g2'2023 > 1
	replace RenrStd`g2'2023Num = RenrStd`g2'2023Denom if RenrStd`g2'2023 > 1
	replace RenrStd`g2'2023 = 1 if RenrStd`g2'2023 > 1
}

** Calculate aggregate rate
local Renr2023NumVarlist 
local Renr2023DenomVarlist
foreach n of num 2/8 {
	local g2 ``n'' 
	local Renr2023NumVarlist `Renr2023NumVarlist' RenrStd`g2'2023Num
	local Renr2023DenomVarlist `Renr2023DenomVarlist' RenrStd`g2'2023Denom
}
egen Renr2023Num = rowtotal( `Renr2023NumVarlist' )
egen Renr2023Denom = rowtotal( `Renr2023DenomVarlist' )
gen AvgRenr2023 = Renr2023Num / Renr2023Denom

** Check why we get negative averages
** => School != School2023

su AvgRenr2023, d
                         ** AvgRenr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,729
** 25%            0              0       Sum of Wgt.      19,729

** 50%            0                      Mean            .000243
                        ** Largest       Std. Dev.      .0028652
** 75%            0       .0961263
** 90%            0       .0990991       Variance       8.21e-06
** 95%            0       .1395833       Skewness       26.27148
** 99%     .0061983        .154213       Kurtosis       1000.273

su AvgRenr2023 if School == School2023, d 
                         ** AvgRenr2023
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,629
** 25%            0              0       Sum of Wgt.      19,629

** 50%            0                      Mean           .0002442
                        ** Largest       Std. Dev.      .0028724
** 75%            0       .0961263
** 90%            0       .0990991       Variance       8.25e-06
** 95%            0       .1395833       Skewness       26.20497
** 99%      .006237        .154213       Kurtosis       995.2308

*************************************
** A. Basic school-level demographics
*************************************
gen SchoolSizeAsc2024 = TotalBoys_2024 + TotalGirls_2024

gen PromotionRateAsc2024 = AvgPr2023
gen DropoutRateAsc2024 = AvgDr2023
gen RepeatRateAsc2024 = AvgRepr2023
gen ReenrollmentRateAsc2024 = AvgRenr2023

lab var SchoolSizeAsc2024 "School size (number of students)"
lab var PromotionRateAsc2024 "Promotion rate"
lab var DropoutRateAsc2024 "Dropout rate"
lab var RepeatRateAsc2024 "Repeat rate"
lab var ReenrollmentRateAsc2024 "Reenrollment rate"

*************************************
** B. SEN identification variables
*************************************

cap drop Total_Female_2024
cap drop Total_Male_2024

local Conditions Albinism Deaf Lowhearing Deafblind Blind Lowvision Physical Autism Intellectual Multiple

gen Total_Female_2024 = 0
gen Total_Male_2024 = 0
gen Total2024 = 0
foreach ss in `Conditions' {
	replace `ss'_Male_2024 = 0 if missing( `ss'_Male_2024 )
	replace `ss'_Female_2024 = 0 if missing( `ss'_Female_2024 )
	gen `ss'2024 = `ss'_Male_2024 + `ss'_Female_2024
	replace Total_Male_2024 = Total_Male_2024 + `ss'_Male_2024
	replace Total_Female_2024 = Total_Female_2024 + `ss'_Female_2024
	replace Total2024 = Total2024 + `ss'2024
}

** ** Check
** gen Total2 = Albinism2024 + Deaf2024 + Lowhearing2024 + Deafblind2024 + Blind2024 + Lowvision2024 + Physical2024 + Autism2024 + Intellectual2024 + Multiple2024
** compare Total2024 Total2

total Total2024
** Total estimation                  Number of obs   =     20,552

** --------------------------------------------------------------
             ** |      Total   Std. Err.     [95% Conf. Interval]
** -------------+------------------------------------------------
   ** Total2024 |      78106   1684.228      74804.78    81407.22
** --------------------------------------------------------------

gen NStudents2024 = SchoolSizeAsc2024
gen NDisability2024 = Total2024
gen PropDisability2024 = NDisability2024 / NStudents2024
gen PropPhysical2024 = Physical2024 / NStudents2024
gen PropVision2024 = ( Lowvision2024 + Blind2024 ) / NStudents2024
gen PropHearing2024 = ( Lowhearing2024 + Deaf2024 ) / NStudents2024
gen PropIntellectual2024 = ( Intellectual2024 ) / NStudents2024
gen PropAutism2024 = ( Autism2024 ) / NStudents2024
gen PropAlbinism2024 = ( Albinism2024 ) / NStudents2024
gen PropMultiple2024 = ( Deafblind2024 + Multiple2024 ) / NStudents2024

lab var NDisability2024 "Total number of children with disability"
lab var PropDisability2024 "Proportion of children with disability"
lab var PropPhysical2024 "Proportion with physical disability"
lab var PropVision2024 "Proportion with vision disability"
lab var PropHearing2024 "Proportion with hearing disability"
lab var PropIntellectual2024 "Proportion with intellectual disability"
lab var PropAutism2024 "Proportion with autism"
lab var PropAlbinism2024 "Proportion with albinism"
lab var PropMultiple2024 "Proportion with multiple disabilities"

*************************************
** C. SEN inclusion outcomes
*************************************
gen AbsenteeismDropoutrateAsc2024 = TruancyTotal2023 / Dr2023Denom

lab var AbsenteeismDropoutrateAsc2024 "Absenteeism dropout rate"

su AbsenteeismDropoutrateAsc2024, d
su AbsenteeismDropoutrateAsc2024 if School == School2023, d
                  ** Absenteeism dropout rate
** -------------------------------------------------------------
      ** Percentiles      Smallest
 ** 1%            0              0
 ** 5%            0              0
** 10%            0              0       Obs              19,629
** 25%            0              0       Sum of Wgt.      19,629

** 50%            0                      Mean           .0115862
                        ** Largest       Std. Dev.      .0300736
** 75%     .0051282       .4011299
** 90%     .0400891       .4461538       Variance       .0009044
** 95%     .0709091       .4482759       Skewness       4.367345
** 99%     .1441578         .45676       Kurtosis        30.9739


save "${PathDataIntermediate}\Inclusion_Data_Cleaned_All_2024", replace

timer off 1
timer list 1
//  1:     19.49 /        1 =      19.4880
*************************************
** Close workspace
*************************************
** log close
