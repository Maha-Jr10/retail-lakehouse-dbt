{% snapshot customer_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_sk',
        strategy='check',
        check_cols=['first_name', 'last_name', 'email', 'phone', 'loyalty_tier'],
        invalidate_hard_deletes=True
    )
}}

SELECT * FROM {{ ref('bronze_customer') }}

{% endsnapshot %}
