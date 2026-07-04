-- Uppdate release_date after the wrong year was discovered during data input.
UPDATE Album
SET release_date = '2020-10-04'
WHERE album_id = 2;

-- Changes track title after the band released an official "renamed" version.
UPDATE Track
SET title = 'Afterglow Engine (Rework)'
WHERE track_id = 6;
