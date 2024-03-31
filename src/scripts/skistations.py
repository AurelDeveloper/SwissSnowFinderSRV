import requests
import json
import os
from dotenv import load_dotenv
from supabase_py import create_client, Client

# Laden Sie die Variablen aus der .env.local-Datei
load_dotenv('.env.local')

# Erstellen Sie eine Verbindung zu Ihrer Supabase-Datenbank
url: str = os.getenv("SUPABASE_URL")
anon_key: str = os.getenv("SUPABASE_ANON_KEY")
supabase: Client = create_client(url, anon_key)

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

def insert_region(supabase, region_name):
    result = supabase.table("regions").select("id").filter("name", "eq", region_name).execute()
    if result.error:
        print(f"Error: {result.error}")
        return None
    if len(result.data) == 0:
        insert_result = supabase.table("regions").insert({"name": region_name}).execute()
        if insert_result.error:
            print(f"Error: {insert_result.error}")
            return None
        return insert_result.data[0]['id']
    else:
        return result.data[0]['id']

def insert_skistations(supabase, skistations):
    for station in skistations:
        lat = station['lat']
        lon = station['lon']
        name = station['tags'].get('name', 'Unknown')
        region_name = get_region(lat, lon)
        region_id = insert_region(supabase, region_name)
        if region_id is not None:
            insert_result = supabase.table("skistations").insert({"name": name, "latitude": lat, "longitude": lon, "region_id": region_id}).execute()
            if insert_result.error:
                print(f"Error: {insert_result.error}")

# Use the functions
skistations = fetch_skistations()
insert_skistations(supabase, skistations)