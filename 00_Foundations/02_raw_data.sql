/*
---------------------------------------------------------------------------------------------------
    Example: Create a bronze table and load data from a staged CSV file in Snowflake

        📌 In this example the .csv file must be in the stage
        📌 Raw data is a copy of the original data, no transformations applied.       

        💡 You can create a file format to check data structure before loading in the table
---------------------------------------------------------------------------------------------------
*/

-- Set warehouse, database, and schema to be used for data loading
use warehouse wh_sample ;
use database db_sample ;
use schema bronze ;


-- Create a file format for CSV files without a field delimiter to check the structure of the file
create or replace file format csv_no_dlm
    type = 'CSV'
    field_delimiter = none 
    record_delimiter = '\n'
;

-- Check the structure of the CSV file by selecting the first column from the staged file
select $1
from @stg_csv/cars.csv
(file_format => 'csv_no_dlm')
limit 5;

-- Create a file format for CSV files delimited by commas, skipping the header row and treating 'NULL' and 'null' as null values
create file format if not exists csv_format
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL', 'null', '');

-- Create a table to store the raw data
create or replace table cars 
(
    make string,
    model string,
    type string,
    origin string,
    drivetrain string,
    msrp number,
    invoice number,
    enginesize number,
    cylinders number,
    horsepower number,
    mpg_city number,
    mpg_highway number,
    weight number,
    wheelbase number,
    length number
);

-- load data from the stage into the cars table
copy into cars
from @stg_csv/cars.csv
file_format = (format_name = csv_format)
on_error = 'continue';

-- Preview of cars table
select * from cars limit 5 ;