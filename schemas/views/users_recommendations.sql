create view
  public.users_recommendations as
with
  user_region_preferences as (
    select
      users.id as user_id,
      users_preferences.region_id
    from
      users
      join users_preferences on users.id = users_preferences.user_id
  ),
  region_top_stations as (
    select
      regions_recommendations.region_id,
      regions_recommendations.skistation_id,
      regions_recommendations.points
    from
      regions_recommendations
  )
select
  user_region_preferences.user_id,
  region_top_stations.skistation_id
from
  user_region_preferences
  join region_top_stations on user_region_preferences.region_id = region_top_stations.region_id;