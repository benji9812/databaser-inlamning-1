-- Enable FK checks in SQLite sessions.
PRAGMA foreign_keys = ON;

-- Artist stores one row per music artist and acts as the parent entity for albums.
CREATE TABLE IF NOT EXISTS Artist (
    artist_id INTEGER PRIMARY KEY,
    artist_name TEXT NOT NULL,
    country TEXT NOT NULL,
    debut_date DATE NOT NULL
);

-- Album stores releases and links each album to exactly one artist.
CREATE TABLE IF NOT EXISTS Album (
    album_id INTEGER PRIMARY KEY,
    artist_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    release_date DATE NOT NULL,
    genre TEXT NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

-- Track stores songs and links each track to one album while keeping useful metadata.
CREATE TABLE IF NOT EXISTS Track (
    track_id INTEGER PRIMARY KEY,
    album_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
    rating REAL CHECK (rating BETWEEN 0 AND 5),
    track_number INTEGER NOT NULL CHECK (track_number > 0),
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
);
