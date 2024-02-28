import sqlite3

conn = sqlite3.connect('meteo.db')
c = conn.cursor()

c.execute("SELECT * FROM cumulative_snowfall")
snowfall_data = c.fetchall()

c.execute("SELECT * FROM weather")
weather_data = c.fetchall()

conn.close()

scores = {}

for snowfall in snowfall_data:
    station_name = snowfall[0]
    snowfall_last_2_days = snowfall[4]

    weather = next((w for w in weather_data if w[0] == station_name), None)
    if weather is None:
        continue

    temperature = weather[1]
    wind_speed = weather[2]
    sunshine_duration = weather[3]
    visibility = weather[6]
    clouds = weather[7]

    score = 0
    score += snowfall_last_2_days * 10 # Snowfall is now the most important factor (10x)
    score -= (temperature < -5) * 10 * 1.0
    score -= wind_speed * 0.5
    score += sunshine_duration * 0.3
    score += visibility * 0.1
    score -= clouds * 0.1

    scores[station_name] = score

best_ski_station = max(scores, key=scores.get)

print(f"The best ski station is {best_ski_station} with a score of {scores[best_ski_station]}")