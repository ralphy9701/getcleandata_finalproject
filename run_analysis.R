###################################
#R.script for PJP
#Date Created: 17 Dec 17
#Getting and Cleaning Data Capstone
###################################

#getwd()
setwd("C:/Users/paul.j.peters/Desktop/AuthScripts/capstone")
#rm(list = ls())

library(plyr)
library(reshape2)

# read preliminary tables
features <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/features.txt"), col.names = c("code", "feature"),
                       stringsAsFactors = FALSE)
activity <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/activity_labels.txt"), 
                       col.names = c("actcode", "actname"), stringsAsFactors = FALSE)


# capture column names for merged file
columnNames <- c(features$feature,"subjectcode","actname")

# read test files
xtest <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/test/X_test.txt"))
ytest <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/test/y_test.txt"), sep = "\n", header = F)
subjecttest <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/test/subject_test.txt"))

# read train files
xtrain <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/train/X_train.txt"))
ytrain <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/train/y_train.txt"), sep = "\n", header = F)
subjecttrain <- read.table(unz("getdata_projectfiles_UCI HAR Dataset.zip", "UCI HAR Dataset/train/subject_train.txt"))

# bind all dataframes and create vectors for yall and subject all
xall <- rbind(xtest, xtrain)
yall <- rbind(ytest, ytrain)
subjectall <- rbind(subjecttest, subjecttrain)

# merge subject data
xall$subjectall <- subjectall$V1

# relabel activities with names
colnames(yall) <- "actcode"
yall <- join(yall, activity, by = "actcode", type = "left")
yall$actcode <- NULL

# merge activity indicator with df
xall$yall <- yall$actname

# rename all columns
colnames(xall) <- columnNames

# rename to dfall
dfall <- xall

# create a character vector of only mean and std measures
meanstdlogical <- grepl(x = features$feature, pattern = "std|mean")
features <- features$feature
meanstdname <- as.character(features[meanstdlogical])

# keep only mean and std data
dfall <- dfall[, meanstdlogical]

# reshape and keep only the means
dfallmelt <- melt(dfall, id=c("subjectcode", "actname"), measure.vars=meanstdname)
dfalltidy <- dcast(data = dfallmelt, subjectcode + actname ~ variable, mean)

# output file
write.csv(dfalltidy, "tidy_dataset.csv")
