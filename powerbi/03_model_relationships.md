# Power BI Model Relationships

Use these relationships in Model View.
Set cross-filter direction to Single unless mentioned otherwise.

## Date Relationships
vw_dim_date[date_key] 1 -> * vw_fact_orders[date_key]
vw_dim_date[date_key] 1 -> * vw_fact_feedback[date_key]
vw_dim_date[date_key] 1 -> * vw_fact_marketing[date_key]
vw_dim_date[date_key] 1 -> * vw_fact_inventory[date_key]

## Product Relationships
vw_dim_products[product_id] 1 -> * vw_fact_order_items[product_id]
vw_dim_products[product_id] 1 -> * vw_fact_inventory[product_id]

## Customer Relationships
vw_dim_customers[customer_id] 1 -> * vw_fact_orders[customer_id]

## Order Relationships
vw_fact_orders[order_id] 1 -> * vw_fact_order_items[order_id]
vw_fact_orders[order_id] 1 -> 1 vw_fact_delivery[order_id]
vw_fact_orders[order_id] 1 -> 1 vw_fact_feedback[order_id]

## Important Notes
- Mark vw_dim_date as the official Date Table.
- Use Import Mode for performance and easier graduation-demo reliability.
- Hide technical columns such as raw IDs unless needed for drill-through.
- Do not connect aggregated reporting views directly to the core model unless you need them for validation only.
