import sqlite3

db_path = '../../swisssnow.sqlite'

conn = sqlite3.connect(db_path)
c = conn.cursor()

# Fetch the data from the view
c.execute("SELECT station_id, region_id, snowfall_last_7_days FROM cumulative_snowfall")
data = c.fetchall()

# Group the data by region and find the station with the most snowfall in the last 7 days in each region
best_stations = {}
for row in data:
    station_id, region_id, snowfall = row
    if region_id not in best_stations or snowfall > best_stations[region_id][1]:
        best_stations[region_id] = (station_id, snowfall)

# Insert the best stations into the new table
for region_id, (station_id, snowfall) in best_stations.items():
    c.execute("INSERT INTO region_skistation (region_id, station_id, snowfall_last_7_days) VALUES (?, ?, ?)", (region_id, station_id, snowfall))

# Fetch the user's preferred regions from the user_preference table
user_id = 'user_id'  # Replace 'user_id' with the actual user's id
c.execute("SELECT region_id FROM user_preference WHERE user_id = ?", (user_id,))
user_preferences = c.fetchall()

# Print out the preferred regions for the user
for preference in user_preferences:
    print(f"User {user_id} has a preference for region {preference[0]}")

conn.commit()
conn.close()