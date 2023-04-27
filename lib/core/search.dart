part of data.core;

abstract class _Search extends _Mock {
  String get searchQuery => data.searchQuery;
  // set searchQuery(String ord) {
  //   data.searchQuery = ord;
  // }

  String get suggestQuery => data.suggestQuery;
  // set suggestQuery(String ord) {
  //   data.suggestQuery = ord;
  // }

  bool get searchQueryFavorited {
    // return collection.favoriteIndex(searchQuery) >= 0;
    return data.favoriteExist(searchQuery).key != null;
  }
  // SuggestionType? _cacheSuggestion;
  // SuggestionType _cacheSuggestion = const SuggestionType();
  // ConclusionType _cacheConclusion = const ConclusionType();

  // SuggestionType get cacheSuggestion => const SuggestionType();
  // ConclusionType get cacheConclusion => const ConclusionType();
  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [SuggestionType]
  // Future<void> suggestionGenerate() async {}
  Future<void> suggestionGenerate() async {
    data.cacheSuggestion = SuggestionType<OfRawType>(
      query: suggestQuery,
      raw: await sql.suggestion(),
    );
    data.notify();
  }

  // get suggestion
  // SuggestionType<OfRawType> get cacheSuggestion {
  //   return data.cacheSuggestion;
  // }

  // Future<void> conclusionGenerate() async {
  //   data.cacheConclusion;

  //   data.cacheConclusion = ConclusionType(
  //     query: searchQuery,
  //   );
  //   data.boxOfRecentSearch.update(searchQuery);
  // }

  // ignore: todo
  // TODO: definition on multi words
  // see
  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [ConclusionType]
  Future<void> conclusionGenerate({bool init = false}) async {
    debugPrint('conclusionGenerate new: $searchQuery old: ${data.cacheConclusion.query}');
    if (data.cacheConclusion.query != searchQuery) {
      data.cacheConclusion = ConclusionType(
        query: searchQuery,
        raw: await _definitionGenerator(),
      );
      data.boxOfRecentSearch.update(searchQuery);
      if (!init) {
        // notify();
        data.notify();
      }
      debugPrint('conclusionGenerate $searchQuery');
    }

    // debugPrint(data.cacheConclusion.raw.toString());
    // collection.recentSearchUpdate(word);
    // collection.searchQuery = word;
    analytics.search(searchQuery);
  }

  // get conclusion
  // ConclusionType get cacheConclusion {
  //   // return _cacheConclusion;
  //   return data.cacheConclusion;
  // }

  Future<List<Map<String, dynamic>>> _definitionGenerator() async {
    List<Map<String, Object?>> raw = [];
    List<Map<String, Object?>> root;
    List<Map<String, Object?>> rawSense;

    rawSense = await sql.search(searchQuery);
    if (rawSense.isEmpty) {
      root = await sql.rootWord(searchQuery);
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
      root = await sql.baseWord(searchQuery);
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
        .map((e) => {'pos': data.partOfGrammar(e.first['wrte']).name, 'clue': _groupSense(e)})
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
          exam = row['exam'].split('\r\n');
        }
        // _TypeError (type 'Null' is not a subtype of type 'String')
        mean = row['sense'];
      } else if (row['dete'] != null && row['derived'] != null) {
        final pos = data.partOfSpeech(row['dete']).name;
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
                final der = o['derived'];
                final pos = data.partOfSpeech(o['dete']).name;
                return '[~:$der] ($pos)';
              }).join('; '),
              'exam': null
            })
        .toList();
  }
}
