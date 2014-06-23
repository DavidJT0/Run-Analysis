#Course Project

create a folder in the working directory, download the data and unzip it

	if(!file.exists("./data")){dir.create("./data")}
	fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileUrl,destfile="Dataset.zip")
	unzip("Dataset.zip")

uploads test and training data

	test <- read.table("./UCI HAR Dataset/test/X_test.txt")
	training <- read.table("./UCI HAR Dataset/train/X_train.txt")

uploads subjects ID for both test and training dataset.
creates a vector that concatenate the data of the two data frames
converts the vector into a factor vector

	subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
	subjecttraining <- read.table("./UCI HAR Dataset/train/subject_train.txt")
	subjects <- c(subjecttest[,1],subjecttraining[,1])
	subjects <- factor(subjects)

Uploads activity IDs for both dataframes

	testlabels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
	traininglabels <- read.table("./UCI HAR Dataset/train/Y_train.txt")

creates a vector that concatenate activity Ids for both dataframes
converts the vector into a factor vector

	activity <- c(testlabels[,1],traininglabels[,1])
	activity <- factor(activity)

uploads the definitions of activity ids (e.g: 1 = WALKING, etc) and replaces the labels
of the existing activity IDs vectors stored as numbers with the text values.

	activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
	levels(activity) <- activitylabels$V2

uploads the names of the variables measured and replace the names in both dataframes with these names

	features <- read.table("./UCI HAR Dataset/features.txt")
	names(test) <- features[,2]
	names(training) <- features[,2]

Finds the positions of the variables that we want to keep. 
Creates a vector that contains the positions of the variables that contains in their names the word "mean()". 
Creates a vector that contains the positions of the variables that contains in their names the word "std()".
Concatenates the vectors

	ColumsMean <- agrep("mean()", features[,2])
	ColumsSTD <- agrep("std()", features[,2])
	ColumsToKeep <- c(ColumsMean, ColumsSTD)

Trims the dataframes keeping only the mean and std variables

	test <- test[,ColumsToKeep]
	training <- training[,ColumsToKeep]

Merges the data frames 

	DataSet <- merge(test,training, all=TRUE)

Adds two colums for activity and subjects' IDs

	DataSet$activity <- activity
	DataSet$subjects <- subjects

Melts the database in 4 colums (activity ID, subject ID, Variable name, variable value)

	library(reshape2)
	MoltenData <- melt(DataSet, id=c("activity","subjects"))

Creates a dataframe that contains, for every row, the average of each value divided by activity and subject
	
	DataSet2 <- (dcast(MoltenData, formula = subjects + activity ~ variable,mean))

Writes the dataframes in CSV format

	write.csv(DataSet, file = "DataSet.csv",row.names=FALSE)
	write.csv(DataSet2, file = "DataSet2.csv",row.names=FALSE)