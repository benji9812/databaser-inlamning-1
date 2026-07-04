-- Uppdaterar release_date efter att fel årtal upptäcktes vid datainmatning.
UPDATE Album
SET release_date = '2020-10-04'
WHERE album_id = 2;

-- Byter låttitel efter att bandet släppte en officiell "renamed" version.
UPDATE Track
SET title = 'Afterglow Engine (Rework)'
WHERE track_id = 6;
