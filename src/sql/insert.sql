-- First, insert the regions
INSERT INTO region (name)
VALUES ('Grisons');

-- Then, insert the ski stations with the region_id
INSERT INTO ski_stations (name, region_id, latitude, longitude)
VALUES ('Tschappina', (SELECT id FROM region WHERE name = 'Grisons'), 46.686360, 9.375720),
       ('Laax', (SELECT id FROM region WHERE name = 'Grisons'), 46.813790, 9.253990),
       ('St. Moritz', (SELECT id FROM region WHERE name = 'Grisons'), 46.498831907768114, 9.81129686427385);

-- For user_preference, replace region with region_id
INSERT INTO user_preference (user_id, region_id)
VALUES (1, (SELECT id FROM region WHERE name = 'Grisons'));