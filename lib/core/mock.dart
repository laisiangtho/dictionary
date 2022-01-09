part of 'main.dart';

/// check
mixin _Mock on _Abstract {
  String get userFile => authentication.id.isNotEmpty ? '${authentication.id}.json' : '';

  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [SuggestionType]
  Future<void> suggestionGenerate() async {
    collection.cacheSuggestion = SuggestionType(
      query: collection.suggestQuery,
      raw: await sql.suggestion(),
    );
    notify();
  }

  // ignore: todo
  // TODO: definition on multi words
  // see
  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [ConclusionType]
  Future<void> conclusionGenerate({bool init = false}) async {
    if (collection.cacheConclusion.query != collection.searchQuery) {
      collection.cacheConclusion = ConclusionType(
        query: collection.searchQuery,
        raw: await _definitionGenerator(),
      );
      collection.recentSearchUpdate(collection.searchQuery);
      if (!init) {
        notify();
      }
    }
    // collection.recentSearchUpdate(word);
    // collection.searchQuery = word;
    analytics.search(collection.searchQuery);
  }

  Future<List<Map<String, dynamic>>> _definitionGenerator() async {
    List<Map<String, Object?>> raw = [];
    List<Map<String, Object?>> root;
    List<Map<String, Object?>> rawSense;

    rawSense = await sql.search(collection.searchQuery);
    if (rawSense.isEmpty) {
      root = await sql.rootWord(collection.searchQuery);
      if (root.isNotEmpty) {
        final i = root.map((e) => e['word'].toString()).toSet().toList();
        for (String e in i) {
          final r = await sql.search(e);
          if (r.isNotEmpty) {
            raw.addAll(r);
          }
        }
      }
    } else {
      root = await sql.baseWord(collection.searchQuery);
      raw.addAll(rawSense);
    }
    if (root.isNotEmpty) {
      final tmp = _groupByBase(root);
      raw.addAll(tmp);
    }

    final result = _groupByWord(raw);

    // final words = raw.map((e) => e['word'].toString()).toSet().toList(growable: false);
    // for (String str in words){
    //   final thes = await sql.thesaurus(str);
    //   if (thes.isNotEmpty){
    //     final wordBlock = result.firstWhere((e) => e['word'] == str);
    //     wordBlock['thesaurus'] = thes.map((e) => e['word'].toString()).toSet().toList(growable: false);
    //   }
    // }

    return result;
  }

  Future<List<Map<String, Object?>>> thesaurusGenerate(String word) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final thes = await sql.thesaurus(word);
    return thes;
  }

  List<Map<String, dynamic>> _groupByWord(List<Map<String, Object?>> raw) {
    // Map<String, List<dynamic>>()
    return raw
        .fold(<String, List<dynamic>>{}, (Map<String, List<dynamic>> a, b) {
          a.putIfAbsent(b['word'].toString(), () => []).add(b);
          return a;
        })
        .values
        .map((e) => {
              'word': e.first['word'],
              'sense': _groupByPOS(e),
              // 'thesaurus': []
              // 'thesaurus': e.first['word']
            })
        .toList();
  }

  List<Map<String, dynamic>> _groupByPOS(List<dynamic> raw) {
    // Map<int, List<Map<String, dynamic>>>()
    return raw
        .fold(<int, List<Map<String, dynamic>>>{}, (Map<int, List<Map<String, dynamic>>> a, b) {
          a.putIfAbsent(b['wrte'], () => []).add(b);
          return a;
        })
        .values
        .map((e) => {'pos': collection.partOfGrammar(e.first['wrte']).name, 'clue': _groupSense(e)})
        .toList();
  }

  List<Map<String, dynamic>> _groupSense(List<Map<String, dynamic>> raw) {
    final List<Map<String, dynamic>> result = [];
    for (var row in raw) {
      String? mean;
      List<String> exam = [];
      // row.containsKey('sense')
      if (row['sense'] != null && row.containsKey('sense')) {
        if (row['exam'] != null) {
          exam = row['exam'].split("\r\n");
        }
        // _TypeError (type 'Null' is not a subtype of type 'String')
        mean = row['sense'];
      } else if (row['dete'] != null && row['derived'] != null) {
        final pos = collection.partOfSpeech(row['dete']).name;
        // final pos = collection.env.grammar(row['wrte']).name;
        mean = '[~:${row['derived']}] ($pos)';
      }
      if (mean != null) {
        result.add({'mean': mean, 'exam': exam});
      }
    }
    return result;
  }

  List<Map<String, dynamic>> _groupByBase(List<dynamic> raw) {
    // Map<int, List<Map<String, dynamic>>>()
    return raw
        .fold(<int, List<Map<String, dynamic>>>{}, (Map<int, List<Map<String, dynamic>>> a, b) {
          a.putIfAbsent(b['wrte'], () => []).add(b);
          return a;
        })
        .values
        .map((e) => {
              'word': e.first['word'],
              'wrte': e.first['wrte'],
              'sense': e.map<String>((o) {
                final _derived = o['derived'];
                final _pos = collection.partOfSpeech(o['dete']).name;
                return '[~:$_derived] ($_pos)';
              }).join('; '),
              'exam': null
            })
        .toList();
  }
}
