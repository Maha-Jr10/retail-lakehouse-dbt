{{ config(
    materialized='view',
    schema='bronze'
) }}

SELECT
    *
FROM
    {{ source('source', 'fact_returns') }}
