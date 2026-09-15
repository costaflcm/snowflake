/*
---------------------------------------------------------------------------------
Program | zoop_pre_process.sql
Author  | Flávio Costa
---------------------------------------------------------------------------------
Snowflake Objects 
---------------------------------------------------------------------------------
WAREHOUSE
  - WH_ZOOP
    Virtual warehouse (XSMALL) for compute resources.

DATABASE
  - DB_ZOOP
    Database for the Zoop project.

SCHEMAS
  - BRONZE
    Raw data ingestion layer.
  - SILVER
    Cleaned and transformed data layer.
  - GOLD
    Business-ready analytical data layer.

FILE FORMAT
  - FF_CSV
    CSV file format for data ingestion.

STAGE
  - STAGE_VENDAS
    Internal stage for sales file storage and ingestion.
---------------------------------------------------------------------------------
*/

-- Exibir o Warehouse atual
select current_warehouse();

-- Criar um novo warehouse com computação extra pequena, suspensão automática após 60seg inativo, e com resumo automático
create warehouse wh_zoop
with
warehouse_size = 'XSMALL'
auto_suspend = 60
auto_resume = true ;

-- Definição de uso
use warehouse wh_zoop ;

-- Criar a base de dados
create database db_zoop ;

-- Criar os Schemas em formato Medallion
create schema bronze;
create schema silver;
create schema gold;

-- visualizar os schemas
show schemas ;

-- Fileformats
use schema bronze ;
create or replace file format ff_csv
type='csv'
field_delimiter = ','
skip_header=1
field_optionally_enclosed_by = '"'
null_if = ('null', 'NULL');

-- Stage
create stage if not exists stage_vendas file_format = ff_csv;
list @stage_vendas;