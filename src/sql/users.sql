CREATE TABLE user_devices (
    user_id INTEGER PRIMARY KEY,
    device_id TEXT NOT NULL,
    device_model TEXT,
    operating_system TEXT
);

CREATE TABLE user_preference (
    user_id INTEGER PRIMARY KEY,
    region TEXT,
    FOREIGN KEY(user_id) REFERENCES user_devices(user_id)
);

CREATE TABLE user_recommendation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    station_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES user_devices(user_id),
    FOREIGN KEY(station_id) REFERENCES ski_stations(id)
);

CREATE TABLE user_scores (
    user_id INTEGER,
    station_id INTEGER,
    score REAL,
    PRIMARY KEY(user_id, station_id),
    FOREIGN KEY(user_id) REFERENCES user_devices(user_id),
    FOREIGN KEY(station_id) REFERENCES ski_stations(id)
);