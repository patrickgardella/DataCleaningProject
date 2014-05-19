# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(reshape2)

#Assume that if this folder exists, the files are present as well.
if (!file.exists("./data/UCI HAR Dataset")) 
{ source(get_files.R) }

#Load Data files to be merged

#Limit the number of rows loaded to speed up the process
rows <- -1 #Set this to -1 to load all data

#Load the list of 6 activities
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
activitynames <- tolower(activities$V2)

#Load the labels for the 561 columns of the XTrain data frame
tmp <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
labels <- tmp$V2

#Load the main data of the experiment using the labels we loaded from features.txt
Xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", nrows = rows)
names(Xtrain) <- labels

#Load the activity done by the subject
Ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", nrows = rows)
names(Ytrain) <- "Activity"
#add in the descriptive text for the activity to make it eaiser to read
Ytrain$ActivityDescription <- activitynames[Ytrain$Activity]

SubjectsTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", nrows = rows)
names(SubjectsTrain) <- "Person"

# "Merge" the three train data frames together using cbind
train <- cbind(SubjectsTrain,Ytrain,Xtrain)

# Load TEST data now

#Load the main data of the experiment using the labels we loaded from features.txt
Xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", nrows = rows)
names(Xtest) <- labels

#Load the activity done by the subject
Ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", nrows = rows)
names(Ytest) <- "Activity"
#add in the descriptive text for the activity to make it eaiser to read
Ytest$ActivityDescription <- activitynames[Ytest$Activity]

SubjectsTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", nrows = rows)
names(SubjectsTest) <- "Person"

# "Merge" the three test data frames together using cbind
test <- cbind(SubjectsTest,Ytest,Xtest)

# Combine all the test and train data into one data frame by adding the rows together using rbind
all <- rbind(test,train)

info <- c(1,3) #The informational columns - subject and description of activity
justmean <- grep("mean(", names(all), fixed = TRUE) # Find all columns with the Mean 
juststd <- grep("std", names(all), fixed = TRUE) # Find all columns with the Standard Deviation
neededcolumns <- c(info, justmean, juststd) # get list of all the columns we need (general, Mean and STD)

allShort <- all[, neededcolumns]

# Cleanup unneeded variables
rm(activities, SubjectsTrain,Ytrain,Xtrain, SubjectsTest,Ytest,Xtest,activitynames, tmp, test, train, info, justmean,juststd, neededcolumns, labels)

#Make names more user friendly - kinda
names(allShort) <- gsub("-","",names(allShort))
names(allShort) <- gsub("mean","Mean",names(allShort))
names(allShort) <- gsub("std","StandardDeviation",names(allShort))
names(allShort) <- gsub("[()]","",names(allShort))
names(allShort) <- gsub("Acc","Accelerometer",names(allShort))
names(allShort) <- gsub("Gyro","Gyrometer",names(allShort))
names(allShort) <- gsub("Mag","Magnitude",names(allShort))
names(allShort) <- gsub("([XYZ])$","\\1Axis",names(allShort))

# Ideas from http://tgmstat.wordpress.com/2013/10/31/reshape-and-aggregate-data-with-the-r-package-reshape2/
molten = melt(allShort, id = c("Person", "ActivityDescription"))
averages <- dcast(molten, formula = Person + ActivityDescription  ~ variable, mean)