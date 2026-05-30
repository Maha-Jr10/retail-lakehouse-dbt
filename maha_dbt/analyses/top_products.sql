-- Top 10 products by net revenue with contribution to total
WITH total AS (
    SELECT SUM(total_net_revenue) AS grand_total
    FROM {{ ref('gold_sales_by_product') }}
)

SELECT
    p.product_sk,
    p.product_name,
    p.category,
    p.department,
    p.total_orders,
    p.total_units_sold,
    p.total_net_revenue,
    p.list_price,
    p.discount_rate,
    {{ safe_divide('p.total_net_revenue', 't.grand_total') }} * 100  AS pct_of_total_revenue,
    RANK() OVER (ORDER BY p.total_net_revenue DESC)                  AS revenue_rank
FROM {{ ref('gold_sales_by_product') }} p
CROSS JOIN total t
ORDER BY revenue_rank
LIMIT 10
