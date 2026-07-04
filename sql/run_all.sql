-- run_all.sql
-- Kör alla SQL-filer i korrekt ordning för att bygga databasen från grunden.
-- Ordningen är kritisk: tabeller måste skapas innan data kan infogas,
-- och Artist/Album måste finnas innan Track kan referera till dem via FK.
-- Steg 1: Skapa tabellstrukturen
.read create_tables.sql
-- Steg 2: Fyll på med testdata (Artist → Album → Track)
.read insert_data.sql
-- Steg 3: Kör grundläggande SELECT-queries för verifiering
.read select_basic.sql
-- Steg 4: Kör JOIN-queries för att testa relationer
.read select_join.sql
-- Steg 5: Kör UPDATE och DELETE för att testa datamanipulering
.read updates.sql
.read deletes.sql
