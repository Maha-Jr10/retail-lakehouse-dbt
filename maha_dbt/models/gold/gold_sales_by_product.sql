{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    product_sk,
    product_name,
    category,
    department,
    list_price,

    COUNT(sales_id)                                                             AS total_orders,
    SUM(quantity)                                                               AS total_units_sold,
    SUM(gross_amount)                                                           AS total_gross_revenue,
    SUM(discount_amount)                                                        AS total_discounts,
    SUM(net_amount)                                                             AS total_net_revenue,
    AVG(net_amount)                                                             AS avg_order_value,
    {{ safe_divide('SUM(discount_amount)', 'SUM(gross_amount)') }}             AS discount_rate,
    MIN(date)                                                                   AS first_sale_date,
    MAX(date)                                                                   AS last_sale_date

FROM {{ ref('silver_sales') }}
GROUP BY 1, 2, 3, 4, 5
ORDER BY total_net_revenue DESC
