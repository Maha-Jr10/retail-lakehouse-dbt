-- Monthly revenue trend with month-over-month growth rate
WITH monthly AS (
    SELECT
        year,
        month,
        month_name,
        SUM(total_net_revenue)  AS revenue,
        SUM(total_orders)       AS orders,
        SUM(total_units_sold)   AS units_sold
    FROM {{ ref('gold_sales_by_day') }}
    GROUP BY 1, 2, 3
),

with_growth AS (
    SELECT
        year,
        month,
        month_name,
        revenue,
        orders,
        units_sold,
        LAG(revenue) OVER (ORDER BY year, month)    AS prev_month_revenue,
        {{ safe_divide(
            'revenue - LAG(revenue) OVER (ORDER BY year, month)',
            'LAG(revenue) OVER (ORDER BY year, month)'
        ) }} * 100                                   AS mom_growth_pct
    FROM monthly
)

SELECT * FROM with_growth
ORDER BY year, month
