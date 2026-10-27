SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.sales),2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.profit),2) AS total_profit
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_profit DESC
LIMIT 10;
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC
LIMIT 10;
SELECT

ROUND(

SUM(sales)/

COUNT(DISTINCT order_id),

2

)

AS avg_order_value

FROM order_items;
SELECT
ROUND(
SUM(oi.sales)
/ COUNT(DISTINCT c.customer_id),
2
) AS average_customer_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id;
SELECT

c.customer_id,

c.customer_name,

ROUND(

SUM(oi.sales),

2

)

AS customer_lifetime_value

FROM customers c

JOIN orders o

ON c.customer_id = o.customer_id

JOIN order_items oi

ON o.order_id = oi.order_id

GROUP BY

c.customer_id,

c.customer_name

ORDER BY customer_lifetime_value DESC;
SELECT

c.segment,

ROUND(

SUM(oi.sales),

2

)

AS revenue

FROM customers c

JOIN orders o

ON c.customer_id = o.customer_id

JOIN order_items oi

ON o.order_id = oi.order_id

GROUP BY c.segment

ORDER BY revenue DESC;
SELECT

c.segment,

ROUND(

SUM(oi.profit),

2

)

AS profit

FROM customers c

JOIN orders o

ON c.customer_id = o.customer_id

JOIN order_items oi

ON o.order_id = oi.order_id

GROUP BY c.segment

ORDER BY profit DESC;

SELECT

segment,

COUNT(*) AS customers

FROM customers

GROUP BY segment

ORDER BY customers DESC;
SELECT

segment,

COUNT(*) AS customers

FROM customers

GROUP BY segment

ORDER BY customers DESC;
SELECT

customer_name,

revenue,

RANK() OVER(

ORDER BY revenue DESC

)

AS customer_rank

FROM

(

SELECT

c.customer_name,

SUM(oi.sales) AS revenue

FROM customers c

JOIN orders o

ON c.customer_id = o.customer_id

JOIN order_items oi

ON o.order_id = oi.order_id

GROUP BY c.customer_name

) t;

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.sales),2) AS lifetime_sales
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING SUM(oi.sales) > 10000
ORDER BY lifetime_sales DESC;