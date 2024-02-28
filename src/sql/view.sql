CREATE VIEW cumulative_snowfall AS
SELECT
    weather.station_name,
    weather.region,
    bihourly_weather.hour,
    CASE
        WHEN bihourly_weather.avg_temperature > 0 THEN
            SUM(bihourly_weather.total_snow) OVER (
        PARTITION BY weather.station_name
        ORDER BY bihourly_weather.hour
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ) - (bihourly_weather.avg_temperature * 0.1)
        ELSE
            SUM(bihourly_weather.total_snow) OVER (
        PARTITION BY weather.station_name
        ORDER BY bihourly_weather.hour
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        )
        END AS snowfall_last_12_hours,
    CASE
        WHEN bihourly_weather.avg_temperature > 0 THEN
            SUM(bihourly_weather.total_snow) OVER (
                PARTITION BY weather.station_name
                ORDER BY bihourly_weather.hour
                ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
            ) - (bihourly_weather.avg_temperature * 0.1)
        ELSE
            SUM(bihourly_weather.total_snow) OVER (
                PARTITION BY weather.station_name
                ORDER BY bihourly_weather.hour
                ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
            )
        END AS snowfall_last_day,
    CASE
        WHEN bihourly_weather.avg_temperature > 0 THEN
            SUM(bihourly_weather.total_snow) OVER (
                PARTITION BY weather.station_name
                ORDER BY bihourly_weather.hour
                ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
            ) - (bihourly_weather.avg_temperature * 0.1)
        ELSE
            SUM(bihourly_weather.total_snow) OVER (
                PARTITION BY weather.station_name
                ORDER BY bihourly_weather.hour
                ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
            )
        END AS snowfall_last_2_days,
    CASE
        WHEN bihourly_weather.avg_temperature > 0 THEN
            SUM(bihourly_weather.total_snow) OVER (
                PARTITION BY weather.station_name
                ORDER BY bihourly_weather.hour
                ROWS BETWEEN 83 PRECEDING AND CURRENT ROW
            ) - (bihourly_weather.avg_temperature * 0.1)
        ELSE
            SUM(bihourly_weather.total_snow) OVER (
                PARTITION BY weather.station_name
                ORDER BY bihourly_weather.hour
                ROWS BETWEEN 83 PRECEDING AND CURRENT ROW
            )
        END AS snowfall_last_week,
    CASE
        WHEN bihourly_weather.avg_temperature > 0 THEN 'Snow is melting'
        ELSE 'Snow is accumulating'
        END AS snow_status
FROM
    bihourly_weather
        JOIN
    weather ON bihourly_weather.station_name = weather.station_name;