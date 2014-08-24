##########################################################################################################
## Coursera Getting and Cleaning Data Course Project
# run_analysis.R File Description:
# This script will perform the following steps on the UCI HAR Dataset downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# This file should be run in the directory where UCI dataset is unzipped.
##########################################################################################################
# Clean up workspace
#rm(list=ls())

#Merge the training and the test sets to create one data set.

#Read data from files
features = read.table("features.txt",header=FALSE) 
activity_labels = read.table("activity_labels.txt",header=FALSE) 
subject_train = read.table("train/subject_train.txt",header=FALSE)
x_train = read.table("train/X_train.txt",header=FALSE)
y_train = read.table("train/y_train.txt",header=FALSE)

#Assigin column names to the data frames read
colnames(activity_labels) = c("activity_id","activity_name")
colnames(subject_train) = "subject_id"
colnames(x_train) = features[,2]
colnames(y_train) = "activity_id"

#Create the final training set by merging various training sets
training_set = cbind(y_train,subject_train,x_train)

# Read test data
subject_test = read.table("test/subject_test.txt",header=FALSE)
x_test = read.table("test/x_test.txt",header=FALSE)
y_test = read.table("test/y_test.txt",header=FALSE)

# Assign column names to the test data frames read
colnames(subject_test) = "subject_id"
colnames(x_test) = features[,2]
colnames(y_test) = "activity_id"

# Create the final test set by merging various test sets
test_set = cbind(y_test,subject_test,x_test)

# Combine training and test data sets to create final data set
final_data_set = rbind(training_set,test_set)

# Create a vector for the column names from the final data set
columns = colnames(final_data_set)
###########################################################

#Extract only the measurements on the mean and standard deviation for each measurement.

# Create a logical vector having TRUE values for the id, mean() & stddev() columns and FALSE for others
logical_vec = (grepl("activity..",columns)|grepl("subject..",columns)|grepl("-mean..",columns)&!grepl("-meanFreq..",columns)&!grepl("mean..-",columns)|grepl("-std..",columns)&!grepl("-std()..-",columns))

# Subset final data set table based on the logical Vector to keep only desired columns
final_data_set = final_data_set[logical_vec==TRUE]
###########################################################

#Use descriptive activity names to name the activities in the data set

#Merge final data set with the acitivity lables data frame to include descriptive activity names
final_data_set = merge(final_data_set,activity_labels,by="activity_id",all.x=TRUE)

#Update the columns vector to include new column names
columns = colnames(final_data_set)
###########################################################

#Appropriately label the data set with descriptive activity names.

#Cleaning up the variable names
for (i in 1:length(columns))
{
  columns[i] = gsub("\\()","",columns[i])
  columns[i] = gsub("-std$","StdDev",columns[i])
  columns[i] = gsub("-mean","Mean",columns[i])
  columns[i] = gsub("^(t)","time",columns[i])
  columns[i] = gsub("^(f)","freq",columns[i])
  columns[i] = gsub("([Gg]ravity)","Gravity",columns[i])
  columns[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columns[i])
  columns[i] = gsub("[Gg]yro","Gyro",columns[i])
  columns[i] = gsub("AccMag","AccMagnitude",columns[i])
  columns[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columns[i])
  columns[i] = gsub("JerkMag","JerkMagnitude",columns[i])
  columns[i] = gsub("GyroMag","GyroMagnitude",columns[i])
}

# Reassigning the new descriptive column names to the final data set
colnames(final_data_set) = columns
######################################

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.

# Create a new table without the activity-name column
final_data_set_without_activity = final_data_set[,names(final_data_set) != "activity_name"]

#create tidy data set
tidy_data_set = aggregate(final_data_set_without_activity[,names(final_data_set_without_activity) != c("activity_id","subject_id")],by=list(activity_id=final_data_set_without_activity$activity_id,subject_id = final_data_set_without_activity$subject_id),mean)
tidy_data_set = merge(tidy_data_set,activity_labels,by="activity_id",all.x=TRUE)

# save tidy data set
write.table(tidy_data_set, "tidy_data_set.txt",row.names=TRUE,sep='\t')