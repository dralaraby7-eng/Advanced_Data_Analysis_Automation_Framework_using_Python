import pandas as pd
import numpy as np
import os

RAW_PATH = "E:\\Blinkit-Graduation-Project\\data\\raw"
CLEAN_PATH = "E:\\Blinkit-Graduation-Project\\data\\clean"

os.makedirs(CLEAN_PATH, exist_ok=True)

orders = pd.read_csv(f"{RAW_PATH}/blinkit_orders.csv")
order_items = pd.read_csv(f"{RAW_PATH}/blinkit_order_items.csv")
products = pd.read_csv(f"{RAW_PATH}/blinkit_products.csv")
customers = pd.read_csv(f"{RAW_PATH}/blinkit_customers.csv")
delivery = pd.read_csv(f"{RAW_PATH}/blinkit_delivery_performance.csv")
feedback = pd.read_csv(f"{RAW_PATH}/blinkit_customer_feedback.csv")
inventory = pd.read_csv(f"{RAW_PATH}/blinkit_inventory.csv")
marketing = pd.read_csv(f"{RAW_PATH}/blinkit_marketing_performance.csv")

# -----------------------------
# Convert Date Columns
# -----------------------------

orders["order_date"] = pd.to_datetime(orders["order_date"])
orders["promised_delivery_time"] = pd.to_datetime(orders["promised_delivery_time"])
orders["actual_delivery_time"] = pd.to_datetime(orders["actual_delivery_time"])

delivery["promised_time"] = pd.to_datetime(delivery["promised_time"])
delivery["actual_time"] = pd.to_datetime(delivery["actual_time"])

feedback["feedback_date"] = pd.to_datetime(feedback["feedback_date"])

customers["registration_date"] = pd.to_datetime(customers["registration_date"])

inventory["date"] = pd.to_datetime(inventory["date"], dayfirst=True)

marketing["date"] = pd.to_datetime(marketing["date"])

# -----------------------------
# Orders Cleaning
# -----------------------------

orders["order_date_only"] = orders["order_date"].dt.date
orders["order_year"] = orders["order_date"].dt.year
orders["order_month"] = orders["order_date"].dt.to_period("M").astype(str)
orders["order_day_name"] = orders["order_date"].dt.day_name()
orders["order_hour"] = orders["order_date"].dt.hour

orders["delivery_delay_minutes"] = (
    orders["actual_delivery_time"] - orders["promised_delivery_time"]
).dt.total_seconds() / 60

orders["is_delayed"] = np.where(orders["delivery_status"] == "On Time", 0, 1)

# -----------------------------
# Order Items Cleaning
# -----------------------------

order_items["line_calc_total"] = (
    order_items["quantity"] * order_items["unit_price"]
)

# Merge order total into order items
order_items_clean = order_items.merge(
    orders[["order_id", "order_total"]],
    on="order_id",
    how="left"
)

# Calculate order-level total based on quantity * unit_price
order_items_clean["order_calc_total"] = order_items_clean.groupby("order_id")[
    "line_calc_total"
].transform("sum")

# Allocate official order revenue to product lines
order_items_clean["adjusted_line_revenue"] = np.where(
    order_items_clean["order_calc_total"] > 0,
    order_items_clean["order_total"]
    * order_items_clean["line_calc_total"]
    / order_items_clean["order_calc_total"],
    0
)

# Add product data
order_items_clean = order_items_clean.merge(
    products[
        [
            "product_id",
            "product_name",
            "category",
            "brand",
            "price",
            "mrp",
            "margin_percentage",
            "shelf_life_days",
            "min_stock_level",
            "max_stock_level",
        ]
    ],
    on="product_id",
    how="left",
)

order_items_clean["estimated_gross_profit"] = (
    order_items_clean["adjusted_line_revenue"]
    * order_items_clean["margin_percentage"]
    / 100
)

# -----------------------------
# Customers 360
# -----------------------------

customer_metrics = orders.groupby("customer_id").agg(
    actual_total_orders=("order_id", "nunique"),
    actual_total_revenue=("order_total", "sum"),
    actual_avg_order_value=("order_total", "mean"),
    first_order_date=("order_date", "min"),
    last_order_date=("order_date", "max"),
    delayed_orders=("is_delayed", "sum"),
).reset_index()

customer_metrics["customer_delay_rate"] = (
    customer_metrics["delayed_orders"]
    / customer_metrics["actual_total_orders"]
)

customers_clean = customers.merge(
    customer_metrics,
    on="customer_id",
    how="left"
)

customers_clean["actual_total_orders"] = customers_clean["actual_total_orders"].fillna(0)
customers_clean["actual_total_revenue"] = customers_clean["actual_total_revenue"].fillna(0)
customers_clean["actual_avg_order_value"] = customers_clean["actual_avg_order_value"].fillna(0)
customers_clean["customer_delay_rate"] = customers_clean["customer_delay_rate"].fillna(0)

# -----------------------------
# Marketing Cleaning
# -----------------------------

marketing["calculated_roas"] = marketing["revenue_generated"] / marketing["spend"]
marketing["ctr"] = marketing["clicks"] / marketing["impressions"]
marketing["conversion_rate"] = marketing["conversions"] / marketing["clicks"]
marketing["cpc"] = marketing["spend"] / marketing["clicks"]
marketing["cpa"] = marketing["spend"] / marketing["conversions"]

# -----------------------------
# Inventory Cleaning
# -----------------------------

inventory["net_stock_received"] = (
    inventory["stock_received"] - inventory["damaged_stock"]
)

inventory = inventory.merge(
    products[["product_id", "product_name", "category", "min_stock_level", "max_stock_level"]],
    on="product_id",
    how="left"
)

# -----------------------------
# Save Clean Files
# -----------------------------

orders.to_csv(f"{CLEAN_PATH}/clean_orders.csv", index=False)
order_items_clean.to_csv(f"{CLEAN_PATH}/clean_order_items.csv", index=False)
customers_clean.to_csv(f"{CLEAN_PATH}/clean_customers.csv", index=False)
delivery.to_csv(f"{CLEAN_PATH}/clean_delivery.csv", index=False)
feedback.to_csv(f"{CLEAN_PATH}/clean_feedback.csv", index=False)
inventory.to_csv(f"{CLEAN_PATH}/clean_inventory.csv", index=False)
marketing.to_csv(f"{CLEAN_PATH}/clean_marketing.csv", index=False)
products.to_csv(f"{CLEAN_PATH}/clean_products.csv", index=False)

print("Clean data files created successfully.")