{% snapshot store_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='store_sk',
        strategy='check',
        check_cols=['store_name', 'region', 'city', 'country'],
        invalidate_hard_deletes=True
    )
}}

SELECT * FROM {{ ref('bronze_store') }}

{% endsnapshot %}
