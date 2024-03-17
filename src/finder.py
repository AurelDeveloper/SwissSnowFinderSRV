import sqlite3

def print_sql(statement):
    print(f"Executing SQL: {statement}")

db_path = '../swisssnow.sqlite'

conn = sqlite3.connect(db_path)
conn.set_trace_callback(print_sql)
c = conn.cursor()

c.execute("SELECT station_id, region_id, snowfall_last_7_days FROM cumulative_snowfall")
data = c.fetchall()

best_stations = {}
for row in data:
    station_id, region_id, snowfall = row
    if region_id not in best_stations or snowfall > best_stations[region_id][1]:
        best_stations[region_id] = (station_id, snowfall)

for region_id, (station_id, snowfall) in best_stations.items():
    c.execute("INSERT INTO region_skistation (region_id, station_id, snowfall_last_7_days) VALUES (?, ?, ?)", (region_id, station_id, snowfall))

user_id = 'user_id'
c.execute("SELECT region_id FROM user_preference WHERE user_id = ?", (user_id,))
user_preferences = c.fetchall()

for preference in user_preferences:
    region_id = preference[0]
    c.execute("SELECT station_id FROM region_skistation WHERE region_id = ? ORDER BY snowfall_last_7_days DESC", (region_id,))
    station_ids = c.fetchall()
    if station_ids:
        # egal was!!! ein Eintrag in die Tabelle user_recommendation einfügen
        c.execute("INSERT INTO user_recommendation (user_id, station_id, date) VALUES (?, ?, datetime('now'))", (user_id, station_ids[0][0]))

conn.commit()
conn.close()