-- First, insert the regions
--delete from region;
INSERT INTO region (name)
VALUES ('Grisons'), ('Wallis');

-- Then, insert the ski stations with the region_id
--delete from ski_stations;
INSERT INTO ski_stations (name, region_id, latitude, longitude)
VALUES ('Tschappina', (SELECT id FROM region WHERE name = 'Grisons'), 46.686360, 9.375720),
       ('Laax', (SELECT id FROM region WHERE name = 'Grisons'), 46.813790, 9.253990),
       ('St. Moritz', (SELECT id FROM region WHERE name = 'Grisons'), 46.498831907768114, 9.81129686427385),
       ('Verbier', (SELECT id FROM region WHERE name = 'Wallis'), 46.0996 , 7.2281);

-- Insert for user, user id and region_id
--delete from user;
INSERT INTO user_preferences (user_id, region_id)
VALUES ((SELECT id FROM user WHERE name = 'John'), (SELECT id FROM region WHERE name = 'Grisons')),
       ((SELECT id FROM user WHERE name = 'Jane'), (SELECT id FROM region WHERE name = 'Grisons')),
       ((SELECT id FROM user WHERE name = 'Jack'), (SELECT id FROM region WHERE name = 'Grisons')),
       ((SELECT id FROM user WHERE name = 'Jack'), (SELECT id FROM region WHERE name = 'Wallis'));