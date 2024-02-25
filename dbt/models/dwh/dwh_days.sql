{{
    config(materialized='table',
        partition_by={
            "field": "created_at",
            "data_type": "timestamp",
            "granularity": "day"
        },
        cluster_by = "actor_id",
        schema='dwh'
    )
}}

SELECT 
    *,
    -- Fix the timestamp and overwrite the original 'created_at' column
    TIMESTAMP_MICROS(CAST(created_at / 1000 AS INT64)) AS created_at
FROM 
    {{ source('dwh', 'gh_external_table') }}
