-- Insert artists first because Album depends on Artist via artist_id.
INSERT INTO Artist (artist_id, artist_name, country, debut_date) VALUES
    (1, 'Northern Echo', 'Sweden', '2012-04-19'),
    (2, 'Velvet Circuit', 'UK', '2015-09-02'),
    (3, 'Solar Harbor', 'Canada', '2010-01-14');

-- Insert albums second because Track depends on Album and Album depends on Artist.
INSERT INTO Album (album_id, artist_id, title, release_date, genre) VALUES
    (1, 1, 'Midnight Transit', '2016-03-11', 'Indie Pop'),
    (2, 1, 'Static Horizon', '2019-10-04', 'Synthwave'),
    (3, 2, 'Signal Bloom', '2018-06-22', 'Alternative Rock'),
    (4, 3, 'Tidal Lights', '2021-02-12', 'Dream Pop');

-- Insert tracks last because each track must reference an existing album_id.
INSERT INTO Track (track_id, album_id, title, duration_seconds, rating, track_number) VALUES
    (1, 1, 'City in Reverse', 214, 4.2, 1),
    (2, 1, 'Neon Rainfall', 189, 4.0, 2),
    (3, 1, 'Glass Platforms', 241, 4.5, 3),
    (4, 2, 'Voltage Tide', 202, 4.3, 1),
    (5, 2, 'Parallel Skies', 233, 4.7, 2),
    (6, 2, 'Afterglow Engine', 256, 4.6, 3),
    (7, 3, 'Faded Receiver', 198, 3.9, 1),
    (8, 3, 'Signal Bloom', 227, 4.4, 2),
    (9, 3, 'Concrete Aurora', 205, 4.1, 3),
    (10, 4, 'Harborline', 219, 4.8, 1),
    (11, 4, 'Low Tide Satellites', 245, 4.5, 2),
    (12, 4, 'Blue Latitude', 231, 4.6, 3);
