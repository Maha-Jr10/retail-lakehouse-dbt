{{ config(
    materialized='incremental',
    schema='silver',
    unique_key='sales_id',
    on_schema_change='sync_all_columns'
) }}

WITH sales AS (
    SELECT * FROM {{ ref('bronze_sales') }}
    {% if is_incremental() %}
        WHERE date_sk > (SELECT MAX(date_sk) FROM {{ this }})
    {% endif %}
),

customers AS (
    SELECT * FROM {{ ref('bronze_customer') }}
),

products AS (
    SELECT * FROM {{ ref('bronze_product') }}
),

stores AS (
    SELECT * FROM {{ ref('bronze_store') }}
),

dates AS (
    SELECT * FROM {{ ref('bronze_date') }}
),

store_regions AS (
    SELECT * FROM {{ ref('store_regions') }}
)

SELECT
    -- keys
    sales.sales_id,
    sales.sale_surrogate_key,
    sales.customer_sk,
    sales.product_sk,
    sales.store_sk,
    sales.date_sk,

    -- customer
    customers.first_name,
    customers.last_name,
    customers.email,
    customers.phone,
    customers.gender,
    customers.loyalty_tier,

    -- product
    products.product_name,
    products.category,
    products.department,
    products.list_price,

    -- store
    stores.store_name,
    stores.city                AS store_city,
    stores.region              AS store_region,
    stores.country             AS store_country,
    store_regions.timezone,

    -- date
    dates.date,
    dates.year,
    dates.quarter,
    dates.month,
    dates.month_name,
    dates.day_name,
    dates.is_weekend,

    -- measures
    sales.quantity,
    sales.unit_price,
    sales.gross_amount,
    sales.discount_amount,
    sales.net_amount,
    sales.payment_method,
    sales.discount_rate

FROM sales
LEFT JOIN customers    ON sales.customer_sk = customers.customer_sk
LEFT JOIN products     ON sales.product_sk  = products.product_sk
LEFT JOIN stores       ON sales.store_sk    = stores.store_sk
LEFT JOIN dates        ON sales.date_sk     = dates.date_sk
LEFT JOIN store_regions ON stores.region   = store_regions.region_name
