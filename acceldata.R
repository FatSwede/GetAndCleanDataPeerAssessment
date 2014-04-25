# Step 01:  Specify the directory where the data is located.
# Change this as necessary
dd <- "/Users/erikedvalson/R/UCI HAR Dataset"

# Step 02:  Load activity_labels.txt to data frame (activity descriptions)
activity_labels <- read.table(paste(dd, "/activity_labels.txt", sep=""), quote="\"")
names(activity_labels) <- c("Activity_ID", "Activity_Description")

# Step 03:  Load features.txt to data frame (data column names)
features <- read.table(paste(dd, "/features.txt", sep=""), quote="\"")
names(features) <- c("Feature_ID", "Feature_Description")

# Step 04:  Load subject_test.txt to data frame (test subjects)
subject_test <- read.table(paste(dd, "/test/subject_test.txt", sep=""), quote="\"")
names(subject_test) <- c("Subject_ID")

# Step 05:  Load y_test.txt to data frame (activity vector)
y_test <- read.table(paste(dd, "/test/y_test.txt", sep=""), quote="\"")
names(y_test) <- c("Activity_ID")

# Step 06:  Load X_test.txt to data frame (test data)
X_test <- read.table(paste(dd, "/test/X_test.txt", sep=""), quote="\"")
names(X_test) <- features[,2]

# Step 07:  Load subject_train.txt to data frame (train subjects)
subject_train <- read.table(paste(dd, "/train/subject_train.txt", sep=""), quote="\"")
names(subject_train) <- c("Subject_ID")

# Step 08:  Load y_train.txt to data frame (activity vector)
y_train <- read.table(paste(dd, "/train/y_train.txt", sep=""), quote="\"")
names(y_train) <- c("Activity_ID")

# Step 09:  Load X_train.txt to data frame (train data)
X_train <- read.table(paste(dd, "/train/X_train.txt", sep=""), quote="\"")
names(X_train) <- features[,2]

# Step 10:  Combine all of the test data
test_data <- data.frame(subject_test, y_test, X_test)

# Step 11:  Translate activity IDs to descriptions
test_data <- merge(test_data, activity_labels, by.x="Activity_ID", by.y="Activity_ID")

# Step 12:  Add source indicator to test data
test_data$source_ind <- "test"

# Step 13:  Combine all of the train data
train_data <- data.frame(subject_train, y_train, X_train)

# Step 14:  Translate activity IDs to descriptions
train_data <- merge(train_data, activity_labels, by.x="Activity_ID", by.y="Activity_ID")

# Step 15:  Add source indicator to test data
train_data$source_ind <- "train"

# Step 16:  "Stack" the test data and train data
all_data <- rbind(test_data, train_data)

# Step 17:  Limit the data to only mean and std dev measurements
# First get the column names
colnm <- names(all_data)
# Next get the mean and std column names
meanstdcols <- colnm[grep(".*(mean|std).*", colnm)]
# Next identify the meanFreq columns (these need to be removed from meanstdcols)
mfcols <- colnm[grep(".*meanFreq.*", colnm)]
# Eliminate the meanFreq columns
meanstdcols <- meanstdcols[! meanstdcols %in% mfcols]
# Add the descriptive columns
selectcols <- c("Subject_ID", "Activity_ID", "Activity_Description", "source_ind", meanstdcols)
# Finally take a subset of the data
final_data <- subset(all_data, select=selectcols)

# Step 18:  Calculate the means for the data
agg <- aggregate(final_data[, ! names(final_data) %in% c("Subject_ID", "Activity_ID", "Activity_Description", "source_ind")], list(Subject = final_data$Subject_ID, Activity = final_data$Activity_Description), FUN = mean)

# Step 19:  Write final data set to a file in the working dir
write.table(agg, file="accel_data_calculated_means.csv", sep=",", col.names=TRUE)