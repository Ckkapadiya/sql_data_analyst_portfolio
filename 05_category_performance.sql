/*
Project 5: Category and product performance
Business question: Which categories drive revenue, and what are the best sellers in each?
Concepts : 4-table join, SUM() OVER () for share of total, RANK() per category
*/
use ecommerce_portfolio;

-- 5a: revenue share by category
SELECT c.category,
       SUM(b.quantity * b.unit_price) AS revenue,
       ROUND(100.0 * SUM(b.quantity * b.unit_price)
             / SUM(SUM(b.quantity * b.unit_price)) OVER (), 1) AS revenue_share_pct
FROM orders a
JOIN order_items b ON b.order_id = a.order_id
JOIN products c ON c.product_id = b.product_id
WHERE a.status = 'Delivered'
GROUP BY c.category
ORDER BY revenue DESC;

-- 5b: top 2 products inside each category
WITH product_sales AS (
    SELECT c.category,c.product_name,
           SUM(b.quantity) AS units_sold,
           SUM(b.quantity * b.unit_price) AS revenue
    FROM orders a
    JOIN order_items b ON b.order_id = a.order_id
    JOIN products c ON c.product_id = b.product_id
    WHERE a.status = 'Delivered'
    GROUP BY c.category,c.product_name
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk
    FROM product_sales
)
SELECT category, product_name, units_sold, revenue
FROM ranked
WHERE rnk <= 2
ORDER BY category, rnk;

-- 5c: cancellation / return rate by category (data-quality style insight)
SELECT c.category,
       COUNT(DISTINCT a.order_id) AS orders,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN a.status <> 'Delivered' THEN a.order_id END)
             / COUNT(DISTINCT a.order_id), 1) AS cancelled_or_returned_pct
FROM orders a
JOIN order_items b ON b.order_id = a.order_id
JOIN products c ON c.product_id = b.product_id
GROUP BY c.category
ORDER BY cancelled_or_returned_pct DESC;
