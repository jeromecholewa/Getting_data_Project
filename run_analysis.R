# This script does the following:
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "HAR.zip", method = "libcurl")
#download.file("http://www.newcl.org/data/zipfiles/a1.zip",temp)

download_date  <- date()  #"Mon Sep 21 04:20:03 2015" (KST)
library(data.table)
setwd("dataset") # where I had put all the data files

# reading in all the files
subject_test <- data.table(readLines("subject_test.txt"))
subject_train <- data.table(readLines("subject_train.txt"))
y_test <- data.table(readLines("y_test.txt"))
y_train <- data.table(readLines("y_train.txt"))
X_test <- data.table(read.csv("X_test.txt", sep = " ", header = F))
X_train <- data.table(read.csv("X_train.txt", sep = " "))

# renaming the names of variables
subject_test <- subject_test %>% rename(subject_test = V1 )
subject_train <- subject_train %>% rename(subject_train = V1 )

# merge 2 tables of same length + rename variables
subject_test_y  <- subject_test
subject_test_y$y  <- y_test[,V1]

# doing the same for the "train"
subject_train_y  <- subject_train
subject_train_y$y  <- y_train[,V1]

