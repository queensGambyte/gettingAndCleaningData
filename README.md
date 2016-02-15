# COURSE PROJECT : Getting and Cleaning Data #
----
The script "run_analysis.R" downloads UCI HAR Datset from url:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and performs the following tasks

1. Creates a directory "CourseProject", downloads the dataset from mentioned url into this directory and unzips it.

2. Merges the training and the test sets to create one data set.

3. Extracts only the measurements on the mean and standard deviation for each measurement.

4. Uses descriptive activity names to name the activities in the data set

5. Appropriately labels the data set with descriptive variable names.

6. From the data set in step 5, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


The end result is shown in "tidydata.txt" file in the repo.


## NOTE:
The dataset is combined and interpreted as:
 
subject | activity | features.txt
------- | -------- | ------------
subject_train.txt | y_train.txt | X_train.txt
subject_test.txt | y_test.txt | X_test.txt