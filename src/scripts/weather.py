import os
import requests
from supabase import create_client, Client
from datetime import datetime

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)

api_key = os.environ['OPENWEATHER_API_KEY']

# Fetch the stations from Supabase using supabase-py
stations = supabase.table("skistations").select("*").execute()

for station in stations['data']:
    id, name, region_id, lat, lon = station["id"], station["name"], station["region_id"], station["latitude"], station["longitude"]

    response = requests.get(f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}')
    data = response.json()

    snow = data['snow']['1h'] if 'snow' in data and '1h' in data['snow'] else 0
    visibility = data['visibility'] if 'visibility' in data else None
    dt = data['dt'] if 'dt' in data else None
    clouds = data['clouds']['all'] if 'clouds' in data and 'all' in data['clouds'] else None
    weather_main = data['weather'][0]['main'] if 'weather' in data and len(data['weather']) > 0 else None
    weather_description = data['weather'][0]['description'] if 'weather' in data and len(data['weather']) > 0 else None

    timestamp = datetime.fromtimestamp(dt).strftime('%Y-%m-%d %H:%M:%S') if dt else None

    # Insert the weather data into Supabase using supabase-py
    supabase.table("weathers").insert({
        "skistation_id": id,
        "temperature": data['main']['temp'],
        "wind_speed": data['wind']['speed'],
        "snow": snow,
        "visibility": visibility,
        "clouds": clouds,
        "weather_main": weather_main,
        "weather_description": weather_description,
        "timestamp": timestamp
    }).execute()