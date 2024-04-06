DROP VIEW IF EXISTS regions_recommendations;

CREATE VIEW regions_recommendations AS
WITH ranked_stations AS (
    SELECT
        skistations.region_id,
        skistations.id AS skistation_id,
        cumulative_snowfall.snowfall_last_day,
        cumulative_snowfall.snowfall_last_2_days,
        cumulative_snowfall.snowfall_last_3_days,
        CASE
            WHEN cumulative_snowfall.snowfall_last_day IS NOT NULL THEN cumulative_snowfall.snowfall_last_day
            WHEN cumulative_snowfall.snowfall_last_2_days IS NOT NULL THEN cumulative_snowfall.snowfall_last_2_days
            ELSE cumulative_snowfall.snowfall_last_3_days
            END AS snowfall,
        (CASE
             WHEN cumulative_snowfall.snowfall_last_day IS NOT NULL THEN 3
             WHEN cumulative_snowfall.snowfall_last_2_days IS NOT NULL THEN 2
             ELSE 1
            END) AS points,
        ROW_NUMBER() OVER (
            PARTITION BY skistations.region_id
            ORDER BY
                CASE
                    WHEN cumulative_snowfall.snowfall_last_day IS NOT NULL THEN 3
                    WHEN cumulative_snowfall.snowfall_last_2_days IS NOT NULL THEN 2
                    ELSE 1
                    END DESC
            ) AS rank
    FROM
        skistations
            JOIN cumulative_snowfall ON skistations.id = cumulative_snowfall.skistation_id
)
SELECT
    region_id,
    skistation_id,
    SUM(points) AS points
FROM
    ranked_stations
GROUP BY
    region_id,
    skistation_id
HAVING
    rank = 1;