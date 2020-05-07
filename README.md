# Getting-and-Cleaning-Data-Course-Project
It's for a Coursera class from Johns Hopkins. What can you do?

The script starts by reading in the 561 data labels. We don't need all the data, but we need the names so we can know what we do need.
A quick grepl() to look for anything with "mean" or "std" in the title finds which variables we do need. This is used several times later.
Read in the activity being performed for each measurement in the training set, as well as the participant. We'll append that to the data later.
Create a data frame to hold all the data labeled "mean" or "std". It's better computationally to make it once, then add to it inside the loop, rather than add a little at a time in the loop.
The data frame also holds the participant and activity (number, not descriptor) in the first columns.
For() loop reads in one line at a time, and copies in the measurements that have "mean" or "std" in the description. I hard-coded in the total length here, would be better to read the length of the data file I suppose.
Do the same making of a frame and reading in data for the test data.
Put them together with rbind(). That was the easy part. Step 1 complete.
Step 2 was already handled, I only saved the data with "mean" or "std" in it. The rest never got moved, it was over-written in the buffer.
Step 3 is just labeling the activities as they were labeled. There has to be a neater way, using Xapply or something, but this worked.
Step 4 copies over the names of the measurements and uses them to label the columns of the combined data. Again, the nested for and if seem inelegant but they do work.
Making the tidy data was really easy using melt() and dcast(). I cast a couple other things as well, mostly for fun and partly because I was not certain what the assignment called for.

This can surely be optimized to run faster, it takes a significant amount of time on my reasonably new laptop. Reducing the number of rows read helps, so that is probably where I should optimize. But the assignment was to make code, not to make optimal code, and I've beaten my head against the wall enough with some of these steps.
