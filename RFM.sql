-- Drop if exists
DROP TABLE IF EXISTS product_category_name_translation;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS geolocation;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- 1. customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 2. geolocation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

-- 3. orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 4. order_items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC
);

-- 5. order_payments
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC
);

-- 6. order_reviews
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 7. products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

-- 8. sellers
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-------------------------------------

WITH max_date AS (
    SELECT MAX(order_purchase_timestamp) AS ref_date FROM orders
),

rfm_raw AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_purchase,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

rfm_calculated AS (
    SELECT
        r.customer_unique_id,
        CAST((JULIANDAY((SELECT ref_date FROM max_date)) - JULIANDAY(r.last_purchase)) AS INTEGER) AS recency,
        r.frequency,
        r.monetary
    FROM rfm_raw r
),

scored AS (
    SELECT
        customer_unique_id,
        recency,
        frequency,
        monetary,

        CASE
            WHEN recency <= 20 THEN 5
            WHEN recency <= 50 THEN 4
            WHEN recency <= 100 THEN 3
            WHEN recency <= 200 THEN 2
            ELSE 1
        END AS r_score,

        CASE
            WHEN frequency >= 10 THEN 5
            WHEN frequency >= 5 THEN 4
            WHEN frequency >= 3 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS f_score,

        CASE
            WHEN monetary >= 1000 THEN 5
            WHEN monetary >= 500 THEN 4
            WHEN monetary >= 200 THEN 3
            WHEN monetary >= 100 THEN 2
            ELSE 1
        END AS m_score
    FROM rfm_calculated
)

SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CAST(r_score AS TEXT) || f_score || m_score AS rfm_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Recent Customer'
        WHEN r_score <= 2 AND f_score >= 4 THEN 'Frequent but At-Risk'
        WHEN r_score <= 2 AND m_score <= 2 THEN 'At-Risk'
        ELSE 'Others'
    END AS segment
FROM scored
ORDER BY rfm_score DESC;

