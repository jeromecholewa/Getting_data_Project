# Project for Getting_and_Cleaning_data Coursera class  
This code book describes:

* The study design, and
* the clean data files

## The Study Design and Data Collection
The data was collected from the accelerometers from the Samsung Galaxy S smartphone on 30 individuals performed 6 basic movements  

70% of the volunteers generated training data and 30% test data.  

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities:

1. Standing
2. Sitting
3. Lying
4. Walking
5. Walking up
6. Walking down

They were wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

However for this assignment, we did not use the triaxial acceleration from the accelerometer, the estimated body acceleration and the triaxial Angular velocity from the gyroscope.

## Code Book
There are 2 clean data files:

1.The "clean_data" file has 89 variables.
The first 3 are:

* subject: this is the human individual tagged by  a number who performed the activities from 1 to 30. Individuals 2, 4, 9, 10, 12, 13, 18, 20, 24 performed a test, while the other 21 individuals performed a training.
* category: describes whether the data was collected during a test or during a training
* activity: describes the activity that the individual was doing. It can take 6 values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, LAYING, STANDING.


The following 86 are all the variables of the X data set that had either "Mean", "mean" or "std" in their names.

* tBodyAcc_mean_X
* tBodyAcc_mean_Y
* tBodyAcc_mean_Z
* tBodyAcc_std_X
* tBodyAcc_std_Y
* tBodyAcc_std_Z
* tGravityAcc_mean_X
* tGravityAcc_mean_Y
* tGravityAcc_mean_Z
* tGravityAcc_std_X
* tGravityAcc_std_Y
* tGravityAcc_std_Z
* tBodyAccJerk_mean_X
* tBodyAccJerk_mean_Y
* tBodyAccJerk_mean_Z
* tBodyAccJerk_std_X
* tBodyAccJerk_std_Y
* tBodyAccJerk_std_Z
* tBodyGyro_mean_X
* tBodyGyro_mean_Y
* tBodyGyro_mean_Z
* tBodyGyro_std_X
* tBodyGyro_std_Y
* tBodyGyro_std_Z
* tBodyGyroJerk_mean_X
* tBodyGyroJerk_mean_Y
* tBodyGyroJerk_mean_Z
* tBodyGyroJerk_std_X
* tBodyGyroJerk_std_Y
* tBodyGyroJerk_std_Z
* tBodyAccMag_mean
* tBodyAccMag_std
* tGravityAccMag_mean
* tGravityAccMag_std
* tBodyAccJerkMag_mean
* tBodyAccJerkMag_std
* tBodyGyroMag_mean
* tBodyGyroMag_std
* tBodyGyroJerkMag_mean
* tBodyGyroJerkMag_std
* fBodyAcc_mean_X
* fBodyAcc_mean_Y
* fBodyAcc_mean_Z
* fBodyAcc_std_X
* fBodyAcc_std_Y
* fBodyAcc_std_Z
* fBodyAcc_meanFreq_X
* fBodyAcc_meanFreq_Y
* fBodyAcc_meanFreq_Z

2. The summary_clean data.table is showing the average of each of the 86 variables shown above, grouped by activity and subject
    + hence it is a 180 x 88 data.table