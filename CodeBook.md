# Getting_data_Project
This code book describes
    + the variables,
    + the data, and
    + any transformations or work that you performed to clean up the data

## Description of the variables


## The data
The data was collected from the accelerometers from the Samsung Galaxy S smartphone on 30 individuals performed 6 basic movements
1. Standing
2. Sitting
3. Lying
4. Walking
5. Walking up
6. Walking down

70% of the volunteers generated training data and 30% test data.
## The raw data processing and cleaning-up

1. Since all files containing actual data have distinct names, I manually put them all in a directory called dataset
    + that is easier to handle in the R console
2. I read in each file individually with readLines() and immediately transformed them as data.table