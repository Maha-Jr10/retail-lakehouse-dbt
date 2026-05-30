-- RFM segmentation: Recency, Frequency, Monetary
WITH rfm_scores AS (
    SELECT
        customer_sk,
        first_name,
        last_name,
        loyalty_tier,
        lifetime_value,
        total_orders,
        last_purchase_date,
        first_purchase_date,
        DATEDIFF(CURRENT_DATE(), last_purchase_date)    AS days_since_last_purchase,

        NTILE(3) OVER (ORDER BY last_purchase_date DESC)    AS recency_score,
        NTILE(3) OVER (ORDER BY total_orders DESC)          AS frequency_score,
        NTILE(3) OVER (ORDER BY lifetime_value DESC)        AS monetary_score
    FROM {{ ref('gold_customer_summary') }}
)

SELECT
    customer_sk,
    first_name,
    last_name,
    loyalty_tier,
    lifetime_value,
    total_orders,
    days_since_last_purchase,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS rfm_total,

    CASE
        WHEN (recency_score + frequency_score + monetary_score) <= 4 THEN 'Champions'
        WHEN (recency_score + frequency_score + monetary_score) <= 6 THEN 'Loyal Customers'
        WHEN (recency_score + frequency_score + monetary_score) <= 8 THEN 'At Risk'
        ELSE 'Lost'
    END AS customer_segment

FROM rfm_scores
ORDER BY rfm_total
