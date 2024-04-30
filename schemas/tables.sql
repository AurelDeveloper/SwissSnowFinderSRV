CREATE TABLE regions
(
    id          SERIAL PRIMARY KEY,
    name        TEXT    NOT NULL
);

CREATE TABLE skistations
(
    id          SERIAL PRIMARY KEY,
    name        TEXT    NOT NULL,
    region_id   INTEGER NOT NULL,
    latitude    REAL    NOT NULL,
    longitude   REAL    NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions (id)
);

CREATE TABLE weathers
(
    id                  SERIAL PRIMARY KEY,
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

CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    aud text CHECK (char_length(aud) > 0),
    role text CHECK (char_length(role) > 0),
    email text CHECK (char_length(email) > 0),
    confirmed_at timestamptz,
    last_sign_in_at timestamptz,
    app_metadata jsonb,
    user_metadata jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

CREATE TABLE users_preferences
(
    id                   SERIAL PRIMARY KEY,
    user_id              uuid NOT NULL,
    region_id            INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (region_id) REFERENCES regions (id)
);