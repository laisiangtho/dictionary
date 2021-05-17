part of 'main.dart';

class SQLite {
  final Collection collection;
  // static final SQLite _instance = new SQLite.internal();
  // factory SQLite() => _instance;
  // SQLite.internal();

  Database? _instance;
  final int version = 1;

  SQLite({required this.collection});

  // String get _primaryDatabase => collection.env.primary.db;
  // List<String> get _secondaryDatabase => collection.env.secondary.map((e) => e.db);

  // APIType get _wordContext => collection.env.word;
  APIType get _wordContext => collection.env!.primary;
  String get _wordTable => _wordContext.tableName;

  // APIType get _deriveContext => collection.env.derive;
  APIType get _deriveContext => collection.env!.children.first;
  String get _deriveTable => _deriveContext.tableName;

  // APIType get _senseContext => collection.env.sense;
  APIType get _senseContext => collection.env!.secondary.first;
  String get _senseTable => _senseContext.tableName;

  // APIType get _thesaurusContext => collection.env.thesaurus;
  APIType get _thesaurusContext => collection.env!.secondary.last;
  String get _thesaurusTable => _thesaurusContext.tableName;

  Future<Database?> get db async {
    if (_instance == null) {
      _instance = await init();
    }
    return _instance;
  }

  FutureOr<Database> init() async {
    // send primary db, attach except db
    final String file = await UtilDocument.fileName(_wordContext.db);
    // debugPrint('load start');
    // await this.load(_wordContext);
    // debugPrint('load end');
    return await openDatabase(
      file,
      version: this.version,
      onConfigure: this.onConfigure,
      onCreate: this.onCreate,
      onUpgrade: this.onUpgrade,
      onDowngrade: this.onDowngrade,
      onOpen: this.onOpen,
      singleInstance: true
    );
  }

  FutureOr<void> onConfigure(Database db) {
    // ALTER TABLE table_name ADD PRIMARY KEY(col1, col2,...)
  }

  FutureOr<void> onCreate(Database db, int v) async {
    collection.notify.progress.value = null;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      await batch.commit(noResult: true);
    });
  }

  FutureOr<void> onUpgrade(Database db, int ov, int nv) async {
    collection.notify.progress.value = null;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      await batch.commit(noResult: true);
    });
  }

  FutureOr<void> onDowngrade(Database db, int ov, int nv) async {
    collection.notify.progress.value = null;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      await batch.commit(noResult: true);
    });
  }

  FutureOr<void> onOpen(Database db) async{
    collection.notify.progress.value = 0.4;
    await attach(db);
  }

  /// `PRAGMA database_list;` `DETACH DATABASE ?;` `ATTACH DATABASE / as ?;`
  FutureOr<void> attach(Database db) async{
    final ath = await db.rawQuery("PRAGMA database_list;");
    // {seq: 0, name: main, file: /}
    Batch batch = db.batch();
    for (var item in collection.env!.secondary) {
      // final bool notAttached = ath.firstWhere((e) => e['name'] == item.uid, orElse:()=> null) == null;
      final notAttached = ath.firstWhere((e) => e['name'] == item.uid).isEmpty;
      if (notAttached) {
        String _filePath = await UtilDocument.fileName(item.db);
        // await db.rawQuery("DETACH DATABASE ${item.uid};");
        await db.rawQuery("ATTACH DATABASE '$_filePath' AS ${item.uid};").then((value){
          if (item.createIndex != null && item.createIndex!.isNotEmpty){
            batch.execute(item.createIndex!);
          }
        }).catchError((e){
          debugPrint(e.toString());
        });
      } else {
        debugPrint('attached ${item.db}');
      }
    }
    await batch.commit(noResult: true);
  }

  // Future<void> test() async {
  //   Stopwatch stopwatch = new Stopwatch()..start();
  //   try {
  //     // await client.transaction((txn) async {
  //     //   Batch batch = txn.batch();
  //     //   for (APIType item in collection.env.secondary) {
  //     //     if (item.createIndex != null && item.createIndex.isNotEmpty){
  //     //       print('item.createIndex ${item.createIndex}');
  //     //       batch.execute(item.createIndex);
  //     //     }
  //     //   }
  //     //   await batch.commit(noResult: true);
  //     // });
  //     // await client.rawQuery("SELECT count(*) as count FROM sense.sqlite_master WHERE type = 'table';").then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     // sense.list_sense
  //     // await client.rawQuery("SELECT * FROM $_senseTable LIMIT 1;").then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     // await search('love').then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     // await rootWord('love').then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   print(e);
  //     //   // debugPrint(e.toString());
  //     // });
  //     // await baseWord('loved').then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     await thesaurus('love').then(
  //       (v) {
  //         debugPrint(v.toString());
  //       }
  //     ).catchError((e){
  //       debugPrint(e.toString());
  //     });
  //     // var client = await this.db;
  //     // await client.rawQuery("SELECT * FROM $_wordTable LIMIT 1").then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   debugPrint('sql.test() executed in ${stopwatch.elapsedMilliseconds} Milliseconds');
  // }

  /// get suggestion
  Future<List<Map<String, Object?>>> suggestion(String keyword) async {
    // return await _instance.query(_senseTable, columns:['word'],where: 'word LIKE ?',whereArgs: [keyword+'%'] ,orderBy: 'word',limit: 10);
    // return await _instance.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 10;",[keyword+'%']);
    return await this.db.then(
      (e) => e!.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 30;",['$keyword%'])
    );
  }

  /// get definition
  Future<List<Map<String, Object?>>> search(String keyword) async {
    return await this.db.then(
      (e) => e!.rawQuery("SELECT word, wrte, sense, exam FROM $_senseTable WHERE word LIKE ? ORDER BY wrte, wseq;",[keyword])
    );
  }

  /// get root
  /// [d.word, c.wrte, c.dete, c.wirg, w.word AS derived]
  Future<List<Map<String, Object?>>> rootWord(String keyword) async {
    var client = await this.db;
    return client!.rawQuery("""SELECT
      d.word, c.wrte, c.dete, c.wirg, w.word AS derived
    FROM $_wordTable AS w
      INNER JOIN $_deriveTable c ON w.id = c.wrid
        INNER JOIN $_wordTable d ON c.id = d.id
    WHERE w.word = ?;
    """,[keyword]);
  }

  /// get base
  /// [w.word, c.wrte, c.dete, c.wirg, d.word AS derived]
  Future<List<Map<String, Object?>>> baseWord(String keyword) async {
    var client = await this.db;
    return client!.rawQuery("""SELECT
      w.word, c.wrte, c.dete, c.wirg, d.word AS derived
    FROM $_wordTable AS w
      INNER JOIN $_deriveTable c ON w.id = c.id
        INNER JOIN $_wordTable d ON c.wrid = d.id
    WHERE w.word = ?;
    """,[keyword]);
  }

  /// get thesaurus
  /// [w.id AS root, c.wlid AS wrid, d.word, d.derived]
  Future<List<Map<String, Object?>>> thesaurus(String keyword) async {
    var client = await this.db;
    return client!.rawQuery("""SELECT
      d.word, d.derived
    FROM $_wordTable AS w
      INNER JOIN $_thesaurusTable c ON w.id = c.wrid
        INNER JOIN $_wordTable d ON c.wlid = d.id
    WHERE w.word = ?;
    """,[keyword]);
  }

  /// temp: get number of tables
  Future<List<Map<String, Object?>>> countTable() async {
    var client = await this.db;
    return client!.rawQuery("SELECT count(*) as count FROM sqlite_master WHERE type = 'table';");
  }

}
