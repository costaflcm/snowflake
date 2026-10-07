/*
---------------------------------------------------------------------------------------------------
    Example: Create a gold table read directly from the silver table in Snowflake
        📌 We will create an Detailed view of the data and an aggregated view
---------------------------------------------------------------------------------------------------
*/

-- Set warehouse, database, and schema to be used for data loading
use warehouse wh_sample ;
use database db_sample;
use schema gold;

-- Create a detailed data from the silver table
create or replace table fct_cars as
select
    make, 
    model, 
    type, 
    origin, 
    drivetrain,
    msrp, 
    invoice,
    msrp - invoice as margin,
    round(100 * (msrp - invoice) / nullif(msrp, 0), 2) as margin_pct,
    (mpg_city + mpg_highway) / 2 as mpg_combined,
    round(weight / nullif(horsepower, 0), 2) as weight_per_hp,
    case
        when msrp < 20000 then 'Economic'
        when msrp < 40000 then 'Intermediate'
        when msrp < 70000 then 'Premium'
        else 'Luxury'
    end as price_range,
    enginesize, 
    cylinders, 
    horsepower,
    mpg_city, 
    mpg_highway, 
    weight, 
    wheelbase, 
    length
from 
    silver.cars;

-- Check first 5 rows of the detailed table
select * from fct_cars limit 5;

-- Create an aggregated view of the data
create or replace view cars_summary as
select
    make,
    type,
    origin,
    drivetrain,

    -- model count
    count(*)                                        as model_count,

    -- price and margin
    round(avg(msrp), 2)                             as avg_msrp,
    round(avg(invoice), 2)                          as avg_invoice,
    round(avg(msrp - invoice), 2)                   as avg_margin,
    round(100 * avg((msrp - invoice) / nullif(msrp, 0)), 2) as avg_margin_pct,
    min(msrp)                                       as min_msrp,
    max(msrp)                                       as max_msrp,

    -- performance and engine
    round(avg(horsepower), 1)                       as avg_horsepower,
    round(avg(enginesize), 2)                       as avg_engine_size,
    round(avg(cylinders), 1)                        as avg_cylinders,
    round(avg(horsepower / nullif(enginesize, 0)), 1) as avg_hp_per_liter,
    round(avg(weight / nullif(horsepower, 0)), 2)   as avg_weight_per_hp,

    -- fuel economy
    round(avg(mpg_city), 1)                         as avg_city_mpg,
    round(avg(mpg_highway), 1)                      as avg_highway_mpg,
    round(avg((mpg_city + mpg_highway) / 2), 1)     as avg_combined_mpg,

    -- dimensions
    round(avg(weight), 0)                           as avg_weight,
    round(avg(wheelbase), 1)                        as avg_wheelbase,
    round(avg(length), 1)                           as avg_length
from 
    silver.cars
group by 
    make, 
    type, 
    origin, 
    drivetrain;

-- Check first 5 rows of the aggregated table
select * from cars_summary limit 5;