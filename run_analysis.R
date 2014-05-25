library(reshape2)

#Assume that if this folder exists, the files are present as well.
if (!file.exists("./data/UCI HAR Dataset")) { 
  source(get_files.R) 
}

#
#Load Data files to be merged
#

#Limit the number of rows loaded to speed up the process
rows <- -1 #Set this to -1 to load all data

#Load the list of 6 activities text descriptions from the dataset information files
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
activitynames <- tolower(activities$V2)

#Load the column labels for the 561 columns of the XTrain data frame from the description file
tmp <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
labels <- tmp$V2

#Load the main data "train" of the experiment and attach the labels we loaded from features.txt
Xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", nrows = rows)
names(Xtrain) <- labels

#Load the activity done by the subject which corresponds to each row in Xtrain
Ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", nrows = rows)
names(Ytrain) <- "Activity"

#Add in the descriptive text for the activity to make it eaiser to read
Ytrain$ActivityDescription <- activitynames[Ytrain$Activity]

#Load the table which holds the list of users for each row in Xtrain
SubjectsTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", nrows = rows)
names(SubjectsTrain) <- "Person"

# "Merge" the three train data frames together using cbind
# Each row of the files correspond with the same row in the other files, so all we need to do is 
# add them in as new columns
train <- cbind(SubjectsTrain,Ytrain,Xtrain)

#
# Load TEST data now
#

#Load the main data "train" of the experiment and attach the labels we loaded from features.txt
Xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", nrows = rows)
names(Xtest) <- labels

#Load the activity done by the subject which corresponds to each row in Xtest
Ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", nrows = rows)
names(Ytest) <- "Activity"

#Add in the descriptive text for the activity to make it eaiser to read
Ytest$ActivityDescription <- activitynames[Ytest$Activity]

#Load the table which holds the list of users for each row in Xtest
SubjectsTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", nrows = rows)
names(SubjectsTest) <- "Person"

# "Merge" the three test data frames together using cbind
# Each row of the files correspond with the same row in the other files, so all we need to do is 
# add them in as new columns
test <- cbind(SubjectsTest,Ytest,Xtest)

#
# Merge the training and test sets to create one data set
#

# Combine all the test and train data into one data frame by adding the rows together using rbind
allData <- rbind(test,train)

#
# Extract only the measurements that deal with the mean and standard deviation for the measurements
#

info <- c(1,3) #The informational columns - subject and description of activity
justmean <- grep("-mean()", names(allData), fixed = TRUE) # Find all columns with the Mean 
juststd <- grep("-std()", names(allData), fixed = TRUE) # Find all columns with the Standard Deviation
neededcolumns <- c(info, justmean, juststd) # Combine previous lists to get list of all the columns we need (general, Mean and STD)

# Create the smaller data set with only the means and standard deviations.
allSmall <- allData[, neededcolumns]

# Cleanup unneeded variables from environment
rm(activities, SubjectsTrain,Ytrain,Xtrain, SubjectsTest,Ytest,Xtest,activitynames, tmp, test, train, info, justmean,juststd, neededcolumns, labels)

#
# Apporpriately label the data set with descriptive activity names
#

# ...kinda
names(allSmall) <- gsub("-","",names(allSmall))
names(allSmall) <- gsub("mean","Mean",names(allSmall))
names(allSmall) <- gsub("std","StandardDeviation",names(allSmall))
names(allSmall) <- gsub("[()]","",names(allSmall))
names(allSmall) <- gsub("Acc","Accelerometer",names(allSmall))
names(allSmall) <- gsub("Gyro","Gyroscope",names(allSmall))
names(allSmall) <- gsub("Mag","Magnitude",names(allSmall))
names(allSmall) <- gsub("([XYZ])$","\\1Axis",names(allSmall))

#
# Create a second, independent tidy data set with the average of each variable for each activity and each subject
#

# Ideas from http://tgmstat.wordpress.com/2013/10/31/reshape-and-aggregate-data-with-the-r-package-reshape2/
molten = melt(allSmall, id = c("Person", "ActivityDescription"))
tidyDataset <- dcast(molten, formula = Person + ActivityDescription  ~ variable, mean)

# Remove working data from environment
rm(molten, allData, allSmall)

write.table(tidyDataset,"./data/UCI-HAR-Averages.txt")

#listOfVariables <- data.frame(names(tidyDataset))
#write.csv(listOfVariables,"listOfVariables.csv")