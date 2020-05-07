# Better make sure we have all the needed packages here
library("dplyr")
library("reshape2")
# Assignment step 1: Merges the training and the test sets to create one data set.
DataNames <- read.table("features.txt") # reads the 561 measurement labels
MeanStdNames <- grepl("mean|std",DataNames$V2)
# Now we have a boolean vector that's TRUE for measurements we care about, to let us pick out the right ones later
TrainColActivity <- read.table("Y_train.txt") # Reads the 6 kinds of activity
TrainParticipant <- read.table("subject_train.txt")
TrainData <- data.frame(matrix(0,nrow = 7352, ncol = (sum(MeanStdNames) +2)))
TrainData[,1] <- TrainParticipant
TrainData[,2] <- TrainColActivity
for(i in 1:7352) # 7352 is the right value, lower it for testing
{
  t <- i -1
  indexer <- 3
  Buffer <- scan(".X_train.txt", skip = t, quiet = TRUE, nlines = 1)
  for(j in 1:561)
  {
    if(MeanStdNames[j] == TRUE)
    {
      TrainData[i,indexer] <- Buffer[j]
      indexer <- indexer + 1
    }
  }
}

TestParticipant <- read.table("subject_test.txt")
TestColActivity <- read.table("Y_test.txt")
TestData <- data.frame(matrix(0,nrow = 2947, ncol = (sum(MeanStdNames) +2)))
TestData[,1] <- TestParticipant
TestData[,2] <- TestColActivity
for(i in 1:2947) # 2947 is the right value, lower it for testing
{
  t <- i -1
  indexer <- 3
  Buffer <- scan("X_test.txt", skip = t, quiet = TRUE, nlines = 1)
  for(j in 1:561)
  {
    if(MeanStdNames[j] == TRUE)
    {
      TestData[i,indexer] <- Buffer[j]
      indexer <- indexer + 1
    }
  }
}

AllData <- rbind(TestData,TrainData) # Step 1 - create one test set (of just means and std's) complete

# Assignment step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
# This was done during step 1, I only took the measurements with "mean" or "std" in their name.

# Assignment step 3 Uses descriptive activity names to name the activities in the data set
ActivityLabels <- read.table("/activity_labels.txt", stringsAsFactors = FALSE)
for(k in 1:6) # Here's where we give the activities reasonable names
{
  AllData[AllData[2]==k,2] <- ActivityLabels[k,2] # Over-write each of the 6 numbers with corresponding descriptor
}
# Now the activities all have names. Step 3 done.
# Assignment step 4 Appropriately labels the data set with descriptive variable names.
ColumnNames <- vector(length = (sum(MeanStdNames) +2)) # Mean/std variables we care about, plus 2 for labeling
ColumnNames[1] <- "Participant"
ColumnNames[2] <- "Activity"
indexer <- 3 # So we don't over-write what we just added in
for(j in 1:561)
{
  if(MeanStdNames[j] == 1)
  {
  ColumnNames[indexer] <- as.character(DataNames$V2[j])
    indexer <- indexer + 1
  }
}
colnames(AllData) <- ColumnNames # Now every (surviving) column has the same name as the original data set
#Step 4 complete

# Assignment step 5 From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

meltedalldata <- melt(AllData, id = c("Participant","Activity"),measure.vars=ColumnNames[3:81] )
ParticipantData <- dcast(meltedalldata, Participant ~ variable,fun.aggregate=mean)
ActivityData <- dcast(meltedalldata, Activity ~ variable,fun.aggregate=mean)
CompiledData <- dcast(meltedalldata, Activity + Participant ~ variable,fun.aggregate=mean)
#castdata is an 81 column data frame with the average value of each mean and std measurement for each participant and each activity
#Ends up being 180 rows, for 30 participants and 6 activities. Step 5 done.
#It's also useful to consider a data set that smushes together everything by participant or by activity
#Not hard to make those from CompiledData but they are included for completeness.