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

-- Create a role for data engineering tasks and grant necessary privileges
create role if not exists db_sample comment = 'Role for data engineering tasks in db_sample' ;
grant usage, operate on warehouse wh_sample to role data_engineer ;
grant usage, create schema on database db_sample to role data_engineer ;
grant usage, create table, create view on all schemas in database db_sample to role data_engineer ;
grant usage, create table, create view on future schemas in database db_sample to role data_engineer ;
grant select, insert, update, delete, truncate on all tables in database db_sample to role data_engineer ;
grant select, insert, update, delete, truncate on future tables in database db_sample to role data_engineer ;
grant select on all views in database db_sample to role data_engineer ;
grant select on future views in database db_sample to role data_engineer ;