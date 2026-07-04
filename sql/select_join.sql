-- 1) Kopplar Artist och Album för att visa vilken artist som står bakom varje album.
SELECT
    ar.artist_name,
    al.title AS album_title,
    al.release_date
FROM Artist ar
INNER JOIN Album al ON al.artist_id = ar.artist_id
ORDER BY ar.artist_name, al.release_date;

-- 2) Kopplar Album och Track för att visa låtlista med albumtitel och spårnummer.
SELECT
    al.title AS album_title,
    tr.track_number,
    tr.title AS track_title,
    tr.duration_seconds
FROM Album al
INNER JOIN Track tr ON tr.album_id = al.album_id
ORDER BY al.title, tr.track_number;

-- 3) Tre-vägs JOIN (Artist -> Album -> Track) för en komplett katalogvy.
SELECT
    ar.artist_name,
    al.title AS album_title,
    tr.track_number,
    tr.title AS track_title,
    tr.rating
FROM Artist ar
INNER JOIN Album al ON al.artist_id = ar.artist_id
INNER JOIN Track tr ON tr.album_id = al.album_id
ORDER BY ar.artist_name, al.title, tr.track_number;
