-- Step 2: Create normalized tables
USE retail_pos_analysis;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(80),
    signup_date DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(80) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_products_price CHECK (unit_price >= 0),
    CONSTRAINT chk_products_cost CHECK (unit_cost >= 0)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    payment_method VARCHAR(40) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_items_quantity CHECK (quantity > 0),
    CONSTRAINT chk_items_price CHECK (unit_price >= 0),
    CONSTRAINT chk_items_discount CHECK (discount_amount >= 0)
);

CREATE TABLE IF NOT EXISTS returns (
    return_id INT PRIMARY KEY,
    order_item_id INT NOT NULL,
    return_date DATE NOT NULL,
    quantity_returned INT NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    return_reason VARCHAR(120) NOT NULL,
    CONSTRAINT fk_returns_item
        FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id),
    CONSTRAINT chk_returns_quantity CHECK (quantity_returned > 0),
    CONSTRAINT chk_returns_refund CHECK (refund_amount >= 0)
);
