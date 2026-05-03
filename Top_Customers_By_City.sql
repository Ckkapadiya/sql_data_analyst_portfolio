/*
===========================================================
Project: Top Customers by City
Author: Chirag Kapadiya
===========================================================

Problem:
Identify the top 3 customers in each city based on total sales.

Business Use Case:
Helps businesses focus on high-value customers for retention,
loyalty programs, and targeted marketing.

Approach:
1. Aggregate total sales per customer per city
2. Rank customers within each city using DENSE_RANK()
3. Filter top 3 customers per city

Key Concepts:
- GROUP BY
- Window Functions (DENSE_RANK)
- CTE
===========================================================
*/

WITH customer_city_sales AS (
    SELECT 
        customer_id,
        city,
        SUM(amount) AS total_sales
    FROM orders
    GROUP BY customer_id, city
),

ranked_customers AS (
    SELECT 
        customer_id,
        city,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY city 
            ORDER BY total_sales DESC
        ) AS city_rank
    FROM customer_city_sales
)

SELECT *
FROM ranked_customers
WHERE city_rank <= 3
ORDER BY city, city_rank;