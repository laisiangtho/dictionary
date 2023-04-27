part of data.core;

class SQLite extends UnitSQLite {
  final Data data;
  SQLite({required this.data});

  // String get _primaryDatabase => data.env.primary.db;
  // List<String> get _secondaryDatabase => data.env.secondary.map((e) => e.db);

  // APIType get _wordContext => data.env.primary;
  APIType get _wordContext => data.primary;
  String get _wordTable => _wordContext.tableName;

  // APIType get _deriveContext => data.env.derive;
  // APIType get _deriveContext => data.env.children.first;
  APIType get _deriveContext => data.children.first;
  String get _deriveTable => _deriveContext.tableName;

  // APIType get _senseContext => data.env.sense;
  // APIType get _senseContext => data.env.secondary.first;
  APIType get _senseContext => data.secondary.first;
  String get _senseTable => _senseContext.tableName;

  // APIType get _thesaurusContext => data.env.thesaurus;
  // APIType get _thesaurusContext => data.env.secondary.last;
  APIType get _thesaurusContext => data.secondary.last;
  String get _thesaurusTable => _thesaurusContext.tableName;

  String get suggestQuery => data.suggestQuery;
  String get searchQuery => data.searchQuery;

  @override
  Future<String> get file async => await UtilDocument.fileName(_wordContext.local);

  @override
  Future<int> get version async => 3;

  @override
  Future<void> doIndex(e) async {
    await e.transaction((txn) async {
      final batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      await batch.commit(noResult: true).catchError((e) {
        debugPrint('db-error-doIndex-Commit $e');
      });
    }).catchError((e) {
      debugPrint('db-error-doIndex-Transaction $e');
    });
  }

  // @override
  // FutureOr<void> onCreate(e, int v) async {
  //   debugPrint('db-onCreate');
  //   // await doIndex(e);
  // }

  // @override
  // FutureOr<void> onUpgrade(e, int ov, int nv) async {
  //   debugPrint('db-onUpgrade');
  //   // await doIndex(e);
  // }

  // @override
  // FutureOr<void> onDowngrade(e, int ov, int nv) async {
  //   debugPrint('db-onDowngrade');
  //   // await doIndex(e);
  // }

  @override
  FutureOr<void> onOpen(e) async {
    await e.transaction((txn) async {
      final dl = await txn.rawQuery(queryDatabaseList);

      final batch = txn.batch();

      for (var item in data.secondary) {
        // final attached = dl.indexWhere((e) => e['name'] == item.uid) < 0;
        final attached = dl.indexWhere((e) => e['name'] == item.uid) >= 0;
        // debugPrint('db-attached $attached ${item.local}');

        if (!attached) {
          debugPrint('db-attaching ${item.local}');

          // debugPrint('db-onOpen secondary ${item.local}');
          String filePath = await UtilDocument.fileName(item.local);
          // await db.rawQuery('DETACH DATABASE ?;',[filePath,item.uid]);
          // await txn.rawQuery('ATTACH DATABASE ? AS ?;', [filePath, item.uid]);
          batch.execute('ATTACH DATABASE ? AS ?;', [filePath, item.uid]);
          batch.execute(item.createIndex!);
        }
      }

      await batch.commit(noResult: true).catchError((e) {
        debugPrint('db-error-onOpen-Commit $e');
      });
      // await batch.commit();
    }).catchError((e) {
      debugPrint('db-error-onOpen-Transaction $e');
    });
  }

  Future<List<Map<String, Object?>>> testDeleteIt(String keyword) async {
    await db;

    return client.query(
      _wordTable,
      columns: ['*'],
      where: 'word LIKE ?',
      whereArgs: [keyword],
    );
    // return client.rawQuery('SELECT * FROM ? WHERE word LIKE ?;', [_wordTable, keyword]);
  }

  /// get suggestion
  // Future<List<Map<String, Object?>>> suggestion() async {
  //   // return await _instance.query(_senseTable, columns:['word'],where: 'word LIKE ?',whereArgs: [keyword+'%'] ,orderBy: 'word',limit: 10);
  //   // return await _instance.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 10;",[keyword+'%']);
  //   // SuggestionType<OfRawType>();
  //   return await db.then(
  //     (e) => e.rawQuery(
  //       "SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word ORDER BY word ASC LIMIT 30;",
  //       ['$suggestQuery%'],
  //     ),
  //   );
  // }
  Future<List<OfRawType>> suggestion() async {
    // return await _instance.query(_senseTable, columns:['word'],where: 'word LIKE ?',whereArgs: [keyword+'%'] ,orderBy: 'word',limit: 10);
    // return await _instance.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 10;",[keyword+'%']);
    // SuggestionType<OfRawType>();
    await db;

    return client.rawQuery(
      'SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word ORDER BY word ASC LIMIT 30;',
      ['$suggestQuery%'],
    ).then((raw) {
      return raw.map((e) => OfRawType(term: e['word'].toString())).toList();
    });
  }

  /// get definition
  Future<List<Map<String, Object?>>> search(String keyword) async {
    await db;
    return client.rawQuery(
      'SELECT word, wrte, sense, exam FROM $_senseTable WHERE word LIKE ? ORDER BY wrte, wseq;',
      [keyword],
    );
  }

  /// get root
  /// [d.word, c.wrte, c.dete, c.wrig, w.word AS derived]
  Future<List<Map<String, Object?>>> rootWord(String keyword) async {
    await db;
    return client.rawQuery(
      '''SELECT
        d.word, c.wrte, c.dete, c.wrig, w.word AS derived
      FROM $_wordTable AS w
        INNER JOIN $_deriveTable c ON w.id = c.wrid
          INNER JOIN $_wordTable d ON c.id = d.id
      WHERE w.word = ?;
      ''',
      [keyword],
    );
  }

  /// get base
  /// [w.word, c.wrte, c.dete, c.wrig, d.word AS derived]
  Future<List<Map<String, Object?>>> baseWord(String keyword) async {
    await db;
    return client.rawQuery(
      '''SELECT
        w.word, c.wrte, c.dete, c.wrig, d.word AS derived
      FROM $_wordTable AS w
        INNER JOIN $_deriveTable c ON w.id = c.id
          INNER JOIN $_wordTable d ON c.wrid = d.id
      WHERE w.word = ?;
      ''',
      [keyword],
    );
  }

  /// get thesaurus
  /// [w.id AS root, c.wlid AS wrid, d.word, d.derived]
  Future<List<Map<String, Object?>>> thesaurus(String keyword) async {
    await db;
    return client.rawQuery(
      '''SELECT
        d.word, d.derived
      FROM $_wordTable AS w
        INNER JOIN $_thesaurusTable c ON w.id = c.wrid
          INNER JOIN $_wordTable d ON c.wlid = d.id
      WHERE w.word = ?;
      ''',
      [keyword],
    );
  }
}
