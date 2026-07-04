-- 1) Fetches all artists for a quick overview of basic data.
SELECT artist_id, artist_name, country, debut_date
FROM Artist;

-- 2) Shows albums released after 2018 to demonstrate WHERE on date.
SELECT album_id, title, release_date
FROM Album
WHERE release_date > '2018-12-31';

-- 3) Lists tracks sorted from longest to shortest to demonstrate ORDER BY DESC.
SELECT track_id, title, duration_seconds
FROM Track
ORDER BY duration_seconds DESC;

-- 4) Searches for tracks containing the word "Signal" to show LIKE matching.
SELECT track_id, title
FROM Track
WHERE title LIKE '%Signal%';

-- 5) Counts the number of albums per genre to demonstrate GROUP BY without HAVING.
SELECT genre, COUNT(*) AS album_count
FROM Album
GROUP BY genre;

-- 6) Calculates the average rating per album to compare quality between albums.
SELECT album_id, ROUND(AVG(rating), 2) AS average_rating
FROM Track
GROUP BY album_id
ORDER BY average_rating DESC;
