DROP VIEW IF EXISTS cumulative_snowfall;

CREATE VIEW cumulative_snowfall AS
SELECT
    ski_stations.id AS station_id,
    ski_stations.name AS station_name,
    ski_stations.region_id,
    weather.dt AS hour,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_12_hours,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_day,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_2_days,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 47 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_3_days,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 71 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_4_days,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 95 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_5_days,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 119 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_6_days,
    SUM(weather.snow) OVER (
        PARTITION BY ski_stations.id
        ORDER BY weather.dt
        ROWS BETWEEN 143 PRECEDING AND CURRENT ROW
        ) AS snowfall_last_7_days,
    CASE
        WHEN weather.temperature > 0 THEN 'Snow is melting'
        ELSE 'Snow is accumulating'
        END AS snow_status
FROM
    weather
        JOIN
    ski_stations ON weather.ski_station_id = ski_stations.id;