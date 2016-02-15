#Create a directory for project data
if(!file.exists("./CourseProject")){dir.create("./CourseProject")}

#Download and unzip the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./CourseProject/Dataset.zip")) {
  download.file(fileUrl,destfile="./CourseProject/Dataset.zip")
  unzip(zipfile="./CourseProject/Dataset.zip",exdir="./CourseProject")
}

path_x <- file.path("./CourseProject" , "UCI HAR Dataset")

#Read activity test and train data
dataActivityTest  <- read.table(file.path(path_x, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_x, "train", "Y_train.txt"),header = FALSE)

#Read subject test and train data
dataSubjectTrain <- read.table(file.path(path_x, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_x, "test" , "subject_test.txt"),header = FALSE)

#Read features test and train data
dataFeaturesTest  <- read.table(file.path(path_x, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_x, "train", "X_train.txt"),header = FALSE)

#Combine train and test data for subject, activity and features respectively
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#Assigning column names for dataSubject and dataActivity
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")

#Reading column names for dataFeatures from features.txt and assigning them to dataFeatures
dataFeaturesNames <- read.table(file.path(path_x, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Combinig all our data into one dataset, "Data"
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Extracting measurements on mean and standard deviation for each measurement, and assigning it back to "Data"
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<- Data[, selectedNames]

#Reading activity labels from "activity_labels.txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#Converting the column "activity" of "Data" into character Vector, and then converting it into factor with labels from "activity_labels.txt"
Data$activity<- as.character(Data$activity)
Data$activity<- factor(Data$activity, labels= activityLabels$V2)

#Replacing non descriptive variable names with descriptive ones. "nonDescriptive" is a character vector containing regular expressions for such variables
nonDescriptive<- c("^t", "^f", "Acc", "Gyro", "Mag", "BodyBody", "mean\\(\\)", "std\\(\\)", "-")
descriptive<- c("time", "frequency", "Accelerometer", "Gyroscope", "Magnitude", "Body", "Mean", "Std", "")
for(i in 1:length(nonDescriptive)) {
  names(Data)<-gsub(nonDescriptive[i], descriptive[i] , names(Data))
}

#Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
#If dplyr package is not installed, use install.packages("dplyr") first
library(dplyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "./CourseProject/tidydata.txt",row.name=FALSE)
