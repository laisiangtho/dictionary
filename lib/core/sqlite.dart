part of 'main.dart';
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:lidea/util/main.dart';
// import 'package:lidea/unit/sqlite.dart';
// import '/type/main.dart';

class SQLite extends UnitSQLite {
  late Collection collection;

  // SQLite({required this._cluster});
  SQLite({required this.collection});

  // String get _primaryDatabase => collection.env.primary.db;
  // List<String> get _secondaryDatabase => collection.env.secondary.map((e) => e.db);

  // APIType get _wordContext => collection.env.primary;
  APIType get _wordContext => collection.primary;
  String get _wordTable => _wordContext.tableName;

  // APIType get _deriveContext => collection.env.derive;
  // APIType get _deriveContext => collection.env.children.first;
  APIType get _deriveContext => collection.children.first;
  String get _deriveTable => _deriveContext.tableName;

  // APIType get _senseContext => collection.env.sense;
  // APIType get _senseContext => collection.env.secondary.first;
  APIType get _senseContext => collection.secondary.first;
  String get _senseTable => _senseContext.tableName;

  // APIType get _thesaurusContext => collection.env.thesaurus;
  // APIType get _thesaurusContext => collection.env.secondary.last;
  APIType get _thesaurusContext => collection.secondary.last;
  String get _thesaurusTable => _thesaurusContext.tableName;

  String get suggestQuery => collection.suggestQuery;
  String get searchQuery => collection.searchQuery;

  @override
  Future<String> get file async => await UtilDocument.fileName(_wordContext.local);

  @override
  Future<int> get version async => 1;

  @override
  FutureOr<void> onCreate(db, int v) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      debugPrint('db.onCreate');
      await batch.commit(noResult: true);
    });
  }

  @override
  FutureOr<void> onUpgrade(db, int ov, int nv) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      debugPrint('db.onUpgrade');
      await batch.commit(noResult: true);
    });
  }

  @override
  FutureOr<void> onDowngrade(db, int ov, int nv) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      debugPrint('db.onDowngrade');
      await batch.commit(noResult: true);
    });
  }

  @override
  FutureOr<void> onOpen(db) async {
    final ath = await db.rawQuery(queryDatabaseList);
    final batch = db.batch();
    for (var item in collection.secondary) {
      // final bool notAttached = ath.firstWhere((e) => e['name'] == item.uid, orElse:()=> null) == null;
      final notAttached = ath.firstWhere(
        (e) => e['name'].toString() == item.uid,
        orElse: () => <String, dynamic>{},
      );
      if (notAttached.isEmpty) {
        String _filePath = await UtilDocument.fileName(item.local);
        // await db.rawQuery("DETACH DATABASE ${item.uid};");
        await db.rawQuery("ATTACH DATABASE '$_filePath' AS ${item.uid};").then((_) {
          if (item.createIndex != null && item.createIndex!.isNotEmpty) {
            // PRAGMA INDEX_LIST('table_name');
            // final ath = await db.rawQuery("PRAGMA INDEX_LIST('${item.uid}');");
            // debugPrint('createIndex $ath');
            batch.execute(item.createIndex!);
          }
        }).catchError((e) {
          debugPrint(e.toString());
        });
      } else {
        // debugPrint('attached ${item.local}');
      }
    }
    await batch.commit(noResult: true);
  }

  /// get suggestion
  Future<List<Map<String, Object?>>> suggestion() async {
    // return await _instance.query(_senseTable, columns:['word'],where: 'word LIKE ?',whereArgs: [keyword+'%'] ,orderBy: 'word',limit: 10);
    // return await _instance.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 10;",[keyword+'%']);
    return await db.then(
      (e) => e.rawQuery(
        "SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word ORDER BY word ASC LIMIT 30;",
        ['$suggestQuery%'],
      ),
    );
  }

  /// get definition
  Future<List<Map<String, Object?>>> search(String keyword) async {
    return await db.then(
      (e) => e.rawQuery(
        "SELECT word, wrte, sense, exam FROM $_senseTable WHERE word LIKE ? ORDER BY wrte, wseq;",
        [keyword],
      ),
    );
  }

  /// get root
  /// [d.word, c.wrte, c.dete, c.wirg, w.word AS derived]
  Future<List<Map<String, Object?>>> rootWord(String keyword) async {
    var client = await db;
    return client.rawQuery(
      """SELECT
        d.word, c.wrte, c.dete, c.wirg, w.word AS derived
      FROM $_wordTable AS w
        INNER JOIN $_deriveTable c ON w.id = c.wrid
          INNER JOIN $_wordTable d ON c.id = d.id
      WHERE w.word = ?;
      """,
      [keyword],
    );
  }

  /// get base
  /// [w.word, c.wrte, c.dete, c.wirg, d.word AS derived]
  Future<List<Map<String, Object?>>> baseWord(String keyword) async {
    var client = await db;
    return client.rawQuery(
      """SELECT
        w.word, c.wrte, c.dete, c.wirg, d.word AS derived
      FROM $_wordTable AS w
        INNER JOIN $_deriveTable c ON w.id = c.id
          INNER JOIN $_wordTable d ON c.wrid = d.id
      WHERE w.word = ?;
      """,
      [keyword],
    );
  }

  /// get thesaurus
  /// [w.id AS root, c.wlid AS wrid, d.word, d.derived]
  Future<List<Map<String, Object?>>> thesaurus(String keyword) async {
    var client = await db;
    return client.rawQuery(
      """SELECT
        d.word, d.derived
      FROM $_wordTable AS w
        INNER JOIN $_thesaurusTable c ON w.id = c.wrid
          INNER JOIN $_wordTable d ON c.wlid = d.id
      WHERE w.word = ?;
      """,
      [keyword],
    );
  }
}
