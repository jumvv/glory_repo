# 3R Sampling Options_012824
# Produced by NECTA and DIME
# This code produces the sample of schools for Tanzania's 2023/24 3Rs assessment.
# Two options were considered to be consistent with previous 3Rs sampling approaches, where previously only sudents in schools with between 25 and 150 Std 2 students were sampled. Since approximately 40% of students come from schools with > 150 Std 2 students in the school, and around 1.3% come from schools with < 25 we consider 2 options here. The first is to exclude all schools with Std 2 class sizes below 25 since the cost of going to these schools is large relative the sample that can be collected, and it is likely to only have a small effect on representivity given the small proportion of schools in this group. The second is to exclude all below 25 and above 150. This is what was done in the previous 3Rs, and is to be consistent with that approach. 20 schools are selected from each region except for Tanga, where 24 were allocated. Within regions, schools were split equally across councils, essentially stratifying by council, since there is a requirement that all councils are included in the sample. If there are an odd number of schools remaining for allocation, they are applied to the largest councils, one-by-one, in order of size. The schools are then selected randomly. For practical reasons, if school sizes exceed 150 std 2 students, a maximum of 150 will be randomly selected. Ex post weighting applying the inverse of probability of student selection will be applied ex post in the analysis.  
# =========================================================================== #
# Set up local workspace.
# =========================================================================== #
rm( list = ls() ) # Clear working memory.
# =========================================================================== #
# Load pacakges. # install the following packages if not installed.
# install.packages(c ("readxl", "writexl", dplyr")) 
# =========================================================================== #
library(dplyr)
library(readxl)
library(writexl)

# Load original sampling frame (Change files_path below accordingly.)
file_path <- "C:/Users/My PC/Downloads/All government schools -2023.xlsx"
data <- read_excel(file_path, sheet = "CLASS II SCHOOLS IN 2023")

# =========================================================================== #
# Option 1. Stratified random sampling, excluding only small-sized schools with 
#           Enrollment under 25 (N = 524)
# =========================================================================== #

# Subset the original dataframe by excluding schools with Enrolment below 25 
data_option_1 <- data[data$Enrolment > 24, ] # Sampling frame = 15,939.

# Set seed for random sampling 
# (random.org, generated between 1 and 100,000) 
set.seed(34201)

# Order the original sampling frame by SchoolNumber for further accurate replication
data_option_1 <- data_option_1 %>%
  arrange(SchoolNumber)

# Randomly sample 20 schools from each region, equally distributed across councils
# When not divisible by 20, add one sample each to the largest councils in order.
# Draw 24 schools for Tanga (11 councils)

# Function to perform stratified sampling with variable sample size
simple_stratified_sampling <- function(data_option_1, regions, councils, schools_per_stratum) {
  data_subset <- subset(data_option_1, Region %in% regions)
  
  stratified_sample <- data_subset %>%
    group_by(Council) %>%
    group_modify(~ slice_sample(.x, n = schools_per_stratum), replace = FALSE)
  
  return(stratified_sample)
}

stratified_sampling <- function(data_option_1, regions, councils, schools_per_stratum, sample_added) {
  data_subset <- subset(data_option_1, Region %in% regions)
  
  stratified_sample <- data_subset %>%
    group_by(Council) %>%
    group_modify(~ slice_sample(.x, n = schools_per_stratum), replace = FALSE)
  
  top_districts <- stratified_sample %>%
    group_by(Region, Council) %>%
    summarise(council_size = sum(Enrolment)) %>%
    arrange(Region, desc(council_size)) %>%
    slice_head(n = sample_added) %>%
    pull(Council)
  
  remaining_schools <- data_subset %>%
    filter(Region %in% unique(stratified_sample$Region), Council %in% top_districts) %>%
    anti_join(stratified_sample, by = c("Region", "Council", "SchoolName"))
  
  addition <- remaining_schools %>%
    group_by(Region, Council) %>%
    sample_n(size = 1, replace = TRUE) %>%
    ungroup()
  
  stratified_sample <- bind_rows(stratified_sample, addition)
  
  return(stratified_sample)
}

# Define the regions, councils, schools_per_stratum, and sample_size for each configuration
configurations_simple <- list(
  list(regions = c("RUKWA"), councils = 4, schools_per_stratum = 5, sample_added = 0),
  list(regions = c("DAR ES SALAAM", "IRINGA", "KATAVI", "SONGWE"), councils = 5, schools_per_stratum = 4, sample_added = 0)
)

configurations <- list(
  list(regions = c("NJOMBE", "SHINYANGA", "SIMIYU", "LINDI", "GEITA"), councils = 6, schools_per_stratum = 3, sample_added = 2),
  list(regions = c("ARUSHA", "KILIMANJARO", "MANYARA", "MBEYA", "SINGIDA"), councils = 7, schools_per_stratum = 2, sample_added = 6),
  list(regions = c("DODOMA", "KAGERA", "KIGOMA", "MWANZA", "RUVUMA", "TABORA"), councils = 8, schools_per_stratum = 2, sample_added = 4),
  list(regions = c("MARA", "MOROGORO", "MTWARA", "PWANI"), councils = 9, schools_per_stratum = 2, sample_added = 2),
  list(regions = c("TANGA"), councils = 11, schools_per_stratum = 2, sample_added = 2)
)

# Initialize an empty list to store the samples
stratified_samples_list_simple <- list()
stratified_samples_list <- list()

# Loop over configurations and perform stratified sampling with variable sample size
for (config1 in configurations_simple) {
  stratified_sample_simple <- simple_stratified_sampling(data_option_1, config1$regions, config1$councils, config1$schools_per_stratum)
  stratified_samples_list_simple[[length(stratified_samples_list_simple) + 1]] <- stratified_sample_simple
}

for (config2 in configurations) {
  stratified_sample <- stratified_sampling(data_option_1, config2$regions, config2$councils, config2$schools_per_stratum, config2$sample_added)
  stratified_samples_list[[length(stratified_samples_list) + 1]] <- stratified_sample
}

# Combine all samples into a final data frame
stratified_sample_final <- bind_rows(stratified_samples_list, stratified_samples_list_simple)

# Perform additional steps as in the original code
stratified_sample_final$students_sampled <- stratified_sample_final$Enrolment
stratified_sample_final$students_sampled[stratified_sample_final$students_sampled > 200] <- 200

summary(stratified_sample_final$students_sampled)

#   Min.  1st Qu.  Median  Mean   3rd Qu.  Max. 
#  25.00   54.75   84.00  102.86  140.25  200.00  

print(nrow(stratified_sample_final)) # Final random stratified sample: 524
n_distinct(stratified_sample_final$Region) # 26 Regions in the final sample
n_distinct(stratified_sample_final$Council) # 184 Councils in the final sample

# Save the stratified random sample data
write_xlsx(stratified_sample_final, path = "C:/Users/My PC/Downloads/Final Sample Option 1.xlsx")

# =========================================================================== #
# Option 2. Stratified random sampling, excluding small-sized schools with 
#           Enrollment under 25 and large-sized schools above 150 (N = 524)
# =========================================================================== #

# Subset the original dataframe by excluding schools with Enrolment below 25
data_option_2 <- data[data$Enrolment > 24 & data$Enrolment < 151, ] # Sampling frame = 12,837 to 12,996

# Set seed for random sampling 
# (random.org, generated between 1 and 100,000) 
set.seed(34201)

# Order the original sampling frame by SchoolNumber for further accurate replication
data_option_2 <- data_option_2 %>%
  arrange(SchoolNumber)

# Randomly sample 20 schools from each region, equally distributed across councils
# When not divisible by 20, add one sample each to the largest councils in order.
# Draw 24 schools for Tanga (11 councils)

# Function to perform stratified sampling with variable sample size
simple_stratified_sampling <- function(data_option_2, regions, councils, schools_per_stratum) {
  data_subset <- subset(data_option_2, Region %in% regions)
  
  stratified_sample <- data_subset %>%
    group_by(Council) %>%
    group_modify(~ slice_sample(.x, n = schools_per_stratum), replace = FALSE)
  
  return(stratified_sample)
}

stratified_sampling <- function(data_option_2, regions, councils, schools_per_stratum, sample_added) {
  data_subset <- subset(data_option_2, Region %in% regions)
  
  stratified_sample <- data_subset %>%
    group_by(Council) %>%
    group_modify(~ slice_sample(.x, n = schools_per_stratum), replace = FALSE)
  
  top_districts <- stratified_sample %>%
    group_by(Region, Council) %>%
    summarise(council_size = sum(Enrolment)) %>%
    arrange(Region, desc(council_size)) %>%
    slice_head(n = sample_added) %>%
    pull(Council)
  
  remaining_schools <- data_subset %>%
    filter(Region %in% unique(stratified_sample$Region), Council %in% top_districts) %>%
    anti_join(stratified_sample, by = c("Region", "Council", "SchoolName"))
  
  addition <- remaining_schools %>%
    group_by(Region, Council) %>%
    sample_n(size = 1, replace = TRUE) %>%
    ungroup()
  
  stratified_sample <- bind_rows(stratified_sample, addition)
  
  return(stratified_sample)
}

# Define the regions, councils, schools_per_stratum, and sample_size for each configuration
configurations_simple <- list(
  list(regions = c("RUKWA"), councils = 4, schools_per_stratum = 5, sample_added = 0),
  list(regions = c("DAR ES SALAAM", "IRINGA", "KATAVI", "SONGWE"), councils = 5, schools_per_stratum = 4, sample_added = 0)
)

configurations <- list(
  list(regions = c("NJOMBE", "SHINYANGA", "SIMIYU", "LINDI", "GEITA"), councils = 6, schools_per_stratum = 3, sample_added = 2),
  list(regions = c("ARUSHA", "KILIMANJARO", "MANYARA", "MBEYA", "SINGIDA"), councils = 7, schools_per_stratum = 2, sample_added = 6),
  list(regions = c("DODOMA", "KAGERA", "KIGOMA", "MWANZA", "RUVUMA", "TABORA"), councils = 8, schools_per_stratum = 2, sample_added = 4),
  list(regions = c("MARA", "MOROGORO", "MTWARA", "PWANI"), councils = 9, schools_per_stratum = 2, sample_added = 2),
  list(regions = c("TANGA"), councils = 11, schools_per_stratum = 2, sample_added = 2)
)

# Initialize an empty list to store the samples
stratified_samples_list_simple <- list()
stratified_samples_list <- list()

# Loop over configurations and perform stratified sampling with variable sample size
for (config1 in configurations_simple) {
  stratified_sample_simple <- simple_stratified_sampling(data_option_2, config1$regions, config1$councils, config1$schools_per_stratum)
  stratified_samples_list_simple[[length(stratified_samples_list_simple) + 1]] <- stratified_sample_simple
}

for (config2 in configurations) {
  stratified_sample <- stratified_sampling(data_option_2, config2$regions, config2$councils, config2$schools_per_stratum, config2$sample_added)
  stratified_samples_list[[length(stratified_samples_list) + 1]] <- stratified_sample
}

# Combine all samples into a final data frame
stratified_sample_final <- bind_rows(stratified_samples_list, stratified_samples_list_simple)

# Perform additional steps as in the original code
stratified_sample_final$students_sampled <- stratified_sample_final$Enrolment
stratified_sample_final$students_sampled[stratified_sample_final$students_sampled > 150] <- 200

summary(stratified_sample_final$students_sampled)

#  Min.  1st Qu.  Median  Mean   3rd Qu.  Max. 
# 25.00   53.00   78.50   80.37  107.00  150.00 

print(nrow(stratified_sample_final)) # Final random stratified sample: 524
n_distinct(stratified_sample_final$Region) # 26 Regions in the final sample
n_distinct(stratified_sample_final$Council) # 184 Councils in the final sample

# Save the stratified random sample data
write_xlsx(stratified_sample_final, path = "C:/Users/My PC/Downloads/Final Sample Option 2.xlsx")

# =========================================================================== #
# Sample Code: How to select all students from schools with Enrolment
# under 150 and randomly select 200 students from schools with Enrolment above 150
# (This code needs student-level data.)
# =========================================================================== #

# Load subset data (Change files_path below accordingly.)
file_path_subset <- "C:/Users/My PC/Downloads/SCHOOLS WITH MORE THAN 150 PUPILS-3Rs 2023.xlsx"
data_subset <- read_excel(file_path_subset, sheet = "SCHOOLS MORE THAN 150 PUPILS")

# Set seed for random sampling 
# (random.org, generated between 1 and 100,000) 
set.seed(34201)

# Order the original sampling frame by CentreNumber for further accurate replication
data_subset <- data_subset %>%
  arrange(CentreNumber)

# Assign random numbers
data_subset$rn <- rnorm(nrow(data_subset), mean = 0, sd = 1)

# Order random numbers by CentreNumber
data_subset <- data_subset %>%
  arrange(CentreNumber, Region, rn)

# Create a SchoolCount variable
data_subset <- data_subset %>%
  group_by(CentreNumber, Region) %>%
  mutate(SchoolCount = row_number())

#First 150 = Primary Sample / >150 = Back-up
data_subset <- data_subset %>%
  group_by(CentreNumber, Region) %>%
  mutate(SamplingGroup = ifelse(SchoolCount <= 150, "Primary Sample", "Back-up"))

#Drop Back-up students after 200
data_subset <- data_subset %>%
  group_by(CentreNumber, Region) %>%
  slice(1:200)

# Check if the code sampled maximum 200 students from the schools
school_summary <- data_subset %>%
  group_by(CentreNumber) %>%
  summarise(
    total_students = n(),
  )

summary(school_summary$total_students)
#   Min.  1st Qu.  Median   Mean  3rd Qu.   Max. 
#  151.0   167.8   199.5   185.2   200.0   200.0

# Drop SchoolCount and rn, if needed

data_subset <- data_subset %>%
  select(-SchoolCount, -rn)

# Save the student data sampled from schools with Enrolment above 150 (Change the path accordingly).
write_xlsx(data_subset, path = "C:/Users/My PC/Downloads/Student Sample from Schools above 150.xlsx")

# Check data quality
View(stratified_sample_final)
stratified_sample_final <- stratified_sample_final[stratified_sample_final$Enrolment > 150, ] 

data_subset_sum <- data_subset %>%
  group_by(CentreNumber) %>%
  summarize(Enrolment = n())

data_subset_sum[data_subset_sum$CentreNumber]
colnames(data_subset_sum)[colnames(data_subset_sum) == "CentreNumber"] <- "SchoolNumber"
colnames(data_subset_sum)[colnames(data_subset_sum) == "Enrolment"] <- "Enrolment2"

merged <- merge(stratified_sample_final, data_subset_sum, by = "SchoolNumber", all = TRUE)

all(merged$Enrolment == merged$Enrolment2)
#TRUE

# =========================================================================== #
# Supplementary Option. Random stratified sampling of additional 2 schools 
#                       for each council for replacement
# =========================================================================== #

# Set seed for random sampling, used for the original frame
set.seed(34201)

# Extract the SchoolNumber that were already sampled
sampled_schools <- stratified_sample_final$SchoolNumber

# Filter out the sampled schools from the original dataset
data_option_1_unsampled <- data_option_1[!(data_option_1$SchoolNumber %in% sampled_schools), ]

# Perform another round of sampling (2 schools for each council)
additional_sample <- data_option_1_unsampled %>%
  group_by(Council) %>%
  group_modify(~ slice_sample(.x, n = 2), replace = FALSE)

summary(additional_sample$SchoolNumber) #368 (2 schools per 184 Councils)

# Perform additional steps as in the original code
additional_sample$students_sampled <- additional_sample$Enrolment
additional_sample$students_sampled[additional_sample$students_sampled > 200] <- 200

summary(additional_sample$students_sampled)
# Min.   1st Qu.  Median  Mean   3rd Qu.   Max. 
# 25.0    56.0    89.5   101.0   135.2    200.0

#Double check if there is any school matching between the original and additional samples
common_schools <- intersect(stratified_sample_final$SchoolNumber, additional_sample$SchoolNumber)
print(common_schools) # character(0): No schools overlapping

# Save the additional sampling data for potential replacement (Change the path accordingly).
write_xlsx(additional_sample, path = "C:/Users/My PC/Downloads/Additional school sample for replacement.xlsx")

#####################################
## Close workspace
#####################################