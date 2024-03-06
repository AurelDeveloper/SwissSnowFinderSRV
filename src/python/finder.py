import sqlite3

# Verbindung zu den Datenbanken herstellen
meteo_conn = sqlite3.connect('../../meteo.db')
meteo_cursor = meteo_conn.cursor()

users_conn = sqlite3.connect('../../users.db')
users_cursor = users_conn.cursor()

# Alle Benutzer-IDs aus der Tabelle user_devices abrufen
users_cursor.execute("SELECT user_id FROM user_devices")
user_ids = users_cursor.fetchall()

for user_id in user_ids:
    user_id = user_id[0]  # fetchall() gibt eine Liste von Tupeln zurück

    # Benutzerpräferenzen für die aktuelle Benutzer-ID abrufen
    users_cursor.execute("SELECT region FROM user_preference WHERE user_id = ?", (user_id,))
    user_preference = users_cursor.fetchone()

    if user_preference is not None:
        user_region = user_preference[0]

        # Alle Skistationen in der bevorzugten Region des Benutzers abrufen
        meteo_cursor.execute("SELECT id FROM ski_stations WHERE region = ?", (user_region,))
        station_ids = meteo_cursor.fetchall()

        scores = {}
        for station_id in station_ids:
            station_id = station_id[0]  # fetchall() gibt eine Liste von Tupeln zurück

            # Schneedaten für die aktuelle Skistation abrufen
            meteo_cursor.execute("""
                SELECT snowfall_last_12_hours, snowfall_last_day, snowfall_last_2_days, snowfall_last_3_days,
                       snowfall_last_4_days, snowfall_last_5_days, snowfall_last_6_days, snowfall_last_7_days
                FROM cumulative_snowfall
                WHERE station_id = ?
            """, (station_id,))
            snow_data = meteo_cursor.fetchone()

            if snow_data is not None:
                # Ein Score basierend auf den Schneedaten berechnen
                score = (
                        snow_data[0] * 7 +  # Schneefall der letzten 12 Stunden
                        snow_data[1] * 6 +  # Schneefall des letzten Tages
                        snow_data[2] * 5 +  # Schneefall der letzten 2 Tage
                        snow_data[3] * 4 +  # Schneefall der letzten 3 Tage
                        snow_data[4] * 3 +  # Schneefall der letzten 4 Tage
                        snow_data[5] * 2 +  # Schneefall der letzten 5 Tage
                        snow_data[6] * 1 +  # Schneefall der letzten 6 Tage
                        snow_data[7] * 0.5  # Schneefall der letzten 7 Tage
                )
                scores[station_id] = score

        # Die Skistation mit dem höchsten Score finden
        best_station_id = max(scores, key=scores.get)

        # Die Benutzer-ID und die ID der besten Skistation in die Tabelle user_recommendation einfügen
        users_cursor.execute("""
            INSERT INTO user_recommendation (user_id, station_id)
            VALUES (?, ?)
        """, (user_id, best_station_id))
        users_conn.commit()

# Verbindungen zu den Datenbanken schließen
meteo_conn.close()
users_conn.close()