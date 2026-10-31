-- Splitting Table into Multiple Tables

-- 1. Create Customers Tables having customer info
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_fname VARCHAR(100),
    customer_lname VARCHAR(100),
    customer_segment VARCHAR(50),
    customer_city VARCHAR(100),
    customer_state VARCHAR(100),
    customer_country VARCHAR(100),
    customer_zipcode VARCHAR(20)
);

INSERT INTO customers (
    customer_id,
    customer_fname,
    customer_lname,
    customer_segment,
    customer_city,
    customer_state,
    customer_country,
    customer_zipcode
)
SELECT DISTINCT
    `Customer_Id`,
    `Customer_Fname`,
    `Customer_Lname`,
    `Customer_Segment`,
    `Customer_City`,
    `Customer_State`,
    `Customer_Country`,
    `Customer_Zipcode`
FROM supply_data;
describe customers;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT *
FROM customers
LIMIT 10;

-- 2. Creating Products table cintaing product info.alter
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category_id INT,
    category_name VARCHAR(100),
    product_price DECIMAL(12,2)
);

INSERT INTO products (
    product_id,
    product_name,
    product_category_id,
    category_name,
    product_price
)
SELECT DISTINCT
    `Product_Card_Id`,
    `Product_Name`,
    `Product_Category_Id`,
    `Category_Name`,
    `Product_Price`
FROM supply_data;

SELECT COUNT(*) AS total_products
FROM products;

SELECT *
FROM products
LIMIT 20;

-- 3. Creating Orders Tables containg Order Info.

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(50),
    order_region VARCHAR(100),
    order_country VARCHAR(100),
    order_city VARCHAR(100),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

INSERT INTO orders (
    order_id,
    customer_id,
    order_date,
    order_status,
    order_region,
    order_country,
    order_city
)
SELECT DISTINCT
    `Order_Id`,
    `Customer_Id`,
	`order_date_(DateOrders)`,
    `Order_Status`,
    `Order_Region`,
    `Order_Country`,
    `Order_City`
FROM supply_data;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT *
FROM orders
LIMIT 10;

-- 4. Creating Order-item table

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    quantity INT,
    sales DECIMAL(12,2),
    profit DECIMAL(12,2),
    profit_ratio DECIMAL(12,4),
    discount DECIMAL(12,2),
    discount_rate DECIMAL(12,4),

    CONSTRAINT fk_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

INSERT INTO order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    sales,
    profit,
    profit_ratio,
    discount,
    discount_rate
)
SELECT
    `Order_Item_Id`,
    `Order_Id`,
    `Product_Card_Id`,
    `Order_Item_Quantity`,
    `Sales`,
    `Order_Profit_Per_Order`,
    `Order_Item_Profit_Ratio`,
    `Order_Item_Discount`,
    `Order_Item_Discount_Rate`
FROM supply_data;


SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM order_items;

SELECT COUNT(DISTINCT product_id) AS unique_products
FROM order_items;

-- 5. Creating shipping table

CREATE TABLE shipping (
    order_item_id INT PRIMARY KEY,
    shipping_mode VARCHAR(50),
    actual_shipping_days INT,
    scheduled_shipping_days INT,
    late_delivery_risk TINYINT,
    delivery_status VARCHAR(100),

    CONSTRAINT fk_shipping_order_item
        FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id)
);

INSERT INTO shipping (
    order_item_id,
    shipping_mode,
    actual_shipping_days,
    scheduled_shipping_days,
    late_delivery_risk,
    delivery_status
)
SELECT
`Order_Item_Id`,
`Shipping_Mode`,
`Days_for_shipping_(real)`,
`Days_for_shipment_(scheduled)`,
`Late_delivery_risk`,
`Delivery_Status`
FROM supply_data;


SELECT COUNT(*) AS total_shipping_records
FROM shipping;

SELECT COUNT(*) AS missing_order_items
FROM shipping s
LEFT JOIN order_items oi
    ON s.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;

SELECT shipping_mode, COUNT(*) AS total_records
FROM shipping
GROUP BY shipping_mode
ORDER BY total_records DESC;




SELECT COUNT(*) AS items_without_orders
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS items_without_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT * FROM orders
LIMIT 10;