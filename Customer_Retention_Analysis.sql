/*
===========================================================
📊 Project: Customer Retention Analysis
👤 Author: Chirag Kapadiya
===========================================================

🔍 Problem:
Calculate monthly customer retention by identifying repeat customers.

💼 Business Use Case:
Helps businesses understand:
- How many customers return after their first purchase
- Customer loyalty trends over time
- Effectiveness of retention strategies

🧠 Approach:
1. Extract month of each order
2. Identify each customer's first purchase month
3. Count total customers per month
4. Count repeat customers (customers who purchased after their first month)
5. Calculate retention rate

🛠️ SQL Concepts Used:
- DATE_TRUNC
- Aggregations (COUNT DISTINCT)
- CTE
- Joins

===========================================================
*/

WITH monthly_orders AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', order_date) AS order_month
    FROM orders
),

first_purchase AS (
    SELECT 
        customer_id,
        MIN(DATE_TRUNC('month', order_date)) AS first_month
    FROM orders
    GROUP BY customer_id
),

total_customers AS (
    SELECT 
        order_month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM monthly_orders
    GROUP BY order_month
),

repeat_customers AS (
    SELECT 
        mo.order_month,
        COUNT(DISTINCT mo.customer_id) AS repeat_customers
    FROM monthly_orders mo
    JOIN first_purchase fp 
        ON mo.customer_id = fp.customer_id
    WHERE mo.order_month > fp.first_month
    GROUP BY mo.order_month
)

SELECT 
    t.order_month,
    t.total_customers,
    COALESCE(r.repeat_customers, 0) AS repeat_customers,
    ROUND(
        COALESCE(r.repeat_customers, 0)::NUMERIC / t.total_customers, 
        2
    ) AS retention_rate
FROM total_customers t
LEFT JOIN repeat_customers r 
    ON t.order_month = r.order_month
ORDER BY t.order_month;