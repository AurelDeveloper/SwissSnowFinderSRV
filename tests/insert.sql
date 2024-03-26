DELETE FROM users_preferences;
DELETE FROM skistations;
DELETE FROM regions;
DELETE FROM users;

INSERT INTO regions (name)
VALUES ('Grisons'), ('Wallis');

INSERT INTO skistations (name, region_id, latitude, longitude)
VALUES ('Tschappina', (SELECT id FROM regions WHERE name = 'Grisons'), 46.686360, 9.375720),
       ('Laax', (SELECT id FROM regions WHERE name = 'Grisons'), 46.813790, 9.253990),
       ('St. Moritz', (SELECT id FROM regions WHERE name = 'Grisons'), 46.498831907768114, 9.81129686427385),
       ('Verbier', (SELECT id FROM regions WHERE name = 'Wallis'), 46.0996 , 7.2281);


INSERT INTO users (name)
VALUES ('John'), ('Jane'), ('Jack');

INSERT INTO users_preferences (user_id, region_id)
VALUES ((SELECT id FROM users WHERE name = 'John'), (SELECT id FROM regions WHERE name = 'Grisons')),
       ((SELECT id FROM users WHERE name = 'Jane'), (SELECT id FROM regions WHERE name = 'Grisons')),
       ((SELECT id FROM users WHERE name = 'Jack'), (SELECT id FROM regions WHERE name = 'Grisons')),
       ((SELECT id FROM users WHERE name = 'Jack'), (SELECT id FROM regions WHERE name = 'Wallis'));