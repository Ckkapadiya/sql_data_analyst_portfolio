/*
Project 4: Top 3 customers in each city
Business question: Who are our highest-value customers per city (for loyalty offers)?
Concepts : multi-table join, window function, ROW_NUMBER vs DENSE_RANK
Why ROW_NUMBER: DENSE_RANK can return more than 3 rows when totals tie.
*/

use ecommerce_portfolio;

WITH customer_sales AS (
    SELECT a.customer_id,
           a.customer_name,
           a.city,
           SUM(b.order_amount) AS total_sales,
           COUNT(*)            AS orders
    FROM v_customers_clean a
    JOIN v_order_revenue b ON b.customer_id = a.customer_id
    GROUP BY a.customer_id, a.customer_name, a.city
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY city ORDER BY total_sales DESC) AS city_rank
    FROM customer_sales
)
SELECT city, city_rank, customer_name, ROUND(total_sales, 0) AS total_sales, orders
FROM ranked
WHERE city_rank <= 3
ORDER BY city, city_rank;
