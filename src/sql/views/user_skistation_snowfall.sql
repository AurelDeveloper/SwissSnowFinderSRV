SELECT *
FROM users
         JOIN users_preferences
              ON users.region_id = users_preferences.region_id
         JOIN weathers
              ON users_preferences.skistations_id = weathers.skistation_id
WHERE weathers.snow > 0.2;

SELECT
    users.name AS username,
    skistations.name AS skistation,
    cumulative_snowfall.snowfall_last_12_hours AS snowfall_last_12_hours,
    cumulative_snowfall.snowfall_last_day AS snowfall_last_day,
    cumulative_snowfall.snowfall_last_3_days AS snowfall_last_3_days
FROM
    users,
    users_preferences,
    skistations,
    cumulative_snowfall
WHERE
    users.id = users_preferences.user_id
  AND users_preferences.region_id = skistations.region_id
  AND cumulative_snowfall.station_id = skistations.id
  AND cumulative_snowfall.snowfall_last_3_days > 0.2;