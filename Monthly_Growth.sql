/*
===========================================
Project: Monthly Revenue Growth Analysis
Author: Chirag Kapadiya
Description:
    This query calculates month-over-month (MoM) revenue growth
    using order data. It aggregates total revenue per month
    and compares it with the previous month using LAG().
===========================================
*/

-- Step 1: Aggregate monthly revenue
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS order_month,
        SUM(amount) AS amt
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),

-- Step 2: Get previous month's revenue using window function
revenue_with_lag AS (
    SELECT 
        order_month,
        amt,
        LAG(amt) OVER (ORDER BY order_month) AS prev_amt
    FROM monthly_revenue
)

-- Step 3: Calculate Month-over-Month Growth %
SELECT 
    order_month,
    ROUND(
        ((amt - COALESCE(prev_amt, 0)) / prev_amt) * 100,
        2
    ) AS mom_growth_percentage
FROM revenue_with_lag
ORDER BY order_month;