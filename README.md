# getcleandata_finalproject

The script creates a file named "final.txt" containing the tidy data asked for by the project description.

It starts by reading the features.txt and activity_labels.txt which contain the measurement titles and activity names needed for labeling the dataset. Afterwards it creates a vector of strings to be used as column names for all the data frames.

Then it performs the same cleaning actions on both the test and train datasets:

    Loads the data in a dataframe
    Loads the subject codes for the data in a vector (found in "subject_test.txt" and "subject_train.txt")
    Adds a subjectCode column to the dataframe
    Loads the activityCodes for each row in a vector (found in "y_test.txt" and "y_train.txt")
    Adds an activityName column to the data frame by mapping each integer of the activityCodes to an activity name( using activityMapping table)
    Names the columns using the columnNames vector.

After we have 2 clean Data.Frames we bind them vertically.( with the rbind function ) We create a Logical vector ("filter") that returns true to the variables whose name contains either "std"(standard deviation) or "mean". We create a new data.frame by keeping only the variables with "mean" or "std" in their names, using the aforementioned filter.

We then load the plyr library that is needed for the next lines... Using the ddply function we create a dataset containing the average of each variable for each activity and each subject. Finaly the data are written to the file "final.txt"
