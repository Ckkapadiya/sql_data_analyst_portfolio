
/*
Project 2: Month-over-month revenue growth
Business question: Is revenue growing, and which months were unusually weak or strong?
Concepts : CTE, LAG(), NULLIF (safe division)
Requires : v_order_revenue (see 01_data_cleaning.sql)
Dialect  : PostgreSQL (Oracle version in 07_oracle_versions.sql)
*/

use ecommerce_portfolio;

WITH monthly_revenue AS (
    SELECT date_format(order_date,'%b %y') AS order_month,
           SUM(order_amount)               AS revenue,
           COUNT(*)                        AS orders
    FROM v_order_revenue
    GROUP BY date_format(order_date,'%b %y')
),
with_prev AS (
    SELECT order_month, revenue, orders,
           LAG(revenue) OVER (ORDER BY order_month) AS prev_revenue
    FROM monthly_revenue
)SELECT order_month AS month,
       ROUND(revenue, 0) AS revenue,
       orders,
       ROUND(100.0 * (revenue - prev_revenue) / NULLIF(prev_revenue, 0), 1) AS mom_growth_pct
FROM with_prev
ORDER BY order_month;
