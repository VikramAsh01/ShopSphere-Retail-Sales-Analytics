/*=========================================================
          MODULE 5 : TIME SERIES ANALYSIS
=========================================================*/

-- Monthly Sales Trend

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-- Monthly Profit Trend

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-- Monthly Quantity Sold

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity) AS quantity_sold
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-- Monthly Number of Orders

SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- Yearly Sales

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;


-- Yearly Profit

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;


-- Quarterly Sales

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    year,
    quarter
ORDER BY
    year,
    quarter;


-- Quarterly Profit

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    ROUND(SUM(oi.profit),2) AS profit
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    year,
    quarter
ORDER BY
    year,
    quarter;


-- Revenue by Month Name

SELECT
    TO_CHAR(o.order_date,'Month') AS month_name,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month_name
ORDER BY revenue DESC;


-- Sales by Weekday

SELECT
    TO_CHAR(order_date,'Day') AS weekday,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_orders DESC;


-- Average Delivery Time by Month

SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(
        AVG(ship_date - order_date),
        2
    ) AS avg_delivery_days
FROM orders
GROUP BY month
ORDER BY month;


-- Running Total Revenue

SELECT
    month,
    revenue,
    SUM(revenue) OVER
    (
        ORDER BY month
    ) AS running_total
FROM
(
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY month
) t
ORDER BY month;


-- Running Total Profit

SELECT
    month,
    profit,
    SUM(profit) OVER
    (
        ORDER BY month
    ) AS running_profit
FROM
(
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.profit) AS profit
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY month
) t
ORDER BY month;


-- Month-over-Month Sales Growth (MoM)

SELECT
    month,
    revenue,
    LAG(revenue) OVER
    (
        ORDER BY month
    ) AS previous_month,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY month)
        )
        *100.0/
        LAG(revenue) OVER (ORDER BY month),
        2
    ) AS mom_growth_percent
FROM
(
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY month
) t;


-- Month-over-Month Profit Growth

SELECT
    month,
    profit,
    LAG(profit) OVER
    (
        ORDER BY month
    ) AS previous_profit,
    ROUND(
        (
            profit -
            LAG(profit) OVER (ORDER BY month)
        )
        *100.0/
        LAG(profit) OVER (ORDER BY month),
        2
    ) AS mom_profit_growth
FROM
(
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.profit) AS profit
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY month
) t;


-- Moving Average (3 Months)

SELECT
    month,
    revenue,
    ROUND(
        AVG(revenue) OVER
        (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS moving_average
FROM
(
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY month
) t;


-- Best Sales Month

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;


-- Worst Sales Month

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.sales),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY revenue ASC
LIMIT 1;


-- Year-over-Year Revenue

SELECT
    year,
    revenue,
    LAG(revenue) OVER
    (
        ORDER BY year
    ) AS previous_year,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY year)
        )
        *100.0/
        LAG(revenue) OVER (ORDER BY year),
        2
    ) AS yoy_growth
FROM
(
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS year,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY year
) t;


-- Time-Series Dashboard

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales),2) AS revenue,
    ROUND(SUM(oi.profit),2) AS profit,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(
        SUM(oi.sales) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;