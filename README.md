# Advanced_Data_Analysis_Automation_Framework_using_Python

An advanced end-to-end data analysis, business intelligence, automation, and AI-powered analytics framework built for the **Blinkit Smart Commerce Intelligence Platform** graduation project.

This project combines **Python, SQL Server, Power BI, Machine Learning, n8n Automation, and AI Chatbot concepts** to transform raw commerce datasets into trusted business insights, executive dashboards, predictive intelligence, and automated decision-support workflows.

![Python](https://img.shields.io/badge/Python-3.x-blue)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Data%20Warehouse-red)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Automation](https://img.shields.io/badge/n8n-Automation-orange)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-Forecasting-green)
![Status](https://img.shields.io/badge/Status-Graduation%20Project-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📌 Project Title

# Blinkit Smart Commerce Intelligence Platform

**A complete DEPI Graduation Project for smart commerce analytics, business intelligence, automation, forecasting, and AI-assisted decision making.**

---

## 📌 Academic Context

This project was developed as a graduation project for **DEPI**.

The project demonstrates practical skills in:

- Data Analysis
- Data Cleaning
- SQL Server Data Warehousing
- Power BI Dashboarding
- DAX Measures
- Python Automation
- Business Intelligence
- Machine Learning Forecasting
- n8n Workflow Automation
- AI Chatbot Design
- GitHub Documentation & Version Control

---

## 📌 About The Project

Blinkit is a quick-commerce business model that depends on fast order processing, accurate inventory, effective marketing, reliable delivery, and high customer satisfaction.

The goal of this project is to build a complete smart analytics platform that helps the business answer critical questions such as:

- What are the total sales, orders, and customer trends?
- Which products and categories generate the most revenue?
- Which products are profitable, and which only drive volume?
- How does delivery delay affect customer satisfaction?
- Which marketing channels generate the best return?
- What inventory risks exist?
- Can future demand be forecasted?
- Can business users ask questions about the data using an AI chatbot?
- Can alerts and reports be automated using n8n?

This project is not just a dashboard.  
It is designed as a full **Smart Commerce Intelligence Platform**.

---

## 📌 Problem Statement

Blinkit needs better visibility into sales, products, customers, delivery performance, marketing ROI, inventory health, and customer satisfaction.

Traditional reporting is often limited to static dashboards and manual analysis. This creates several business challenges:

- Difficulty identifying revenue and profit drivers
- Limited visibility into delivery delays and customer experience
- Inconsistent raw data requiring cleaning and validation
- Weak connection between sales, inventory, feedback, and marketing
- Lack of automated alerts for business-critical issues
- No predictive layer for demand forecasting
- No conversational analytics interface for non-technical users

---

## 📌 Proposed Solution

The proposed solution is a complete analytics and automation framework that includes:

1. **Python Data Audit & Cleaning**
2. **SQL Server Data Warehouse**
3. **Trusted Reporting Views**
4. **Power BI Executive Dashboard**
5. **Sales & Product Deep-Dive Analysis**
6. **Customer Segmentation & Retention Analysis**
7. **Delivery Performance Analysis**
8. **Marketing ROI Analysis**
9. **Inventory Intelligence**
10. **Machine Learning Demand Forecasting**
11. **n8n Automation Workflows**
12. **AI Chatbot for Data Questions**
13. **Graduation Presentation Storyline**

---

## 📌 Project Objectives

The main objectives of this project are:

- Build a professional data analysis project from raw CSV files
- Clean and validate the data using Python
- Detect and document data quality issues
- Design a SQL Server data warehouse
- Build staging and reporting layers
- Create trusted KPIs from cleaned data
- Build an interactive Power BI dashboard
- Validate Power BI numbers against SQL Server
- Analyze sales, products, customers, delivery, marketing, feedback, and inventory
- Build a machine learning forecasting layer
- Design automation workflows using n8n
- Design an AI chatbot capable of answering questions from business data
- Present the project as a complete business intelligence product

---

## 📌 Dataset Overview

The project uses multiple Blinkit-related datasets:

| Dataset | Description |
|---|---|
| `blinkit_orders.csv` | Order-level transactional data |
| `blinkit_order_items.csv` | Product-level order details |
| `blinkit_products.csv` | Product catalog and margin data |
| `blinkit_customers.csv` | Customer profile data |
| `blinkit_delivery_performance.csv` | Delivery timing and performance |
| `blinkit_customer_feedback.csv` | Ratings, sentiment, and customer feedback |
| `blinkit_inventory.csv` | Inventory movement and damaged stock |
| `blinkit_marketing_performance.csv` | Campaign, spend, revenue, and channel performance |

---

## 📌 Key Business KPIs

The platform is designed to track and analyze the following KPIs:

### Sales KPIs

- Total Revenue
- Total Orders
- Average Order Value
- Active Customers
- Total Units Sold
- Revenue per Unit
- Average Items per Order
- Monthly Revenue Trend
- Monthly Orders Trend
- Product Revenue
- Category Revenue
- Top Products by Revenue
- Top Products by Quantity

### Profitability KPIs

- Estimated Gross Profit
- Estimated Gross Margin %
- Profit per Unit
- Product Margin %
- Revenue Contribution %
- Category Profitability

### Customer KPIs

- Active Customers
- Customer Segments
- Customer Order Frequency
- Customer Lifetime Value Concept
- Average Customer Spend
- Delayed Order Rate per Customer
- Retention & RFM Segmentation Concept

### Delivery KPIs

- On-Time Delivery Rate
- Delayed Orders %
- Average Delay Minutes
- Delivery Status Breakdown
- Delivery Partner Performance
- Delay Impact on Rating

### Feedback KPIs

- Average Rating
- Positive Feedback Count
- Negative Feedback Count
- Positive Feedback %
- Rating by Feedback Category
- Sentiment Distribution
- Customer Satisfaction Analysis

### Marketing KPIs

- Marketing Spend
- Marketing Revenue
- Marketing ROAS
- Impressions
- Clicks
- Conversions
- CTR
- Conversion Rate
- CPA
- Channel Performance

### Inventory KPIs

- Stock Received
- Damaged Stock
- Damage Rate
- Net Stock Received
- Inventory Risk
- Min Stock Level
- Max Stock Level
- Reorder Recommendation Concept

---

## 📌 Data Quality Findings

During the data audit phase, several important data quality issues were identified and handled:

### 1. Order Total vs Order Items Mismatch

The value of `orders.order_total` did not always match the sum of `order_items.total_price`.

**Decision:**  
`orders.order_total` was treated as the official source of truth for revenue.

---

### 2. Order Item Total Price Inconsistency

In many records:

```text
total_price ≠ quantity × unit_price
```

**Decision:**  
A calculated field was created:

```text
line_calc_total = quantity × unit_price
```

Then official order revenue was allocated across product lines proportionally.

---

### 3. Customer Table Metrics Not Fully Reliable

Some ready-made customer metrics such as total orders and average order value were not fully consistent with the actual order table.

**Decision:**  
Customer KPIs were recalculated from the transaction tables.

---

### 4. Marketing ROAS Mismatch

The original ROAS column was not always consistent with:

```text
revenue_generated / spend
```

**Decision:**  
ROAS was recalculated using a trusted formula.

---

### 5. Store ID Limitation

The `store_id` field was not reliable enough for branch-level analysis.

**Decision:**  
Store-level analysis was not used as a major business insight.

---

## 📌 Trusted KPI Layer

To avoid incorrect reporting, the project uses a trusted KPI layer based on cleaned and validated calculations.

Important trusted fields include:

| Field | Purpose |
|---|---|
| `order_total` | Official revenue source |
| `line_calc_total` | Calculated item-level value |
| `adjusted_line_revenue` | Allocated product revenue |
| `estimated_gross_profit` | Estimated profit based on product margin |
| `calculated_roas` | Correct marketing ROAS |
| `delivery_delay_minutes` | Delivery delay measurement |
| `is_delayed` | Delivery delay flag |

---

## 📌 System Architecture

The project follows a layered analytics architecture:

```text
Raw CSV Files
      ↓
Python Data Audit
      ↓
Python Data Cleaning
      ↓
Clean CSV Files
      ↓
SQL Server Database
      ↓
Staging Tables
      ↓
Reporting / Gold Views
      ↓
Power BI Data Model
      ↓
DAX Measures
      ↓
Interactive Dashboards
      ↓
Machine Learning Forecasting
      ↓
n8n Automation
      ↓
AI Chatbot Interface
```

---

## 📌 Data Warehouse Design

The SQL Server database is named:

```text
BlinkitDW
```

The database uses two main schemas:

| Schema | Purpose |
|---|---|
| `stg` | Staging tables loaded from clean CSV files |
| `rpt` | Reporting views used by Power BI, ML, and chatbot layers |

---

## 📌 Main SQL Server Objects

### Staging Tables

```text
stg.clean_orders
stg.clean_order_items
stg.clean_customers
stg.clean_delivery
stg.clean_feedback
stg.clean_inventory
stg.clean_marketing
stg.clean_products
```

### Reporting Views

```text
rpt.vw_executive_kpis
rpt.vw_dim_date
rpt.vw_dim_products
rpt.vw_dim_customers
rpt.vw_fact_orders
rpt.vw_fact_order_items
rpt.vw_fact_delivery
rpt.vw_fact_feedback
rpt.vw_fact_marketing
rpt.vw_fact_inventory
rpt.vw_sales_daily
rpt.vw_product_performance
rpt.vw_category_performance
rpt.vw_delivery_analysis
rpt.vw_customer_360
rpt.vw_marketing_performance
rpt.vw_inventory_risk
rpt.vw_ml_daily_product_demand
rpt.vw_ml_daily_category_demand
rpt.vw_data_quality_report
```

---

## 📌 Power BI Data Model

The Power BI model follows a star-schema approach.

### Dimension Tables

```text
vw_dim_date
vw_dim_products
vw_dim_customers
```

### Fact Tables

```text
vw_fact_orders
vw_fact_order_items
vw_fact_delivery
vw_fact_feedback
vw_fact_marketing
vw_fact_inventory
```

### Supporting Views

```text
vw_data_quality_report
vw_executive_kpis
vw_product_performance
vw_category_performance
vw_customer_360
vw_inventory_risk
```

---

## 📌 Power BI Relationships

```text
vw_dim_date[date_key] 1 → * vw_fact_orders[date_key]
vw_dim_date[date_key] 1 → * vw_fact_feedback[date_key]
vw_dim_date[date_key] 1 → * vw_fact_marketing[date_key]
vw_dim_date[date_key] 1 → * vw_fact_inventory[date_key]

vw_dim_products[product_id] 1 → * vw_fact_order_items[product_id]
vw_dim_products[product_id] 1 → * vw_fact_inventory[product_id]

vw_dim_customers[customer_id] 1 → * vw_fact_orders[customer_id]

vw_fact_orders[order_id] 1 → * vw_fact_order_items[order_id]
vw_fact_orders[order_id] 1 → 1 vw_fact_delivery[order_id]
vw_fact_orders[order_id] 1 → 1 vw_fact_feedback[order_id]
```

---

## 📌 Power BI Dashboard Pages

The dashboard is designed to include the following pages:

### 1. Executive Overview

A high-level business summary page containing:

- Total Revenue
- Total Orders
- Active Customers
- Average Order Value
- Total Units Sold
- Estimated Gross Profit
- On-Time Delivery %
- Average Rating
- Marketing ROAS
- Revenue Trend
- Orders Trend
- Revenue by Category
- Delivery Status Breakdown
- Marketing Performance
- Top Products
- Data Quality Insights

### 2. Sales & Product Deep-Dive

A detailed page for analyzing:

- Product Revenue
- Category Revenue
- Units Sold
- Estimated Gross Profit
- Product Margin %
- Revenue per Unit
- Average Items per Order
- Top 10 Products by Revenue
- Top 10 Products by Units Sold
- Revenue vs Profitability Scatter Analysis
- Category Performance Matrix
- Brand Revenue Share

### 3. Customer Segmentation & Retention

Planned analysis includes:

- Customer segmentation
- RFM analysis
- High-value customers
- Low-frequency customers
- Customer retention patterns
- Customer delay rate
- Customer revenue contribution

### 4. Delivery Performance

Planned analysis includes:

- On-time vs delayed orders
- Average delay minutes
- Delivery partner performance
- Delay reasons
- Distance analysis
- Delay impact on customer rating

### 5. Feedback & Satisfaction

Planned analysis includes:

- Rating trends
- Sentiment distribution
- Positive vs negative feedback
- Feedback category performance
- Rating by delivery status
- Customer satisfaction drivers

### 6. Marketing ROI

Planned analysis includes:

- Spend by channel
- Revenue generated by channel
- ROAS
- CTR
- Conversion rate
- CPA
- Campaign performance
- Best and worst marketing channels

### 7. Inventory Intelligence

Planned analysis includes:

- Stock received
- Damaged stock
- Damage rate
- Net stock received
- Product inventory risk
- Category inventory performance
- Reorder recommendations

### 8. ML Forecasting

Planned analysis includes:

- Daily product demand forecasting
- Daily category demand forecasting
- Forecast vs actual demand
- Inventory reorder support
- Shortage risk prediction concept

### 9. AI Chatbot Demo

Planned chatbot capability:

- Ask questions about the data
- Retrieve KPIs from SQL Server
- Explain sales trends
- Identify best products
- Identify low-performing categories
- Answer business questions using natural language

---

## 📌 Current Project Progress

### Completed

- Project folder structure created
- Raw CSV files organized
- Python data audit script created
- Python cleaning script created
- Clean CSV files generated
- SQL Server database created
- Staging schema created
- Reporting schema created
- Clean data loaded into SQL Server
- Reporting views created
- Executive KPI view created
- Data quality view created
- Power BI connected to SQL Server
- Power BI data model built
- Relationships created
- Date table marked
- DAX base measures created
- Executive Overview page created
- Power BI numbers validated against SQL Server
- Month sorting issue fixed using `Year Month Sort`
- Sales & Product Deep-Dive page started

### In Progress

- Sales & Product Deep-Dive dashboard
- Product profitability analysis
- Category performance analysis
- Visual storytelling refinement

### Planned

- Customer segmentation page
- Delivery performance page
- Feedback and satisfaction page
- Marketing ROI page
- Inventory intelligence page
- Machine learning forecasting model
- n8n automation workflows
- AI chatbot integration
- Graduation presentation design

---

## 📌 Python Scripts

### 1. Data Audit

```text
scripts/01_data_audit.py
```

Purpose:

- Read raw CSV files
- Display row and column counts
- Check data types
- Check missing values
- Check duplicate rows
- Show sample records

---

### 2. Data Cleaning

```text
scripts/02_prepare_clean_data.py
```

Purpose:

- Convert date columns
- Create date features
- Calculate delivery delay
- Create delayed order flag
- Calculate item-level values
- Allocate official revenue to products
- Estimate gross profit
- Recalculate customer metrics
- Recalculate marketing KPIs
- Prepare inventory fields
- Export clean CSV files

---

### 3. Load Clean Data to SQL Server

```text
scripts/03_load_clean_to_sqlserver.py
```

Purpose:

- Connect Python to SQL Server
- Create database if needed
- Create schemas
- Load clean CSV files into SQL Server staging tables

---

## 📌 SQL Files

### 1. Create Database

```text
sql/00_create_database.sql
```

Creates:

```text
BlinkitDW
stg schema
rpt schema
```

### 2. Create Reporting Views

```text
sql/04_create_gold_views.sql
```

Creates reporting views for:

- Executive KPIs
- Date dimension
- Product dimension
- Customer dimension
- Sales facts
- Product facts
- Delivery facts
- Feedback facts
- Marketing facts
- Inventory facts
- ML-ready demand data
- Data quality reporting

---

## 📌 DAX Measures

The Power BI report includes DAX measures such as:

### Sales

```DAX
Total Revenue =
SUM ( vw_fact_orders[order_total] )

Total Orders =
DISTINCTCOUNT ( vw_fact_orders[order_id] )

Average Order Value =
DIVIDE ( [Total Revenue], [Total Orders] )

Total Units Sold =
SUM ( vw_fact_order_items[quantity] )
```

### Profit

```DAX
Estimated Gross Profit =
SUM ( vw_fact_order_items[estimated_gross_profit] )

Estimated Gross Margin % =
DIVIDE ( [Estimated Gross Profit], [Product Revenue] )
```

### Delivery

```DAX
On Time Delivery % =
DIVIDE ( [On Time Orders], [Total Orders] )

Delayed Orders % =
DIVIDE ( [Delayed Orders], [Total Orders] )
```

### Feedback

```DAX
Average Rating =
AVERAGE ( vw_fact_feedback[rating] )
```

### Marketing

```DAX
Marketing ROAS =
DIVIDE ( [Marketing Revenue], [Marketing Spend] )
```

### Inventory

```DAX
Damage Rate =
DIVIDE ( [Damaged Stock], [Stock Received] )
```

---

## 📌 Machine Learning Plan

The machine learning part of the project is planned to focus on:

### Demand Forecasting

Forecasting daily demand at:

- Product level
- Category level

### Business Use Cases

- Predict future sales demand
- Support inventory replenishment
- Reduce stockout risk
- Identify seasonal demand patterns
- Improve supply planning

### Possible Models

- Moving Average Baseline
- Linear Regression
- Random Forest Regressor
- XGBoost / Gradient Boosting
- Time-series forecasting models

### ML Output

The ML module is planned to generate:

- Forecasted demand
- Actual vs predicted comparison
- Forecast accuracy metrics
- Reorder recommendations
- Shortage risk indicators

---

## 📌 n8n Automation Plan

The automation layer is planned to include:

### 1. Daily Sales Report

Automatically send daily sales KPIs to email or messaging channels.

### 2. Low Stock Alert

Trigger alerts when product stock risk is detected.

### 3. Delayed Delivery Alert

Notify business users when delayed orders exceed a threshold.

### 4. Weekly Executive Summary

Generate and send a weekly business performance report.

### 5. Power BI Refresh Workflow

Trigger dataset refresh after data update.

### 6. AI Chatbot Workflow

Receive a user question, query SQL Server, send results to an AI model, and return a business-friendly answer.

---

## 📌 AI Chatbot Concept

The chatbot is planned as a natural language analytics assistant.

Example questions:

```text
What is the total revenue?
What is the best-selling category?
Which product has the highest revenue?
Which products need restocking?
What is the on-time delivery rate?
Which marketing channel has the best ROAS?
Why are ratings dropping?
What are the top delayed delivery reasons?
```

### Chatbot Architecture

```text
User Question
      ↓
n8n Webhook
      ↓
AI Intent Understanding
      ↓
SQL Query Generation / Predefined Query Mapping
      ↓
SQL Server
      ↓
Result Formatting
      ↓
AI Response
      ↓
User Answer
```

---

## 📌 Repository Structure

```text
Advanced_Data_Analysis_Automation_Framework_using_Python/
│
├── data/
│   ├── raw/
│   ├── clean/
│   └── output/
│
├── scripts/
│   ├── 01_data_audit.py
│   ├── 02_prepare_clean_data.py
│   └── 03_load_clean_to_sqlserver.py
│
├── sql/
│   ├── 00_create_database.sql
│   └── 04_create_gold_views.sql
│
├── powerbi/
│   ├── themes/
│   └── reports/
│
├── ml/
│   ├── notebooks/
│   ├── models/
│   └── outputs/
│
├── n8n/
│   ├── workflows/
│   └── documentation/
│
├── chatbot/
│   ├── prompts/
│   ├── workflows/
│   └── documentation/
│
├── presentation/
│   ├── slides/
│   └── assets/
│
├── screenshots/
│
├── requirements.txt
├── .gitignore
└── README.md
```

---

## 📌 Tech Stack

| Technology | Usage |
|---|---|
| Python | Data audit, cleaning, transformation, ML preparation |
| Pandas | Data processing |
| NumPy | Numerical operations |
| SQLAlchemy | SQL Server connection |
| PyODBC | ODBC database driver |
| SQL Server | Data warehouse |
| SSMS | SQL development and validation |
| Power BI | Dashboard and data visualization |
| DAX | KPI calculations and measures |
| Power Query | Data transformation inside Power BI |
| n8n | Workflow automation |
| AI Chatbot | Natural language data interaction |
| Git & GitHub | Version control and project documentation |

---

## 📌 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/dralaraby7-eng/Advanced_Data_Analysis_Automation_Framework_using_Python.git
```

### 2. Navigate to the Project Folder

```bash
cd Advanced_Data_Analysis_Automation_Framework_using_Python
```

### 3. Install Python Requirements

```bash
pip install -r requirements.txt
```

### 4. Run Data Audit

```bash
python scripts/01_data_audit.py
```

### 5. Prepare Clean Data

```bash
python scripts/02_prepare_clean_data.py
```

### 6. Create SQL Server Database

Run the following SQL file in SQL Server Management Studio:

```text
sql/00_create_database.sql
```

### 7. Load Clean Data into SQL Server

```bash
python scripts/03_load_clean_to_sqlserver.py
```

### 8. Create Reporting Views

Run the following SQL file in SQL Server Management Studio:

```text
sql/04_create_gold_views.sql
```

### 9. Connect Power BI

Connect Power BI Desktop to:

```text
Server: Your SQL Server instance
Database: BlinkitDW
Schema: rpt
Mode: Import
```

---

## 📌 Power BI Validation

Power BI KPIs were validated against SQL Server using:

```SQL
SELECT *
FROM rpt.vw_executive_kpis;
```

The Power BI cards were compared with SQL Server results to ensure that the dashboard numbers are accurate and trusted.

---

## 📌 Dashboard Design Concept

The dashboard design follows a professional executive style:

- Dark background
- Blinkit-inspired green/yellow accent colors
- KPI cards at the top
- Business-focused charts
- Clean navigation
- Strong visual hierarchy
- Drill-down capability
- Slicers by date, category, customer segment, payment method, and delivery status

---

## 📌 Business Storytelling

The project is presented as a complete business intelligence solution:

> I built a Smart Commerce Intelligence Platform that detects data quality issues, builds a trusted sales model, analyzes customer experience, measures marketing efficiency, predicts demand, and automates business alerts.

In business terms:

- The project identifies revenue drivers
- Detects product profitability differences
- Links delivery delays with customer satisfaction
- Measures marketing efficiency
- Supports inventory planning
- Prepares the business for AI-driven analytics

---

## 📌 Key Insights Expected

The platform is designed to uncover insights such as:

- Revenue concentration by category and product
- High-revenue but low-margin products
- High-margin but underperforming products
- Monthly seasonality patterns
- Delivery delay impact on rating
- Best and worst marketing channels
- Inventory damage and risk patterns
- Customer segments and retention opportunities
- Forecasted demand for better stock planning

---

## 📌 Future Enhancements

Future development can include:

- Full machine learning model deployment
- Advanced forecasting dashboard
- Real-time SQL Server refresh
- Automated Power BI refresh
- n8n alerting workflows
- WhatsApp or Telegram business alerts
- AI chatbot connected directly to SQL Server
- Cloud deployment
- Role-level security in Power BI
- Executive PDF report automation
- Streamlit or web-based analytics app

---

## 📌 Version Control Workflow

To update the GitHub repository after making changes:

```bash
git status
git add .
git commit -m "Update project files"
git push origin main
```

If the default branch is `master`, use:

```bash
git push origin master
```

---

## 📌 Project Status

```text
Status: In Progress
Current Phase: Power BI Dashboard Development
Last Completed Phase: Executive Overview Dashboard
Current Working Phase: Sales & Product Deep-Dive Page
Next Phase: Customer Segmentation & Retention Analysis
```

---

## 📌 Author

**Alaraby Ahmed Eissa**

GitHub: [dralaraby7-eng](https://github.com/dralaraby7-eng)

---

## 📌 License

This project is developed for academic and educational purposes.

Licensed under the MIT License.

---

## 📌 Acknowledgment

This project is part of a graduation project journey focused on building a real-world data analytics, automation, and AI-powered business intelligence solution.

The project demonstrates the ability to move from raw data to business value through:

- Data engineering
- Data analysis
- Business intelligence
- Automation
- Machine learning
- AI-assisted analytics
