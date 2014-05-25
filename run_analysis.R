## Getting and Cleaning Data 
## Course Project

## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## The data was downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## plyr and reshape2 packages are used in this script. 
## So, if not install yet, then install first.

library(plyr)
library(reshape2)

## 1. Merges the training and the test sets to create one data set.

## in my working directory, the dataDirectory is my data path after downloading and unzipping the data
## change dataDirectory to your own data path
dataDirectory <- "data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/"

## create a dataSet in which all the training and test sets can be added in a list
dataSet <- list()
dataSet$test <- cbind(subject=read.table(paste(dataDirectory, "test", "subject_test.txt", sep="/"), col.names="Subject", header=FALSE),
                       y=read.table(paste(dataDirectory, "test", "y_test.txt", sep="/"), col.names="Activity.ID", header=FALSE),
                       x=read.table(paste(dataDirectory, "test", "x_test.txt", sep="/")), header=FALSE)
dataSet$train <- cbind(subject=read.table(paste(dataDirectory, "train", "subject_train.txt", sep="/"), col.names="Subject", header=FALSE),
                        y=read.table(paste(dataDirectory, "train", "y_train.txt", sep="/"), col.names="Activity.ID", header=FALSE),
                        x=read.table(paste(dataDirectory, "train", "X_train.txt", sep="/")), header=FALSE)

features <- read.table(paste0(dataDirectory, "features.txt"), header=FALSE, stringsAsFactors=FALSE)
activityLabels <- read.table(paste0(dataDirectory, "activity_labels.txt"), header=FALSE, stringsAsFactors=FALSE)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
tidyData <- rbind(dataSet$test, dataSet$train)

## 3. Uses descriptive activity names to name the activities in the data set
names(tidyData) <- c("Subject", "ActivityID", features[,2])
tidyDataFrame <- data.frame(tidyData)


## 4. Appropriately labels the data set with descriptive activity names. 
activityLabelsDataFrame <- data.frame(activityLabels)
names(activityLabelsDataFrame)[1] <- "ActivityID"
names(activityLabelsDataFrame)[2] <- "Activity"
tidyDataFrame <- merge(tidyDataFrame, activityLabelsDataFrame, by.x="ActivityID", by.y="ActivityID")

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
tidyDataFrameMean <- ddply(melt(tidyDataFrame, id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, MeanSamples=mean(value))

## create a file with the Tidy data "tidyData.txt" and a file with the averages "tidyDataMean.txt"
write.csv(tidyDataFrame, file = "tidyData.txt",row.names = FALSE)
write.csv(tidyDataFrameMean, file = "tidyDataMean.txt",row.names = FALSE)
