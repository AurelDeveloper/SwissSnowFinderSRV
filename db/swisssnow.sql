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

CREATE TABLE user
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE user_preferences
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    region_id  INTEGER,
    FOREIGN KEY (user_id) REFERENCES user (id),
    FOREIGN KEY (region_id) REFERENCES region (id)
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
    FOREIGN KEY (user_id) REFERENCES user (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);

CREATE TABLE user_scores
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    station_id INTEGER,
    score      REAL,
    date       TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user (id),
    FOREIGN KEY (station_id) REFERENCES ski_stations (id)
);