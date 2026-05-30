{% snapshot product_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='product_sk',
        strategy='check',
        check_cols=['product_name', 'list_price', 'category', 'department'],
        invalidate_hard_deletes=True
    )
}}

SELECT * FROM {{ ref('bronze_product') }}

{% endsnapshot %}
