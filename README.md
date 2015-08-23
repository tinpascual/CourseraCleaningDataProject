##Readme for run_analysis.R

###Purpose

Extracts mean and standard deviation measurements, and tidies data from testing and training data from the [Human Activity Recognition Using Smartphones Data Set](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

###Output

A tidy data set tidy_data.txt

###Required R packages

- dplyr - for summarizing data (summarise_each) and command piping (%>%)
- stringr - for renaming column names (str_replace_all)

###Data files needed (download files [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extract to the same directory as script):
- activity_labels.txt - contains physical activity names
- features.txt - contains measurement names
- test/subject_test.txt and train/subject_train.txt - contain the ID numbers of the subjects in the experiment
- test/y_test.txt and test/y_test.txt - contain the numeric codes of the physical activities done by the subjects
- test/X_test.txt and /train/X_train.txt - contain the numeric test measurements

###Script steps: (steps 2-7 must be done for both test and train data sets)

1. Read files into separate data sets.
2. Bind the test activities numeric codes with their corresponding descriptive activity names.
4. Bind subject ID and activity names, and assign column names "SubjectID" and "ActivityName".
5. Name the columns in the test and train measurement data sets using data from the measurement names data set.
6. Grep columns in the measurements data sets from step _ which contain means or standard deviations (column name has either "mean()" or "std()"). Subset the data sets based on the column numbers obtained in this grep.
7. Column bind data sets from steps 4 and 6.
8. Row bind test and train data sets from step 7 to create one data set.
9. Summarize the dataset by SubjectID and ActivityName.
10. Rename parts of the column names of the summarized data set to make it more readable:
  - "fBodyBody" and "fBody" to "freqBody")
  - "tBody" to "timeBody"
  - "tGravity" to "timeGravity"
  - "Acc" to "Accelorometer"
  - "Gyro" to "Gyroscope"
  - "Mag" to "Magnitude"
  - "-mean()" to "Mean"
  - "-std()" to "StdDeviation"
  - "-X" to "XAxis"
  - "-Y" to "YAxis"
  - "-Z" to "ZAxis"
11. Write tidy data set to tidy_data.txt with row.name = FALSE.