# Blinkit Power BI Executive Overview Page Wireframe

## Page Setup
- Canvas: 16:9
- Page name: Executive Overview
- Theme: Blinkit professional dark/green/yellow theme
- Main title: Blinkit Smart Commerce Intelligence Platform
- Subtitle: Sales, Delivery, Inventory, Marketing & Customer Experience Intelligence

## Top Section: KPI Cards
Use cards for:
1. Total Revenue
2. Total Orders
3. Active Customers
4. Average Order Value
5. Total Units Sold
6. Estimated Gross Profit
7. On Time Delivery %
8. Average Rating
9. Marketing ROAS

Suggested formatting:
- Big number
- Small label
- Optional secondary value such as MoM change

## Slicers
Place on the left or top-right:
- Date / Month
- Product Category
- Customer Segment
- Payment Method
- Delivery Status

## Visuals
1. Line chart: Revenue by Month
   - Axis: vw_dim_date[year_month]
   - Values: [Total Revenue]

2. Column chart: Orders by Month
   - Axis: vw_dim_date[year_month]
   - Values: [Total Orders]

3. Bar chart: Revenue by Category
   - Axis: vw_dim_products[category]
   - Values: [Product Revenue]
   - Sort descending by Product Revenue

4. Donut chart: Delivery Status Breakdown
   - Legend: vw_fact_orders[delivery_status]
   - Values: [Total Orders]

5. Bar chart: Top 10 Products by Revenue
   - Axis: vw_dim_products[product_name]
   - Values: [Product Revenue]
   - Visual filter: Top N = 10 by Product Revenue

6. Combo chart: Marketing Spend vs Revenue by Channel
   - Axis: vw_fact_marketing[channel]
   - Column values: [Marketing Spend]
   - Line values: [Marketing Revenue]

7. Scatter chart: Delivery Delay vs Rating
   - X-axis: Average Delay Minutes
   - Y-axis: Average Rating
   - Details: Delivery Status or Feedback Category

8. Matrix: Category Performance
   - Rows: Category
   - Values: Product Revenue, Total Units Sold, Estimated Gross Profit, Estimated Gross Margin %, Damage Rate

## Storytelling Notes
- Start by showing total business size.
- Show that delivery delays are a key customer experience risk.
- Show which categories/products drive revenue.
- Show marketing efficiency through ROAS.
- End with the ML and automation roadmap.
