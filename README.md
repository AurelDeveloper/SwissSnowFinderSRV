# Project Title

It's a server script for an app that finds the ski station with the best snow in Switzerland.

## Functions

- **weather.py:** Fetches the list of all ski stations in Switzerland. The list is stored in a Postgres table in the Supabase database. It runs on GitHub Actions.

- **VIEW:** `cumulative_snowfall` generates a summary of the snowfall from the last 12 hours, last day, and last 3 days.

- **VIEW:** `regions_recommendations` finds the best ski station for every region in Switzerland.

- **VIEW:** `users_recommendations` connects the region that the user has chosen with the best ski station for this region.

- **TABLES:** `users_preferences`, `users`, `weathers`, `ski_stations`,

`regions`
![Screenshot 2024-04-30 at 22 47 25](https://github.com/AurelDeveloper/SwissSnowFinderSRV/assets/150530607/48ffe3be-ff36-4b3f-8f9d-4fbb9d0d4174)

`skistations`

## Tech Stack

**Server:** Supabase, GitHub Actions, OpenWeather API

## Roadmap

- Import the list of all ski stations in Switzerland with their coordinates and regions.
- Import the list of all regions (cantons) in Switzerland.
- Create the app.
- Create the user backend.
