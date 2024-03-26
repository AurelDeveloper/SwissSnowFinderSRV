CREATE TABLE regions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE ski_stations
(
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT    NOT NULL UNIQUE,
    region_id INTEGER NOT NULL,
    latitude  REAL    NOT NULL,
    longitude REAL    NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions (id)
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

CREATE TABLE users
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE users_preferences
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    region_id  INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (region_id) REFERENCES regions (id)
);

CREATE TABLE regions_skistations
(
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    region_id            INTEGER NOT NULL,
    station_id           INTEGER NOT NULL,
    score                REAL,
    temperature          REAL,
    snowfall_last_7_days REAL,
    snowfall_last_6_days REAL,
    snowfall_last_5_days REAL,
    snowfall_last_4_days REAL,
    snowfall_last_3_days REAL,
    snowfall_last_2_days REAL,
    snowfall_last_day    REAL,
    FOREIGN KEY (region_id) REFERENCES regions (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);

CREATE TABLE users_recommendations
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    station_id INTEGER,
    date       TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);

CREATE TABLE users_scores
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    station_id INTEGER,
    score      REAL,
    date       TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);