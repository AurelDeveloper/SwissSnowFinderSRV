create view
  public.regions_recommendations as
with
  ranked_stations as (
    select
      skistations.region_id,
      skistations.id as skistation_id,
      cumulative_snowfall.snowfall_last_day,
      cumulative_snowfall.snowfall_last_2_days,
      cumulative_snowfall.snowfall_last_3_days,
      case
        when cumulative_snowfall.snowfall_last_day is not null then cumulative_snowfall.snowfall_last_day
        when cumulative_snowfall.snowfall_last_2_days is not null then cumulative_snowfall.snowfall_last_2_days
        else cumulative_snowfall.snowfall_last_3_days
      end as snowfall,
      case
        when cumulative_snowfall.snowfall_last_day is not null then 3
        when cumulative_snowfall.snowfall_last_2_days is not null then 2
        else 1
      end as points,
      row_number() over (
        partition by
          skistations.region_id
        order by
          (
            case
              when cumulative_snowfall.snowfall_last_day is not null then 3
              when cumulative_snowfall.snowfall_last_2_days is not null then 2
              else 1
            end
          ) desc
      ) as rank
    from
      skistations
      join cumulative_snowfall on skistations.id = cumulative_snowfall.skistation_id
  ),
  grouped_stations as (
    select
      ranked_stations.region_id,
      ranked_stations.skistation_id,
      sum(ranked_stations.points) as points
    from
      ranked_stations
    group by
      ranked_stations.region_id,
      ranked_stations.skistation_id
  )
select
  grouped_stations.region_id,
  grouped_stations.skistation_id,
  grouped_stations.points
from
  grouped_stations
where
  grouped_stations.points = 1;