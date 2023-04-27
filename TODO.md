# Todo

## Components

- [ ] Custom dictionary and administration
- [ ] Definition suggestion form
- [x] Change to common font height
- [x] WidgetButton(back, cancel, home, profile) duration
  - duration: const Duration(milliseconds: 500),

## Database

- [ ] ignore recovered database ROLLBACK error DatabaseException(Cannot perform this operation because there is no current transaction.) sql 'ROLLBACK' args []
- [ ] SqfliteDatabaseException (DatabaseException(no such table: main.list (code 1 SQLITE_ERROR): , while compiling: CREATE UNIQUE INDEX IF NOT EXISTS wordIdIndex ON list (id, word)) sql 'CREATE UNIQUE INDEX IF NOT EXISTS wordIdIndex ON list (id, word)' args [])
- [ ] SqfliteDatabaseException (DatabaseException(no such table: android_metadata (code 1 SQLITE_ERROR)))
- [ ] SqfliteDatabaseException (DatabaseException(Cannot perform this operation because there is no current transaction.) sql 'COMMIT' args [])

- Definition
  - post
  - review

- primaryTextTheme vs textTheme
- RichText vs Text.rich

## Feature

- [ ] Home view
- [x] Definition makeup
- [ ] none result lookup
- [x] Store
  - [x] Restore purchase
- [ ] analytics
- [x] History (Recent searches)
  - [ ] list is current limited 30 word statically
  - [x] History navigator
  - [ ] History view sort
- [ ] Like
- [x] Improve scroll for NestedScrollView
- [ ] gist backup
- [ ] Dark mode color

## Test

- Keep-Asset
- [x] each(word, sense, thesaurus)
- [x] archive each(word, sense, thesaurus)
- [x] archive single(all in one)
- [ ] word single(all in one)
- Cloud-Asset
- [ ] each(word, sense, thesaurus)
- [ ] Single(all in one)
