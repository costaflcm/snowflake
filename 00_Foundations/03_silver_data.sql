/*
---------------------------------------------------------------------------------------------------
    Example: Create a silver table read directly from the bronze table in Snowflake

        📌 I n this example we will clean and transform the data from the bronze table.       
---------------------------------------------------------------------------------------------------
*/

-- Set warehouse, database, and schema to be used for data loading
use warehouse wh_sample ;
use database db_sample ;
use schema silver ;

-- Check if has any fields with null values in the bronze table
with ds as
(
    select
        row_number() over (order by 1) as rn,
        object_construct_keep_null(*) as obj
    from bronze.cars
),
nmss as
(
    select
        d.rn,
        array_agg(f.key) as colunas_com_missing
    from ds d,
         lateral flatten(input => d.obj) f
    where is_null_value(f.value)
       or trim(f.value::string) = ''
    group by d.rn
)
select d.obj, n.colunas_com_missing
from ds d
join nmss n on n.rn = d.rn; 

-- This table has no eletrical cars and missing values in cylinders is a error in the data, 
-- so we will remove these rows and create a new table in the silver schema with the cleaned data
DB_SAMPLE.SILVERcreate or replace table cars
as
select
    make,
    model,
    type,
    origin,
    drivetrain,
    msrp,
    invoice,
    enginesize,
    cylinders,
    horsepower,
    mpg_city,
    mpg_highway,
    weight,
    wheelbase,
    length
from bronze.cars
where cylinders is not null;

-- Check if the rows are removed from the silver table
select *
from cars
where cylinders is null;