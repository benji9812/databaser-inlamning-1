# Musikbibliotek – SQL & Databasdesign

Detta projekt bygger ett komplett databasupplägg för ett musikbibliotek med tabellerna **Artist**, **Album** och **Track**.

## Tema
Musikbibliotek med fokus på relationer mellan artist, album och låtar.

## Filstruktur

| Fil | Innehåll |
|---|---|
| `sql/create_tables.sql` | Skapar `Artist`, `Album`, `Track` med PK, FK och constraints |
| `sql/insert_data.sql` | Lägger in realistisk seed-data i rätt FK-ordning |
| `sql/select_basic.sql` | Grundläggande SELECT-exempel (WHERE, ORDER BY, LIKE, GROUP BY) |
| `sql/select_join.sql` | JOIN-frågor mellan 2–3 tabeller, inklusive tre-vägs JOIN |
| `sql/updates.sql` | UPDATE-scenarier för realistiska dataändringar |
| `sql/deletes.sql` | DELETE-scenario för att ta bort en specifik track |
| `docs/er_diagram.md` | Mermaid ER-diagram + motivering av datamodell |
| `docs/rapport.md` | Full rapport med SQL, LINQ-jämförelser, säkerhet och reflektion |

## Hur du kör SQL-filerna

### Alternativ 1: SQLite via terminal

```bash
sqlite3 music_library.db
.read sql/create_tables.sql
.read sql/insert_data.sql
.read sql/select_basic.sql
.read sql/select_join.sql
.read sql/updates.sql
.read sql/deletes.sql
```

Kör `SELECT`-filerna igen efter `UPDATE`/`DELETE` om du vill se ändrade resultat.

### Alternativ 2: DB Browser for SQLite

1. Skapa eller öppna en databasfil (t.ex. `music_library.db`).
2. Öppna flik för SQL-körning.
3. Kör filerna i ordningen: `create_tables` → `insert_data` → övriga.

## Kort projektsammanfattning

Projektet demonstrerar en normaliserad datamodell för musikbibliotek med tydliga relationer:
**Artist (1-n) Album (1-n) Track**. Det innehåller strukturerad schema-definition, testdata, frågeexempel, JOIN-analys, uppdaterings-/raderingsscenarier samt en rapportdel med jämförelse mellan SQL och LINQ samt säkerhetsresonemang för backend.
