# setwd("getData-assign")

features <- read.table("features.txt", stringsAsFactors = FALSE)
idx_m <- grep("mean", features$V2, ignore.case=TRUE)
idx_s <- grep("std", features$V2, ignore.case=TRUE)

act_label <- read.table("activity_labels.txt", stringsAsFactors = FALSE)

setwd("test")
test_subj <- read.table("subject_test.txt")
test_act <- read.table("y_test.txt")
test <- read.table("X_test.txt")
test_sub <- test[, c(idx_m, idx_s)]
rm(test)

setwd("../")
setwd("train")
train_subj <- read.table("subject_train.txt")
train_act <- read.table("y_train.txt")
train <- read.table("X_train.txt")
train_sub <- train[, c(idx_m, idx_s)]
rm(train)

colnames(test_subj) <- "subj"
colnames(test_act) <- "activities"
colnames(test_sub) <- features[c(idx_m, idx_s),2]

colnames(train_subj) <- "subj"
colnames(train_act) <- "activities"
colnames(train_sub) <- features[c(idx_m, idx_s),2]

library(dplyr)
setwd("../")

data1 <- bind_cols(test_subj, test_act)
data1 <- bind_cols(data1, test_sub)
rm(test_sub, test_subj, test_act)

data2 <- bind_cols(train_subj, train_act)
data2 <- bind_cols(data2, train_sub)
rm(train_sub, train_subj, train_act)

data <- bind_rows(data1, data2)
rm(data1, data2)

data$activities <- factor(data$activities)
levels(data$activities) <- act_label$V2

# write.table(data, file="dataWhole.txt", row.names=FALSE)

by_subj_act <- group_by(data, subj, activities)

tidyData <- summarise_each(by_subj_act, funs(mean))


