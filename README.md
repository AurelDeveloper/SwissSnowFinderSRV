# Project Title

It's a server script for an app that finds the ski station with the best snow in Switzerland.

## Functions

- **weather.py:** Fetches the list of all ski stations in Switzerland. The list is stored in a Postgres table in the Supabase database. It runs on GitHub Actions.

### Views

#### cumulative_snowfall
![cumulative_snowfall](path_to_cumulative_snowfall_image.jpg)
Generates a summary of the snowfall from the last 12 hours, last day, and last 3 days.

#### regions_recommendations
![regions_recommendations](path_to_regions_recommendations_image.jpg)
Finds the best ski station for every region in Switzerland.

#### users_recommendations
![users_recommendations](path_to_users_recommendations_image.jpg)
Connects the region that the user has chosen with the best ski station for this region.

### Tables

- #### user_preferences

- #### user

- `weathers`
  ![weathers](path_to_weathers_image.jpg)

- `ski_stations`
  ![ski_stations](path_to_ski_stations_image.jpg)

- `regions`
  ![regions](![Screenshot 2024-04-30 at 22 53 39](https://github.com/AurelDeveloper/SwissSnowFinderSRV/assets/150530607/f5de845d-b69a-492f-b7c7-3989b8f721a3)
)

- `skistations`
  ![skistations](path_to_skistations_image.jpg)

## Tech Stack

**Server:** Supabase, GitHub Actions, OpenWeather API

## Roadmap

- Import the list of all ski stations in Switzerland with their coordinates and regions.
- Import the list of all regions (cantons) in Switzerland.
- Create the app.
- Create the user backend.
