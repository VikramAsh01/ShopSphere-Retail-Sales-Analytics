-- ============================================
-- Sales Analysis
-- ============================================

-- Query 1: Total Revenue

SELECT
    SUM(sales) AS total_revenue
FROM order_items;


-- Query 2: Total Profit

SELECT
    SUM(profit) AS total_profit
FROM order_items;


-- Query 3: Total Orders

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- Query 4: Total Customers

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- Query 5: Average Order Value

SELECT
    ROUND(
        SUM(sales) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;