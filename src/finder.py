import sqlite3

def print_sql(statement):
    print(f"Executing SQL: {statement}")

def calculate_score(snowfalls, temperature):
    if sum(snowfalls) == 0:
        return temperature
    else:
        weights = [7, 6, 5, 4, 3, 2, 1]
        return sum(snowfall * weight for snowfall, weight in zip(snowfalls, weights))

db_path = '../swisssnow.sqlite'

conn = sqlite3.connect(db_path)
conn.set_trace_callback(print_sql)
c = conn.cursor()

c.execute("""
    SELECT
        cumulative_snowfall.station_id,
        cumulative_snowfall.region_id,
        cumulative_snowfall.snowfall_last_7_days,
        cumulative_snowfall.snowfall_last_6_days,
        cumulative_snowfall.snowfall_last_5_days,
        cumulative_snowfall.snowfall_last_4_days,
        cumulative_snowfall.snowfall_last_3_days,
        cumulative_snowfall.snowfall_last_2_days,
        cumulative_snowfall.snowfall_last_day,
        latest_temperatures.temperature
    FROM
        cumulative_snowfall
    JOIN
        (SELECT ski_station_id, temperature FROM weather ORDER BY timestamp DESC LIMIT 1) AS latest_temperatures
    ON
        cumulative_snowfall.station_id = latest_temperatures.ski_station_id
""")
data = c.fetchall()

best_stations = {}
for row in data:
    station_id, region_id, *snowfalls, temperature = row
    score = calculate_score(snowfalls, temperature)
    if region_id not in best_stations or score > best_stations[region_id][1]:
        best_stations[region_id] = (station_id, score, snowfalls, temperature)

for region_id, (station_id, score, snowfalls, temperature) in best_stations.items():
    c.execute("INSERT INTO regions_skistations (region_id, station_id, score, snowfall_last_7_days, snowfall_last_6_days, snowfall_last_5_days, snowfall_last_4_days, snowfall_last_3_days, snowfall_last_2_days, snowfall_last_day, temperature) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
              (region_id, station_id, score, *snowfalls, temperature))

user_id = 'user_id'
c.execute("SELECT region_id FROM users_preferences WHERE user_id = ?", (user_id,))
user_preferences = c.fetchall()

for preference in user_preferences:
    region_id = preference[0]
    c.execute("SELECT station_id, score FROM regions_skistations WHERE region_id = ? ORDER BY score DESC",
              (region_id,))
    station_ids_scores = c.fetchall()
    if station_ids_scores:
        station_id, score = station_ids_scores[0]
        if score > 0:
            c.execute("INSERT INTO users_recommendations (user_id, station_id, date) VALUES (?, ?, datetime('now'))",
                      (user_id, station_id))

conn.commit()
conn.close()