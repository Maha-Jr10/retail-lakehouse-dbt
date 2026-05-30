{{ config(
    materialized='view',
    schema='bronze'
) }}

{% set price_columns = ['unit_price', 'gross_amount', 'discount_amount', 'net_amount'] %}
{% set use_cents = false %}

SELECT
    sales_id,
    customer_sk,
    product_sk,
    store_sk,
    date_sk,
    promotion_sk,

    {{ generate_surrogate_key(['sales_id', 'customer_sk', 'product_sk']) }} AS sale_surrogate_key,

    {% for col in price_columns %}
        {% if use_cents %}
            {{ cents_to_dollars(col) }} AS {{ col }}
        {% else %}
            {{ col }}
        {% endif %}
        {%- if not loop.last %},{% endif %}
    {% endfor %},

    {{ safe_divide('discount_amount', 'gross_amount') }} AS discount_rate,

    quantity,
    payment_method

FROM {{ source('source', 'fact_sales') }}
