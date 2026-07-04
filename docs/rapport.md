# Rapport – SQL & Databasdesign (Musikbibliotek)

## 1. ER-diagram

Samma modell som i `docs/er_diagram.md`:

```mermaid
erDiagram
    ARTIST ||--o{ ALBUM : "har"
    ALBUM ||--o{ TRACK : "innehåller"

    ARTIST {
        INTEGER artist_id PK
        TEXT artist_name
        TEXT country
        DATE debut_date
    }

    ALBUM {
        INTEGER album_id PK
        INTEGER artist_id FK
        TEXT title
        DATE release_date
        TEXT genre
    }

    TRACK {
        INTEGER track_id PK
        INTEGER album_id FK
        TEXT title
        INTEGER duration_seconds
        REAL rating
        INTEGER track_number
    }
```

## 2. Tabellförklaringar och motiveringar

**Artist** lagrar artistens identitet och metadata. `artist_id` är `INTEGER` för enkel och snabb nyckelhantering. `artist_name` och `country` är `TEXT` eftersom värden varierar i längd. `debut_date` är `DATE` för tidsbaserad filtrering.

**Album** lagrar utgivningar och kopplar varje album till en artist via `artist_id` (FK). `title` och `genre` är `TEXT` eftersom värden är fritext. `release_date` är `DATE` för sortering och jämförelser över tid.

**Track** lagrar låtar för ett album via `album_id` (FK). `duration_seconds` är `INTEGER` eftersom sekunder är heltal. `rating` är `REAL` för decimalvärden mellan 0 och 5. `track_number` är `INTEGER` eftersom spårnummer är ordinaldata.

`NOT NULL` används på fält som måste finnas för att posten ska vara meningsfull (t.ex. namn, titel, relationer). `CHECK` används för kvalitetskontroll, t.ex. positiv låtlängd och betyg inom giltigt intervall.

## 3. Alla SQL-kommandon

### create_tables.sql

```sql
-- Aktiverar FK-kontroller i SQLite-sessioner.
PRAGMA foreign_keys = ON;

-- Artist lagrar en rad per musikartist och fungerar som överordnad entitet för album.
CREATE TABLE IF NOT EXISTS Artist (
    artist_id INTEGER PRIMARY KEY,
    artist_name TEXT NOT NULL,
    country TEXT NOT NULL,
    debut_date DATE NOT NULL
);

-- Album lagrar utgivningar och kopplar varje album till exakt en artist.
CREATE TABLE IF NOT EXISTS Album (
    album_id INTEGER PRIMARY KEY,
    artist_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    release_date DATE NOT NULL,
    genre TEXT NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

-- Track lagrar låtar och kopplar varje låt till ett album samt behåller relevant metadata.
CREATE TABLE IF NOT EXISTS Track (
    track_id INTEGER PRIMARY KEY,
    album_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
    rating REAL CHECK (rating BETWEEN 0 AND 5),
    track_number INTEGER NOT NULL CHECK (track_number > 0),
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
);
```

### insert_data.sql

```sql
-- Infoga artister först eftersom Album beror på Artist via artist_id.
INSERT INTO Artist (artist_id, artist_name, country, debut_date) VALUES
    (1, 'Northern Echo', 'Sweden', '2012-04-19'),
    (2, 'Velvet Circuit', 'UK', '2015-09-02'),
    (3, 'Solar Harbor', 'Canada', '2010-01-14');

-- Infoga album därefter eftersom Track beror på Album och Album beror på Artist.
INSERT INTO Album (album_id, artist_id, title, release_date, genre) VALUES
    (1, 1, 'Midnight Transit', '2016-03-11', 'Indie Pop'),
    (2, 1, 'Static Horizon', '2019-10-04', 'Synthwave'),
    (3, 2, 'Signal Bloom', '2018-06-22', 'Alternative Rock'),
    (4, 3, 'Tidal Lights', '2021-02-12', 'Dream Pop');

-- Infoga låtar sist eftersom varje låt måste referera till ett befintligt album_id.
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
```

### select_basic.sql

```sql
-- 1) Hämtar alla artister för en snabb överblick av grunddata.
SELECT artist_id, artist_name, country, debut_date
FROM Artist;

-- 2) Visar album släppta efter 2018 för att demonstrera WHERE på datum.
SELECT album_id, title, release_date
FROM Album
WHERE release_date > '2018-12-31';

-- 3) Listar låtar sorterade från längst till kortast för att demonstrera ORDER BY DESC.
SELECT track_id, title, duration_seconds
FROM Track
ORDER BY duration_seconds DESC;

-- 4) Söker efter låtar som innehåller ordet "Signal" för att demonstrera LIKE-matchning.
SELECT track_id, title
FROM Track
WHERE title LIKE '%Signal%';

-- 5) Räknar antalet album per genre för att demonstrera GROUP BY utan HAVING.
SELECT genre, COUNT(*) AS album_count
FROM Album
GROUP BY genre;

-- 6) Beräknar genomsnittligt betyg per album för att jämföra kvalitet mellan album.
SELECT album_id, ROUND(AVG(rating), 2) AS average_rating
FROM Track
GROUP BY album_id
ORDER BY average_rating DESC;
```

### select_join.sql

```sql
-- 1) Sammanfogar Artist och Album för att visa vilken artist som ligger bakom varje album.
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

-- 3) Tredelad JOIN (Artist -> Album -> Track) för en komplett katalogvy.
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
```

### updates.sql

```sql
-- Uppdaterar release_date efter att fel år upptäcktes vid datainmatning.
UPDATE Album
SET release_date = '2020-10-04'
WHERE album_id = 2;

-- Ändrar låttitel efter att bandet släppte en officiell "omdöpt" version.
UPDATE Track
SET title = 'Afterglow Engine (Rework)'
WHERE track_id = 6;
```

### deletes.sql

```sql
-- Tar bort en specifik låt från katalogen efter artistens begäran om korrigering.
DELETE FROM Track
WHERE track_id = 7;
```

## 4. LINQ-jämförelser

LINQ är C#:s sätt att skriva datafrågor med stark typning och stöd för IntelliSense. I en .NET-applikation som använder Entity Framework Core översätts LINQ-uttryck vanligtvis till SQL och körs av databasen. Det gör att samma logik för filtrering, sortering och gruppering kan skrivas direkt i applikationskoden utan att bygga SQL-strängar manuellt. Utvecklare väljer ofta LINQ för bättre läsbarhet, säkrare refaktorering och bättre kontroller vid kompilering.

### Filtrera album släppta efter 2018 (WHERE)

**SQL-version**

```sql
SELECT album_id, title, release_date
FROM Album
WHERE release_date > '2018-12-31';
```

**LINQ-version**

```csharp
// Hämtar album släppta efter 2018-12-31 och materialiserar resultatet.
using var context = new MusicLibraryContext();

var albumsAfter2018 = context.Albums
    .Where(a => a.ReleaseDate > new DateTime(2018, 12, 31))
    .Select(a => new
    {
        a.AlbumId,
        a.Title,
        a.ReleaseDate
    })
    .ToList();
```

I SQL motsvarar `WHERE` direkt `.Where(...)` i LINQ och använder samma filtreringslogik. `SELECT`-kolumnerna motsvarar `.Select(...)`, där vi projicerar exakt `AlbumId`, `Title` och `ReleaseDate`. När `.ToList()` anropas kör EF Core den översatta SQL-frågan och materialiserar resultatet som en lista.

### Sortera låtar från längst till kortast (ORDER BY DESC)

**SQL-version**

```sql
SELECT track_id, title, duration_seconds
FROM Track
ORDER BY duration_seconds DESC;
```

**LINQ-version**

```csharp
// Hämtar låtar sorterade i fallande ordning efter längd i sekunder.
using var context = new MusicLibraryContext();

var tracksByLengthDesc = context.Tracks
    .OrderByDescending(t => t.DurationSeconds)
    .Select(t => new
    {
        t.TrackId,
        t.Title,
        t.DurationSeconds
    })
    .ToList();
```

`ORDER BY duration_seconds DESC` i SQL motsvarar `.OrderByDescending(t => t.DurationSeconds)` i LINQ. Sorteringsnyckeln är samma fält i båda versionerna, men i LINQ uttrycks den som en lambda. Efter sortering formar `.Select(...)` utdata innan `.ToList()` materialiserar datan.

### Räkna album per genre (GROUP BY + COUNT)

**SQL-version**

```sql
SELECT genre, COUNT(*) AS album_count
FROM Album
GROUP BY genre;
```

**LINQ-version**

```csharp
// Grupperar album efter genre och räknar hur många album varje genre har.
using var context = new MusicLibraryContext();

var albumsPerGenre = context.Albums
    .GroupBy(a => a.Genre)
    .Select(g => new
    {
        Genre = g.Key,
        AlbumCount = g.Count()
    })
    .ToList();
```

`GROUP BY genre` i SQL motsvarar `.GroupBy(a => a.Genre)` i LINQ, där varje grupp representeras av `g`. Gruppkolumnen exponeras via `g.Key`, vilket motsvarar `genre` i SQL-utdata. Aggregatet `COUNT(*)` motsvarar `g.Count()`, och resultatet projiceras till ett objekt med `Genre` och `AlbumCount`.

## 5. Säkerhet

Säker åtkomst till databaser är kritisk eftersom databasen ofta innehåller kärndata som kunduppgifter, transaktioner eller annan affärskritisk information. Om serversidan tillåter osäkra frågor kan en angripare läsa, ändra eller radera data med stora konsekvenser för både drift och integritet. Autentisering betyder att systemet verifierar vem användaren eller tjänsten faktiskt är, medan auktorisering avgör vilka resurser och operationer den identiteten får använda. Ett grundskydd är parameteriserade frågor, eftersom de separerar data från SQL-logik och minskar risken för SQL-injektion. Lösenord ska aldrig lagras i klartext utan hash:as med moderna algoritmer och salter, så att läckta databaser inte direkt avslöjar användarkonton. Databasanvändare bör följa minsta privilegieprincipen, exempelvis skrivskyddad åtkomst för rapportering och separata konton för skrivoperationer. Anslutningssträngar och hemligheter ska lagras i miljövariabler eller en hemlighetshanterare i stället för i källkod och kodförråd.

## 6. Versionshantering – reflektion

Git är viktigt i databasutveckling eftersom schema och frågor förändras över tid och behöver vara spårbara. Med meningsfulla incheckningar går det snabbt att förstå varför en viss tabell, begränsning eller fråga ändrades. Vid felaktiga ändringar kan man återställa utan att tappa hela projektets historik. I teamarbete gör grenar och sammanslagningsförfrågningar att flera utvecklare kan jobba parallellt med migreringar och datalogik utan att skriva över varandra.

## 7. Personlig reflektion

Det som gick bäst var att bryta ner arbetet i tydliga steg med separata incheckningar, eftersom det gjorde varje del lättare att verifiera och dokumentera. Det svåraste var att hålla balansen mellan enkel modell och tillräckligt robusta begränsningar för VG-nivå, särskilt kring datatyper och validering av låtdata. Jag märkte också att ordningen mellan infogningsoperationerna är central när främmande nycklar används, annars blir det direkt referensfel. Om jag gjorde om arbetet skulle jag lägga till ett separat testskript som kör allt i rätt ordning automatiskt för snabbare validering. Jag skulle även komplettera med fler gränsfallsdata, exempelvis album utan betygsatta låtar, för att stresstesta frågeresultaten bättre.
