download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "data.zip")
unzip("data.zip")
read.table("./UCI HAR Dataset/test/X_test.txt") -> testset
read.table("./UCI HAR Dataset/test/y_test.txt") -> testlabels
read.table("./UCI HAR Dataset/test/subject_test.txt") -> testsub
read.table("./UCI HAR Dataset/train/x_train.txt") -> trainset
read.table("./UCI HAR Dataset/train/y_train.txt") -> trainlabels
read.table("./UCI HAR Dataset/train/subject_train.txt") -> trainsub
cbind(testlabels,testsub,testset)-> testsl
cbind(trainlabels,trainsub,trainset)-> trainsl
rbind(testsl,trainsl) -> dtset
read.table("./UCI HAR Dataset/features.txt") -> ft
as.character(ft[,2]) -> ft
c("activity","subject",ft) -> ft1
grep("mean|std",ft1)  -> g
grep("meanFreq",ft1)-> sub 
subset(g, !(g %in% sub)) -> g
c(1,2,g) -> g
dtset[,g] -> dtt
name <- c("walking","walkingup","walkingdown","sitting","standing","laying")
for(i in 1:6) {gsub(i,name[[i]],dtt[,1]) -> dtt[,1]}
ft1[g] -> clname
tolower(clname) -> clname; gsub("\\()","",clname) -> clname;
c(clname[1:2],gsub("^","\\mean*",clname[3:68])) -> clname
colnames(dtt) <- clname
sapply(split(dtt,dtt[,1:2]),function(x) colMeans(x[,3:68])) -> dtiy
as.data.frame(t(dtiy)) -> dtidy
head(dtidy)
