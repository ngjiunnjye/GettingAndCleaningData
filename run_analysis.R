# read activity
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")
# Load Metadata
activity <- read.table("activity_labels.txt",sep = " ", col.names = c("activity_id", "activity"))
features <- read.table("features.txt",sep = " ", col.names = c("feature_id", "feature"))

# Load train data
y_train <- read.table("train/y_train.txt",sep = " ", col.names = c("activity_id"))
subject_train <- read.table("train/subject_train.txt",sep = " ", col.names = c("subject_id"))
X_train <- read.table("train/X_train.txt")
colnames (X_train) <- features$feature
# Merge Train Set
train_set <- cbind(y_train,subject_train,X_train)

# Load test data
y_test <- read.table("test/y_test.txt",sep = " ", col.names = c("activity_id"))
subject_test <- read.table("test/subject_test.txt",sep = " ", col.names = c("subject_id"))
X_test <- read.table("test/X_test.txt")
colnames (X_test) <- features$feature

# Merge Test set
test_set <- cbind(y_test,subject_test,X_test)

# 1 Row Merge Train and Test Set
train_test_set <- rbind(train_set,test_set)
# remove duplicated columns
train_test_set <- train_test_set[,!duplicated(colnames(train_test_set))]
library(dplyr)
dataSet= tbl_df(train_test_set)
# Enrich Activity Name
enrich <- inner_join(mean_and_std, activity)

# Extract only mean and standard deviation for each measurement
# output of instruction 4
mean_and_std <- select (enrich, subject_id, activity, contains("mean"),contains("std"))

# group by subject_id and activity
mean_and_std_by_activity_subject <- group_by(mean_and_std, subject_id, activity)

# compute average for all measurement
summarized <- summarize_each(mean_and_std_by_activity_subject, funs(mean))

# write to output file
write.table(summarized, "TidyData.txt",row.name=FALSE)

