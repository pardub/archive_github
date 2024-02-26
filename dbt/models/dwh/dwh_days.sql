{{
    config(materialized='table',
        partition_by={
            "field": "created_at_truncated",
            "data_type": "timestamp",
            "granularity": "day"
        },
        cluster_by = "actor_id",
        schema='dwh'
    )
}}

SELECT 
    *,
    -- First, convert created_at to TIMESTAMP
    CAST(created_at AS TIMESTAMP) as created_at_timestamp,
    -- Then use the converted timestamp in TIMESTAMP_TRUNC
    TIMESTAMP_TRUNC(CAST(created_at AS TIMESTAMP), DAY) as created_at_truncated
FROM 
    `final-project-zoomcamp-2024.gh_archive_all.gh_external_table`
