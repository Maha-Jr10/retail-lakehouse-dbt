{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    date_sk,
    date,
    year,
    quarter,
    month,
    month_name,
    day_name,
    is_weekend,

    COUNT(sales_id)                                                             AS total_orders,
    SUM(quantity)                                                               AS total_units_sold,
    SUM(gross_amount)                                                           AS total_gross_revenue,
    SUM(discount_amount)                                                        AS total_discounts,
    SUM(net_amount)                                                             AS total_net_revenue,
    AVG(net_amount)                                                             AS avg_order_value,
    {{ safe_divide('SUM(discount_amount)', 'SUM(gross_amount)') }}             AS overall_discount_rate

FROM {{ ref('silver_sales') }}
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
ORDER BY date_sk
