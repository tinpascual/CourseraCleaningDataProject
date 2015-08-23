run_analysis<-function()
{
    require("dplyr")
    require("stringr")
    library(dplyr)
    library(stringr)
    
    #read all relevant files
    activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
    measLabels<-read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

    testSubjID<-read.table("UCI HAR Dataset/test/subject_test.txt")
    testMeas<-read.table("UCI HAR Dataset/test/X_test.txt")
    testActivities <-read.table("UCI HAR Dataset/test/y_test.txt")
    
    trainSubjID<-read.table("UCI HAR Dataset/train/subject_train.txt")
    trainMeas<-read.table("UCI HAR Dataset/train/X_train.txt")
    trainActivities <-read.table("UCI HAR Dataset/train/y_train.txt")
    
    # get descriptive activity names and add to new dataframe
    testActivitiesLabeled<-as.data.frame(matrix(0, ncol = 1, nrow = nrow(testActivities)))
    trainActivitiesLabeled<-as.data.frame(matrix(0, ncol = 1, nrow = nrow(trainActivities)))
    for (i in 1:nrow(testActivities))
    {
        testActivitiesLabeled[i, 1]<- activityLabels[as.integer(testActivities[i, 1]),2]    
    }
    for (i in 1:nrow(trainActivities))
    {
        trainActivitiesLabeled[i, 1]<- activityLabels[as.integer(trainActivities[i, 1]),2]    
    }
    # test/trainActivities and activityLabels are not used after this point
    
    # bind and label subjectID and activity columns
    testSubjActivities <- cbind(testSubjID, testActivitiesLabeled)
    colnames(testSubjActivities) <- c("SubjectID", "ActivityName")
    trainSubjActivities <- cbind(trainSubjID, trainActivitiesLabeled)
    colnames(trainSubjActivities) <- c("SubjectID", "ActivityName")
    # test/trainSubjID and test/trainActivitiesLabeled are not used after this point
    
    # label measurements tables with names from features.txt
    colnames(testMeas) <- measLabels[,2]
    colnames(trainMeas) <- measLabels[,2]
    #after this, don't use measurementLabels anymore
    
    # subset measurements with 
    colsToSubset<-grep("mean\\(\\)|std\\(\\)", measLabels[,2])
    testMeas <- testMeas[,colsToSubset]
    trainMeas <- trainMeas[,colsToSubset]
    
    #then colbind measurements and activities, and rbind test and train sets
    testSubjActivityMeas <-cbind(testSubjActivities, testMeas)
    trainSubjActivityMeas <-cbind(trainSubjActivities, trainMeas)
    mergedTestTrain <- rbind(testSubjActivityMeas, trainSubjActivityMeas)
    
    #summarize measurements by activity name
    summary<-mergedTestTrain%>%group_by(SubjectID,ActivityName)%>%summarise_each(funs(mean))

    #make column names more readable
    names<-names(summary)
    names <- str_replace_all(names, "fBodyBody", "fBody")
    names <- str_replace_all(names, "fBody", "freqBody")
    names <- str_replace_all(names, "tBody", "timeBody")
    names <- str_replace_all(names, "Acc", "Accelorometer")
    names <- str_replace_all(names, "Gyro", "Gyroscope")
    names <- str_replace_all(names, "-mean\\(\\)", "Mean")
    names <- str_replace_all(names, "-std\\(\\)", "StdDeviation")
    names <- str_replace_all(names, "-X", "XAxis")
    names <- str_replace_all(names, "-Y", "YAxis")
    names <- str_replace_all(names, "-Z", "ZAxis")
    names <- str_replace_all(names, "Mag", "Magnitude")
    colnames(summary)<-names
    
    summary
}

