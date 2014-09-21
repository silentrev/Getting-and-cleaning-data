
## Read train and test set from file
TrainSet = read.table("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
TestSet = read.table("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)

## Read and add subjects and labels to the sets
TrainSet[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
TrainSet[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

TestSet[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
TestSet[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

## Read activity label and features
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

## Merge data
CombinedSet = rbind(TrainSet, TestSet)

## Sort out mean and std(LOL)
sorted <- grep(".*mean.*|.*std.*", features[,2])
## subsetting
features <- features[sorted,]
sorted <- c(sorted, 562, 563)

## Sort out wanted data from CombinedSet
SortedSet <- CombinedSet[,sorted]

Names
<- as.character(features$V2)
## Add column names
colnames(SortedSet) <- c(Names, "Activity", "Subject")
colnames(SortedSet) <- tolower(colnames(SortedSet))


currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  SortedSet$activity <- gsub(currentActivity, currentActivityLabel, SortedSet$activity)
  currentActivity <- currentActivity + 1
}

SortedSet$activity <- as.factor(SortedSet$activity)
SortedSet$subject <- as.factor(SortedSet$subject)


tidySet = aggregate(SortedSet, by=list(activity = SortedSet$activity, subject=SortedSet$subject), mean)

## Remove subject and activity columns
tidySet[,90] = NULL
tidySet[,89] = NULL

## write tidy set to file
write.table(tidySet, "tidy.txt", sep="\t")







