"""
Blinkit Graduation Project 
Load clean CSV files into SQL Server staging schema.


"""

from pathlib import Path
from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine, text


# ==========================
# 1) EDIT THESE SETTINGS
# ==========================

SERVER = r"Alaraby\SQLEXPRESS"   # Examples: "localhost", ".\SQLEXPRESS", "DESKTOP-XXXX\SQLEXPRESS"
DATABASE = "BlinkitDW"
DRIVER = "ODBC Driver 18 for SQL Server"  # If you have Driver 18, change to: "ODBC Driver 18 for SQL Server"

# For Windows Authentication:
AUTH_PART = "Trusted_Connection=yes"

# For SQL Login instead of Windows Authentication, comment AUTH_PART above and use:
# AUTH_PART = "UID=sa;PWD=YourStrongPassword"


# ==========================
# 2) PROJECT PATHS
# ==========================

PROJECT_ROOT = Path(__file__).resolve().parents[1]
CLEAN_PATH = PROJECT_ROOT / "data" / "clean"

if not CLEAN_PATH.exists():
    raise FileNotFoundError(f"Clean data folder not found: {CLEAN_PATH}")


# ==========================
# 3) CONNECTION HELPERS
# ==========================

def build_engine(database_name: str):
    conn_str = (
        f"DRIVER={{{DRIVER}}};"
        f"SERVER={SERVER};"
        f"DATABASE={database_name};"
        f"{AUTH_PART};"
        "TrustServerCertificate=yes;"
    )
    quoted = quote_plus(conn_str)
    return create_engine(
        f"mssql+pyodbc:///?odbc_connect={quoted}",
        fast_executemany=True
    )


# Connect to master first to create DB if needed
master_engine = build_engine("master")

with master_engine.begin() as conn:
    conn.execute(text(f"""
    IF DB_ID('{DATABASE}') IS NULL
    BEGIN
        CREATE DATABASE [{DATABASE}];
    END
    """))

engine = build_engine(DATABASE)

with engine.begin() as conn:
    conn.execute(text("IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg') EXEC('CREATE SCHEMA stg');"))
    conn.execute(text("IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'rpt') EXEC('CREATE SCHEMA rpt');"))


# ==========================
# 4) TABLES CONFIG
# ==========================

tables = {
    "clean_orders": {
        "file": "clean_orders.csv",
        "date_cols": ["order_date", "promised_delivery_time", "actual_delivery_time", "order_date_only"],
    },
    "clean_order_items": {
        "file": "clean_order_items.csv",
        "date_cols": [],
    },
    "clean_customers": {
        "file": "clean_customers.csv",
        "date_cols": ["registration_date", "first_order_date", "last_order_date"],
    },
    "clean_delivery": {
        "file": "clean_delivery.csv",
        "date_cols": ["promised_time", "actual_time"],
    },
    "clean_feedback": {
        "file": "clean_feedback.csv",
        "date_cols": ["feedback_date"],
    },
    "clean_inventory": {
        "file": "clean_inventory.csv",
        "date_cols": ["date"],
    },
    "clean_marketing": {
        "file": "clean_marketing.csv",
        "date_cols": ["date"],
    },
    "clean_products": {
        "file": "clean_products.csv",
        "date_cols": [],
    },
}


# ==========================
# 5) LOAD FILES TO SQL SERVER
# ==========================

for table_name, cfg in tables.items():
    csv_path = CLEAN_PATH / cfg["file"]
    if not csv_path.exists():
        raise FileNotFoundError(f"Missing file: {csv_path}")

    print("=" * 80)
    print(f"Loading {csv_path.name} -> stg.{table_name}")

    df = pd.read_csv(csv_path)

    for col in cfg["date_cols"]:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")

    # Convert object columns safely to string where appropriate
    # Keep NaN values as NULL in SQL.
    df = df.where(pd.notnull(df), None)

    df.to_sql(
        name=table_name,
        con=engine,
        schema="stg",
        if_exists="replace",
        index=False,
        chunksize=5000
    )

    print(f"Done: {len(df):,} rows loaded into stg.{table_name}")

print("=" * 80)
print("All clean files loaded successfully into SQL Server.")
print("Next: run sql/04_create_gold_views.sql in SSMS.")
