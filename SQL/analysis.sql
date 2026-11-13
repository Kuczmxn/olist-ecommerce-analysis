-- 1. Top 10 product categories generating the highiest revenue
SELECT 
    p.product_category_name_english AS category,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(oi.order_id) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- 2. Top 10 Brazilian states with the highest number of orders
SELECT 
    c.customer_state AS state,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- 3. Checking delivery time (how many orders were delayed)
SELECT 
    CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Delayed'
        ELSE 'On time'
    END AS delivery_status,
    COUNT(order_id) AS orders_count
FROM orders
GROUP BY delivery_status;

-- 4. Creating view (joining tables for powerbi dashboard)
DROP VIEW IF EXISTS dashboard_data;

CREATE VIEW dashboard_data AS
SELECT 
    o.order_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    c.customer_state,
    p.product_category_name_english AS category,
    oi.price AS revenue,
    oi.freight_value AS shipping_cost,
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'On time'
    END AS delivery_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;