CREATE TABLE user_preference (
    id INTEGER PRIMARY KEY,
    region TEXT
);

CREATE TABLE IF NOT EXISTS user_recommendation (
    id INTEGER PRIMARY KEY,
    station_name TEXT
);

CREATE TABLE IF NOT EXISTS user_infos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    device_id TEXT NOT NULL,
    device_model TEXT NOT NULL,
    os_version TEXT NOT NULL
);