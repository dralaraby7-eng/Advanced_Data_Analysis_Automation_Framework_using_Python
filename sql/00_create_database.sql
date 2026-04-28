/*
Blinkit Graduation Project 
Create SQL Server database and schemas.

Run this in SSMS before running the Python loader.
*/

IF DB_ID('BlinkitDW') IS NULL
BEGIN
    CREATE DATABASE BlinkitDW;
END;
GO

USE BlinkitDW;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'rpt')
    EXEC('CREATE SCHEMA rpt');
GO

USE BlinkitDW;
GO

SELECT 
    s.name AS schema_name,
    t.name AS table_name
FROM sys.tables t
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'stg'
ORDER BY t.name;


SELECT COUNT(*) AS orders_count FROM stg.clean_orders;
SELECT COUNT(*) AS order_items_count FROM stg.clean_order_items;
SELECT COUNT(*) AS customers_count FROM stg.clean_customers;
SELECT COUNT(*) AS products_count FROM stg.clean_products;
SELECT COUNT(*) AS delivery_count FROM stg.clean_delivery;
SELECT COUNT(*) AS feedback_count FROM stg.clean_feedback;
SELECT COUNT(*) AS inventory_count FROM stg.clean_inventory;
SELECT COUNT(*) AS marketing_count FROM stg.clean_marketing;