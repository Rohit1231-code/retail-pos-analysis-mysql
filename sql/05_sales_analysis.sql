-- Step 5: Sales analysis
USE retail_pos_analysis;

-- A. Overall sales KPIs (Completed orders only; before refunds)
SELECT
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COUNT(DISTINCT o.customer_id) AS unique_buyers,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue_before_refunds,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2
    ) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- B. Monthly revenue
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- C. Revenue by payment method
SELECT
    o.payment_method,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.payment_method
ORDER BY revenue DESC;

-- D. Highest-value orders
SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.order_id, o.order_date, o.customer_id
ORDER BY order_value DESC
LIMIT 10;

-- E. Gross margin estimate by order line, using product master cost.
-- This assumes the unit cost is applicable to the sale and excludes overheads/tax.
SELECT
    ROUND(SUM(oi.quantity * (oi.unit_price - p.unit_cost) - oi.discount_amount), 2)
        AS estimated_gross_margin_before_returns
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed';
