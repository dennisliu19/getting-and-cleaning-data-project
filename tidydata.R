install.packages("reshape2")
library(reshape2)

setwd("~/Desktop/coursera/UCI HAR Dataset")

activity <- read.table("activity_labels.txt")
activity[,2] <- as.character(activity[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

remains <- grep(".*mean.*|.*std.*", features[,2])
cleanname <- features[remains,2]
cleanname = gsub('-mean', 'Mean', cleanname)
cleanname = gsub('-std', 'Std', cleanname)
cleanname <- gsub('[-()]', '', cleanname)

train <- read.table("train/X_train.txt")
train <- train[remains]
trainactivities <- read.table("train/Y_train.txt")
trainsubjects <- read.table("train/subject_train.txt")
train <- cbind(trainsubjects, trainactivities, train)

test <- read.table("test/X_test.txt")
test <- test[remains]
testactivities <- read.table("test/Y_test.txt")
testsubjects <- read.table("test/subject_test.txt")
test <- cbind(testsubjects, testactivities, test)

combined <- rbind(train, test)
colnames(combined) <- c("subject", "activity", cleanname)
combined$activity <- factor(combined$activity, levels = activity[,1], labels = activity[,2])
combined$subject <- as.factor(combined$subject)

clean.data <- melt(combined, id = c("subject", "activity"))
clean.data <- dcast(clean.data, subject + activity ~ variable, mean)

write.table(clean.data, "tidydata.txt")
