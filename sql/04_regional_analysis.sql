/*=========================================================
            MODULE 4 : REGIONAL ANALYSIS
=========================================================*/

-- Revenue by Region

SELECT
    o.region,
    ROUND(SUM(oi.sales),2) AS total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY total_revenue DESC;


-- Profit by Region

SELECT
    o.region,
    ROUND(SUM(oi.profit),2) AS total_profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY total_profit DESC;


-- Quantity Sold by Region

SELECT
    o.region,
    SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY total_quantity DESC;


-- Number of Orders by Region

SELECT
    region,
    COUNT(*) AS total_orders
FROM orders
GROUP BY region
ORDER BY total_orders DESC;


-- Average Order Value by Region

SELECT
    o.region,
    ROUND(
        SUM(oi.sales) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY average_order_value DESC;


-- Profit Margin by Region

SELECT
    o.region,
    ROUND(
        SUM(oi.profit) * 100.0 /
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY profit_margin DESC;


-- Top 10 States by Revenue

SELECT
    o.state,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.state
ORDER BY revenue DESC
LIMIT 10;


-- Bottom 10 States by Profit

SELECT
    o.state,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.state
ORDER BY profit ASC
LIMIT 10;


-- Revenue by City

SELECT
    o.city,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.city
ORDER BY revenue DESC
LIMIT 20;


-- Profit by City

SELECT
    o.city,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.city
ORDER BY profit DESC
LIMIT 20;


-- Top 3 States in Each Region by Revenue

SELECT *
FROM
(
    SELECT
        o.region,
        o.state,
        ROUND(SUM(oi.sales),2) AS revenue,
        RANK() OVER
        (
            PARTITION BY o.region
            ORDER BY SUM(oi.sales) DESC
        ) AS state_rank
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY
        o.region,
        o.state
) ranked_states
WHERE state_rank <= 3;


-- Region Contribution to Total Revenue

SELECT
    o.region,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(
        SUM(oi.sales) * 100.0 /
        (SELECT SUM(sales) FROM order_items),
        2
    ) AS revenue_percentage
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY revenue DESC;


-- Region Contribution to Total Profit

SELECT
    o.region,
    ROUND(SUM(oi.profit),2) AS profit,
    ROUND(
        SUM(oi.profit) * 100.0 /
        (SELECT SUM(profit) FROM order_items),
        2
    ) AS profit_percentage
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY profit DESC;


-- Average Delivery Time by Region

SELECT
    region,
    ROUND(
        AVG(ship_date - order_date),
        2
    ) AS avg_delivery_days
FROM orders
GROUP BY region
ORDER BY avg_delivery_days;


-- Shipping Mode Usage by Region

SELECT
    region,
    ship_mode,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    region,
    ship_mode
ORDER BY
    region,
    total_orders DESC;


-- State-wise Revenue Ranking

SELECT
    state,
    revenue,
    DENSE_RANK() OVER
    (
        ORDER BY revenue DESC
    ) AS state_rank
FROM
(
    SELECT
        o.state,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY o.state
) t;


-- Top 5 Cities by Profit in Each Region

SELECT *
FROM
(
    SELECT
        o.region,
        o.city,
        ROUND(SUM(oi.profit),2) AS profit,
        ROW_NUMBER() OVER
        (
            PARTITION BY o.region
            ORDER BY SUM(oi.profit) DESC
        ) AS city_rank
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY
        o.region,
        o.city
) ranked_cities
WHERE city_rank <= 5;


-- Revenue and Profit by State

SELECT
    o.state,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    ROUND(
        SUM(oi.profit) * 100.0 /
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.state
ORDER BY revenue DESC;


-- Regional Performance Dashboard

SELECT
    o.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(
        SUM(oi.sales) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value,
    ROUND(
        SUM(oi.profit) * 100.0 /
        SUM(oi.sales),
        2
    ) AS profit_margin
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY revenue DESC;