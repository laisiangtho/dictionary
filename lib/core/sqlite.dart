part of data.core;
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

  String get suggestQuery => collection.suggestQuery.asString;
  String get searchQuery => collection.searchQuery.asString;

  @override
  Future<String> get file async => await UtilDocument.fileName(_wordContext.local);

  @override
  Future<int> get version async => 1;

  @override
  FutureOr<void> doIndex(e) async {
    await e.transaction((txn) async {
      final batch = txn.batch();
      batch.execute(_wordContext.createIndex!);
      batch.execute(_deriveContext.createIndex!);
      await batch.commit(noResult: true);
    });
  }

  @override
  FutureOr<void> onOpen(e) async {
    final ath = await e.rawQuery(queryDatabaseList);
    final batch = e.batch();
    for (var item in collection.secondary) {
      // final bool notAttached = ath.firstWhere((e) => e['name'] == item.uid, orElse:()=> null) == null;
      final notAttached = ath.firstWhere(
        (e) => e['name'].toString() == item.uid,
        orElse: () => <String, dynamic>{},
      );
      if (notAttached.isEmpty) {
        String filePath = await UtilDocument.fileName(item.local);
        // await db.rawQuery("DETACH DATABASE ${item.uid};");
        await e.rawQuery("ATTACH DATABASE '$filePath' AS ${item.uid};").then((_) {
          if (item.createIndex != null && item.createIndex!.isNotEmpty) {
            // PRAGMA INDEX_LIST('table_name');
            // final ath = await db.rawQuery("PRAGMA INDEX_LIST('${item.uid}');");
            debugPrint('ATTACH DATABASE createIndex $ath');
            batch.execute(item.createIndex!);
          }
        }).catchError((e) {
          debugPrint('??1 $e');
        });
      } else {
        // debugPrint('attached ${item.local}');
      }
    }
    try {
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('??2 $e');
    }
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
      "SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word ORDER BY word ASC LIMIT 30;",
      ['$suggestQuery%'],
    ).then((raw) {
      return raw.map((e) => OfRawType(term: e['word'].toString())).toList();
    });
  }

  /// get definition
  Future<List<Map<String, Object?>>> search(String keyword) async {
    await db;
    return client.rawQuery(
      "SELECT word, wrte, sense, exam FROM $_senseTable WHERE word LIKE ? ORDER BY wrte, wseq;",
      [keyword],
    );
  }

  /// get root
  /// [d.word, c.wrte, c.dete, c.wirg, w.word AS derived]
  Future<List<Map<String, Object?>>> rootWord(String keyword) async {
    await db;
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
    await db;
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
    await db;
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
