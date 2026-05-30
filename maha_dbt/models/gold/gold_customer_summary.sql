{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    customer_sk,
    first_name,
    last_name,
    email,
    phone,
    gender,
    loyalty_tier,

    COUNT(sales_id)                                                             AS total_orders,
    SUM(quantity)                                                               AS total_units_purchased,
    SUM(gross_amount)                                                           AS total_gross_spend,
    SUM(net_amount)                                                             AS lifetime_value,
    AVG(net_amount)                                                             AS avg_order_value,
    SUM(discount_amount)                                                        AS total_discounts_received,
    {{ safe_divide('SUM(discount_amount)', 'SUM(gross_amount)') }}             AS avg_discount_rate,
    MIN(date)                                                                   AS first_purchase_date,
    MAX(date)                                                                   AS last_purchase_date,
    COUNT(DISTINCT date_sk)                                                     AS active_days,
    COUNT(DISTINCT product_sk)                                                  AS unique_products_bought,
    COUNT(DISTINCT store_sk)                                                    AS unique_stores_visited

FROM {{ ref('silver_sales') }}
GROUP BY 1, 2, 3, 4, 5, 6, 7
ORDER BY lifetime_value DESC
