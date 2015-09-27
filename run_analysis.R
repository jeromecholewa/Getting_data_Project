# This script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "HAR.zip", method = "libcurl")
#download.file("http://www.newcl.org/data/zipfiles/a1.zip",temp)
# I had put all the 10 data files relevant to me
# in a directory called "dataset"
#"activity_labels.txt" "features_info.txt"   "features.txt"
# "README.txt" "subject_test.txt" "subject_train.txt"
# "X_test.txt" "X_train.txt" "y_test.txt" "y_train.txt"
setwd("dataset")

download_date  <- date()  #"Mon Sep 21 04:20:03 2015" (KST)
library(data.table)

########## reading in the activity labels
activity_labels <- data.table(read.csv("activity_labels.txt", sep = " ", header = FALSE, col.names = c("lab_act", "activity")))

###############################
# The next part merges the subject and y tables together for each train and test files
# reading in the "subject" and "y" files
subject_test <- data.table(readLines("subject_test.txt"))
subject_train <- data.table(readLines("subject_train.txt"))
y_test <- data.table(readLines("y_test.txt"))
y_train <- data.table(readLines("y_train.txt"))

# renaming the names of variables
subject_test <- subject_test %>% rename(subject = V1 )
subject_train <- subject_train %>% rename(subject = V1 )

# merge 2 tables of same length and add a category column
subject_test_y  <- subject_test
subject_test_y$lab_act  <- y_test[,V1]
subject_test_y$category  <- "test"

# doing the same for the "train"
subject_train_y  <- subject_train
subject_train_y$lab_act  <- y_train[,V1]
subject_train_y$category  <- "train"

#declaring these 3 columns as factors
cols  <- c("subject","lab_act", "category")
subject_test_y <- subject_test_y[,(cols):=lapply(.SD, as.factor),
                                 .SDcols=cols]
subject_train_y <- subject_train_y[,(cols):=lapply(.SD, as.factor),
                                   .SDcols=cols]

# putting these 2 tables together
# this table shows which subjects did which category (test or train)
subj_label_category <- rbindlist(list(subject_test_y, subject_train_y), use.names = TRUE)
# create a column with activity. At first "WALKING" is everywhere
subj_label_category$activity <- "WALKING"
# replace one by one as a lookup table
subj_label_category$activity[subj_label_category$lab_act == 2] <- "WALKING_UPSTAIRS"
subj_label_category$activity[subj_label_category$lab_act == 3] <- "WALKING_DOWNSTAIRS"
subj_label_category$activity[subj_label_category$lab_act == 4] <- "SITTING"
subj_label_category$activity[subj_label_category$lab_act == 5] <- "STANDING"
subj_label_category$activity[subj_label_category$lab_act == 6] <- "LAYING"
library(dplyr)
subj_label_category <- subj_label_category %>% select(subject, category, activity)
###########################################

############################
## cleaning the X_train data
X_train_messy <- readLines("X_train.txt")
# almost all lines start with doubles spaces
# except some lines starting with " -"
# so on those lines, we first add one space, so ALL lines start with double spaces
X_train_messy2 <- sub(" -", "  -", X_train_messy)
# then we remove all starting double spaces
X_train_messy3  <- sub("  ", "", X_train_messy2)
# then we replace all other double spaces by single spaces
X_train_1space  <- gsub("  ", " ", X_train_messy3)
X_train_1space_DT  <- data.table(X_train_1space)
X_train_clean  <- data.table(X_train_1space_DT) %>% separate(X_train_1space, sep = " ", into = paste("X", sep="", 1:561))

# all 561 columns are characters
# converting into numeric
X_train_clean[,(names(X_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(X_train_clean)]
###############################

############################
## cleaning the X_test data
X_test_messy <- readLines("X_test.txt")
X_test_messy2  <- sub(" -", "  -", X_test_messy)
X_test_messy3  <- sub("  ", "", X_test_messy2)
X_test_1space  <- gsub("  ", " ", X_test_messy3)

X_test_1space_DT  <- data.table(X_test_1space)
X_test_clean  <- data.table(X_test_1space_DT) %>% separate(X_test_1space, sep = " ", into = paste("X", sep="", 1:561))

# all 561 columns are characters
# converting into numeric
X_test_clean[,(names(X_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(X_test_clean)]
###############################

## putting the 2 X sets on top of each other (test is above, train is below)
X_all <- rbindlist(list(X_test_clean, X_train_clean), use.names = TRUE)

# library(stringr)
# str_count(body_acc_x_test_1space[1], " ")

########## reading in the feature.txt file to have the correct labels
features <- data.table(read.table("features.txt", sep = " ", header = FALSE, col.names = c("index", "features"), as.is = 2))

library(dplyr)
features <- select(features, features)

# remove all parentheses
features$features <- gsub("(", "", fixed = TRUE, features$features)
features$features <- gsub(")", "", fixed = TRUE, features$features)
# replace "-" dash symbol and "," commas by underscore _
features$features <- gsub("-", "_", fixed = TRUE, features$features)
features$features <- gsub(",", "_", fixed = TRUE, features$features)


###  NOT RUN  YET
####### rbind all the "_all" data.tables with the subj_label_category table
clean_data <- cbind(subj_label_category, X_all)
