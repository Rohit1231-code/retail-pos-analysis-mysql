-- Step 8: Returns and refunds analysis
USE retail_pos_analysis;

-- A. Overall returned units and refunds.
-- Return records are separate from sales; inspect whether each returned item came from a completed order.
SELECT
    COUNT(DISTINCT r.return_id) AS return_records,
    SUM(r.quantity_returned) AS returned_units,
    ROUND(SUM(r.refund_amount), 2) AS total_refunds
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';

-- B. Unit return rate by category:
-- denominator = units sold in completed orders; numerator = returned units linked to those orders.
WITH sold AS (
    SELECT
        p.category,
        SUM(oi.quantity) AS units_sold
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category
),
returned AS (
    SELECT
        p.category,
        SUM(r.quantity_returned) AS returned_units,
        SUM(r.refund_amount) AS refunds
    FROM returns r
    JOIN order_items oi ON r.order_item_id = oi.order_item_id
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category
)
SELECT
    s.category,
    s.units_sold,
    COALESCE(r.returned_units, 0) AS returned_units,
    ROUND(100.0 * COALESCE(r.returned_units, 0) / NULLIF(s.units_sold, 0), 2)
        AS unit_return_rate_pct,
    ROUND(COALESCE(r.refunds, 0), 2) AS refunds
FROM sold s
LEFT JOIN returned r ON s.category = r.category
ORDER BY unit_return_rate_pct DESC;

-- C. Return reasons
SELECT
    r.return_reason,
    COUNT(*) AS return_records,
    SUM(r.quantity_returned) AS returned_units,
    ROUND(SUM(r.refund_amount), 2) AS refunds
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY r.return_reason
ORDER BY returned_units DESC, refunds DESC;

-- D. Returned products
SELECT
    p.product_name,
    p.category,
    SUM(r.quantity_returned) AS returned_units,
    ROUND(SUM(r.refund_amount), 2) AS refunds
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY returned_units DESC, refunds DESC;
