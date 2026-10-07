/*
---------------------------------------------------------------------------------------------------
    Example: Create a warehouse in Snowflake

        📌 A warehouse is a cluster of compute resources in Snowflake that provides the 
        necessary resources to perform operations on your data. 

        💡 You can create a warehouse using the SQL commands or click on the "Create Warehouse" 
        button in the Snowflake web interface.
---------------------------------------------------------------------------------------------------
*/
 -- Create the warehouse using the parameters
create warehouse if not exists wh_sample -- name is a string 
with 
    warehouse_size = 'X-Small' -- size is a string (e.g., 'X-Small', 'Small', 'Medium', 'Large', 'X-Large') 
    auto_suspend   = 60 -- auto-suspend is an integer (in seconds) 
    auto_resume    = true -- auto-resume is a boolean (true or false)
;