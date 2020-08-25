library(dplyr)

##downloading the dataset

filename <- "dataset.zip"

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = filename)
unzip(filename)

list.files()

##reading data

features = read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
subjecttest <- read.table("UCI HAR Dataset./test/subject_test.txt", col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

##merging the data

x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain,subjecttest)
merged_data <- cbind(subject,y,x)

##subsetting data
tidydata <- merged_data %>% select(subject, code, contains("mean"), contains("std"))
tidydata$code = activity[tidydata$code,2]

##labelling the data
names(tidydata)[2] = "activities"
names(tidydata) <- gsub("Acc","Accelerometer",names(tidydata))
names(tidydata) <- gsub("Gyro","Gyroscoope",names(tidydata))
names(tidydata) <- gsub("BodyBody","Body",names(tidydata))
names(tidydata) <- gsub("Mag","Magnitude",names(tidydata))
names(tidydata) <- gsub("^t","Time",names(tidydata))
names(tidydata) <- gsub("^f","Frequency",names(tidydata))
names(tidydata) <- gsub("Tbody","TimeBody",names(tidydata))
names(tidydata) <- gsub("-mean()","Mean",names(tidydata),ignore.case = TRUE)
names(tidydata) <- gsub("-std()","STD",names(tidydata),ignore.case = TRUE)
names(tidydata) <- gsub("-freq()","Frequency",names(tidydata),ignore.case = TRUE)
names(tidydata) <- gsub("angle","Angle",names(tidydata))
names(tidydata) <- gsub("gravity","Gravity",names(tidydata))

##obtaining the final data
Finaldata <- tidydata %>% group_by(subject,activities) %>% summarise_all(funs(mean))
write.table(Finaldata,"FinalData.txt",row.name =FALSE)
Finaldata









                                   


