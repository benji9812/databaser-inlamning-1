-- 1) Hämtar alla artister för en snabb översikt av grunddata.
SELECT artist_id, artist_name, country, debut_date
FROM Artist;

-- 2) Visar album släppta efter 2018 för att demonstrera WHERE på datum.
SELECT album_id, title, release_date
FROM Album
WHERE release_date > '2018-12-31';

-- 3) Listar tracks sorterade längst till kortast för att demonstrera ORDER BY DESC.
SELECT track_id, title, duration_seconds
FROM Track
ORDER BY duration_seconds DESC;

-- 4) Söker fram låtar som innehåller ordet "Signal" för att visa LIKE-matchning.
SELECT track_id, title
FROM Track
WHERE title LIKE '%Signal%';

-- 5) Räknar antal album per genre för att visa GROUP BY utan HAVING.
SELECT genre, COUNT(*) AS album_count
FROM Album
GROUP BY genre;

-- 6) Beräknar snittbetyg per album för att jämföra kvalitet mellan album.
SELECT album_id, ROUND(AVG(rating), 2) AS average_rating
FROM Track
GROUP BY album_id
ORDER BY average_rating DESC;
