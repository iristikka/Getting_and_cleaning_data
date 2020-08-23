#download data
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/projectdataset.zip")

unzip(zipfile = "./data/projectdataset.zip", exdir = "./data")

#READING DATAS

x_train <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Reading feature vector
features <- read.table("./data/UCI HAR Dataset/features.txt")

#Reading activity labels
activity_labels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

#Assigning variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activity"
colnames(subject_train) <- "subject"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"

colnames(activity_labels) <- c("activity", "activityType")

#Merging 
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
finaldata <- rbind(train,test)

#mean and sd

colNames <- colnames(finaldata)

mean_and_sd <- (grepl("activity", colNames) |
                   grepl("subject", colNames) |
                   grepl("mean..", colNames) |
                   grepl("std...", colNames)
)

df_mean_sd <- finaldata[ , mean_and_sd == TRUE]

m_sd_names <- merge(df_mean_sd, activity_labels,
                              by = "activity",
                              all.x = TRUE)

#Making tidy data

FinalData <- m_sd_names %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))


write.table(FinalData, "tidydata.txt", row.names = FALSE)
