/*=========================================================
                MODULE 7 : SQL VIEWS
=========================================================*/

-----------------------------------------------------------
-- 1. Customer Sales View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_customer_sales AS

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS total_revenue,
    ROUND(SUM(oi.profit),2) AS total_profit,
    SUM(oi.quantity) AS total_quantity
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment;


-----------------------------------------------------------
-- 2. Product Performance View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_product_performance AS

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(AVG(oi.discount)*100,2) AS avg_discount,
    ROUND(
        SUM(oi.profit)*100.0/
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category;


-----------------------------------------------------------
-- 3. Regional Performance View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_region_summary AS

SELECT
    o.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(
        SUM(oi.profit)*100.0/
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region;


-----------------------------------------------------------
-- 4. State Performance View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_state_summary AS

SELECT
    o.state,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.state;


-----------------------------------------------------------
-- 5. Monthly Sales View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_monthly_sales AS

SELECT
    DATE_TRUNC('month',o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month;


-----------------------------------------------------------
-- 6. Category Performance View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_category_summary AS

SELECT
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(AVG(oi.discount)*100,2) AS avg_discount
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category;


-----------------------------------------------------------
-- 7. Sub-Category Performance View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_subcategory_summary AS

SELECT
    p.sub_category,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.sub_category;


-----------------------------------------------------------
-- 8. Shipping Performance View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_shipping_summary AS

SELECT
    o.ship_mode,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(o.ship_date-o.order_date),2) AS avg_delivery_days,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.ship_mode;


-----------------------------------------------------------
-- 9. Executive KPI View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_company_kpis AS

SELECT
    ROUND(SUM(sales),2) AS total_revenue,
    ROUND(SUM(profit),2) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(sales)/
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value,
    ROUND(
        SUM(profit)*100.0/
        SUM(sales),
        2
    ) AS profit_margin
FROM order_items;


-----------------------------------------------------------
-- 10. Top Customers View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_top_customers AS

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 11. Top Products View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_top_products AS

SELECT
    p.product_id,
    p.product_name,
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 12. Customer Lifetime Value View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_customer_ltv AS

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.sales),2) AS lifetime_value,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name;


-----------------------------------------------------------
-- 13. Profit Margin View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_profit_margin AS

SELECT
    p.product_name,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    ROUND(
        SUM(oi.profit)*100.0/
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name;


-----------------------------------------------------------
-- 14. Revenue by Year View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_yearly_sales AS

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY year;


-----------------------------------------------------------
-- 15. Dashboard Summary View
-----------------------------------------------------------

CREATE OR REPLACE VIEW vw_dashboard_summary AS

SELECT
    o.region,
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY
    o.region,
    p.category;


-----------------------------------------------------------
-- Example Queries Using Views
-----------------------------------------------------------

SELECT * FROM vw_company_kpis;

SELECT * FROM vw_customer_sales;

SELECT * FROM vw_product_performance
ORDER BY revenue DESC
LIMIT 10;

SELECT * FROM vw_region_summary;

SELECT * FROM vw_monthly_sales;

SELECT * FROM vw_category_summary;

SELECT * FROM vw_top_customers
LIMIT 10;

SELECT * FROM vw_top_products
LIMIT 10;

SELECT * FROM vw_customer_ltv
ORDER BY lifetime_value DESC
LIMIT 10;