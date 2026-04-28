# Step 3 Power BI Build Checklist

## Connect to SQL Server
1. Open Power BI Desktop.
2. Get Data > SQL Server.
3. Server: your SQL Server instance.
4. Database: BlinkitDW.
5. Data Connectivity mode: Import.
6. Select these views:
   - rpt.vw_dim_date
   - rpt.vw_dim_products
   - rpt.vw_dim_customers
   - rpt.vw_fact_orders
   - rpt.vw_fact_order_items
   - rpt.vw_fact_delivery
   - rpt.vw_fact_feedback
   - rpt.vw_fact_marketing
   - rpt.vw_fact_inventory
   - rpt.vw_data_quality_report

## Power Query Checks
- Confirm date columns are Date/DateTime.
- Confirm numeric columns are Decimal Number or Whole Number.
- Rename queries by removing rpt prefix if desired.
- Disable load for validation-only tables if not used.

## Model View
- Create relationships from the relationship file.
- Mark vw_dim_date as date table.
- Use single-direction filtering.

## Measures
- Create table _Measures using Enter Data.
- Add all measures from 01_dax_measures_core.txt.
- Format money measures as currency.
- Format percentage measures as percentage.
- Format rating as decimal with 2 digits.

## Executive Overview Page
- Add KPI cards.
- Add slicers.
- Add revenue trend.
- Add category/product performance.
- Add delivery and feedback visuals.
- Add marketing visuals.
- Add a small Data Quality insight section.

## Quality Validation
Compare Power BI cards with SQL:
SELECT * FROM rpt.vw_executive_kpis;

If the numbers match, the model is trusted.
