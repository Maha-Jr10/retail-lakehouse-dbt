{{ config(
    materialized='view',
    schema='bronze'
) }}

SELECT
    *
FROM
    {{ source('source', 'dim_store') }}
