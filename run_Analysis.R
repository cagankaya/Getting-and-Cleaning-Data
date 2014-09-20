xtrain<- read.table("./UCI HAR Dataset/train/X_train.txt")
xtest<- read.table("./UCI HAR Dataset/test/X_test.txt")
strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
ytrain<- read.table("./UCI HAR Dataset/train/y_train.txt")
ytest<- read.table("./UCI HAR Dataset/test/y_test.txt")

xbind <- rbind(xtrain, xtest)
sbind <- rbind(strain, stest)
ybind <- rbind(ytrain, ytest)

features<- read.table("./UCI HAR Dataset/features.txt")
meanstdfeat<-grep("-mean\\(\\)|-std\\(\\)", features[, 2])
xbind<-xbind[,meanstdfeat]
names(xbind) <- features[meanstdfeat, 2]
names(xbind) <- gsub("\\(|\\)", "", names(xbind))
names(xbind) <- tolower(names(xbind))

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
ybind[,1] = activities[ybind[,1], 2]
names(ybind) <- "activity"

names(sbind) <- "subject"
allbind <- cbind(sbind, ybind, xbind)
write.table(allbind, "merged_data.txt")

uniques = unique(sbind)[,1]
nums = length(unique(sbind)[,1])
numa = length(activities[,1])
numc = dim(allbind)[2]
result = allbind[1:(nums*numa), ]

row = 1
for (i in 1:nums) {
    for (j in 1:numa) {
        result[row, 1] = uniques[i]
        result[row, 2] = activities[j, 2]
        tmp <- allbind[allbind$subject==i & allbind$activity==activities[j, 2], ]
        result[row, 3:numc] <- colMeans(tmp[, 3:numc])
        row = row+1
    }
}
write.table(result, "./result.txt",row.name=FALSE)
