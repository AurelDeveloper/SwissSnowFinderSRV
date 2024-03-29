CREATE VIEW user_skistation_snowfall AS
SELECT
    users.name AS username,
    skistations.name AS skistation,
    cumulative_snowfall.snowfall_last_3_days AS snowfall_last_3_days
FROM
    users
        JOIN users_preferences ON users.id = users_preferences.user_id
        JOIN skistations ON users_preferences.region_id = skistations.region_id
        JOIN cumulative_snowfall ON cumulative_snowfall.station_id = skistations.id
WHERE
    cumulative_snowfall.snowfall_last_3_days > 0.2;