/*=========================================================
                MODULE 6 : ADVANCED SQL
=========================================================*/

-----------------------------------------------------------
-- 1. Customers Whose Spending is Above Average
-----------------------------------------------------------

SELECT
    customer_name,
    total_spending
FROM
(
    SELECT
        c.customer_name,
        SUM(oi.sales) AS total_spending
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY c.customer_name
) t
WHERE total_spending >
(
    SELECT AVG(customer_sales)
    FROM
    (
        SELECT
            SUM(oi.sales) AS customer_sales
        FROM customers c
        JOIN orders o
        ON c.customer_id = o.customer_id
        JOIN order_items oi
        ON o.order_id = oi.order_id
        GROUP BY c.customer_id
    ) avg_sales
)
ORDER BY total_spending DESC;


-----------------------------------------------------------
-- 2. Products With Revenue Above Average
-----------------------------------------------------------

SELECT
    product_name,
    revenue
FROM
(
    SELECT
        p.product_name,
        SUM(oi.sales) AS revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_name
) t
WHERE revenue >
(
    SELECT AVG(product_revenue)
    FROM
    (
        SELECT SUM(sales) AS product_revenue
        FROM order_items
        GROUP BY product_id
    ) x
)
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 3. Customers Who Purchased Office Supplies
-----------------------------------------------------------

SELECT DISTINCT
    c.customer_name
FROM customers c
WHERE EXISTS
(
    SELECT 1
    FROM orders o
    JOIN order_items oi
    ON o.order_id=oi.order_id
    JOIN products p
    ON oi.product_id=p.product_id
    WHERE o.customer_id=c.customer_id
    AND p.category='Office Supplies'
);


-----------------------------------------------------------
-- 4. Products Never Ordered
-----------------------------------------------------------

SELECT
    product_name
FROM products p
WHERE NOT EXISTS
(
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id=p.product_id
);


-----------------------------------------------------------
-- 5. Revenue Classification using CASE
-----------------------------------------------------------

SELECT
    p.product_name,
    SUM(oi.sales) AS revenue,
    CASE
        WHEN SUM(oi.sales)>=10000 THEN 'High Revenue'
        WHEN SUM(oi.sales)>=5000 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_category
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 6. Customer Spending Classification
-----------------------------------------------------------

SELECT
    c.customer_name,
    SUM(oi.sales) AS revenue,
    CASE
        WHEN SUM(oi.sales)>=15000 THEN 'VIP'
        WHEN SUM(oi.sales)>=7000 THEN 'Premium'
        ELSE 'Regular'
    END AS customer_type
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_name
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 7. COALESCE Example
-----------------------------------------------------------

SELECT
    product_name,
    COALESCE(sub_category,'Unknown') AS sub_category
FROM products;


-----------------------------------------------------------
-- 8. NULLIF Example
-----------------------------------------------------------

SELECT
    ROUND(
        SUM(profit)/
        NULLIF(SUM(sales),0)*100,
        2
    ) AS profit_margin
FROM order_items;


-----------------------------------------------------------
-- 9. UNION
-----------------------------------------------------------

SELECT customer_name AS name,'Customer' AS type
FROM customers

UNION

SELECT product_name,'Product'
FROM products;


-----------------------------------------------------------
-- 10. UNION ALL
-----------------------------------------------------------

SELECT region
FROM orders

UNION ALL

SELECT category
FROM products;


-----------------------------------------------------------
-- 11. Recursive CTE
-----------------------------------------------------------

WITH RECURSIVE numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n+1
    FROM numbers
    WHERE n<10
)

SELECT *
FROM numbers;


-----------------------------------------------------------
-- 12. Monthly Revenue CTE
-----------------------------------------------------------

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month',o.order_date) AS month,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id=oi.order_id
    GROUP BY month
)

SELECT *
FROM monthly_sales
ORDER BY month;


-----------------------------------------------------------
-- 13. Running Revenue using CTE
-----------------------------------------------------------

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month',o.order_date) AS month,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id=oi.order_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    SUM(revenue)
    OVER(ORDER BY month)
    AS cumulative_sales
FROM monthly_sales;


-----------------------------------------------------------
-- 14. Revenue Rank
-----------------------------------------------------------

SELECT
    product_name,
    revenue,
    RANK() OVER
    (
        ORDER BY revenue DESC
    ) AS rank
FROM
(
    SELECT
        p.product_name,
        SUM(oi.sales) revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id=oi.product_id
    GROUP BY p.product_name
)t;


-----------------------------------------------------------
-- 15. Dense Rank
-----------------------------------------------------------

SELECT
    product_name,
    revenue,
    DENSE_RANK() OVER
    (
        ORDER BY revenue DESC
    ) dense_rank
FROM
(
    SELECT
        p.product_name,
        SUM(oi.sales) revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id=oi.product_id
    GROUP BY p.product_name
)t;


-----------------------------------------------------------
-- 16. Row Number
-----------------------------------------------------------

SELECT
    product_name,
    revenue,
    ROW_NUMBER() OVER
    (
        ORDER BY revenue DESC
    ) row_number
FROM
(
    SELECT
        p.product_name,
        SUM(oi.sales) revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id=oi.product_id
    GROUP BY p.product_name
)t;


-----------------------------------------------------------
-- 17. Previous Month Revenue
-----------------------------------------------------------

WITH monthly_sales AS
(
SELECT
DATE_TRUNC('month',o.order_date) month,
SUM(oi.sales) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
month,
revenue,
LAG(revenue)
OVER(ORDER BY month)
AS previous_month
FROM monthly_sales;


-----------------------------------------------------------
-- 18. Next Month Revenue
-----------------------------------------------------------

WITH monthly_sales AS
(
SELECT
DATE_TRUNC('month',o.order_date) month,
SUM(oi.sales) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
month,
revenue,
LEAD(revenue)
OVER(ORDER BY month)
AS next_month
FROM monthly_sales;


-----------------------------------------------------------
-- 19. Moving Average
-----------------------------------------------------------

WITH monthly_sales AS
(
SELECT
DATE_TRUNC('month',o.order_date) month,
SUM(oi.sales) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
month,
revenue,
ROUND(
AVG(revenue)
OVER
(
ORDER BY month
ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW
),2)
AS moving_average
FROM monthly_sales;


-----------------------------------------------------------
-- 20. Top 3 Products in Every Category
-----------------------------------------------------------

SELECT *
FROM
(
SELECT
p.category,
p.product_name,
SUM(oi.sales) revenue,
ROW_NUMBER()
OVER
(
PARTITION BY p.category
ORDER BY SUM(oi.sales) DESC
) rn
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY
p.category,
p.product_name
)t
WHERE rn<=3;


-----------------------------------------------------------
-- 21. Revenue Share
-----------------------------------------------------------

SELECT
product_name,
revenue,
ROUND(
revenue*100/
SUM(revenue)
OVER(),
2
)
AS revenue_share
FROM
(
SELECT
p.product_name,
SUM(oi.sales) revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
)t
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 22. Cumulative Revenue Percentage
-----------------------------------------------------------

SELECT
product_name,
revenue,
ROUND(
SUM(revenue)
OVER
(
ORDER BY revenue DESC
)
*100/
SUM(revenue)
OVER(),
2
)
AS cumulative_percentage
FROM
(
SELECT
p.product_name,
SUM(oi.sales) revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_name
)t
ORDER BY revenue DESC;


-----------------------------------------------------------
-- 23. Products Above Category Average
-----------------------------------------------------------

WITH product_sales AS
(
SELECT
category,
product_name,
SUM(oi.sales) revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY
category,
product_name
)

SELECT *
FROM product_sales ps
WHERE revenue >
(
SELECT AVG(revenue)
FROM product_sales
WHERE category=ps.category
);


-----------------------------------------------------------
-- 24. Most Profitable Product in Each Category
-----------------------------------------------------------

SELECT *
FROM
(
SELECT
p.category,
p.product_name,
SUM(oi.profit) profit,
RANK()
OVER
(
PARTITION BY p.category
ORDER BY SUM(oi.profit) DESC
) rnk
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY
p.category,
p.product_name
)t
WHERE rnk=1;


-----------------------------------------------------------
-- 25. Executive Advanced SQL Dashboard
-----------------------------------------------------------

WITH customer_sales AS
(
SELECT
c.customer_name,
SUM(oi.sales) revenue,
SUM(oi.profit) profit
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_name
)

SELECT
customer_name,
revenue,
profit,
ROUND(profit*100/revenue,2) profit_margin,
RANK()
OVER(ORDER BY revenue DESC)
AS revenue_rank,
NTILE(4)
OVER(ORDER BY revenue DESC)
AS customer_quartile
FROM customer_sales
ORDER BY revenue DESC;