# Type and models

connection

```shell
word -> { w: wordId, v: string }
sense -> { i: uId, w: wordId, t: 0, v: string }
usage -> { i: uId, v: string }
```

List of ResultModel

```json
[
  {
    word:'',
    sense:[
      {
        pos:'',
        clue:[
          {
            mean:''
            exam:['','']
          }
        ]
      }
    ],
    thesaurus:[]
  }
]
```

```dart
Iterable<WordType> get wordValues => Hive.box<WordType>(_wordName).values;
Iterable<SenseType> get senseValues => Hive.box<SenseType>(_senseName).values;
Iterable<UsageType> get usageValues => Hive.box<UsageType>(_usageName).values;
Iterable<SynsetType> get synsetValues => Hive.box<SynsetType>(_synsetName).values;
Iterable<SynmapType> get synmapValues => Hive.box<SynmapType>(_synmapName).values;

Iterable<WordType> suggestion(String word) => wordValues.where((e) => e.v.toLowerCase() == word.toLowerCase());
Iterable<WordType> suggestion(String word) => wordValues.where((e) => new RegExp(word,caseSensitive: false).hasMatch(e.v));
Iterable<WordType> wordStartWith(String word) => wordValues.where((e) => e.charStartsWith(word));
Iterable<WordType> wordExactMatch(String word) => wordValues.where((e) => e.charMatchExact(word));

factory Collection.fromJSON(Map<String, dynamic> o) {
  // NOTE: change of collection bible model
  return Collection(
    version: o['version'] as int,
    setting: CollectionSetting.fromJSON(o['setting']),
    keyword: o['keyword'].map<CollectionKeyword>((json) => CollectionKeyword.fromJSON(json)).toList(),
    // bible: o['bible'].map<CollectionBible>((json) => CollectionBible.fromJSON(json)).toList(),
    bible: (o['bible']??o['book']).map<CollectionBible>((json) => CollectionBible.fromJSON(json)).toList(),
    bookmark: o['bookmark'].map<CollectionBookmark>((json) => CollectionBookmark.fromJSON(json)).toList(),
  );
}

Map<String, dynamic> toJSON() {
  // List bible = _collectionBook.map((e)=>e.toJSON()).toList();
  return {
    'version':this.version,
    'setting':this.setting.toJSON(),
    'keyword':this.keyword.map((e)=>e.toJSON()).toList(),
    'bible':this.bible.map((e)=>e.toJSON()).toList(),
    'bookmark':this.bookmark.map((e)=>e.toJSON()).toList()
  };
}
```

ObjectMapType -> json

```json
{
  "key": {
    "a": "1",
    "b": "2",
    "c": "3"
  }
}
```

ObjectMapType

```dart
class ObjectMapType {
  Map<String, String> data;

  ObjectMapType({
    this.data,
  });

  factory ObjectMapType.fromJSON(Map<String, dynamic> o) {
    return ObjectMapType(
      data: Map.from(o["key"]).map((k, v) => MapEntry<String, String>(k, v)),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v))
    };
  }
}
```

ObjectListType -> json

```json
{
  "1": ["a","b","c"],
  "2": ["d","e","f"],
  "3": ["g","h","i"]
}
```

ObjectListType ??

```dart
class ObjectListType {
  String word;
  List<String> synonym;

  ObjectListType({
    this.word,
    this.synonym,
  });

  factory ObjectListType.fromJSON(Map<String, dynamic> o) {
    return ObjectListType(
      word: Map.from(o).map((k, v) => MapEntry<String, String>(k, v)),
      synonym: Map.from(o["key"]).map((k, v) => MapEntry<String, String>(k, v)),
    );
  }
//v: List.from(o['v'])
      // v: (o['v'] as List<dynamic>).cast<String>()

  Map<String, dynamic> toJSON() {
    return {
      "word": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v))
      "synonym": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v))
    };
  }
}
```
