DROP VIEW IF EXISTS users_recommendations;

CREATE VIEW users_recommendations AS
WITH user_region_preferences AS (
    SELECT
        users.id AS user_id,
        users_preferences.region_id
    FROM
        users
            JOIN users_preferences ON users.id = users_preferences.user_id
),
     region_top_stations AS (
         SELECT
             region_id,
             skistation_id,
             points
         FROM
             regions_recommendations
     )
SELECT
    user_region_preferences.user_id,
    region_top_stations.skistation_id
FROM
    user_region_preferences
        JOIN region_top_stations ON user_region_preferences.region_id = region_top_stations.region_id;