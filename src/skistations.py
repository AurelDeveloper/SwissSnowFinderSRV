import requests
import sqlite3
import json

def fetch_skistations():
    overpass_url = "http://overpass-api.de/api/interpreter"
    overpass_query = """
    [out:json];
    area["ISO3166-1"="CH"][admin_level=2];
    (node["tourism"="ski_resort"](area);
     way["tourism"="ski_resort"](area);
     rel["tourism"="ski_resort"](area);
    );
    out center;
    """
    response = requests.get(overpass_url, params={'data': overpass_query})
    data = response.json()
    return data['elements']

def get_region(lat, lon):
    url = f"https://nominatim.openstreetmap.org/reverse?format=json&lat={lat}&lon={lon}&zoom=10&addressdetails=1"
    response = requests.get(url)
    data = response.json()
    return data['address']['state']

def insert_region(conn, region_name):
    c = conn.cursor()
    c.execute("SELECT id FROM regions WHERE name = ?", (region_name,))
    result = c.fetchone()
    if result is None:
        c.execute("INSERT INTO regions (name) VALUES (?)", (region_name,))
        return c.lastrowid
    else:
        return result[0]

def insert_skistations(db_path, skistations):
    conn = sqlite3.connect(db_path)

    for station in skistations:
        lat = station['lat']
        lon = station['lon']
        name = station['tags'].get('name', 'Unknown')
        region_name = get_region(lat, lon)
        region_id = insert_region(conn, region_name)
        c = conn.cursor()
        c.execute("INSERT INTO skistations (name, latitude, longitude, region_id) VALUES (?, ?, ?, ?)", (name, lat, lon, region_id))

    conn.commit()
    conn.close()

# Use the functions
db_path = '../swisssnow.sqlite'
skistations = fetch_skistations()
insert_skistations(db_path, skistations)