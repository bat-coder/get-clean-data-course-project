get-clean-data-course-project
=============================

Repository for Getting and Cleaning Data course project

##ReadMe

This file describes how the script run_analysis.R contained in the repo get-clean-data-course-project works.

##How scripts works

This script will perform the following steps on the UCI HAR Dataset downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
1. Merge the training and the test sets to create one final data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Note
This script should be run in the directory where UCI dataset is unzipped.