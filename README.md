# Dictionary (MyOrdbok)

MyOrdbok is 'A comprehensive Myanmar online dictionary', and providing parts of speech, thesaurus and synonyms. It is aimed to help learning english, as well as burmese vocabularies and expressions. We have 57223 primary words with over 103787 definitions which can be used to lookup with over 200000 words. Our web app supports 24 languages.

Feature:

- Definition
- Example(usage)
- Parts of speech
- Thesaurus and synonyms
- Bookmark
- Search (instant suggestion and result)
- Open Source
- Offline
- Customizable
- Elegant
- No authentication require
- No Ads
- Free

As it is active in develpment, please feel free to rate/write yours review, so that we can bring a better Dictionary app.

## Todo

- [x] Definition makeup
- [ ] none result lookup
- [ ] Cart
- [ ] analytics
- [ ] History
- [ ] Like
- [ ] Improve scroll for NestedScrollView

lidea
ledi, lidea lai l
zaideih
laist
ledic
le
dictionary
myordbok
ordbok
l

```shell
1. flutter channel stable
2. flutter upgrade
3. flutter config --enable-web
4. cd into project directory
5. flutter create .
6. flutter run -d chrome
```

```pug

 #{tagName}(class!=attributes.class)!= e.replace(/\"(.+?)\"/g, '<q>$1</q>')
 .replace(/\(-(.+?)-\)/g, '<small>$1</small>')
 .replace(/\((.+?)\)/g, '<em>$1</em>')
 .replace(/\{-(.+?)-\}/g, (_,q)=>'<a href="definition?q='+encodeURI(q)+'">'+q+'</a>').replace(/\[(.*?)\]/g, '<b>$1</b>')

```

hive

```dart

return Consumer<FormNotifier>(
  builder: (BuildContext context, FormNotifier form, Widget child) => Text(??)
);

```

```sql
SELECT
    word, tid, sense, exam
FROM
    senses
INTO OUTFILE 'C:/tmp/sense.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY '|'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';

SELECT
    word, is_derived
FROM
    words
INTO OUTFILE 'C:/tmp/words.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ';'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';
```
