CREATE TABLE region
(
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE ski_stations
(
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT    NOT NULL UNIQUE,
    region_id INTEGER NOT NULL,
    latitude  REAL    NOT NULL,
    longitude REAL    NOT NULL,
    FOREIGN KEY (region_id) REFERENCES region (id)
);

CREATE TABLE weather
(
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    ski_station_id      INTEGER   NOT NULL,
    temperature         DECIMAL(5, 2),
    wind_speed          DECIMAL(5, 2),
    snow                DECIMAL(5, 2),
    timestamp           TIMESTAMP NOT NULL,
    visibility          INTEGER,
    dt                  TIMESTAMP,
    clouds              INTEGER,
    weather_main        TEXT,
    weather_description TEXT,
    FOREIGN KEY (ski_station_id) REFERENCES ski_stations (id)
);

CREATE TABLE user_devices
(
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id          INTEGER,
    device_id        TEXT NOT NULL,
    device_model     TEXT,
    operating_system TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE user_preference
(
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    region  TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE region_skistation
(
    region_id            INTEGER NOT NULL,
    station_id           INTEGER NOT NULL,
    snowfall_last_7_days REAL,
    FOREIGN KEY (region_id) REFERENCES region (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);

CREATE TABLE user_recommendation
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    station_id INTEGER,
    date       TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);

CREATE TABLE user_scores
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    station_id INTEGER,
    score      REAL,
    date       TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);