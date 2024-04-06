DROP VIEW IF EXISTS cumulative_snowfall;

CREATE VIEW cumulative_snowfall AS
SELECT
    skistations.id AS skistation_id,
    skistations.name AS skistation_name,
    skistations.region_id,
    weathers.timestamp AS hour,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_12_hours,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_day,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_2_days,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 47 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_3_days,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 71 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_4_days,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 95 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_5_days,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 119 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_6_days,
    SUM(weathers.snow) OVER (
        PARTITION BY skistations.id
        ORDER BY weathers.timestamp
        ROWS BETWEEN 143 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_7_days,
    CASE
        WHEN weathers.temperature > 0 THEN 'Snow is melting'
        ELSE 'Snow is accumulating'
        END AS snow_status
FROM
    weathers
        JOIN
    skistations ON weathers.skistation_id = skistations.id;