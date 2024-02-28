import os
import sqlite3
import requests

db_path = '../meteo.db'
api_key = '8c5029c0520440cedde7e4884da9ec6d'

conn = sqlite3.connect(db_path)
c = conn.cursor()

c.execute("SELECT name, region, latitude, longitude FROM ski_stations")
stations = c.fetchall()

for station in stations:
    name, region, lat, lon = station

    response = requests.get(f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}')
    data = response.json()

    snow = data['snow']['1h'] if 'snow' in data and '1h' in data['snow'] else 0
    visibility = data['visibility'] if 'visibility' in data else None
    dt = data['dt'] if 'dt' in data else None
    clouds = data['clouds']['all'] if 'clouds' in data and 'all' in data['clouds'] else None
    weather_main = data['weather'][0]['main'] if 'weather' in data and len(data['weather']) > 0 else None
    weather_description = data['weather'][0]['description'] if 'weather' in data and len(data['weather']) > 0 else None

    sunrise = data['sys']['sunrise']
    sunset = data['sys']['sunset']

    c.execute("""
        INSERT INTO weather (station_name, region, latitude, longitude, temperature, wind_speed, snow, sunrise, sunset, visibility, dt, clouds, weather_main, weather_description)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (name, region, lat, lon, data['main']['temp'], data['wind']['speed'], snow, sunrise, sunset, visibility, dt, clouds, weather_main, weather_description))

conn.commit()
conn.close()