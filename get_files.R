if (!file.exists("./data")) 
{ dir.create("./data") }

# Download the file from professor's Amazon Cloud Front storage drive
fileName <- "./data/getdata-projectfiles-UCI HAR Dataset.zip"
if (!file.exists(fileName)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, destfile = fileName, method="curl")
  dateDownloaded <- date()
}

# Extract the files to the folder "./data/UCI HAR Dataset"
# NOTE: This will throw warnings. 28 of them.  You can safely ignore as this is telling us that it 
# is not overwriting the files
unzip(fileName, overwrite = FALSE, exdir = "./data")
