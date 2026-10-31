-- CHecking Data for Splitting Table into Multiple Table

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT `Order_Id`) AS unique_orders,
    COUNT(DISTINCT `Order_Item_Id`) AS unique_order_items,
    COUNT(DISTINCT `Customer_Id`) AS unique_customers,
    COUNT(DISTINCT `Product_Card_Id`) AS unique_products
FROM supply_data;

-- Check whether each order belongs to one customer
SELECT
    `Order_Id`,
    COUNT(DISTINCT `Customer_Id`) AS customer_count
FROM supply_data
GROUP BY `Order_Id`
HAVING COUNT(DISTINCT `Customer_Id`) > 1;


SELECT
    `Customer_Id`,
    COUNT(DISTINCT `Customer_Fname`) AS first_names,
    COUNT(DISTINCT `Customer_Lname`) AS last_names,
    COUNT(DISTINCT `Customer_Email`) AS emails
FROM supply_data
GROUP BY `Customer_Id`
HAVING
    COUNT(DISTINCT `Customer_Fname`) > 1
    OR COUNT(DISTINCT `Customer_Lname`) > 1
    OR COUNT(DISTINCT `Customer_Email`) > 1;
