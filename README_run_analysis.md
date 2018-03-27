The run_analysis script downloads and unzips a file from the web. It then extracts it. 
All the nescesarry variables are loaded and assigned where the test and train dataset are seperated. 
The datasets are then combined and the labels are added.
As the data frame contains to much information a subset is being created with the mean and standard deviation only.
Then the activities are given the descriptive names to make things more easier readable.
In the end a tidy dataset is created with the average of each variable for each activity and each subject.
