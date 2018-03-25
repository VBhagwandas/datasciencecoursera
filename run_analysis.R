#Download file
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", method = "curl")

#unzip files
unzip("Dataset.zip")
list.files() #UCI HAR Dataset

#load activity labels
activity.labels = read.table("UCI HAR Dataset/activity_labels.txt", quote = "")

#load features 
features = read.table("UCI HAR Dataset/features.txt", sep="", header=FALSE)
#remove punctuations from features
features[,2] = gsub("[[:punct:]]", "", features[,2])

#load test data
x.test = read.table("UCI HAR Dataset/test/X_test.txt")
y.test = read.table("UCI HAR Dataset/test/y_test.txt")
subject.test = read.table("UCI HAR Dataset/test/subject_test.txt")

#assign rownames
colnames(x.test) <- features[,2]
colnames(y.test) <- c("activity")
colnames(subject.test) <- c("subject")

#bind coulums
test = cbind(y.test, subject.test, x.test)

#load training data
x.train = read.table("UCI HAR Dataset/train/X_train.txt")
y.train = read.table("UCI HAR Dataset/train/y_train.txt")
subject.train = read.table("UCI HAR Dataset/train/subject_train.txt")

#assign rownames
colnames(x.train) <- features[,2]
colnames(y.train) <- c("activity")
colnames(subject.train) <- c("subject")

#bind coulums
train = cbind(y.train, subject.train, x.train)
rm(x.test, y.test, subject.test, x.train, y.train, subject.train) 

#Step1: Merges the training and the test sets to create one data set
#merge datasets
mergedData = rbind(test, train)
rm(test, train)

#Step2: Extracts only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
#There are duplicates in name, remove duplicates:
#duplicated(names(mergedData))
names(mergedData) = make.unique(names(mergedData))

#names(mergedData) = lapply(names(mergedData), function(x) paste0("", x, sep="_"))

mergedSubset <- select(mergedData, contains("subject"), contains("activity"), contains("label"),
                       contains("mean"), contains("std"), -contains("freq"),
                       -contains("angle"))
rm(mergedData)

#Step3: Uses descriptive activity names to name the activities in the data set
mergedSubset$activity = activity.labels[match(as.numeric(mergedSubset$activity), as.numeric(activity.labels$V2)), 'V2']

#Step4: Appropriately labels the data set with descriptive variable names
#Done in step 1

#Step5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
meltData = melt(mergedSubset, id=c("activity", "subject"))
tidyData = dcast(meltData, activity+subject ~ variable, mean)

write.table(tidyData, "tidyData.txt", row.names=FALSE)
