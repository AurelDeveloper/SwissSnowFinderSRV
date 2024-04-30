create view
  public.cumulative_snowfall as
select
  skistations.id as skistation_id,
  skistations.name as skistation_name,
  skistations.region_id,
  weathers."timestamp" as hour,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 5 preceding
      and current row
  ) as snowfall_last_12_hours,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 11 preceding
      and current row
  ) as snowfall_last_day,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 23 preceding
      and current row
  ) as snowfall_last_2_days,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 47 preceding
      and current row
  ) as snowfall_last_3_days,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 71 preceding
      and current row
  ) as snowfall_last_4_days,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 95 preceding
      and current row
  ) as snowfall_last_5_days,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 119 preceding
      and current row
  ) as snowfall_last_6_days,
  sum(weathers.snow) over (
    partition by
      skistations.id
    order by
      weathers."timestamp" rows between 143 preceding
      and current row
  ) as snowfall_last_7_days,
  case
    when weathers.temperature > 0::numeric then 'Snow is melting'::text
    else 'Snow is accumulating'::text
  end as snow_status
from
  weathers
  join skistations on weathers.skistation_id = skistations.id;