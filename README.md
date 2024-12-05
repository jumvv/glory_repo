# glory_repo README
My name is Youngkwang Jeon, and I am an aspiring education researcher, currently working at the World Bank Development Impact Evaluation (DIME) in Tanzania.
This document summarizes the codes used in various development projects I have participated in.

1. Embedded Ethics 

This was a randomized trial, investigating the impacts of the embedded-ethics software coding education program with a sample of 200 students in Arusha Girls’ Secondary School in the United Republic of Tanzania. For the purpose of the study, the sample is randomly assigned to two treatment groups – one where students code interactions of virtual “Standard Nash” agents that only take account of the benefit to oneself, and another where they code interactions of virtual “Altruistic-Equitable” agents that are interested in not only one’s own benefit but also others’ – and a control group for which no program activities are taken place. Through such random assignment to the intervention, this study planned to study the impact of the embedded-ethics digital education program on i) students’ social preferences in altruism, equity, and inclusion; ii) psychosocial well-being; and other socioemotional-learning indicators such as STEM interest gender-based attitudes, and digital exposure.

i) RandomizeUniqueIds.do

The code randomizes the student sample into groups of eight combinations  between types of game (2) x role (2) x and frame (acceptance vs. rejection) in each of the two grades (Form 5 and 6)

ii) RunRegressions.do

The code runs regressions for baseline balance and treatment effects on main and auxiliary outcomes.

iii) SummarizeStatistics.do

The code tabulates and produce figures for baseline balance and treatment effects on main and auxiliary outcomes by intervention groups and phases (base-, mid-, and end-line).

2. Shule Bora Project

a. Descriptive Statistics of Monitoring Data

Shule Bora Monitoring and Evaluation (M&E) team quarterly collect data from head teachers and pupils on various topics of programm interests, including safety & inclusion, Teachers' Continuous Professional Development (TCPD), and Parent-Teacher Partnership (PTP). The following codes, producing descriptive statistics of Head Teachers(HT)' data on safety & inclusion and TCPD, helped designing questionnaires for the 2.c. (PSSP Process Evaluation).

i) MergeData.do

Merge Tanzania's annual census data with:
1) Shule Bora Monitoring Data on safety & inclusion for HT
2) Shule Bora Monitoring Data on TCPD for HT

ii) ConstructVariables.do

Construct sub-variables for categorical variables to be tabulated for descriptive statistics.

iii) TabulateDescriptiveStatistics.do

b. Impact Evaluation of SEN intervention

i) MergeData.do

Merge Tanzania's annual census data with: 
1) The Shule Bora programme's budget planning
2) Updated government data:
- Dropouts by grade and sex (2023)
- Primary Enrollment by age and sex (2024)
- Primary Re-enrollment by grade and sex (2024)
- Primary Repeaters by grade and sex (2024)
- Primary Transfers-In and Out, 2023/2024
- Pupils with Disabilities in primary schools (2024)
- Dropouts by reasons (2023)

ii) ConstructBaselineVariables.do

Using available variables from i), construct the following variables to be used for the balance table after randomization:
- Promotion rates (with upper-bound and lower-bound)
- Dropout rates
- Repeat rates
- Reenrollment rates

iii) RandomizeSchools.do

iv) CheckBalance.do
Check balance between treatment and control groups and produce balance table

v) MakeSchoolList.do
Produce a list of schools randomly selected
	

c. Descriptive Statistics of PSSP Process Evaluation

Primary School Safety Program (PSSP) is a holistic 8-component program of the Government of Tanzania, which aims at creating a safe learning environment by building protections against various forms of violence and improving students' life skills. This process evaluation assessed the implementation of the PSSP and identify ways to enhance it for future rollout.

i) ConstructVariables.do

Construct sub-variables for categorical variables for each of the eight modules to   be tabulated for descriptive statistics.
  
ii) TabulateDescriptiveStatistics.do

iii) AggregateTabulateText.do

Aggregate and label all existing text data for further qualitative analysis.


d. Disability Inclusion Data Comparison

This study aimed at understanding: (1) the comparability of disability information gathered from children in Tanzanian schools with data from caregivers across Sub-Saharan Africa; (2) the implications of these findings for estimating the enrollment rate of children with disabilities; and (3) domain-specific disabilities that appear more pronounced in Tanzanian schools compared to other SSA countries. In order to achieve these aims, we merged school-based Shule Bora baseline data on 3,250 students with UNICEF Multiple Indicator Cluster Surveys (MICS) data on 16 sub-Saharan African countries and 51 Low-and-Middle-Income countries (LMICs) and performed distributional comparison tests.

i) ImportMICS.R

Import .sav files and convert into .dta for Questionnaires for Children Age 5-17 MICS 6 surveys for 51 countries.

ii) CleanData.do

Clean (tranlate) and construct variables needed for analyses. Clean another data on population and GDP, drawn from UNESCO.

iii) AppendData.do

Append data for sub-Saharan African (SSA) countries (16) and LMICs (51).

iv) GenerateFinalSample.do

Adjust sampling weights, clusters and strata for MICS data. Define population segments (Tanzania vs. SSA vs. World (LMICS))

v) TabulateTable1.do

Tabulate characteristics of datasets, including survey years, population represented, and mean age.

vi) TabulateTable2.do

Tabulate disability scores, Mann-Whitney Probability Index (PI) and Proportional Odds PI, and disability severity scores across geographic samples, segmented with ages 6 to 13.

vii) ProduceFigure1.do

Produce Kernel density plots comparing distributions in disability scores across geographic samples, segmented with ages 6 to 13.

e. Capacity Building Training

i) Introduction to Data Wrangling in R training scirpt.R

The code script was used for techcnial capacity training in data collection, analysis, and research methods for Agency for the Development of Educational     Management (ADEM), the Ministry of Education, Science and Technology (MoEST) and the President's Office Regional Administration and Local Government (PO-RALG) in Tanzania. 

ii) Introduction to Data Sampling in R training script. R

The code script was used for technical capaity training for the National Examinations Council (NECTA) of Tanzania. The training aimed to strengthen NECTA technical staff's capacity to conduct sampling and data analysis of the biennial 3Rs assessments. The range of topics included basic introduction to R, simple random sampling (SRS), power calculation, stratified/clustered sampling, complemented with conceptual details about implications of each sampling method. 
