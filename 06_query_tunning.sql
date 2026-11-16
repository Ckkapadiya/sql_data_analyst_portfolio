SET SESSION cte_max_recursion_depth = 600000;

INSERT INTO orders (order_id, customer_id, order_date, status)
WITH RECURSIVE seq AS (
    SELECT 1 AS g
    UNION ALL
    SELECT g + 1 FROM seq WHERE g < 500000
)
SELECT 100000 + g,
       1 + (g % 60),
       DATE_ADD('2025-01-01', INTERVAL (g % 540) DAY),
       'Delivered'
FROM seq;

-- 6b: BEFORE (needs MySQL 8.0.18+). Save execution time and plan (full table scan).
EXPLAIN ANALYZE
SELECT customer_id, COUNT(*) AS order_count
FROM orders
WHERE order_date >= '2026-01-01'
  AND order_date <  '2026-02-01'
GROUP BY customer_id;

-- 6c: add the index
CREATE INDEX idx_orders_order_date ON orders (order_date);

EXPLAIN ANALYZE
SELECT customer_id, COUNT(*) AS order_count
FROM orders
WHERE order_date >= '2026-01-01'
  AND order_date <  '2026-02-01'
GROUP BY customer_id;
