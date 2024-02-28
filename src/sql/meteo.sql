CREATE TABLE ski_stations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    region TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL
);

CREATE TABLE weather (
    ski_station_id INTEGER,
    temperature Decimal(5,2),
    wind_speed Decimal(5,2),
    snow Decimal(5,2),
    sunshine_duration Decimal(5,2),
    timestamp Timestamp NOT NULL,
    visibility INTEGER,
    dt INTEGER,
    clouds INTEGER,
    weather_main TEXT,
    weather_description TEXT,
    FOREIGN KEY(ski_station_id) REFERENCES ski_stations(id)
);