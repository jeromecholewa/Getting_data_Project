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
# library(tidyr)
setwd("dataset") # where I had put all the data files

########## reading in and cleaning the activity labels
activity_labels <- data.table(read.csv("activity_labels.txt", sep = " ", header = FALSE, col.names = c("lab_act", "activity")))


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

# str_count(body_acc_x_test_1space[1], " ")

###########################
##  Cleaning the "body_acc_x_test.txt"
body_acc_x_test_messy <- readLines("body_acc_x_test.txt")
# almost all lines start with doubles spaces
# except some lines starting with " -"
# so on those lines, we first add one space, so ALL lines start with double spaces
body_acc_x_test_messy2 <- sub(" -", "  -", body_acc_x_test_messy)
# then we remove all starting double spaces
body_acc_x_test_messy3  <- sub("  ", "", body_acc_x_test_messy2)
# then we replace all other double spaces by single spaces
body_acc_x_test_1space  <- gsub("  ", " ", body_acc_x_test_messy3)
body_acc_x_test_1spaceDT  <- data.table(body_acc_x_test_1space)
body_acc_x_test_clean  <- data.table(body_acc_x_test_1spaceDT) %>% separate( body_acc_x_test_1space , sep = " ", into = paste("body_acc_x", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_acc_x_test_clean[,(names(body_acc_x_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_acc_x_test_clean)]
###########################

############################
##  Cleaning the "body_acc_y_test.txt"
body_acc_y_test_messy <- readLines("body_acc_y_test.txt")
body_acc_y_test_messy2 <- sub(" -", "  -", body_acc_y_test_messy)
# then we remove all starting double spaces
body_acc_y_test_messy3  <- sub("  ", "", body_acc_y_test_messy2)
# then we replace all other double spaces by single spaces
body_acc_y_test_1space  <- gsub("  ", " ", body_acc_y_test_messy3)
body_acc_y_test_1spaceDT  <- data.table(body_acc_y_test_1space)
body_acc_y_test_clean  <- data.table(body_acc_y_test_1spaceDT) %>% separate( body_acc_y_test_1space , sep = " ", into = paste("body_acc_y", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_acc_y_test_clean[,(names(body_acc_y_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_acc_y_test_clean)]
###############################

############################
##  Cleaning the "body_acc_z_test.txt"
body_acc_z_test_messy <- readLines("body_acc_z_test.txt")

body_acc_z_test_messy2 <- sub(" -", "  -", body_acc_z_test_messy)
# then we remove all starting double spaces
body_acc_z_test_messy3  <- sub("  ", "", body_acc_z_test_messy2)
# then we replace all other double spaces by single spaces
body_acc_z_test_1space  <- gsub("  ", " ", body_acc_z_test_messy3)
body_acc_z_test_1spaceDT  <- data.table(body_acc_z_test_1space)
body_acc_z_test_clean  <- data.table(body_acc_z_test_1spaceDT) %>% separate( body_acc_z_test_1space , sep = " ", into = paste("body_acc_z", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_acc_z_test_clean[,(names(body_acc_z_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_acc_z_test_clean)]
###############################

# library(stringr)
# str_count(body_acc_x_test_1space[1], " ")

###########################
##  Cleaning the "body_acc_x_train.txt"
body_acc_x_train_messy <- readLines("body_acc_x_train.txt")
body_acc_x_train_messy2 <- sub(" -", "  -", body_acc_x_train_messy)
# then we remove all starting double spaces
body_acc_x_train_messy3  <- sub("  ", "", body_acc_x_train_messy2)
# then we replace all other double spaces by single spaces
body_acc_x_train_1space  <- gsub("  ", " ", body_acc_x_train_messy3)
body_acc_x_train_1spaceDT  <- data.table(body_acc_x_train_1space)
body_acc_x_train_clean  <- data.table(body_acc_x_train_1spaceDT) %>% separate( body_acc_x_train_1space , sep = " ", into = paste("body_acc_x", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_acc_x_train_clean[,(names(body_acc_x_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_acc_x_train_clean)]
###########################

############################
##  Cleaning the "body_acc_y_train.txt"
body_acc_y_train_messy <- readLines("body_acc_y_train.txt")

body_acc_y_train_messy2 <- sub(" -", "  -", body_acc_y_train_messy)
# then we remove all starting double spaces
body_acc_y_train_messy3  <- sub("  ", "", body_acc_y_train_messy2)
# then we replace all other double spaces by single spaces
body_acc_y_train_1space  <- gsub("  ", " ", body_acc_y_train_messy3)
body_acc_y_train_1spaceDT  <- data.table(body_acc_y_train_1space)
body_acc_y_train_clean  <- data.table(body_acc_y_train_1spaceDT) %>% separate( body_acc_y_train_1space , sep = " ", into = paste("body_acc_y", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_acc_y_train_clean[,(names(body_acc_y_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_acc_y_train_clean)]
###############################

############################
##  Cleaning the "body_acc_z_train.txt"
body_acc_z_train_messy <- readLines("body_acc_z_train.txt")
body_acc_z_train_messy2 <- sub(" -", "  -", body_acc_z_train_messy)
body_acc_z_train_messy3  <- sub("  ", "", body_acc_z_train_messy2)
# then we replace all other double spaces by single spaces
body_acc_z_train_1space  <- gsub("  ", " ", body_acc_z_train_messy3)
body_acc_z_train_1spaceDT  <- data.table(body_acc_z_train_1space)
body_acc_z_train_clean  <- data.table(body_acc_z_train_1spaceDT) %>% separate( body_acc_z_train_1space , sep = " ", into = paste("body_acc_z", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_acc_z_train_clean[,(names(body_acc_z_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_acc_z_train_clean)]
###############################

############### DOING THE SAME 6 cleaning for the _gyro_ files
###########################
##  Cleaning the "body_gyro_x_test.txt"
body_gyro_x_test_messy <- readLines("body_gyro_x_test.txt")

body_gyro_x_test_messy2 <- sub(" -", "  -", body_gyro_x_test_messy)
# then we remove all starting double spaces
body_gyro_x_test_messy3  <- sub("  ", "", body_gyro_x_test_messy2)
# then we replace all other double spaces by single spaces
body_gyro_x_test_1space  <- gsub("  ", " ", body_gyro_x_test_messy3)
body_gyro_x_test_1spaceDT  <- data.table(body_gyro_x_test_1space)
body_gyro_x_test_clean  <- data.table(body_gyro_x_test_1spaceDT) %>% separate( body_gyro_x_test_1space , sep = " ", into = paste("body_gyro_x", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_gyro_x_test_clean[,(names(body_gyro_x_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_gyro_x_test_clean)]
###########################

# library(stringr)
# str_count(body_acc_x_test_1space[1], " ")

############################
##  Cleaning the "body_gyro_y_test.txt"
body_gyro_y_test_messy <- readLines("body_gyro_y_test.txt")
body_gyro_y_test_messy2 <- sub(" -", "  -", body_gyro_y_test_messy)
# then we remove all starting double spaces
body_gyro_y_test_messy3  <- sub("  ", "", body_gyro_y_test_messy2)
# then we replace all other double spaces by single spaces
body_gyro_y_test_1space  <- gsub("  ", " ", body_gyro_y_test_messy3)
body_gyro_y_test_1spaceDT  <- data.table(body_gyro_y_test_1space)
body_gyro_y_test_clean  <- data.table(body_gyro_y_test_1spaceDT) %>% separate( body_gyro_y_test_1space , sep = " ", into = paste("body_gyro_y", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_gyro_y_test_clean[,(names(body_gyro_y_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_gyro_y_test_clean)]
###############################

############################
##  Cleaning the "body_gyro_z_test.txt"
body_gyro_z_test_messy <- readLines("body_gyro_z_test.txt")

body_gyro_z_test_messy2 <- sub(" -", "  -", body_gyro_z_test_messy)
# then we remove all starting double spaces
body_gyro_z_test_messy3  <- sub("  ", "", body_gyro_z_test_messy2)
# then we replace all other double spaces by single spaces
body_gyro_z_test_1space  <- gsub("  ", " ", body_gyro_z_test_messy3)
body_gyro_z_test_1spaceDT  <- data.table(body_gyro_z_test_1space)
body_gyro_z_test_clean  <- data.table(body_gyro_z_test_1spaceDT) %>% separate( body_gyro_z_test_1space , sep = " ", into = paste("body_gyro_z", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_gyro_z_test_clean[,(names(body_gyro_z_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_gyro_z_test_clean)]
###############################

###########################
##  Cleaning the "body_gyro_x_train.txt"
body_gyro_x_train_messy <- readLines("body_gyro_x_train.txt")
body_gyro_x_train_messy2 <- sub(" -", "  -", body_gyro_x_train_messy)
# then we remove all starting double spaces
body_gyro_x_train_messy3  <- sub("  ", "", body_gyro_x_train_messy2)
# then we replace all other double spaces by single spaces
body_gyro_x_train_1space  <- gsub("  ", " ", body_gyro_x_train_messy3)
body_gyro_x_train_1spaceDT  <- data.table(body_gyro_x_train_1space)
body_gyro_x_train_clean  <- data.table(body_gyro_x_train_1spaceDT) %>% separate( body_gyro_x_train_1space , sep = " ", into = paste("body_gyro_x", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_gyro_x_train_clean[,(names(body_gyro_x_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_gyro_x_train_clean)]
###########################

############################
##  Cleaning the "body_gyro_y_train.txt"
body_gyro_y_train_messy <- readLines("body_gyro_y_train.txt")
body_gyro_y_train_messy2 <- sub(" -", "  -", body_gyro_y_train_messy)
# then we remove all starting double spaces
body_gyro_y_train_messy3  <- sub("  ", "", body_gyro_y_train_messy2)
# then we replace all other double spaces by single spaces
body_gyro_y_train_1space  <- gsub("  ", " ", body_gyro_y_train_messy3)
body_gyro_y_train_1spaceDT  <- data.table(body_gyro_y_train_1space)
body_gyro_y_train_clean  <- data.table(body_gyro_y_train_1spaceDT) %>% separate( body_gyro_y_train_1space , sep = " ", into = paste("body_gyro_y", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_gyro_y_train_clean[,(names(body_gyro_y_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_gyro_y_train_clean)]
###############################

############################
##  Cleaning the "body_gyro_z_train.txt"
body_gyro_z_train_messy <- readLines("body_gyro_z_train.txt")
body_gyro_z_train_messy2 <- sub(" -", "  -", body_gyro_z_train_messy)
# then we remove all starting double spaces
body_gyro_z_train_messy3  <- sub("  ", "", body_gyro_z_train_messy2)
# then we replace all other double spaces by single spaces
body_gyro_z_train_1space  <- gsub("  ", " ", body_gyro_z_train_messy3)
body_gyro_z_train_1spaceDT  <- data.table(body_gyro_z_train_1space)
body_gyro_z_train_clean  <- data.table(body_gyro_z_train_1spaceDT) %>% separate( body_gyro_z_train_1space , sep = " ", into = paste("body_gyro_z", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
body_gyro_z_train_clean[,(names(body_gyro_z_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(body_gyro_z_train_clean)]
###############################

############# DOING the same for the 6 total_acc files

###########################
##  Cleaning the "total_acc_x_test.txt"
total_acc_x_test_messy <- readLines("total_acc_x_test.txt")
total_acc_x_test_messy2 <- sub(" -", "  -", total_acc_x_test_messy)
# then we remove all starting double spaces
total_acc_x_test_messy3  <- sub("  ", "", total_acc_x_test_messy2)
# then we replace all other double spaces by single spaces
total_acc_x_test_1space  <- gsub("  ", " ", total_acc_x_test_messy3)
total_acc_x_test_1spaceDT  <- data.table(total_acc_x_test_1space)
total_acc_x_test_clean  <- data.table(total_acc_x_test_1spaceDT) %>% separate( total_acc_x_test_1space , sep = " ", into = paste("total_acc_x", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
total_acc_x_test_clean[,(names(total_acc_x_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(total_acc_x_test_clean)]
###########################

############################
##  Cleaning the "total_acc_y_test.txt"
total_acc_y_test_messy <- readLines("total_acc_y_test.txt")
total_acc_y_test_messy2 <- sub(" -", "  -", total_acc_y_test_messy)
# then we remove all starting double spaces
total_acc_y_test_messy3  <- sub("  ", "", total_acc_y_test_messy2)
# then we replace all other double spaces by single spaces
total_acc_y_test_1space  <- gsub("  ", " ", total_acc_y_test_messy3)
total_acc_y_test_1spaceDT  <- data.table(total_acc_y_test_1space)
total_acc_y_test_clean  <- data.table(total_acc_y_test_1spaceDT) %>% separate( total_acc_y_test_1space , sep = " ", into = paste("total_acc_y", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
total_acc_y_test_clean[,(names(total_acc_y_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(total_acc_y_test_clean)]
###############################

############################
##  Cleaning the "total_acc_z_test.txt"
total_acc_z_test_messy <- readLines("total_acc_z_test.txt")
total_acc_z_test_messy2 <- sub(" -", "  -", total_acc_z_test_messy)
# then we remove all starting double spaces
total_acc_z_test_messy3  <- sub("  ", "", total_acc_z_test_messy2)
# then we replace all other double spaces by single spaces
total_acc_z_test_1space  <- gsub("  ", " ", total_acc_z_test_messy3)
total_acc_z_test_1spaceDT  <- data.table(total_acc_z_test_1space)
total_acc_z_test_clean  <- data.table(total_acc_z_test_1spaceDT) %>% separate( total_acc_z_test_1space , sep = " ", into = paste("total_acc_z", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
total_acc_z_test_clean[,(names(total_acc_z_test_clean)):=lapply(.SD, as.numeric),.SDcols=names(total_acc_z_test_clean)]
###############################

###########################
##  Cleaning the "total_acc_x_train.txt"
total_acc_x_train_messy <- readLines("total_acc_x_train.txt")
total_acc_x_train_messy2 <- sub(" -", "  -", total_acc_x_train_messy)
# then we remove all starting double spaces
total_acc_x_train_messy3  <- sub("  ", "", total_acc_x_train_messy2)
# then we replace all other double spaces by single spaces
total_acc_x_train_1space  <- gsub("  ", " ", total_acc_x_train_messy3)
total_acc_x_train_1spaceDT  <- data.table(total_acc_x_train_1space)
total_acc_x_train_clean  <- data.table(total_acc_x_train_1spaceDT) %>% separate( total_acc_x_train_1space , sep = " ", into = paste("total_acc_x", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
total_acc_x_train_clean[,(names(total_acc_x_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(total_acc_x_train_clean)]
###########################

############################
##  Cleaning the "total_acc_y_train.txt"
total_acc_y_train_messy <- readLines("total_acc_y_train.txt")
total_acc_y_train_messy2 <- sub(" -", "  -", total_acc_y_train_messy)
# then we remove all starting double spaces
total_acc_y_train_messy3  <- sub("  ", "", total_acc_y_train_messy2)
# then we replace all other double spaces by single spaces
total_acc_y_train_1space  <- gsub("  ", " ", total_acc_y_train_messy3)
total_acc_y_train_1spaceDT  <- data.table(total_acc_y_train_1space)
total_acc_y_train_clean  <- data.table(total_acc_y_train_1spaceDT) %>% separate( total_acc_y_train_1space , sep = " ", into = paste("total_acc_y", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
total_acc_y_train_clean[,(names(total_acc_y_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(total_acc_y_train_clean)]
###############################

############################
##  Cleaning the "total_acc_z_train.txt"
total_acc_z_train_messy <- readLines("total_acc_z_train.txt")
total_acc_z_train_messy2 <- sub(" -", "  -", total_acc_z_train_messy)
# then we remove all starting double spaces
total_acc_z_train_messy3  <- sub("  ", "", total_acc_z_train_messy2)
# then we replace all other double spaces by single spaces
total_acc_z_train_1space  <- gsub("  ", " ", total_acc_z_train_messy3)
total_acc_z_train_1spaceDT  <- data.table(total_acc_z_train_1space)
total_acc_z_train_clean  <- data.table(total_acc_z_train_1spaceDT) %>% separate( total_acc_z_train_1space , sep = " ", into = paste("total_acc_z", sep="", 1:128))

# all 128 columns are characters --> converting into numeric
total_acc_z_train_clean[,(names(total_acc_z_train_clean)):=lapply(.SD, as.numeric),.SDcols=names(total_acc_z_train_clean)]
###############################

## putting the 2 X sets on top of each other (test is above, train is below)
X_all <- rbindlist(list(X_test_clean, X_train_clean), use.names = TRUE)

### binding all body_acc data on top of each other
### test is on top, train is at the bottom
body_acc_x_all <- rbindlist(list(body_acc_x_test_clean, body_acc_x_train_clean), use.names = TRUE)

body_acc_y_all <- rbindlist(list(body_acc_y_test_clean, body_acc_y_train_clean), use.names = TRUE)

body_acc_z_all <- rbindlist(list(body_acc_z_test_clean, body_acc_z_train_clean), use.names = TRUE)

#### bind all gyro on top of each other
### test is on top, train is at the bottom
body_gyro_x_all <- rbindlist(list(body_gyro_x_test_clean, body_gyro_x_train_clean), use.names = TRUE)

body_gyro_y_all <- rbindlist(list(body_gyro_y_test_clean, body_gyro_y_train_clean), use.names = TRUE)

body_gyro_z_all <- rbindlist(list(body_gyro_z_test_clean, body_gyro_z_train_clean), use.names = TRUE)

#### bind all body_acc on top of each other
### test is on top, train is at the bottom
total_acc_x_all <- rbindlist(list(total_acc_x_test_clean, total_acc_x_train_clean), use.names = TRUE)

total_acc_y_all <- rbindlist(list(total_acc_y_test_clean, total_acc_y_train_clean), use.names = TRUE)

total_acc_z_all <- rbindlist(list(total_acc_z_test_clean, total_acc_z_train_clean), use.names = TRUE)

####### rbind all the "_all" data.tables with the subj_label_category table

clean_data <- cbind(subj_label_category, X_all, body_acc_x_all, body_acc_y_all, body_acc_z_all, body_gyro_x_all, body_gyro_y_all, body_gyro_z_all, total_acc_x_all, total_acc_y_all, total_acc_z_all)
