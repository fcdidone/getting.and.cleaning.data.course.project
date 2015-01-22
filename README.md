# getting.and.cleaning.data.course.project
Project for Getting and cleaning data course

##The first line download the data and save in your working directory

download.file( "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",  destfile = "data.zip")

##The next lines unzip the data and read the test and train set, labels and subjects 

unzip("data.zip")

read.table("./UCI HAR Dataset/test/X_test.txt") -> testset

read.table("./UCI HAR Dataset/test/y_test.txt") -> testlabels

read.table("./UCI HAR Dataset/test/subject_test.txt") -> testsub

read.table("./UCI HAR Dataset/train/x_train.txt") -> trainset

read.table("./UCI HAR Dataset/train/y_train.txt") -> trainlabels

read.table("./UCI HAR Dataset/train/subject_train.txt") -> trainsub

## Merging all together in one big data set

cbind(testlabels,testsub,testset)-> testsl

cbind(trainlabels,trainsub,trainset)-> trainsl

rbind(testsl,trainsl) -> dtset


##Read the features of the data set for the colnames and selecting the mean and the standard deviation

read.table("./UCI HAR Dataset/features.txt") -> ft


## Transform the data set in characters and subset only the second column for easing the managemnt of the data set
as.character(ft[,2]) -> ft

## add the other to columns for the activity and subject that were binding togehter in the big data set
c("activity","subject",ft) -> ft1

##The next lines select the variables that have the mean and std in the name, execpt the meanFreq
grep("mean|std",ft1)  -> g

grep("meanFreq",ft1)-> sub 

subset(g, !(g %in% sub)) -> g

## The gg vector now contain all the columns that are either mean or standard deviation. Next I added the first to columns that are the activity and subject
c(1,2,g) -> g

#Subseting the columns that are either mean or standard deviation
dtset[,g] -> dtt


## The next lines add the activity names in the data frame
name <- c("walking","walkingup","walkingdown","sitting","standing","laying")

for(i in 1:6) {gsub(i,name[[i]],dtt[,1]) -> dtt[,1]}


## Selecting the columns that are in the data set and making more readable(all lowere cases, without those anoying "()" )
ft1[g] -> clname

tolower(clname) -> clname

gsub("\\()","",clname) -> clname; gsub("bodybody","body",clname) -> clname

c(clname[1:2],gsub("^","\\mean*",clname[3:68])) -> clname

## Putting the column  names with the mean* explation on the data frame
colnames(dtt) <- clname


## Splitting the data into groups of Activity and subject and applying the column means of the variables
sapply(split(dtt,dtt[,1:2]),function(x) colMeans(x[,3:68])) -> dtiy

## Transposing and creating a data frame from the result. Note: I think that I did not need to transpose but I did just in case.
as.data.frame(t(dtiy)) -> dtidy

##Showing the first lines of the tidy data set
head(dtidy)

## Hope you guys enjoy. Sorry for any grammatical mistake, english is not my first language
