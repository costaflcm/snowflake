/*
---------------------------------------------------------------------------------------------------
    Example: Create Databases and Schemas in Snowflake

        📌 A database is a logical container for storing data in Snowflake. 
        📌 A schema is a logical container for storing tables and other database objects within a database.

        💡 You can create a database and schema using the SQL commands or click on the "Create Database" 
        button in the Snowflake web interface.
---------------------------------------------------------------------------------------------------
*/

-- Set warehouse to be used for database and schema creation
use warehouse wh_sample ;

-- Create a database with a comment
create database if not exists db_sample comment = 'A sample database for demonstrating Snowflake features' ;

-- Create schemas with medallion architecture (bronze, silver, gold)
create schema if not exists db_sample.bronze comment = 'Schema to storage the raw data' ;
create schema if not exists db_sample.silver comment = 'Schema to storage the cleaned and transformed data' ;
create schema if not exists db_sample.gold   comment = 'Schema to storage the aggregated data' ;
create schema if not exists db_sample.pipelines comment= 'Schema to orchestration pipelines' ;

-- Create a Stage on Bronze Schema ;
create stage if not exists bronze.stg_csv;