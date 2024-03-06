CREATE TABLE ski_stations (
                              id INTEGER PRIMARY KEY AUTOINCREMENT,
                              name TEXT NOT NULL,
                              region TEXT NOT NULL,
                              latitude REAL NOT NULL,
                              longitude REAL NOT NULL
);

CREATE TABLE weather (
                         id INTEGER PRIMARY KEY AUTOINCREMENT,
                         ski_station_id INTEGER,
                         temperature DECIMAL(5,2),
                         wind_speed DECIMAL(5,2),
                         snow DECIMAL(5,2),
                         sunshine_duration DECIMAL(5,2),
                         timestamp TIMESTAMP NOT NULL,
                         visibility INTEGER,
                         dt INTEGER,
                         clouds INTEGER,
                         weather_main TEXT,
                         weather_description TEXT,
                         FOREIGN KEY(ski_station_id) REFERENCES ski_stations(id)
);