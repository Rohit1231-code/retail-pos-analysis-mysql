-- Step 7: Customer analysis
USE retail_pos_analysis;

-- A. Customer-level order count and spend (Completed orders only)
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spend DESC;

-- B. Repeat-customer summary
WITH customer_orders AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS completed_orders
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers_with_completed_orders,
    SUM(CASE WHEN completed_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN completed_orders > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS repeat_customer_rate_pct
FROM customer_orders;

-- C. Top 5 customers by spend
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC
LIMIT 5;
