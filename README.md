# glory_repo README
My name is Youngkwang Jeon, and I am an aspiring education researcher, currently working at the World Bank Development Impact Evaluation (DIME) in Tanzania.
This document summarizes the codes used in various development projects I have participated in.

1. Embedded Ethics 



2. Shule Bora Project

a. Descriptive Statistics of Monitoring Data

Shule Bora Monitoring and Evaluation (M&E) team quarterly collect data from head teachers and pupils on various topics of programm interests, including safety & inclusion, Teachers' Continuous Professional Development (TCPD), and Parent-Teacher Partnership (PTP). The following codes, producing descriptive statistics of Head Teachers(HT)' data on safety & inclusion and TCPD, helped designing questionnaires for the 2.c. (PSSP Process Evaluation).

2.a.i. MergeData.do

Merge Tanzania's annual census data with:
1) Shule Bora Monitoring Data on safety & inclusion for HT
2) Shule Bora Monitoring Data on TCPD for HT

2.a.ii. ConstructVariables.do

Construct sub-variables for categorical variables to be tabulated for descriptive statistics.

2.a.iii. TabulateDescriptiveStatistics.do

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

i) 2.c.i. ConstructVariables.do

Construct sub-variables for categorical variables for each of the eight modules to   be tabulated for descriptive statistics.
  
ii) 2.c.ii. TabulateDescriptiveStatistics.do

iii) 2.c.iii. AggregateTabulateText.do

Aggregate and label all existing text data for further qualitative analysis.


d. Disability Inclusion Data Comparison



Comparing distributions of child disability scores from surveys in primary schools in Tanzania and in households across sub-Saharan Africa and Low-and-Middle-Income Countries




e. Capacity Building Training

i) Introduction to Data Wrangling in R training scirpt.R

The code script was used for techcnial capacity training in data collection, analysis, and research methods for Agency for the Development of Educational     Management (ADEM), the Ministry of Education, Science and Technology (MoEST) and the President's Office Regional Administration and Local Government (PO-     RALG) in Tanzania. 

ii) Introduction to Data Sampling in R training script. R

The code script was used for technical capaity training for the National Examinations Council (NECTA) of Tanzania. The training aimed to strengthen NECTA     technical staff's capacity to conduct sampling and data analysis of the biennial 3Rs assessments. The range of topics included basic introduction to R,       simple random sampling (SRS), power calculation, stratified/clustered sampling, complemented with conceptual details about implications of each sampling      method. 
  