import pandas as pd
import sqlite3

# Reading CSV files
orders = pd.read_csv('raw_data/olist_orders_dataset.csv')
items = pd.read_csv('raw_data/olist_order_items_dataset.csv')
products = pd.read_csv('raw_data/olist_products_dataset.csv')
translation = pd.read_csv('raw_data/product_category_name_translation.csv')
customers = pd.read_csv('raw_data/olist_customers_dataset.csv')

# Keeping only delivered orders and removing rows with missing values
orders = orders[orders['order_status'] == 'delivered']
orders = orders.dropna()

# Merging products with English category names and keeping only needed columns
products = pd.merge(products, translation, on='product_category_name')
products = products[['product_id', 'product_category_name_english']]

# Saving cleaned tables to SQLite database
conn = sqlite3.connect('olist_ecommerce.db')

orders.to_sql('orders', conn, if_exists='replace', index=False)
items.to_sql('order_items', conn, if_exists='replace', index=False)
products.to_sql('products', conn, if_exists='replace', index=False)
customers.to_sql('customers', conn, if_exists='replace', index=False)

conn.close()
print("Database created successfully")