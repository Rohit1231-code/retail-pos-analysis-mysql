# Retail Point of Sale (POS) Analysis Using MySQL

## Project Overview
This project analyzes retail sales data using MySQL to understand sales performance, product performance, customer purchasing behavior, data quality, and product returns.

The dataset is synthetic and was created for SQL practice and portfolio development.

## Business Objectives
- Measure sales revenue and order performance.
- Identify top-performing product categories and products.
- Analyze customer spending and repeat purchases.
- Evaluate product returns, return rates, and refund amounts.
- Perform data quality checks before drawing business conclusions.

## Database Schema
The project contains five tables:
- `customers` — customer information
- `products` — product details and unit costs
- `orders` — order dates, statuses, and payment methods
- `order_items` — products, quantities, prices, and discounts per order
- `returns` — returned quantities, refund amounts, and return details

## SQL Concepts Used
- SELECT, WHERE, ORDER BY
- GROUP BY and aggregate functions
- INNER JOIN and LEFT JOIN
- Common Table Expressions (CTEs)
- CASE/COALESCE and NULLIF
- Subqueries
- Data quality checks
- Revenue, return-rate, and gross-margin calculations

## Key Findings
- Total units sold: 52
- Revenue before refunds: ₹19,981
- Recorded refunds: ₹4,475
- Returned units: 6
- Unit return rate: 11.54%
- Highest-revenue category: Electronics (₹8,585)
- Home category revenue: ₹7,664
- Stationery category revenue: ₹3,732

Revenue is calculated after discounts and before refunds. Revenue after refunds is a simplified measure, not a final accounting figure.

## Project Structure
```text
retail_pos_analysis_project/
├── README.md
└── sql/
    ├── 01_create_database.sql
    ├── 02_create_tables.sql
    ├── 03_insert_sample_data.sql
    ├── 04_data_quality_checks.sql
    ├── 05_sales_analysis.sql
    ├── 06_product_analysis.sql
    ├── 07_customer_analysis.sql
    └── 08_returns_analysis.sql
```

## How to Run
1. Install MySQL Server and MySQL Workbench.
2. Open and execute the SQL files in numerical order.
3. Run the analysis queries to inspect the outputs.
4. The sample data is synthetic and intended for learning and demonstration.

## Limitations
- The dataset is small and synthetic.
- Gross margin is an estimate and excludes operating expenses and other accounting adjustments.
- Return-rate comparisons require business context or external benchmarks.

## Tools
- MySQL
- MySQL Workbench
- Visual Studio Code
- Git and GitHub (for version control and portfolio hosting)

## Project goal
Analyze retail transactions to understand sales performance, product/category performance, customer purchasing behavior, and product returns.

**Important:** The included records are synthetic learning data. Do not present their results as real-world business findings.

## Tools
- MySQL Server 8.0+
- MySQL Workbench
- Git (optional for publishing to GitHub)

## Database design
- `customers`: customer profile
- `products`: product, category, price, and cost
- `orders`: one row per order
- `order_items`: one row per product line in an order
- `returns`: returned quantities and refund details linked to order items

### Relationships
- `customers.customer_id` → `orders.customer_id`
- `orders.order_id` → `order_items.order_id`
- `products.product_id` → `order_items.product_id`
- `order_items.order_item_id` → `returns.order_item_id`

## Run order in MySQL Workbench
Open each file, click the lightning bolt (Execute), and run them in this order:

1. `sql/01_create_database.sql`
2. `sql/02_create_tables.sql`
3. `sql/03_insert_sample_data.sql`
4. `sql/04_data_quality_checks.sql`
5. `sql/05_sales_analysis.sql`
6. `sql/06_product_analysis.sql`
7. `sql/07_customer_analysis.sql`
8. `sql/08_returns_analysis.sql`

Run one file at a time. After each script, check the output/results. The scripts target MySQL 8.0+.

## Definitions used in this project
- **Gross line sales** = quantity × unit price
- **Line revenue before returns** = quantity × unit price − line discount
- **Completed-order revenue before refunds** = sum of line revenue for orders marked `Completed`
- **AOV** = completed-order revenue before refunds ÷ number of completed orders
- **Unit return rate** = returned units ÷ units sold in completed orders
- The model does not include taxes, shipping, or inventory movements. Profit calculations are illustrative and use stored unit cost.
