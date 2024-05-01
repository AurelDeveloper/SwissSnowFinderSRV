# SwissSnowFinder

It's a server script for an app that finds the ski station with the best snow in Switzerland.

**Note**: I won't continue developing this project for the moment because I don't have the competence to develop an iOS app.

## Functions

- **weather.py:** Fetches the list of all ski stations in Switzerland. The list is stored in a Postgres table in the Supabase database. It runs on GitHub Actions.

## Views

- #### `cumulative_snowfall`
Generates a summary of the snowfall from the last 12 hours, last day, and last 3 days.

- #### `regions_recommendations`
Finds the best ski station for every region in Switzerland.

- #### `users_recommendations`
Connects the region that the user has chosen with the best ski station for this region.

## Tables

- ### `user_preferences`
``` sql
create table
  public.users_preferences (
    id serial,
    user_id uuid not null,
    region_id integer not null,
    constraint users_preferences_pkey primary key (id),
    constraint users_preferences_region_id_fkey foreign key (region_id) references regions (id),
    constraint users_preferences_user_id_fkey foreign key (user_id) references users (id)
  ) tablespace pg_default;
```

- ### `users`
``` sql
create table
  public.users (
    id uuid not null default gen_random_uuid (),
    aud text null,
    role text null,
    email text null,
    confirmed_at timestamp with time zone null,
    last_sign_in_at timestamp with time zone null,
    app_metadata jsonb null,
    user_metadata jsonb null,
    created_at timestamp with time zone null default now(),
    updated_at timestamp with time zone null default now(),
    constraint users_pkey primary key (id),
    constraint users_aud_check check ((char_length(aud) > 0)),
    constraint users_email_check check ((char_length(email) > 0)),
    constraint users_role_check check ((char_length(role) > 0))
  ) tablespace pg_default;
```

- ### `weathers`
``` sql
create table
  public.weathers (
    id serial,
    skistation_id integer not null,
    temperature numeric(5, 2) null,
    wind_speed numeric(5, 2) null,
    snow numeric(5, 2) null,
    timestamp timestamp without time zone not null,
    visibility integer null,
    clouds integer null,
    weather_main text null,
    weather_description text null,
    constraint weathers_pkey primary key (id),
    constraint weathers_skistation_id_fkey foreign key (skistation_id) references skistations (id)
  ) tablespace pg_default;
```

- ### `skistations`
``` sql
create table
  public.skistations (
    id serial,
    name text not null,
    region_id integer not null,
    latitude real not null,
    longitude real not null,
    constraint skistations_pkey primary key (id),
    constraint skistations_region_id_fkey foreign key (region_id) references regions (id)
  ) tablespace pg_default;
```

- ### `regions`
``` sql
create table
  public.regions (
    id serial,
    name text not null,
    constraint regions_pkey primary key (id)
  ) tablespace pg_default;
```
  

## Tech Stack

**Server:** Supabase, GitHub Actions, OpenWeather API

## TODO

- Import the list of all ski stations in Switzerland with their coordinates and regions.
- Import the list of all regions (cantons) in Switzerland.
- Create the app.
- Create the user backend.
- Setup github actions to run the `weathers.py`.
