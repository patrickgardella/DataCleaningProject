Data Cleaning Project
===================

May 25, 2014

Original Dataset
----------------
The original source of the data for this project is taken from the Human Activity Recognition Using Smartphones Dataset Version 1.0 as compiled by:

> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Universit‡ degli Studi di Genova.
> Via Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws
> www.smartlab.ws

> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Dataset and Data Subset
-----------------------
For additional details of the original experiment and the specific details of the original dataset, they are available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones .

As noted in the original description of the data:
> The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

This work was conducted on a subset of the original dataset, and focuses specifically on the combined test and training data. It does *not* include the inertial signal sensor data, nor the all of the measurements. Our subset relies entirely on the Mean/Average and Standard Deviations of the measurement of the accelerometer and gyroscope data in both the time and frequency domain. Thus, the variables used in this work were selected from the original dataset by searching for *-mean()* and *-std()* character strings.

Steps to run the R Script
------------------------
1. Ensure that R is installed, 3.1.0 or later
2. Install the "reshape2" package: install.packages("reshape2") - Version 1.4 was used for this work
3. **Verify** that the "rows" variable is set to "-1" to ensure that all data is processed
4. Run the "run_analysis.R" script

What the R Script does
--------------------
* If the dataset is not present, it will download and then unzip the datafile into a subdirectory of the project
* The activity_labels.txt, features.txt, train/X_train.txt, train/y_train.txt, train/subject_train.txt, test/X_test.txt, and test/y_test.txt are loaded and merged into one large dataset
* The original activity numbers are replaced with the text associated with those numbers, per the original dataset's descriptions.
* The dataset is then subset using regular expressions as described in the **Dataset and Data Subset** section above
* The variable names are then modified per the **Codebook** attached
* For each variable, the average of each variable is calculated for each combination of subject and activity
* The resulting tidy data set is then stored in the file "./data/UCI-HAR-Averages.txt"

Platform used
-------------
> R version 3.1.0 (2014-04-10) -- "Spring Dance"
> Copyright (C) 2014 The R Foundation for Statistical Computing
> Platform: x86_64-apple-darwin13.1.0 (64-bit)

**Note** - This script has been run multiple times to ensure that it functions as expected.

Contributors
------------
[Patrick Gardella](http://www.asburyseminary.edu/person/patrick-s-gardela/) - Chief Programmer and Data Analyst