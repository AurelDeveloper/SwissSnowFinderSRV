import requests
import json

# Overpass API-Abfrage
query = """
[out:json];
area["ISO3166-1"="CH"]->.searchArea;
(
  node["leisure"="ski_resort"](area.searchArea);
  way["leisure"="ski_resort"](area.searchArea);
  relation["leisure"="ski_resort"](area.searchArea);
);
out body;
>;
out skel qt;
"""

# Senden Sie die Anfrage an die Overpass API
response = requests.get("http://overpass-api.de/api/interpreter", params={'data': query})

# Überprüfen Sie, ob die Anfrage erfolgreich war
if response.status_code == 200:
    # Konvertieren Sie die Antwort in ein JSON-Objekt
    data = response.json()

    # Durchlaufen Sie alle Elemente in den Daten
    for element in data['elements']:
        # Überprüfen Sie, ob das Element Tags hat
        if 'tags' in element:
            # Überprüfen Sie, ob das Element einen Namen hat
            if 'name' in element['tags']:
                # Drucken Sie den Namen der Skistation
                print('Name der Skistation: ', element['tags']['name'])

            # Überprüfen Sie, ob das Element einen Kanton hat
            if 'addr:state' in element['tags']:
                # Drucken Sie den Namen des Kantons
                print('Name des Kantons: ', element['tags']['addr:state'])

        # Drucken Sie die Koordinaten der Skistation
        if 'lat' in element and 'lon' in element:
            print('Koordinaten der Skistation: ', element['lat'], element['lon'])
else:
    print("Fehler: ", response.status_code)