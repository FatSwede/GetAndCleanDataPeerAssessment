CODE BOOK
=

The following will describe the process of refining the accelerometer data as outlined in the assignment.  This algorithm is a simple series of steps to be taken in order.  The output is CSV file that calculates the means of all of the mean and standard deviation variables included in the data files X_test.txt and X_train.txt.

*emphasis* denotes a variable name

**bold** denotes a function name

### STEP 1
- Specify the directory where the data files are located and store in the variable *dd*.

### STEP 2
- Load activity_labels.txt to the data frame *activity_lables* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *activity_labels*.
- This file contains the translation of activity codes to a more verbose description.

### Step 3
- Load features.txt to the data frame *features* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *features*.
- This file contains a vector of column headings for the main data files (X_test.txt and X_train.txt).

### Step 4
- Load subject_test.txt to the data frame *subject_test* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *subject_test*.
- This file contains a vector of all of the test subjects that correspond to the rows of X_test.txt.

### Step 5
- Load y_test.txt to the data frame *y_test* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *y_test*.
- The file contains a vector of the activities that correspond to the rows of X_test.txt.

### Step 6
- Load X_test.txt to the data frame *X_test* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *X_test*.  The descriptive names are sourced from column 2 of the *features* data frame.
- This is the main data file for the test data.

### Step 7
- Load subject_train.txt to the data frame *subject_train* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *subject_train*.
- This file contains a vector of all of the train subjects that correspond to the rows of X_train.txt.

### Step 8
- Load y_train.txt to the data frame *y_train* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *y_train*.
- The file contains a vector of the activities that correspond to the rows of X_train.txt.

### Step 9
- Load X_train.txt to the data frame *X_train* using **read.table**.  Use the **paste** function to build the file location.
- Use the **names** function to assign descriptive names to the columns of *X_train*.  The descriptive names are sourced from column 2 of the *features* data frame.
- This is the main data file for the train data.

### Step 10
- Combine all of the test data into a single data frame called *test_data*.  This can be accomplished using the **data.frame** function.

### Step 11
- Translate all of the activity codes from a number into a description.  This is done using the **merge** function on the *test_data* and *activity_labels* data frames and "joining" on Activity_ID.  The results are reassigned to the data frame *test_data*.

### Step 12
- Add a souce indicator column called source_ind to the data frame *test_data*.  This column will indicate that the data is test data.  This will become important after the test data and train data are combined together.

### Step 13
- Combine all of the train data into a single data frame called *train_data*.  This can be accomplished using the **data.frame** function.

### Step 14
- Translate all of the activity codes from a number into a description.  This is done using the **merge** function on the *train_data* and *activity_labels* data frames and "joining" on Activity_ID.  The results are reassigned to the data frame *train_data*.

### Step 15
- Add a source indicator column called source_ind to the data frame *train_data*.  This column will indicate that the data is train data.  This will become important after the test data and train data are combined together.

### Step 16
- Combine the test data and train data together using the function **rbind** and storing the results in the data frame *all_data*.  This data frame has the same column structure as both *test_data* and *train_data* but just "stacks" the 2 data frames one on top of the other.

### Step 17
- Limit the data to only the mean and standard deviation columns.  This is the most complicated step in the process and is broken down into multiple commands as follows:
1. Get the names of the columns of the data frame all_data and assign this vector to the variable *colnm*.
2. Use a regular expression to extract the column names from *colnm* that have either the string "mean" or "std".  The **grep** function with the regular expression to do this is ".*(mean|std).*".  Store the result in the variable *meanstdcols*.
3. The problem with the above regular expression is that it also returns some unwanted column names, specifically all column names that contain "meanFreq".  So using the same method as above, extract the column names that contain the string "meanFreq" and store them in the variable *mfcols*.
4. Now eliminate all of the column names that contain "meanFreq" from the *meanstdcols* vector and reassign the result to *meanstdcols*.
5. In addition to the mean and standard deviation measurements the data should also include the descriptive columns Subject_ID, Activity_ID, Activity_Description and source_ind.  So combine these values with the *meanstdcols* vector into the variable *selectcols*.
6. Finally, use the **subset** function to select all of the columns listed in *selectcols* and store the results in the data frame *final_data*.

### Step 18
- Use the **aggregate** function to calculate the mean for each column that is a measurement column and store the results in the data frame *agg*.  The mean will be calculated by subject by activity.  The **aggregate** function takes the following 3 arguments:
1. A data frame.  In this case all of the mean and standard deviation columns from *final_data*.  The non-measurement columns (Subject_ID, Activity_ID, Activity_Description, source_ind) are omitted.
2. A list of the grouping variables by which the aggregate will be calculated.  In this case *final_data*$Subject_ID and *final_data*$Activity_Description.
3. The aggregate function to apply to the data.  In this case the **mean** function.

### Step 19
- Save the final results in the data frame *agg* to a .CSV file using **write.table**.