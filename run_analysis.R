## Getting and Cleaning Data Course Project
## 

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip")
unzip("Dataset.zip")

test <- read.table("./UCI HAR Dataset/test/X_test.txt")
training <- read.table("./UCI HAR Dataset/train/X_train.txt")

subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjecttraining <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjects <- c(subjecttest[,1],subjecttraining[,1])
subjects <- factor(subjects)

testlabels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
traininglabels <- read.table("./UCI HAR Dataset/train/Y_train.txt")
activity <- c(testlabels[,1],traininglabels[,1])
activity <- factor(activity)
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
levels(activity) <- activitylabels$V2

features <- read.table("./UCI HAR Dataset/features.txt")

names(test) <- features[,2]
names(training) <- features[,2]

ColumsMean <- agrep("mean()", features[,2])
ColumsSTD <- agrep("std()", features[,2])
ColumsToKeep <- c(ColumsMean, ColumsSTD)

test <- test[,ColumsToKeep]
training <- training[,ColumsToKeep]

DataSet <- merge(test,training, all=TRUE)

DataSet$activity <- activity
DataSet$subjects <- subjects

library(reshape2)

MoltenData <- melt(DataSet, id=c("activity","subjects"))
DataSet2 <- (dcast(MoltenData, formula = subjects + activity ~ variable,mean))

write.csv(DataSet, file = "DataSet.csv",row.names=FALSE)
write.csv(DataSet2, file = "DataSet2.csv",row.names=FALSE)