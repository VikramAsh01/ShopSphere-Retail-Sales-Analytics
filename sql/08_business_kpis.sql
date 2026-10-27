/*=========================================================
          MODULE 8 : BUSINESS KPIs & EXECUTIVE DASHBOARD
=========================================================*/

-----------------------------------------------------------
-- 1. Executive KPI Dashboard
-----------------------------------------------------------

SELECT
    ROUND(SUM(sales),2) AS total_revenue,
    ROUND(SUM(profit),2) AS total_profit,
    SUM(quantity) AS total_units_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(sales) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value,
    ROUND(
        SUM(profit) * 100.0 /
        SUM(sales),
        2
    ) AS profit_margin
FROM order_items;


-----------------------------------------------------------
-- 2. Revenue by Customer Segment
-----------------------------------------------------------

SELECT
    c.segment,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.segment
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 3. Revenue by Category
-----------------------------------------------------------

SELECT
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 4. Revenue by Region
-----------------------------------------------------------

SELECT
    o.region,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 5. Top 10 Customers
-----------------------------------------------------------

SELECT
    c.customer_name,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 10;


-----------------------------------------------------------
-- 6. Top 10 Products
-----------------------------------------------------------

SELECT
    p.product_name,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;


-----------------------------------------------------------
-- 7. Top 10 States
-----------------------------------------------------------

SELECT
    o.state,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.state
ORDER BY revenue DESC
LIMIT 10;


-----------------------------------------------------------
-- 8. Monthly Business Performance
-----------------------------------------------------------

SELECT
    DATE_TRUNC('month',o.order_date) AS month,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-----------------------------------------------------------
-- 9. Yearly Business Performance
-----------------------------------------------------------

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;


-----------------------------------------------------------
-- 10. Average Delivery Time
-----------------------------------------------------------

SELECT
    ROUND(
        AVG(ship_date - order_date),
        2
    ) AS average_delivery_days
FROM orders;


-----------------------------------------------------------
-- 11. Shipping Mode Performance
-----------------------------------------------------------

SELECT
    ship_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(ship_date-order_date),2) AS average_delivery_days
FROM orders
GROUP BY ship_mode
ORDER BY total_orders DESC;


-----------------------------------------------------------
-- 12. Discount Impact
-----------------------------------------------------------

SELECT
    ROUND(AVG(discount)*100,2) AS average_discount,
    ROUND(SUM(profit),2) AS total_profit
FROM order_items;


-----------------------------------------------------------
-- 13. Best Performing Category
-----------------------------------------------------------

SELECT
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC
LIMIT 1;


-----------------------------------------------------------
-- 14. Least Performing Category
-----------------------------------------------------------

SELECT
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue
LIMIT 1;


-----------------------------------------------------------
-- 15. Most Profitable Region
-----------------------------------------------------------

SELECT
    o.region,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY profit DESC
LIMIT 1;


-----------------------------------------------------------
-- 16. Least Profitable Region
-----------------------------------------------------------

SELECT
    o.region,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY profit
LIMIT 1;


-----------------------------------------------------------
-- 17. Customer Lifetime Value (Top 10)
-----------------------------------------------------------

SELECT
    c.customer_name,
    ROUND(SUM(oi.sales),2) AS customer_lifetime_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY customer_lifetime_value DESC
LIMIT 10;


-----------------------------------------------------------
-- 18. Overall Business Health Summary
-----------------------------------------------------------

SELECT
    ROUND(SUM(sales),2) AS revenue,
    ROUND(SUM(profit),2) AS profit,
    ROUND(
        SUM(profit) * 100.0 /
        SUM(sales),
        2
    ) AS profit_margin,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS quantity_sold,
    ROUND(
        SUM(sales) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value,
    ROUND(
        AVG(discount) * 100,
        2
    ) AS average_discount
FROM order_items;


-----------------------------------------------------------
-- 19. Executive Dashboard Table
-----------------------------------------------------------

SELECT
    o.region,
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(
        SUM(oi.profit) * 100.0 /
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY
    o.region,
    p.category
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 20. Power BI Final Dataset
-----------------------------------------------------------

SELECT
    o.order_id,
    o.order_date,
    o.ship_date,
    o.ship_mode,
    o.region,
    o.state,
    o.city,
    c.customer_id,
    c.customer_name,
    c.segment,
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    oi.sales,
    oi.quantity,
    oi.discount,
    oi.profit
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id;