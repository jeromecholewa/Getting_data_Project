# ReadMe file
Description of the file: this explains how all of the scripts work and how they are connected.

1. I downloaded the zip file on Mon Sep 21 04:20:03 2015" (KST)
2. Since all files containing actual data have distinct names, I manually put  all 10 relevant files in a directory called dataset since it is easier to handle in the R console. These files are:
    + "activity_labels.txt"
    + "features_info.txt"
    + "features.txt"
    + "README.txt"
    + "subject_test.txt"
    + "subject_train.txt"
    + "X_test.txt"
    + "X_train.txt"
    + "y_test.txt"
    + "y_train.txt"
3. I read the "activity_labels.txt" file
4. I read the "y_test.txt" and the "subject_test.txt" files as data.tables
    + both have 2947 records in one column
    + I joined them together into 2 columns
    + I added one column called "category": all the values are "test"
    + I added one column called "activity" reflecting the column lab_act (numbers giving the activity done by the subject) by using the actual string of that activity, making it easy to read.
    + as a result I had a 2947 x 3 data.table
5. I did the same as 4. with the "y_train.txt" and "subject.train.txt" files
    +  as a result I had a 7352 x 3 data.table
    + the category value is "train", instead of "test"
6. I then joined the tables from steps 4 and 5 on top of each other
    + that subj_label_category data.table has dimension 10299 x 3
    + "test" data are the first 2947 rows
    + "train" data are the last 7352 rows
7. I read the "X_train.txt" with readLines
    + I observed that some lines start with double space followed by a positive number, or by a single space and a negative number
    + I observed that positive numbers are preceded by double spaces, whereas negative numbers are preceded only by a single space
    + therefore I first added one space at the beginning of each line starting with a negative number
    + then I could remove the double space from ALL lines
    + then I replaced all remaining double spaces in the middle of the lines by a single space
    + now I could transform the file as data.table and use separate(..., sep = " ", ...)
    + As a result I had a X_train_clean data.table with dimension 7352 x 561
8. I did the same with "X_test.txt"
    + As a result I had a X_test_clean data.table with dimension 2947 x 561
9. I joined the tables from steps 7 and 8 on top of each other
    + that X_all data.table has dimension 10299 x 561
    + "test" data are the first 2947 rows
    + "train" data are the last 7352 rows
10. In order to keep only the columns representing some means or standard deviation data, I used the "features.txt"
    + I read the "features.txt" file as text with read.table but kept only the character columns of the actual variable names (by dropping the index column)
    + I cleaned the variable names by removing the opening and closing parentheses, and by replacing the "-" and "," signs with "_" (underscore) by using "gsub()"
    + I created a "vars" character vector of those variables containing "mean", "Mean" or "std" only. "vars" has 86 values
    + I used "vars" to select (tidyr library) only those columns in the X_all data.table

### The result is the clean_data data.table dimension 10299 x 89

## Next step: summarize by activity and subject and get the mean of all 86 variables

1. First I removed the column "category" from the clean_data set
2. set I grouped this new data.table by "activity" and "subject"
3. Then I applied the summarise_each(funs(mean)) and save under the final data set
    + 30 subjects x 6 activities = 180 rows

### The result is the summary_clean data.table dimension 180 x 88
