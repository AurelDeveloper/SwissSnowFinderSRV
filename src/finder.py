import sqlite3

def print_sql(statement):
    print(f"Executing SQL: {statement}")

def calculate_score(snowfalls):
    weights = [7, 6, 5, 4, 3, 2, 1]  # neuer Schnee bekommt mehr Punkte
    return sum(snowfall * weight for snowfall, weight in zip(snowfalls, weights))

db_path = '../swisssnow.sqlite'

conn = sqlite3.connect(db_path)
conn.set_trace_callback(print_sql)
c = conn.cursor()

c.execute("SELECT station_id, region_id, snowfall_last_7_days, snowfall_last_6_days, snowfall_last_5_days, snowfall_last_4_days, snowfall_last_3_days, snowfall_last_2_days, snowfall_last_day FROM cumulative_snowfall")
data = c.fetchall()

best_stations = {}
for row in data:
    station_id, region_id, *snowfalls = row
    score = calculate_score(snowfalls)
    if region_id not in best_stations or score > best_stations[region_id][1]:
        best_stations[region_id] = (station_id, score, snowfalls)

for region_id, (station_id, score, snowfalls) in best_stations.items():
    c.execute("INSERT INTO regions_skistations (region_id, station_id, score, snowfall_last_7_days, snowfall_last_6_days, snowfall_last_5_days, snowfall_last_4_days, snowfall_last_3_days, snowfall_last_2_days, snowfall_last_day) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
              (region_id, station_id, score, *snowfalls))

user_id = 'user_id'
c.execute("SELECT region_id FROM users_preferences WHERE user_id = ?", (user_id,))
user_preferences = c.fetchall()

for preference in user_preferences:
    region_id = preference[0]
    c.execute("SELECT station_id FROM regions_skistations WHERE region_id = ? ORDER BY score DESC",
              (region_id,))
    station_ids = c.fetchall()
    if station_ids:
        c.execute("INSERT INTO users_recommendations (user_id, station_id, date) VALUES (?, ?, datetime('now'))",
                  (user_id, station_ids[0][0]))

conn.commit()
conn.close()