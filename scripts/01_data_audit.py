import pandas as pd
import os
import glob

RAW_PATH = "E:\\Blinkit-Graduation-Project\\data\\raw"

files = glob.glob(os.path.join(RAW_PATH, "*.csv"))

print("=" * 80)
print("BLINKIT DATA AUDIT REPORT")
print("=" * 80)

for file in files:
    table_name = os.path.basename(file).replace(".csv", "")
    df = pd.read_csv(file)

    print("\n" + "-" * 80)
    print(f"TABLE: {table_name}")
    print("-" * 80)

    print(f"Rows: {df.shape[0]:,}")
    print(f"Columns: {df.shape[1]:,}")

    print("\nColumns:")
    print(df.dtypes)

    print("\nMissing Values:")
    print(df.isnull().sum())

    print("\nDuplicate Rows:")
    print(df.duplicated().sum())

    print("\nSample Data:")
    print(df.head(3))