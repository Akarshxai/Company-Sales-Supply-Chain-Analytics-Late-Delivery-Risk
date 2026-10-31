-- Section A — Overall business performance

-- Calculate total sales, total profit, total quantity, and total order.
SELECT 
SUM(sales) as Total_sales,
SUM(profit) as Total_profit,
SUM(quantity) as Total_quantity,
COUNT(DISTINCT(order_id)) as Total_orders
FROM order_items;

-- Calculate the number of unique products and customers.
SELECT
	(SELECT COUNT(product_id) FROM products) AS Unique_Products,
    (SELECT COUNT(customer_id) FROM customers) AS Total_Customers;

-- Calculate average sales per order.

SELECT
    AVG(order_sales) AS average_sales_per_order
FROM (
    SELECT
        order_id,
        SUM(sales) AS order_sales
    FROM order_items
    GROUP BY order_id
) AS order_totals;

-- Calculate overall profit margin.

SELECT
    SUM(profit) AS total_profit,
    SUM(sales) AS total_sales,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,2
    ) AS overall_profit_margin
FROM order_items;

-- Find monthly sales and profit trends.
SELECT month(order_date) as Months,SUM(profit) as Profits
FROM orders o
join order_items oi
ON o.order_id=oi.order_id
GROUP BY Months;

-- Section B — Delivery performance

-- Delivery status distribution
SELECT delivery_status,COUNT(*) as Total 
FROM shipping
GROUP BY delivery_status;

-- Late-delivery percentage

SELECT
    COUNT(*) AS total_shipments,
    SUM(
        CASE
            WHEN delivery_status = 'Late delivery'
            THEN 1
            ELSE 0
        END
    ) AS late_shipments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN delivery_status = 'Late delivery'
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage
FROM shipping;

-- Actual versus scheduled shipping time
SELECT 
ROUND(AVG(actual_shipping_days),2) AS avg_shipping_days,
ROUND(AVG(scheduled_shipping_days),2) AS avg_scheduled_days,
ROUND(
AVG(actual_shipping_days)-AVG(scheduled_shipping_days),2
) AS avg_delay
FROM shipping;

-- Shipping-mode performance
SELECT
    shipping_mode,
    COUNT(*) AS total_shipments,
    ROUND(AVG(actual_shipping_days), 2) AS avg_actual_days,
    SUM(
        CASE
            WHEN delivery_status = 'Late delivery' THEN 1
            ELSE 0
        END
    ) AS late_shipments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN delivery_status = 'Late delivery' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage
FROM shipping
GROUP BY shipping_mode
ORDER BY late_delivery_percentage DESC;

-- Regional delivery performance
SELECT
    order_region,
    COUNT(*) AS total_shipments,
    ROUND(AVG(actual_shipping_days), 2) AS avg_actual_days,
    SUM(
        CASE
            WHEN delivery_status = 'Late delivery' THEN 1
            ELSE 0
        END
    ) AS late_shipments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN delivery_status = 'Late delivery' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN shipping s
    ON oi.order_item_id = s.order_item_id
GROUP BY o.order_region
ORDER BY late_delivery_percentage DESC;


-- SECION C- Product and profitability analysis

-- Top 10 products by sales
SELECT product_name,SUM(sales) AS Total_sales
FROM products p 
JOIN order_items oi 
ON p.product_id=oi.product_id
GROUP BY product_name
ORDER BY Total_sales DESC
LIMIT 10;

-- Top 10 products by profit
SELECT product_name,SUM(profit) AS Total_profit
FROM products p 
JOIN order_items oi 
ON p.product_id=oi.product_id
GROUP BY product_name
ORDER BY Total_profit DESC
LIMIT 10;

-- High-sales, low-profit product

WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.sales) AS total_sales,
        SUM(oi.profit) AS total_profit,
        SUM(oi.quantity) AS total_quantity
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
),
overall_average AS (
    SELECT AVG(total_sales) AS avg_product_sales
    FROM product_performance
)
SELECT
    pp.product_id,
    pp.product_name,
    ROUND(pp.total_sales, 2) AS total_sales,
    ROUND(pp.total_profit, 2) AS total_profit,
    ROUND(
        100.0 * pp.total_profit /
        NULLIF(pp.total_sales, 0),
        2
    ) AS profit_margin_percentage
FROM product_performance pp
CROSS JOIN overall_average oa
WHERE pp.total_sales > oa.avg_product_sales
  AND (
      pp.total_profit < 0
      OR 100.0 * pp.total_profit /
         NULLIF(pp.total_sales, 0) < 10
  )
ORDER BY pp.total_sales DESC;

-- Category profitability
SELECT 
category_name,SUM(sales) as Sales_,
SUM(profit) AS Profit_,SUM(quantity) as Quantity_,
ROUND(100*SUM(profit)/NULLIF(SUM(sales), 0),2) AS Profit_Margin
FROM products p
JOIN order_items oi
on p.product_id=oi.product_id
GROUP BY category_name
ORDER BY Profit_Margin DESC
LIMIT 10;

-- Highest-value customers
SELECT c.customer_id,c.customer_fname,customer_lname,SUM(sales) as Total_sales
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY customer_id
ORDER BY Total_sales DESC
LIMIT 10;
