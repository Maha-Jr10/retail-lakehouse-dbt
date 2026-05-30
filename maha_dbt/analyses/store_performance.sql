-- Store performance ranked globally and within each region
WITH ranked AS (
    SELECT
        store_sk,
        store_name,
        store_region,
        store_country,
        timezone,
        total_orders,
        unique_customers,
        total_net_revenue,
        avg_order_value,
        revenue_per_customer,
        discount_rate,
        first_sale_date,
        last_sale_date,

        RANK() OVER (ORDER BY total_net_revenue DESC)                                AS overall_rank,
        RANK() OVER (PARTITION BY store_region ORDER BY total_net_revenue DESC)      AS rank_in_region,
        {{ safe_divide('total_net_revenue', 'SUM(total_net_revenue) OVER ()') }} * 100 AS pct_of_total_revenue
    FROM {{ ref('gold_sales_by_store') }}
)

SELECT * FROM ranked
ORDER BY overall_rank
