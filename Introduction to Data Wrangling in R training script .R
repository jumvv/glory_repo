# =========================================================================== #
# ADEM Research Capacity Building Training
# Code Script for R lab sessions
# Date: August 15, 2024
# =========================================================================== #
rm( list = ls() ) # Clear working memory.

# =========================================================================== #
# Exercise 1: Writing Code in the console
# =========================================================================== #
print("Mambo")

#Practice options:
print("Shwari")
print("Watoto wote wana haki ya elimu bora")

# =========================================================================== #
# Exercise 2: Creating objects in R
# =========================================================================== #
x1 <- 50
x2 <- 15
x3 <- x1 + x2
print(x3)

#Practice options:
x1 <- 100
x2 <- 2
x3 <- x1 / x2
print(x3)

# =========================================================================== #
# Exercise 3: Loading & Viewing Data (ht_survey_data) in R (with package 
#             installation) and merge two connected sheets* 
# =========================================================================== #
install.packages('readxl')
library(readxl)
library(dplyr)
data <- read_excel('C:/Users/My PC/Downloads/ht_survey_data.xlsx', sheet = "Head Teacher Survey - Advanced")
sheet1 <- read_excel('C:/Users/My PC/Downloads/ht_survey_data.xlsx', sheet = "Head Teacher Survey - Advanced")
sheet2 <- read_excel('C:/Users/My PC/Downloads/ht_survey_data.xlsx', sheet = "cols_rep")

names(sheet1)[names(sheet1) == "_index"] <- "index"

sheet1$index_link <- sheet1$index

names(sheet2)[names(sheet2) == "_parent_index"]<- "parent_index"

tidy_sheet2 <- sheet2 %>%
  group_by(parent_index) %>%
  summarise(
    b3 = paste(unique(b3), collapse = "; "),
    b4 = paste(unique(b4), collapse = "; "),
    mem1_lab = paste(unique(mem1_lab), collapse = "; "),
    mem2_lab = paste(unique(mem2_lab), collapse = "; "),
    mem3_lab = paste(unique(mem3_lab), collapse = "; "),
    mem4_lab = paste(unique(mem4_lab), collapse = "; "),
    mem5_lab = paste(unique(mem5_lab), collapse = "; "),
    mem1 = paste(unique(mem1), collapse = "; "),
    mem2 = paste(unique(mem2), collapse = "; "),
    mem3 = paste(unique(mem3), collapse = "; "),
    mem4 = paste(unique(mem4), collapse = "; "),
    mem5 = paste(unique(mem5), collapse = "; "),
    total_mem = paste(unique(mem_num), collapse = "; "),
    b5_1 = paste(unique(b5_1), collapse = "; "),
    b5_2 = paste(unique(b5_2), collapse = "; "),
    b5_3 = paste(unique(b5_3), collapse = "; "),
    b6 = paste(unique(b6), collapse = "; "),
    b7 = paste(unique(b7), collapse = "; "),
    b8 = paste(unique(b8), collapse = "; "),
    b5_1 = paste(unique(b5_1), collapse = "; "),
  )

tidy_sheet2$index_link <- tidy_sheet2$parent_index
data <- left_join(sheet1, tidy_sheet2, by = "index_link")

View(data) # 49 observations and 66 variables

#Practice options:
data <- read_excel('..../ht_survey_data.xlsx')
View(data)

# =========================================================================== #
# Exercise 4: Rename variables 
# =========================================================================== #
names(data) # Many variables need to be renamed for clearer communication
install.packages('dplyr')
library(dplyr) # we need tidyverse for easier renaming

# Rename one variable
data <- data %>%
  rename(region = a1)

# Rename several variables
data <- data %>%
  rename(district = a2, ward = a3, school = a4, first_name = a5, last_name = a5_1)

#Practice options:
data <- data %>%
  rename(district = a2)

data<- data %>%
  rename(region = a1, ward = a3, school = a4)

# =========================================================================== #
# Exercise 4: Order variables (Relocating the order of var columns)
# =========================================================================== #
data <- data %>%
  relocate(region, district, ward, school)

#Practice options: Try the same code

# =========================================================================== #
# Exercise 5: label variables & values
# =========================================================================== #
#Label variables
attr(data$a9, "label") <- "Number of students"
sapply(data, function(x) attr(x, "label")) #check the label

#Label values
#install.packages("haven")
library(haven)

data$a8 <- as.numeric(data$a8)
data$a8 <- labelled(data$a8,
               labels = c("Yes" = 1, "No" = 0))
print(data$a8)

#Practice options:

attr(data$a10, "label") <- "Number of teachers"
sapply(data, function(x) attr(x, "label"))

#Try out the same code for labeling values.

# =========================================================================== #
# Exercise 6: Remove variables using subseting
# =========================================================================== #
data = subset(data, select = -c(today, username))
# or create list of values with which to drop variables

drop <- c("deviceid")
data = data[,!(names(data) %in% drop)]
#Practice options: Try the same code

# =========================================================================== #
# Exercise 7: Subset variables for exploration
# =========================================================================== #
table(data$district) #There are two districts from which data was collected.
#Subset the dataset for district 1
data_district1 <- subset(data, district == 1)
table(data_district1$district) #39 observations
#Practice options: Try the same code or subset district2

# =========================================================================== #
# Exercise 8: Save dataframe in csv (R code needs to be saved manually.)
# =========================================================================== #
write.csv(data, file = "C:/Users/My PC/Downloads/ht_survey_data.csv", row.names = FALSE)

# =========================================================================== #
# Composite Exercise before break
# =========================================================================== #
#Load data and pacakges ('readxl' 'dplyr' 'haven')
data <- read_excel('C:/Users/My PC/Downloads/ht_survey_data.xlsx', sheet = "Head Teacher Survey - Advanced")
library(readxl)
library(dplyr)
library(haven)
#rename a1, a2, a3, and a4 to region, district, ward, and school, respectively 
data <- data %>%
  rename(region = a1, district = a2, ward = a3, school = a4)
#label a9 and a10 as "Number of students" and "Number of teachers"
attr(data$a9, "label") <- "Number of students"
attr(data$a10, "label") <- "Number of teachers"
#label a7 as "Received training from ADEM on HT CoL" and label values 1 and 0 to
# "Yes" and "No" and print the labelled values
attr(data$a7, "label") <- "Received training from ADEM on HT CoL"
data$a7 <- as.numeric(data$a7)
data$a7 <- labelled(data$a7,
                    labels = c("Yes" = 1, "No" = 0))
print(data$a7)
# Remove variables of today, username, and a7_stop
data = subset(data, select = -c(today, username, a7_stop))

#Create another dataframe that subsets district1.
data_district1 <- subset(data, district == 1)

#Save dataframe in csv format
write.csv(data, file = "C:/Users/My PC/Downloads/ht_survey_data.csv", row.names = FALSE)

# =========================================================================== #
# BREAK. ----------
# =========================================================================== #
# Import the saved csv file
rm( list = ls() ) # Clear working memory.
data <- read.csv("C:/Users/My PC/Downloads/ht_survey_data.csv")

# =========================================================================== #
# Exercise 9: Summary statistics (to understand the code structure, summary of
#             numeric variables)
# =========================================================================== #
#Summarize all variables
summary_table <- summary(data)
print(summary_table)
#Summarize all variables

# =========================================================================== #
# Exercise 10: Check unique observations and drop duplicates
# =========================================================================== #
#Find duplicates using particular columns
duplicates <- data[duplicated(data[c("first_name", "last_name")]) | duplicated(data[c("first_name", "last_name")], fromLast = TRUE), ]
duplicates$ward <- as.numeric(duplicates$ward)
duplicates <- duplicates[order(-duplicates$ward), ]
View(duplicates)
# School 33 are exactly same, while School 2 is almost similar.
#id 371644723 371649913 to drop

names(data)[names(data) == "X_id"] <- "id"
data$id <- as.numeric(data$id)

ids_drop <- c(371644723, 371649913)
data_filtered <- data[!data$id %in% ids_drop, ]

# =========================================================================== #
# Exercise 11: Find anomalies
# =========================================================================== #
library(dplyr)
# For characters (i.e. name)
lengths <- nchar(data_filtered$first_name)
short_names <- data_filtered$first_name[lengths < 4]
print(short_names) # Found YJK and DJJ.

# For numeric outliers for # of students, teachers, CoL membership
data_filtered <- data_filtered %>%
  rename(pupil_num = a9, teacher_num = a10, col_num = b2_calc)

# select three variables
data_summarize <- data_filtered[, c("pupil_num", "teacher_num", "col_num")]
summary(data_summarize) # You can find outlying minimum and maximum of these 
#                         selected variables

# =========================================================================== #
# Exercise 12: Find enumerators with outlying data record
# =========================================================================== #
# Identify outlying number of students
outlier <- data_filtered$pupil_num < 30 | data_filtered$pupil_num > 2000
# Extract enumerators who recorded these outliers
enum_with_outliers <- data_filtered$enuname[outlier]
#Get unique enumerators
unique_enum_with_outliers <- unique(enum_with_outliers)
print(unique_enum_with_outliers)

# =========================================================================== #
# Exercise 13: Flag rows with outlying numbers and count the outlying observations
# =========================================================================== #
data_filtered$outlier_flag <- ifelse(data_filtered$pupil_num < 30 | data_filtered$pupil_num > 2000 | data_filtered$teacher_num < 2 | data_filtered$teacher_num > 20, TRUE, FALSE)
count_flag <- sum(data_filtered$outlier_flag)
print(count_flag) #16 observations with outlying numbers of pupils and teachers.

# =========================================================================== #
# Exercise 14: Construct variables
# =========================================================================== #
# Construct numberic variables (Pupil-to-Teacher Ratio)
data <- data %>%
  rename(pupil_num = a9, teacher_num = a10, col_num = b2_calc)
data$PTR <- data$pupil_num / data$teacher_num
summary(data$PTR) #Distorted because of outliers

data_without_outliers <- data_filtered %>%
  filter(outlier_flag == FALSE)

data_without_outliers$PTR <- data_without_outliers$pupil_num / data_without_outliers$teacher_num
summary(data_without_outliers$PTR) # 88.18

#Construct binary categorical variable

attr(data_without_outliers$b10, "label") <- "Challenges in CoLs"
attr(data_without_outliers$b10.1, "label") <- "Resources shared are incorrect/of poor quality"
attr(data_without_outliers$b10.2, "label") <- "Problems with internet/cellular/communication"
attr(data_without_outliers$b10.3, "label") <- "Lack of engagement from others"
attr(data_without_outliers$b10.4, "label") <- "Lack of prompt responses from members"
attr(data_without_outliers$b10.5, "label") <- "No motivation for frequent engagement"
attr(data_without_outliers$b10.0, "label") <- "None"
attr(data_without_outliers$b10..96, "label") <- "Other, specify"
sapply(data_without_outliers, function(x) attr(x, "label")) #check the label

#Label values
#install.packages("haven")
library(haven)
variables_to_label <- c("b10",
                        "b10.1", 
                        "b10.2", 
                        "b10.3", 
                        "b10.4",
                        "b10.5",
                        "b10.0",
                        "b10..96"
                       )

# Set value labels for each variable
data_without_outliers[variables_to_label] <- lapply(data_without_outliers[variables_to_label], function(x) {
  labelled(as.numeric(x), labels = c("Yes" = 1, "No" = 0))
})
val_labels(data_without_outliers[variables_to_label])

#Now we can summarize the question about any challenges in CoLs. 
summary(data_without_outliers[variables_to_label])

# =========================================================================== #
# Exercise 15: Visualize Data
# =========================================================================== #
#Histogram to give frequency
hist(data_filtered$b10.1,
     main = "Histogram of Challenge in Shared Resources",
     xlab = "Values",
     ylab = "Frequency",
     col = "lightblue",
     border = "black",
     breaks = c(-0.5, 0.5, 1.5))

#Use of ggplot2 package

library(ggplot2)
data_filtered$pupil_num <- as.numeric(data_filtered$pupil_num)

#Histogram

ggplot(data_filtered, aes(x = pupil_num)) +
  geom_histogram(binwidth = 5, fill = "lightblue", color = "black") +
  ggtitle("Histogram of Number of Students") +
  xlab("Number of Students") +
  ylab("Frequency")

#Box plot
ggplot(data, aes(y = pupil_num)) +
  geom_boxplot(outlier.size = 2, outlier.colour = "red") +
  ggtitle("Box Plot of Number of Students") +
  ylab("Number of Students")

#Box plot with coordinate restriction
ggplot(data, aes(y = pupil_num)) +
  geom_boxplot(outlier.size = 2, outlier.colour = "red") +  # Customize outliers
  coord_cartesian(ylim = c(100, 3000)) +
  ggtitle("Box Plot of Number of Students") +
  ylab("Number of Students")

#Violin plot with coordinate restriction
ggplot(data_filtered, aes(x = factor(1), y = a9)) +
  geom_violin(fill = "lightblue", color = "black") +
  coord_cartesian(ylim = c(100, 5000)) +
  ggtitle("Violin Plot of Number of Students by Group") +
  xlab("Group") +
  ylab("Number of Students")

#Regraph without outliers

data_without_outliers <- data_filtered %>%
  filter(outlier_flag == FALSE)

ggplot(data_without_outliers, aes(x = pupil_num)) +
  geom_histogram(binwidth = 5, fill = "lightblue", color = "black") +
  ggtitle("Histogram of Number of Students") +
  xlab("Number of Students") +
  ylab("Frequency")

ggplot(data_without_outliers, aes(x = pupil_num)) +
  geom_histogram(aes(y = ..density..), binwidth = 5, fill = "lightblue", color = "black") +
  geom_density(color = "red") +
  ggtitle("Histogram with Density Overlay") +
  xlab("Number of Students") +
  ylab("Density")

# =========================================================================== #
# Exercise 16: Generate and Export descriptive statistics
# =========================================================================== #
install.packages("writexl")
library(writexl)
data_summarize <- data_without_outliers[, c("pupil_num",
                                            "teacher_num", 
                                            "col_num",
                                            "b10.1", 
                                            "b10.2",
                                            "b10.3",
                                            "b10.4",
                                            "b10.5",
                                            "b10.0",
                                            "b10..96")]
summary_num_stats <- summary(data_summarize)

N <- sapply(data_summarize, function(x) sum(!is.na(x)))

# Convert the summary statistics and number of observations to a data frame for easy manipulation
results <- as.data.frame(summary_num_stats)
print(summary_num_stats)

results <- as.data.frame(summary_num_stats)


install.packages("tidyr")
library(tidyr)

result_wide <- results %>%
  filter(!is.na(Var2)) %>%  # Remove rows with NA in Var2
  mutate(Measure = gsub("[:].*", "", Freq),  # Extract measure type
         Value = gsub(".*[:]", "", Freq)) %>%  # Extract value part
  select(-c(Freq, Var1)) %>%
  pivot_wider(
    names_from = Measure,
    values_from = Value)

print(result_wide)
result_wide <- cbind(result_wide, Total_Observations = N)
result_wide <- result_wide[, !names(result_wide) %in% "NA"]

second_to_last_index <- ncol(result_wide) - 1

# Remove the second-to-last column
result_wide_clean <- result_wide[, -second_to_last_index]

print(result_wide_clean)

# Write the summary data frame to an Excel file
write_xlsx(result_wide_clean, path = "C:/Users/My PC/Downloads/descriptive_statistics.xlsx")

# =========================================================================== #
# End of code
# =========================================================================== #