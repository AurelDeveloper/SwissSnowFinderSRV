CREATE TABLE regions
(
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL
);

CREATE TABLE skistations
(
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL,
    region_id   INTEGER NOT NULL,
    latitude    REAL    NOT NULL,
    longitude   REAL    NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions (id)
);

CREATE TABLE weathers
(
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    skistation_id       INTEGER NOT NULL,
    temperature         DECIMAL(5, 2),
    wind_speed          DECIMAL(5, 2),
    snow                DECIMAL(5, 2),
    timestamp           TIMESTAMP NOT NULL,
    visibility          INTEGER,
    clouds              INTEGER,
    weather_main        TEXT,
    weather_description TEXT,
    FOREIGN KEY (skistation_id) REFERENCES skistations (id)
);

CREATE TABLE skistations_regions
(
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    region_id            INTEGER NOT NULL,
    skistation_id        INTEGER NOT NULL,
    score                REAL,
    FOREIGN KEY (region_id) REFERENCES regions (id),
    FOREIGN KEY (skistation_id) REFERENCES skistations (id)
);

CREATE TABLE users
(
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL
);

CREATE TABLE users_preferences
(
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id              INTEGER NOT NULL,
    region_id            INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (region_id) REFERENCES regions (id)
);

CREATE TABLE users_scores
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER,
    skistation_id INTEGER,
    score      REAL,
    date       TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (skistation_id) REFERENCES skistations (id)
);