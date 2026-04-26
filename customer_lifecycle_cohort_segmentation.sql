WITH customer_purchases AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase,
        MAX(o.order_purchase_timestamp) AS last_purchase,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

customer_lifecycle AS (
    SELECT
        customer_unique_id,
        first_purchase,
        last_purchase,
        total_orders,
        CAST((JULIANDAY(last_purchase) - JULIANDAY(first_purchase)) AS INTEGER) AS lifecycle_days,
        CAST((JULIANDAY('2018-09-01') - JULIANDAY(last_purchase)) AS INTEGER) AS days_since_last_purchase
    FROM customer_purchases
),

segmented_customers AS (
    SELECT
        customer_unique_id,
        total_orders,
        lifecycle_days,
        days_since_last_purchase,
        CASE
            WHEN days_since_last_purchase > 180 THEN 'Churned'
            WHEN days_since_last_purchase > 90 THEN 'At Risk'
            ELSE 'Active'
        END AS customer_status,
        CASE
            WHEN total_orders = 1 THEN 'New Customer'
            WHEN total_orders BETWEEN 2 AND 3 THEN 'Early-Stage Customer'
            ELSE 'Repeated Customer'
        END AS purchase_stage
    FROM customer_lifecycle
),

stage_totals AS (
    SELECT
        purchase_stage,
        COUNT(*) AS total_customers_in_stage
    FROM segmented_customers
    GROUP BY purchase_stage
)

SELECT
    sc.purchase_stage,
    sc.customer_status,
    COUNT(*) AS customer_count_in_segment,
    st.total_customers_in_stage,
    ROUND(100.0 * COUNT(*) / st.total_customers_in_stage, 2) AS percent_within_stage,
    ROUND(AVG(sc.lifecycle_days), 2) AS avg_lifecycle_days,
    ROUND(AVG(sc.days_since_last_purchase), 2) AS avg_days_since_last_purchase
FROM segmented_customers sc
JOIN stage_totals st ON sc.purchase_stage = st.purchase_stage
GROUP BY sc.purchase_stage, sc.customer_status
ORDER BY 
    CASE sc.purchase_stage
        WHEN 'New Customer' THEN 1
        WHEN 'Early-Stage Customer' THEN 2
        WHEN 'Repeated Customer' THEN 3
    END,
    CASE sc.customer_status
        WHEN 'Active' THEN 1
        WHEN 'At Risk' THEN 2
        WHEN 'Churned' THEN 3
    END;
