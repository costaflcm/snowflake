/*
---------------------------------------------------------------------------------------------------
    Example: Create a pipeline to orchestrate the execution of the bronze, silver and gold tables in Snowflake
        📌 We will create a root task that will trigger the execution of the other tasks
        📌 We will create a final task that will be executed at the end of the pipeline
---------------------------------------------------------------------------------------------------
*/

use warehouse wh_sample;
use database db_sample ;
use schema pipelines ;


-- Task 1: Root Schedule 
create or replace task cars_root_pipeline
    schedule = 'USING CRON 0 6 9 10 * America/Sao_Paulo'
    as select 'Start of Cars Sampe Pipeline' ;

-- Task2 Rawdata
create or replace task cars_bronze_pipeline
    after cars_root_pipeline
    as execute immediate from 'snow://workspace/USER$MCOSTA22.PUBLIC.DEFAULT$/versions/head/cars_example/cars_bronze.sql';

-- Task2 Silverdata
create or replace task cars_silver_pipeline
    after cars_bronze_pipeline
    as execute immediate from 'snow://workspace/USER$MCOSTA22.PUBLIC.DEFAULT$/versions/head/cars_example/cars_silver.sql';

create or replace task cars_gold_pipeline
    after cars_silver_pipeline
    as execute immediate from 'snow://workspace/USER$MCOSTA22.PUBLIC.DEFAULT$/versions/head/cars_example/cars_gold.sql';

-- Finaliza o pipeline com sucesso ou erro
create or replace task cars_root_pipeline_end
    finalize = cars_root_pipeline
as alter task cars_root_pipeline suspend ;

-- 6) Ativar: filhas primeiro, raiz por último
alter task cars_root_pipeline_end resume;
alter task cars_gold_pipeline     resume;
alter task cars_silver_pipeline   resume;
alter task cars_bronze_pipeline   resume;
alter task cars_root_pipeline     resume;