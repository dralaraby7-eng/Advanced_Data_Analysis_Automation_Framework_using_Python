/*
Blinkit Graduation Project - Step 2
Gold / Reporting Views for Power BI, ML, and Chatbot.

*/

USE BlinkitDW;
GO

/* ============================================================
   DIMENSIONS
============================================================ */

CREATE OR ALTER VIEW rpt.vw_dim_date AS
WITH all_dates AS (
    SELECT CAST(order_date AS date) AS date_value
    FROM stg.clean_orders

    UNION

    SELECT CAST([date] AS date) AS date_value
    FROM stg.clean_inventory

    UNION

    SELECT CAST([date] AS date) AS date_value
    FROM stg.clean_marketing

    UNION

    SELECT CAST(feedback_date AS date) AS date_value
    FROM stg.clean_feedback
)
SELECT DISTINCT
    CAST(CONVERT(varchar(8), date_value, 112) AS int) AS date_key,
    date_value AS [date],
    YEAR(date_value) AS [year],
    MONTH(date_value) AS [month_number],
    DATENAME(month, date_value) AS [month_name],
    CONCAT(YEAR(date_value), '-', RIGHT('0' + CAST(MONTH(date_value) AS varchar(2)), 2)) AS year_month,
    DAY(date_value) AS [day],
    DATEPART(quarter, date_value) AS [quarter],
    DATEPART(week, date_value) AS week_number,
    DATENAME(weekday, date_value) AS day_name,
    DATEPART(weekday, date_value) AS day_of_week,
    CASE WHEN DATENAME(weekday, date_value) IN ('Friday', 'Saturday', 'Sunday') THEN 1 ELSE 0 END AS is_weekend
FROM all_dates
WHERE date_value IS NOT NULL;
GO


CREATE OR ALTER VIEW rpt.vw_dim_products AS
SELECT
    product_id,
    product_name,
    category,
    brand,
    price,
    mrp,
    margin_percentage,
    shelf_life_days,
    min_stock_level,
    max_stock_level,
    CASE
        WHEN shelf_life_days <= 7 THEN 'Short Shelf Life'
        WHEN shelf_life_days <= 30 THEN 'Medium Shelf Life'
        ELSE 'Long Shelf Life'
    END AS shelf_life_group,
    CASE
        WHEN margin_percentage >= 35 THEN 'High Margin'
        WHEN margin_percentage >= 20 THEN 'Medium Margin'
        ELSE 'Low Margin'
    END AS margin_group
FROM stg.clean_products;
GO


CREATE OR ALTER VIEW rpt.vw_dim_customers AS
SELECT
    customer_id,
    customer_name,
    email,
    phone,
    [address],
    area,
    pincode,
    registration_date,
    customer_segment,
    actual_total_orders,
    actual_total_revenue,
    actual_avg_order_value,
    first_order_date,
    last_order_date,
    delayed_orders,
    customer_delay_rate,
    CASE
        WHEN actual_total_revenue >= 10000 THEN 'VIP'
        WHEN actual_total_revenue >= 5000 THEN 'High Value'
        WHEN actual_total_revenue > 0 THEN 'Regular'
        ELSE 'No Purchase'
    END AS value_segment,
    CASE
        WHEN actual_total_orders >= 5 THEN 'Loyal'
        WHEN actual_total_orders BETWEEN 2 AND 4 THEN 'Repeat'
        WHEN actual_total_orders = 1 THEN 'One Time'
        ELSE 'No Orders'
    END AS frequency_segment
FROM stg.clean_customers;
GO


/* ============================================================
   FACT VIEWS
============================================================ */

CREATE OR ALTER VIEW rpt.vw_fact_orders AS
SELECT
    order_id,
    customer_id,
    CAST(CONVERT(varchar(8), CAST(order_date AS date), 112) AS int) AS date_key,
    CAST(order_date AS date) AS order_date_only,
    order_date,
    promised_delivery_time,
    actual_delivery_time,
    delivery_status,
    order_total,
    payment_method,
    delivery_partner_id,
    store_id,
    order_year,
    order_month,
    order_day_name,
    order_hour,
    delivery_delay_minutes,
    is_delayed
FROM stg.clean_orders;
GO


CREATE OR ALTER VIEW rpt.vw_fact_order_items AS
SELECT
    ROW_NUMBER() OVER (ORDER BY order_id, product_id) AS order_item_key,
    order_id,
    product_id,
    quantity,
    unit_price,
    total_price AS source_total_price,
    line_calc_total,
    order_total,
    order_calc_total,
    adjusted_line_revenue,
    estimated_gross_profit,
    margin_percentage
FROM stg.clean_order_items;
GO


CREATE OR ALTER VIEW rpt.vw_fact_delivery AS
SELECT
    order_id,
    delivery_partner_id,
    promised_time,
    actual_time,
    delivery_time_minutes,
    distance_km,
    delivery_status,
    COALESCE(reasons_if_delayed, 'No Delay') AS reasons_if_delayed
FROM stg.clean_delivery;
GO


CREATE OR ALTER VIEW rpt.vw_fact_feedback AS
SELECT
    feedback_id,
    order_id,
    customer_id,
    CAST(CONVERT(varchar(8), CAST(feedback_date AS date), 112) AS int) AS date_key,
    rating,
    feedback_text,
    feedback_category,
    sentiment,
    feedback_date
FROM stg.clean_feedback;
GO


CREATE OR ALTER VIEW rpt.vw_fact_marketing AS
SELECT
    campaign_id,
    campaign_name,
    CAST(CONVERT(varchar(8), CAST([date] AS date), 112) AS int) AS date_key,
    CAST([date] AS date) AS campaign_date,
    target_audience,
    channel,
    impressions,
    clicks,
    conversions,
    spend,
    revenue_generated,
    roas AS source_roas,
    calculated_roas,
    ctr,
    conversion_rate,
    cpc,
    cpa
FROM stg.clean_marketing;
GO


CREATE OR ALTER VIEW rpt.vw_fact_inventory AS
SELECT
    product_id,
    CAST(CONVERT(varchar(8), CAST([date] AS date), 112) AS int) AS date_key,
    CAST([date] AS date) AS inventory_date,
    stock_received,
    damaged_stock,
    net_stock_received,
    product_name,
    category,
    min_stock_level,
    max_stock_level,
    CASE
        WHEN stock_received = 0 THEN 0
        ELSE CAST(damaged_stock AS float) / NULLIF(stock_received, 0)
    END AS damage_rate
FROM stg.clean_inventory;
GO


/* ============================================================
   KPI AND ANALYTICAL VIEWS
============================================================ */

CREATE OR ALTER VIEW rpt.vw_executive_kpis AS
WITH orders_kpi AS (
    SELECT
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS active_customers,
        SUM(order_total) AS total_revenue,
        AVG(order_total) AS avg_order_value,
        AVG(CAST(is_delayed AS float)) AS delayed_order_rate,
        AVG(CAST(CASE WHEN delivery_status = 'On Time' THEN 1 ELSE 0 END AS float)) AS on_time_delivery_rate,
        AVG(delivery_delay_minutes) AS avg_delivery_delay_minutes
    FROM stg.clean_orders
),
items_kpi AS (
    SELECT
        SUM(quantity) AS total_units_sold,
        SUM(estimated_gross_profit) AS estimated_gross_profit
    FROM stg.clean_order_items
),
feedback_kpi AS (
    SELECT
        AVG(CAST(rating AS float)) AS avg_rating
    FROM stg.clean_feedback
),
marketing_kpi AS (
    SELECT
        SUM(spend) AS total_marketing_spend,
        SUM(revenue_generated) AS marketing_revenue,
        SUM(revenue_generated) / NULLIF(SUM(spend), 0) AS overall_roas
    FROM stg.clean_marketing
)
SELECT
    o.total_orders,
    o.active_customers,
    o.total_revenue,
    o.avg_order_value,
    i.total_units_sold,
    i.estimated_gross_profit,
    i.estimated_gross_profit / NULLIF(o.total_revenue, 0) AS estimated_gross_margin,
    o.on_time_delivery_rate,
    o.delayed_order_rate,
    o.avg_delivery_delay_minutes,
    f.avg_rating,
    m.total_marketing_spend,
    m.marketing_revenue,
    m.overall_roas
FROM orders_kpi o
CROSS JOIN items_kpi i
CROSS JOIN feedback_kpi f
CROSS JOIN marketing_kpi m;
GO


CREATE OR ALTER VIEW rpt.vw_sales_daily AS
WITH feedback_daily AS (
    SELECT
        CAST(feedback_date AS date) AS feedback_date,
        AVG(CAST(rating AS float)) AS avg_rating,
        COUNT(*) AS feedback_count
    FROM stg.clean_feedback
    GROUP BY CAST(feedback_date AS date)
)
SELECT
    CAST(o.order_date AS date) AS order_date,
    CAST(CONVERT(varchar(8), CAST(o.order_date AS date), 112) AS int) AS date_key,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS active_customers,
    SUM(o.order_total) AS total_revenue,
    AVG(o.order_total) AS avg_order_value,
    SUM(o.is_delayed) AS delayed_orders,
    AVG(CAST(CASE WHEN o.delivery_status = 'On Time' THEN 1 ELSE 0 END AS float)) AS on_time_rate,
    AVG(o.delivery_delay_minutes) AS avg_delay_minutes,
    fd.avg_rating,
    fd.feedback_count
FROM stg.clean_orders o
LEFT JOIN feedback_daily fd
    ON CAST(o.order_date AS date) = fd.feedback_date
GROUP BY
    CAST(o.order_date AS date),
    fd.avg_rating,
    fd.feedback_count;
GO


CREATE OR ALTER VIEW rpt.vw_product_performance AS
SELECT
    oi.product_id,
    oi.product_name,
    oi.category,
    oi.brand,
    COUNT(DISTINCT oi.order_id) AS orders_count,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.adjusted_line_revenue) AS revenue,
    SUM(oi.estimated_gross_profit) AS estimated_gross_profit,
    SUM(oi.estimated_gross_profit) / NULLIF(SUM(oi.adjusted_line_revenue), 0) AS estimated_margin,
    AVG(oi.unit_price) AS avg_unit_price,
    AVG(oi.margin_percentage) AS avg_margin_percentage
FROM stg.clean_order_items oi
GROUP BY
    oi.product_id,
    oi.product_name,
    oi.category,
    oi.brand;
GO


CREATE OR ALTER VIEW rpt.vw_category_performance AS
SELECT
    oi.category,
    COUNT(DISTINCT oi.order_id) AS orders_count,
    COUNT(DISTINCT oi.product_id) AS products_count,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.adjusted_line_revenue) AS revenue,
    SUM(oi.estimated_gross_profit) AS estimated_gross_profit,
    SUM(oi.estimated_gross_profit) / NULLIF(SUM(oi.adjusted_line_revenue), 0) AS estimated_margin,
    AVG(oi.margin_percentage) AS avg_margin_percentage
FROM stg.clean_order_items oi
GROUP BY oi.category;
GO


CREATE OR ALTER VIEW rpt.vw_delivery_analysis AS
SELECT
    d.delivery_partner_id,
    d.delivery_status,
    COALESCE(d.reasons_if_delayed, 'No Delay') AS reasons_if_delayed,
    COUNT(DISTINCT d.order_id) AS orders_count,
    AVG(d.delivery_time_minutes) AS avg_delivery_time_minutes,
    AVG(d.distance_km) AS avg_distance_km,
    AVG(CAST(f.rating AS float)) AS avg_rating,
    AVG(CASE WHEN d.delivery_status = 'On Time' THEN 1.0 ELSE 0.0 END) AS on_time_rate
FROM stg.clean_delivery d
LEFT JOIN stg.clean_feedback f
    ON d.order_id = f.order_id
GROUP BY
    d.delivery_partner_id,
    d.delivery_status,
    COALESCE(d.reasons_if_delayed, 'No Delay');
GO


CREATE OR ALTER VIEW rpt.vw_customer_360 AS
SELECT
    c.customer_id,
    c.customer_name,
    c.area,
    c.pincode,
    c.registration_date,
    c.customer_segment,
    c.actual_total_orders,
    c.actual_total_revenue,
    c.actual_avg_order_value,
    c.first_order_date,
    c.last_order_date,
    c.delayed_orders,
    c.customer_delay_rate,
    AVG(CAST(f.rating AS float)) AS avg_customer_rating,
    COUNT(f.feedback_id) AS feedback_count,
    CASE
        WHEN c.actual_total_revenue >= 10000 THEN 'VIP'
        WHEN c.actual_total_revenue >= 5000 THEN 'High Value'
        WHEN c.actual_total_revenue > 0 THEN 'Regular'
        ELSE 'No Purchase'
    END AS value_segment,
    CASE
        WHEN c.customer_delay_rate >= 0.50 THEN 'High Delay Experience'
        WHEN c.customer_delay_rate >= 0.25 THEN 'Medium Delay Experience'
        ELSE 'Low Delay Experience'
    END AS delivery_experience_segment
FROM stg.clean_customers c
LEFT JOIN stg.clean_feedback f
    ON c.customer_id = f.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.area,
    c.pincode,
    c.registration_date,
    c.customer_segment,
    c.actual_total_orders,
    c.actual_total_revenue,
    c.actual_avg_order_value,
    c.first_order_date,
    c.last_order_date,
    c.delayed_orders,
    c.customer_delay_rate;
GO


CREATE OR ALTER VIEW rpt.vw_marketing_performance AS
SELECT
    campaign_id,
    campaign_name,
    CAST([date] AS date) AS campaign_date,
    CAST(CONVERT(varchar(8), CAST([date] AS date), 112) AS int) AS date_key,
    target_audience,
    channel,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    SUM(spend) AS spend,
    SUM(revenue_generated) AS revenue_generated,
    SUM(revenue_generated) / NULLIF(SUM(spend), 0) AS calculated_roas,
    SUM(clicks) / NULLIF(CAST(SUM(impressions) AS float), 0) AS ctr,
    SUM(conversions) / NULLIF(CAST(SUM(clicks) AS float), 0) AS conversion_rate,
    SUM(spend) / NULLIF(SUM(clicks), 0) AS cpc,
    SUM(spend) / NULLIF(SUM(conversions), 0) AS cpa
FROM stg.clean_marketing
GROUP BY
    campaign_id,
    campaign_name,
    CAST([date] AS date),
    target_audience,
    channel;
GO


CREATE OR ALTER VIEW rpt.vw_inventory_risk AS
WITH sales AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.adjusted_line_revenue) AS revenue,
        SUM(oi.estimated_gross_profit) AS estimated_gross_profit
    FROM stg.clean_order_items oi
    GROUP BY oi.product_id
),
supply AS (
    SELECT
        product_id,
        SUM(stock_received) AS total_stock_received,
        SUM(damaged_stock) AS total_damaged_stock,
        SUM(net_stock_received) AS total_net_stock_received
    FROM stg.clean_inventory
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    p.min_stock_level,
    p.max_stock_level,
    COALESCE(sales.units_sold, 0) AS units_sold,
    COALESCE(supply.total_stock_received, 0) AS total_stock_received,
    COALESCE(supply.total_damaged_stock, 0) AS total_damaged_stock,
    COALESCE(supply.total_net_stock_received, 0) AS total_net_stock_received,
    COALESCE(supply.total_net_stock_received, 0) - COALESCE(sales.units_sold, 0) AS supply_demand_gap,
    COALESCE(supply.total_damaged_stock, 0) / NULLIF(CAST(COALESCE(supply.total_stock_received, 0) AS float), 0) AS damage_rate,
    COALESCE(sales.revenue, 0) AS revenue,
    COALESCE(sales.estimated_gross_profit, 0) AS estimated_gross_profit,
    CASE
        WHEN COALESCE(supply.total_net_stock_received, 0) - COALESCE(sales.units_sold, 0) < p.min_stock_level THEN 'High Shortage Risk'
        WHEN COALESCE(supply.total_damaged_stock, 0) / NULLIF(CAST(COALESCE(supply.total_stock_received, 0) AS float), 0) >= 0.05 THEN 'High Damage Risk'
        ELSE 'Healthy'
    END AS inventory_risk_status
FROM stg.clean_products p
LEFT JOIN sales
    ON p.product_id = sales.product_id
LEFT JOIN supply
    ON p.product_id = supply.product_id;
GO


/* ============================================================
   MACHINE LEARNING TRAINING VIEWS
============================================================ */

CREATE OR ALTER VIEW rpt.vw_ml_daily_product_demand AS
SELECT
    CAST(o.order_date AS date) AS demand_date,
    CAST(CONVERT(varchar(8), CAST(o.order_date AS date), 112) AS int) AS date_key,
    oi.product_id,
    oi.product_name,
    oi.category,
    oi.brand,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.adjusted_line_revenue) AS revenue,
    SUM(oi.estimated_gross_profit) AS estimated_gross_profit,
    COUNT(DISTINCT o.order_id) AS orders_count,
    COUNT(DISTINCT o.customer_id) AS customers_count,
    YEAR(o.order_date) AS [year],
    MONTH(o.order_date) AS [month],
    DAY(o.order_date) AS [day],
    DATEPART(weekday, o.order_date) AS day_of_week,
    DATENAME(weekday, o.order_date) AS day_name,
    CASE WHEN DATENAME(weekday, o.order_date) IN ('Friday', 'Saturday', 'Sunday') THEN 1 ELSE 0 END AS is_weekend
FROM stg.clean_order_items oi
INNER JOIN stg.clean_orders o
    ON oi.order_id = o.order_id
GROUP BY
    CAST(o.order_date AS date),
    oi.product_id,
    oi.product_name,
    oi.category,
    oi.brand,
    YEAR(o.order_date),
    MONTH(o.order_date),
    DAY(o.order_date),
    DATEPART(weekday, o.order_date),
    DATENAME(weekday, o.order_date);
GO


CREATE OR ALTER VIEW rpt.vw_ml_daily_category_demand AS
SELECT
    CAST(o.order_date AS date) AS demand_date,
    CAST(CONVERT(varchar(8), CAST(o.order_date AS date), 112) AS int) AS date_key,
    oi.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.adjusted_line_revenue) AS revenue,
    SUM(oi.estimated_gross_profit) AS estimated_gross_profit,
    COUNT(DISTINCT oi.product_id) AS active_products_count,
    COUNT(DISTINCT o.order_id) AS orders_count,
    COUNT(DISTINCT o.customer_id) AS customers_count,
    YEAR(o.order_date) AS [year],
    MONTH(o.order_date) AS [month],
    DAY(o.order_date) AS [day],
    DATEPART(weekday, o.order_date) AS day_of_week,
    DATENAME(weekday, o.order_date) AS day_name,
    CASE WHEN DATENAME(weekday, o.order_date) IN ('Friday', 'Saturday', 'Sunday') THEN 1 ELSE 0 END AS is_weekend
FROM stg.clean_order_items oi
INNER JOIN stg.clean_orders o
    ON oi.order_id = o.order_id
GROUP BY
    CAST(o.order_date AS date),
    oi.category,
    YEAR(o.order_date),
    MONTH(o.order_date),
    DAY(o.order_date),
    DATEPART(weekday, o.order_date),
    DATENAME(weekday, o.order_date);
GO


/* ============================================================
   DATA QUALITY REPORT VIEW
============================================================ */

CREATE OR ALTER VIEW rpt.vw_data_quality_report AS
SELECT
    'Order item price mismatch' AS issue_name,
    CAST(SUM(CASE WHEN ABS(total_price - line_calc_total) > 0.01 THEN 1 ELSE 0 END) AS float) AS issue_count,
    CAST(COUNT(*) AS float) AS total_count,
    CAST(SUM(CASE WHEN ABS(total_price - line_calc_total) > 0.01 THEN 1 ELSE 0 END) AS float) / NULLIF(COUNT(*), 0) AS issue_rate,
    'total_price does not match quantity * unit_price' AS business_meaning
FROM stg.clean_order_items

UNION ALL

SELECT
    'Marketing ROAS mismatch' AS issue_name,
    CAST(SUM(CASE WHEN ABS(roas - calculated_roas) > 0.01 THEN 1 ELSE 0 END) AS float) AS issue_count,
    CAST(COUNT(*) AS float) AS total_count,
    CAST(SUM(CASE WHEN ABS(roas - calculated_roas) > 0.01 THEN 1 ELSE 0 END) AS float) / NULLIF(COUNT(*), 0) AS issue_rate,
    'source roas does not match revenue_generated / spend' AS business_meaning
FROM stg.clean_marketing

UNION ALL

SELECT
    'Customer total orders mismatch' AS issue_name,
    CAST(SUM(CASE WHEN ABS(total_orders - actual_total_orders) > 0.01 THEN 1 ELSE 0 END) AS float) AS issue_count,
    CAST(COUNT(*) AS float) AS total_count,
    CAST(SUM(CASE WHEN ABS(total_orders - actual_total_orders) > 0.01 THEN 1 ELSE 0 END) AS float) / NULLIF(COUNT(*), 0) AS issue_rate,
    'customer table total_orders does not match actual orders table' AS business_meaning
FROM stg.clean_customers

UNION ALL

SELECT
    'High store_id cardinality' AS issue_name,
    CAST(COUNT(DISTINCT store_id) AS float) AS issue_count,
    CAST(COUNT(*) AS float) AS total_count,
    CAST(COUNT(DISTINCT store_id) AS float) / NULLIF(COUNT(*), 0) AS issue_rate,
    'store_id behaves almost like a transaction id, not a useful store dimension' AS business_meaning
FROM stg.clean_orders;
GO


/* ============================================================
   QUICK VALIDATION QUERIES
============================================================ */

SELECT 'vw_executive_kpis' AS view_name, COUNT(*) AS rows_count FROM rpt.vw_executive_kpis
UNION ALL SELECT 'vw_sales_daily', COUNT(*) FROM rpt.vw_sales_daily
UNION ALL SELECT 'vw_product_performance', COUNT(*) FROM rpt.vw_product_performance
UNION ALL SELECT 'vw_category_performance', COUNT(*) FROM rpt.vw_category_performance
UNION ALL SELECT 'vw_delivery_analysis', COUNT(*) FROM rpt.vw_delivery_analysis
UNION ALL SELECT 'vw_customer_360', COUNT(*) FROM rpt.vw_customer_360
UNION ALL SELECT 'vw_marketing_performance', COUNT(*) FROM rpt.vw_marketing_performance
UNION ALL SELECT 'vw_inventory_risk', COUNT(*) FROM rpt.vw_inventory_risk
UNION ALL SELECT 'vw_ml_daily_product_demand', COUNT(*) FROM rpt.vw_ml_daily_product_demand
UNION ALL SELECT 'vw_ml_daily_category_demand', COUNT(*) FROM rpt.vw_ml_daily_category_demand
UNION ALL SELECT 'vw_data_quality_report', COUNT(*) FROM rpt.vw_data_quality_report;
GO


SELECT * FROM rpt.vw_executive_kpis;

SELECT TOP 10 *
FROM rpt.vw_product_performance
ORDER BY revenue DESC;

SELECT *
FROM rpt.vw_data_quality_report;