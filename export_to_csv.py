import pandas as pd
import sqlite3

# Connecting to SQLite database
conn = sqlite3.connect('olist_ecommerce.db')

# Reading data from the SQL view and saving to CSV for Power BI
df = pd.read_sql_query("SELECT * FROM dashboard_data", conn)
df.to_csv('powerbi_dashboard/dashboard_data.csv', index=False)

conn.close()
print("CSV exported successfully")