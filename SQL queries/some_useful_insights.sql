-- 1. CTE for monthly business performance
SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    SUM(oi.sales) AS total_sales,
    SUM(oi.profit) AS total_profit
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    order_year,
    order_month;

-- 2. Products performing above average
WITH above_average_performance AS (
    SELECT
        p.product_id AS Product_ID,
        p.product_name,
        SUM(oi.sales) AS Sales,
        SUM(oi.profit) AS Profits
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
),
average_sales AS (
    SELECT AVG(Sales) AS AVG_Sales
    FROM above_average_performance
)
SELECT
    a.Product_ID,
    a.product_name,
    ROUND(a.Sales, 2) AS Total_Sales,
    ROUND(a.Profits, 2) AS Total_Profit,
    ROUND(avg.AVG_Sales, 2) AS Average_Product_Sales
FROM above_average_performance a
CROSS JOIN average_sales avg
WHERE a.Sales > avg.AVG_Sales
ORDER BY a.Sales DESC;

-- 3. Products with below-average sales
WITH above_average_performance AS (
    SELECT
        p.product_id AS Product_ID,
        p.product_name,
        SUM(oi.sales) AS Sales,
        SUM(oi.profit) AS Profits
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
),
average_sales AS (
    SELECT AVG(Sales) AS AVG_Sales
    FROM above_average_performance
)
SELECT
    a.Product_ID,
    a.product_name,
    ROUND(a.Sales, 2) AS Total_Sales,
    ROUND(a.Profits, 2) AS Total_Profit,
    ROUND(avg.AVG_Sales, 2) AS Average_Product_Sales
FROM above_average_performance a
CROSS JOIN average_sales avg
WHERE a.Sales <= avg.AVG_Sales
ORDER BY a.Sales DESC;

-- 4. Rank products within each category
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_name,
        SUM(oi.sales) AS total_sales
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_name
)
SELECT
    product_name,
    category_name,
    total_sales,
    DENSE_RANK() OVER (
        PARTITION BY category_name
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM product_sales
ORDER BY category_name, sales_rank;

-- 5. Month-over-month sales growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.sales) AS total_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    sales_month,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY sales_month
    ) AS previous_month_sales
FROM monthly_sales
ORDER BY sales_month;

-- 6. Cumulative monthly sales
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.sales) AS total_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(total_sales, 2) AS monthly_sales,
    ROUND(
        SUM(total_sales) OVER (
            ORDER BY sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_sales
FROM monthly_sales
ORDER BY sales_month;

-- 7. Rank customers by sales and profit
WITH customer_performance AS (
    SELECT
        c.customer_id,
        c.customer_fname,
        c.customer_lname,
        SUM(oi.sales) AS total_sales,
        SUM(oi.profit) AS total_profit
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_fname,
        c.customer_lname
),
customer_ranking AS (
    SELECT
        customer_id,
        customer_fname,
        customer_lname,
        total_sales,
        total_profit,
        DENSE_RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank,
        DENSE_RANK() OVER (
            ORDER BY total_profit DESC
        ) AS profit_rank
    FROM customer_performance
)
SELECT *
FROM customer_ranking
WHERE sales_rank <= 10
ORDER BY sales_rank;

-- 8. Late-delivery rates by region and shipping mode
WITH late_delivery_performance AS (
    SELECT
        o.order_region AS region,
        s.shipping_mode,
        COUNT(s.order_item_id) AS total_shipments,
        SUM(
            CASE
                WHEN s.delivery_status = 'Late delivery'
                THEN 1
                ELSE 0
            END
        ) AS late_shipments,
        ROUND(
            100.0 * SUM(
                CASE
                    WHEN s.delivery_status = 'Late delivery'
                    THEN 1
                    ELSE 0
                END
            ) / NULLIF(COUNT(s.order_item_id), 0),
            2
        ) AS late_percentage

    FROM shipping s
    JOIN order_items oi
        ON s.order_item_id = oi.order_item_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY
        o.order_region,
        s.shipping_mode
)
SELECT *
FROM late_delivery_performance
ORDER BY late_percentage DESC;

-- 9. Compare shipping modes within each region
WITH late_delivery_performance AS (
    SELECT
        o.order_region AS region,
        s.shipping_mode,
        COUNT(s.order_item_id) AS total_shipments,
        SUM(
            CASE
                WHEN s.delivery_status = 'Late delivery'
                THEN 1 ELSE 0
            END
        ) AS late_shipments,
        ROUND(AVG(s.actual_shipping_days), 2) AS avg_actual_shipping_days,
        ROUND(
            100.0 * SUM(
                CASE
                    WHEN s.delivery_status = 'Late delivery'
                    THEN 1 ELSE 0
                END
            ) / NULLIF(COUNT(s.order_item_id), 0),
            2
        ) AS late_percentage
    FROM shipping s
    JOIN order_items oi
        ON s.order_item_id = oi.order_item_id
    JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY
        o.order_region,
        s.shipping_mode
),
ranked_performance AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY late_percentage ASC
        ) AS ranking
    FROM late_delivery_performance
)
SELECT *
FROM ranked_performance
ORDER BY region, ranking;

-- 10. Investigate delivery delays by scheduled duration
SELECT
    scheduled_shipping_days,
    COUNT(*) AS total_shipments,

    ROUND(AVG(actual_shipping_days), 2)
        AS avg_actual_shipping_days,

    ROUND(AVG(scheduled_shipping_days), 2)
        AS avg_scheduled_shipping_days,

    ROUND(
        AVG(actual_shipping_days - scheduled_shipping_days),
        2
    ) AS avg_delay_days,

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

FROM shipping
GROUP BY scheduled_shipping_days
ORDER BY scheduled_shipping_days;

-- 11. Pareto analysis of product sales
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.sales) AS total_sales
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
),
product_contribution AS (
    SELECT
        product_id,
        product_name,
        total_sales,
        SUM(total_sales) OVER () AS overall_sales,
        DENSE_RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank,
        SUM(total_sales) OVER (
            ORDER BY total_sales DESC, product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_sales
    FROM product_sales
)
SELECT
    product_id,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    sales_rank,
    ROUND(
        total_sales / NULLIF(overall_sales, 0) * 100,
        2
    ) AS contribution_percentage,
    ROUND(
        cumulative_sales / NULLIF(overall_sales, 0) * 100,
        2
    ) AS cumulative_contribution_percentage
FROM product_contribution
ORDER BY total_sales DESC, product_id;
