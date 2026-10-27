-- Step 4: Inspect data quality before analysis
USE retail_pos_analysis;

-- 1. Row counts: confirm that data loaded
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'returns', COUNT(*) FROM returns;

-- 2. Check required fields that should not be NULL
SELECT * FROM customers
WHERE customer_name IS NULL OR customer_id IS NULL;

SELECT * FROM products
WHERE product_name IS NULL OR category IS NULL
   OR unit_price IS NULL OR unit_cost IS NULL;

SELECT * FROM orders
WHERE customer_id IS NULL OR order_date IS NULL
   OR order_status IS NULL;

-- 3. Check invalid numeric values
SELECT * FROM order_items
WHERE quantity <= 0 OR unit_price < 0 OR discount_amount < 0
   OR discount_amount > quantity * unit_price;

SELECT * FROM returns
WHERE quantity_returned <= 0 OR refund_amount < 0;

-- 4. Check for duplicate primary-key values (normally prevented by PK constraints)
SELECT customer_id, COUNT(*) AS occurrences
FROM customers GROUP BY customer_id HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS occurrences
FROM orders GROUP BY order_id HAVING COUNT(*) > 1;

-- 5. Inspect order statuses
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 6. Check that returned quantities do not exceed the original line quantity
SELECT
    r.return_id,
    r.order_item_id,
    oi.quantity AS purchased_quantity,
    SUM(r.quantity_returned) AS total_returned_quantity
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
GROUP BY r.return_id, r.order_item_id, oi.quantity
HAVING SUM(r.quantity_returned) > oi.quantity;

-- Empty result sets in the checks above generally mean no issues were found by that check.
