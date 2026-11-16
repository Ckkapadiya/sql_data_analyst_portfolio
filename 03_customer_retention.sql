/*
Project 3: Month-over-month customer retention
Business question: Of the customers who bought in month N, what % bought again in month N+1?
Concepts : self-join on month + 1, COUNT(DISTINCT), LEFT JOIN
Dialect  : PostgreSQL (Oracle version in 07_oracle_versions.sql)
Note     : With this small sample data, percentages will be low and noisy. That is
           normal; the logic is what matters, and it scales to real data.
*/

use ecommerce_portfolio;

WITH monthly_customers AS (
    SELECT DISTINCT customer_id,
           str_to_date(date_format(order_date,'01-%b-%y'),'%d-%b-%y') AS order_month
    FROM v_order_revenue
)
SELECT date_format(a.order_month,'%b-%y') AS month,
       COUNT(DISTINCT a.customer_id) AS active_customers,
       COUNT(DISTINCT b.customer_id) AS retained_next_month,
       ROUND(100.0 * COUNT(DISTINCT b.customer_id)
             / COUNT(DISTINCT a.customer_id), 1) AS retention_pct
FROM monthly_customers a
LEFT JOIN monthly_customers b
       ON b.customer_id = a.customer_id
      AND b.order_month = a.order_month + INTERVAL 1 month
-- WHERE a.order_month < (SELECT MAX(order_month) FROM monthly_customers)  -- last month has no 'next month' yet
GROUP BY a.order_month
ORDER BY a.order_month;

select * from v_order_revenue where order_date between '2025-05-01' and '2025-05-31' and customer_id in(
select customer_id from v_order_revenue where order_date between '2025-04-01' and '2025-04-30');