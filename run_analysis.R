library(reshape2)
## download and unzip into a temp file
rawdata <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",rawdata)
unzip(rawdata, list = FALSE) 

#load the data
Y_test <- read.table(unzip(rawdata, "UCI HAR Dataset/test/y_test.txt"))

X_test <- read.table(unzip(rawdata, "UCI HAR Dataset/test/X_test.txt"))

subject_test <- read.table(unzip(rawdata, "UCI HAR Dataset/test/subject_test.txt"))

Y_train <- read.table(unzip(rawdata, "UCI HAR Dataset/train/y_train.txt"))

X_train <- read.table(unzip(rawdata, "UCI HAR Dataset/train/X_train.txt"))

subject_train <- read.table(unzip(rawdata, "UCI HAR Dataset/train/subject_train.txt"))

features <- read.table(unzip(rawdata, "UCI HAR Dataset/features.txt"))

activity_labels <- read.table(unzip(rawdata,"UCI HAR Dataset/activity_labels.txt"))

unlink(rawdata) # we're done with the temp file

## change activity and features labels to more descriptive ones using the files provided

activity_labels[,2] <- as.character(activity_labels[,2])

features[,2] <- as.character(features[,2])


# For this assignment we need mean and standard deviation datapoints only

datapoints <- grep(".*mean.*|.*std.*", features[,2])

datapoints.names <- features[datapoints,2]

datapoints.names = gsub('-mean', 'Mean', datapoints.names)

datapoints.names = gsub('-std', 'Std', datapoints.names)

datapoints.names <- gsub('[-()]', '', datapoints.names)

## combine "train" data and "test" data

train <- cbind(X_train, Y_train, subject_train)

test <- cbind(X_test, Y_test, subject_test)

## merge train and test
merged <- rbind(train, test)

## add labels
colnames(merged) <- c("subject", "activity", datapoints.names)

## create factors from both subjects and activities
merged$activity <- factor(merged$activity, levels = activity_labels[,1], labels = activity_labels[,2])
merged$subject <- as.factor(merged$subject)

## get the data properly shaped
merged.melted <- melt(merged, id = c("subject", "activity"))

## finish the tidying with dcast
merged.mean <- dcast(merged.melted, subject + activity ~ variable, mean)

## write the text file "tidy.txt"
write.table(merged.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

