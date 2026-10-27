-- Step 6: Product and category analysis
USE retail_pos_analysis;

-- A. Revenue and units by category
SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;

-- B. Top 10 products by revenue
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- C. Estimated gross margin by product (before returns and overheads)
SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.unit_cost) - oi.discount_amount), 2)
        AS estimated_gross_margin
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY estimated_gross_margin DESC;
