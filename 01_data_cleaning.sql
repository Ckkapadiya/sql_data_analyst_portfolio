use ecommerce_portfolio;
/*
Project 1: Data cleaning and reusable views
Problem  : customers.city is messy ('VADODARA', 'rajkot ', NULL). Any city-level
           report built on the raw column gives wrong totals.
Approach : 1) Profile the problem  2) Fix it in a view  3) Build an order-level
           revenue view that every later query reuses.
Works in : PostgreSQL and Oracle
*/

-- Step 1: profile the issue (same city appearing as several values)
SELECT city, COUNT(*) AS customers
FROM customers
GROUP BY city
ORDER BY city;

-- Step 2: clean view
CREATE OR REPLACE VIEW v_customers_clean AS
SELECT customer_id,
       customer_name,
       COALESCE(upper(TRIM(city)), 'Unknown') AS city,
       signup_date
FROM customers;

-- Step 3: verify the fix (should now show one row per city)
SELECT city, COUNT(*) AS customers
FROM v_customers_clean
GROUP BY city
ORDER BY customers DESC;

-- Step 4: order-level revenue (Delivered orders only, cancelled and returned excluded)
CREATE OR REPLACE VIEW v_order_revenue AS
SELECT a.order_id,
       a.customer_id,
       a.order_date,
       SUM(b.quantity * b.unit_price) AS order_amount
FROM orders a
JOIN order_items b ON b.order_id = a.order_id
WHERE a.status = 'Delivered'
GROUP BY a.order_id,a.customer_id,a.order_date;

select * from v_order_revenue;