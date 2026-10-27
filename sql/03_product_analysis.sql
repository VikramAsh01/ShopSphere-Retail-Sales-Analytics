/*=========================================================
            MODULE 3 : PRODUCT ANALYSIS
=========================================================*/

-- Top 10 Best-Selling Products (Revenue)

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.sales),2) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Top 10 Most Profitable Products

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.profit),2) AS total_profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_profit DESC
LIMIT 10;


-- Top 10 Loss-Making Products

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.profit),2) AS total_profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_profit ASC
LIMIT 10;


-- Most Sold Products (Quantity)

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;


-- Average Sales Per Product

SELECT
    p.product_name,
    ROUND(AVG(oi.sales),2) AS average_sales
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY average_sales DESC
LIMIT 10;


-- Revenue by Category

SELECT
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- Profit by Category

SELECT
    p.category,
    ROUND(SUM(oi.profit),2) AS profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY profit DESC;


-- Quantity Sold by Category

SELECT
    p.category,
    SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_quantity DESC;


-- Revenue by Sub-Category

SELECT
    p.sub_category,
    ROUND(SUM(oi.sales),2) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.sub_category
ORDER BY revenue DESC;


-- Profit by Sub-Category

SELECT
    p.sub_category,
    ROUND(SUM(oi.profit),2) AS profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.sub_category
ORDER BY profit DESC;


-- Category Contribution to Total Revenue (%)

SELECT
    p.category,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(
        SUM(oi.sales) * 100.0 /
        (SELECT SUM(sales) FROM order_items),
        2
    ) AS revenue_percentage
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- Product Profit Margin

SELECT
    p.product_name,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    ROUND(
        SUM(oi.profit) * 100.0 /
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY profit_margin DESC;


-- Products with Overall Negative Profit

SELECT
    p.product_name,
    ROUND(SUM(oi.profit),2) AS total_loss
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING SUM(oi.profit) < 0
ORDER BY total_loss;


-- Top 3 Products in Each Category

SELECT *
FROM
(
    SELECT
        p.category,
        p.product_name,
        ROUND(SUM(oi.sales),2) AS revenue,
        RANK() OVER
        (
            PARTITION BY p.category
            ORDER BY SUM(oi.sales) DESC
        ) AS product_rank
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY
        p.category,
        p.product_name
) ranked_products
WHERE product_rank <= 3;


-- Product Revenue Ranking

SELECT
    product_name,
    revenue,
    RANK() OVER
    (
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM
(
    SELECT
        p.product_name,
        SUM(oi.sales) AS revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_name
) t;


-- ABC (Pareto) Analysis

WITH product_sales AS
(
    SELECT
        p.product_name,
        SUM(oi.sales) AS revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_name
)

SELECT
    product_name,
    revenue,
    ROUND
    (
        SUM(revenue) OVER
        (
            ORDER BY revenue DESC
        ),
        2
    ) AS cumulative_revenue
FROM product_sales
ORDER BY revenue DESC;


-- Average Discount by Category

SELECT
    p.category,
    ROUND(AVG(oi.discount) * 100,2) AS average_discount
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY average_discount DESC;


-- Top 10 Highest Discounted Products

SELECT
    p.product_name,
    ROUND(AVG(oi.discount) * 100,2) AS average_discount
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY average_discount DESC
LIMIT 10;


-- Products Ordered Only Once

SELECT
    p.product_name,
    COUNT(oi.order_id) AS total_orders
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING COUNT(oi.order_id) = 1;


-- Complete Product Performance Dashboard

SELECT
    p.product_name,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(AVG(oi.discount) * 100,2) AS average_discount,
    ROUND(
        SUM(oi.profit) * 100.0 /
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;