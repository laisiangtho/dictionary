part of 'main.dart';

/// check
mixin _Mock on _Abstract {
  Future<dynamic> mockTest1() async {
    Stopwatch mockWatch = Stopwatch()..start();

    final a3 = UtilDocument.encodeJSON({'hello': 'hello!!'});
    collection.gist.updateFile(file: userFile, content: a3).then((e) {
      debugPrint('$e');
    }).catchError((e) async {
      if (e == 'Failed to load') {
        await collection.tokenUpdate().then((e) {
          debugPrint('done');
        }).catchError((e) {
          debugPrint('$e');
        });
      } else {
        debugPrint('$e');
      }
    });

    // await gist.gitFiles().then((res) {
    //   debugPrint('result $res');
    // }).catchError((e) {
    //   debugPrint('error $e');
    // });
    // await gist.updateFile('other.csv', 'id,\nfirst-,\nsecond-,').then((res) {
    //   debugPrint('result $res');
    // }).catchError((e) {
    //   debugPrint('error $e');
    // });
    // await gist.removeFile('others.csv').then((res) {
    //   debugPrint('result $res');
    // }).catchError((e) {
    //   debugPrint('error $e');
    // });

    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} ms');
  }

  Future<dynamic> mockTest2() async {
    // final gist = GistData(
    //   owner: 'collection.env.configure.owns',
    //   repo: 'collection.env.configure.name',
    // );
    // final gist = userGist;

    // final gitUri = await gist.gitContent<Uri>(
    //   // owner: 'me',
    //   // repo: 'lai',
    //   file: 'bfe/abc.json',
    //   debug: true,
    // );
    // uri request local, get nameLive getCache
    // final tmpLive = collection.env.repo.live(2147);
    // final tmpCache = collection.env.repo.local(2147);
    // final tmpLive = collection.env.repo.local(2147);
    // final tmpCache = collection.env.repo.local(2147);

    // final api = collection.env.api.firstWhere((e) => e.uid == 'bible');
    // final bibleUri = gist.rawContentUri(
    //   owner: collection.env.repo.owns,
    //   repo: collection.env.repo.name,
    //   file: api.repoName('fe'),
    // );
    // debugPrint(' repo: $bibleUri');

    // comLive, comCache

    // final trackLive = collection.env.track.liveName(2147);
    // final trackCache = collection.env.track.cacheName(2147);
    // debugPrint('-live: $trackLive \n-cache: $trackCache');

    // debugPrint(' ${gitUri.toString()}');
    // debugPrint(' ${rawUri.toString()}');
    // debugPrint(' ${liveUri.toString()}');
    // debugPrint(' ${gist.gitContentUri}');
    // debugPrint(' ${gist.rawContentUri}');

    // final urlParse = Uri.parse(url);
    // debugPrint(
    //     'parse $urlParse ${urlParse.authority} ${urlParse.path} ${urlParse.queryParametersAll}');
    // final urlParseHttp = Uri.https(urlParse.authority, urlParse.path, urlParse.queryParameters);
    // debugPrint(
    //     'http $urlParseHttp ${urlParseHttp.authority} ${urlParseHttp.path} ${urlParseHttp.queryParameters}');

    // final asdf = 'com+';
    // final adf = Uri.parse('api/audio/#?d1v=l1&ad=2');
    // debugPrint(' $adf ${adf.path} ${adf.queryParameters}');
    // final adf1 = collection.env.apis
    //     .firstWhere((e) => e.uid == 'track')
    //     .parseUriTest(collection.env.domain, 5);
    // debugPrint(' $adf1');

    // final fee = collection.env.apis.firstWhere((e) => e.uid == 'track');
    // final fee1 = collection.env.urlTest(fee.liveName(45));
    // debugPrint(' $fee1');
    // for (var api in collection.env.api) {
    //   debugPrint(' ${api.uid} \n -src ${api.src}');
    // }

    // final uriFirst = collection.env.url('word').uri('4354');
    // final uriSecond = collection.env.url('word').uri('4354', index: 1, scheme: 'http');
    // final cache = collection.env.url('word').cache('4354');
    // debugPrint('\n live $uriFirst \n cache $cache \n second $uriSecond');

    final uriFirst = collection.env.url('bible').uri(name: '4354');
    final uriSecond = collection.env.url('bible').uri(name: '4354', index: 1, scheme: 'http');
    final cache = collection.env.url('bible').cache('4354');
    debugPrint('\n live $uriFirst \n cache $cache \n second $uriSecond');

    // final bible = collection.env.url('bible');
    // final bibleLive = bible.uri('4354');
    // final bibleCache = bible.cache('4354');
    // debugPrint('---------\n bibleLive $bibleLive \n bibleCache $bibleCache');
    // debugPrint('assetName ${bible.assetName}');
    // debugPrint('localName ${bible.localName}');
    // debugPrint('repoName ${bible.repoName}');
  }

  String get userFile => authentication.id.isNotEmpty ? '${authentication.id}.json' : '';

  // Future<bool> initArchive() async{
  //   bool toChecks = false;
  //   for (var item in collection.env.listOfDatabase) {
  //     toChecks = await UtilDocument.exists(item.file).then(
  //       (e) => e.isEmpty
  //     ).catchError((_)=>true);
  //     if (toChecks){
  //       // stop checking at ${item.uid}
  //       debugPrint('stop checking at ${item.uid}');
  //       break;
  //     }
  //     // continuous checking on ${item.uid}
  //     debugPrint('continuous checking on ${item.uid}');
  //   }
  //   if (toChecks) {
  //     return await loadArchiveMock(collection.env.primary).then((e) => true).catchError((_)=>false);
  //   }
  //   // Nothing to unpack so everything is Ok!
  //   debugPrint('Nothing to unpack, everything seems fine!');
  //   return true;
  // }

  // // Archive: extract File
  // Future<List<String>> loadArchiveMock(APIType id) async{
  //   for (var item in id.src) {
  //     List<int>? bytes;
  //     bool _validURL = Uri.parse(item).isAbsolute;
  //     if (_validURL){
  //       bytes = await UtilClient(item).get<Uint8List?>().catchError((_) => null);
  //     } else {
  //       bytes = await UtilDocument.loadBundleAsByte(item).then(
  //         (value) => UtilDocument.byteToListInt(value).catchError((_) => null)
  //       ).catchError((e) => null);
  //     }
  //     if (bytes != null && bytes.isNotEmpty) {
  //       // load at $item
  //       debugPrint('load at $item');
  //       final res = await UtilArchive().extract(bytes).catchError((_) => null);
  //       if (res != null) {
  //         // loaded file $res
  //         debugPrint('loaded file $res');
  //         return res;
  //       }
  //     }
  //   }
  //   return Future.error("Failed to load");
  // }

  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [SuggestionType]
  // Future<void> suggestionGenerate() async {
  //   Stopwatch suggestionWatch = Stopwatch()..start();
  //   int randomNumber = Random().nextInt(100);
  //   collection.cacheSuggestion = SuggestionType(
  //     query: collection.suggestQuery,
  //     // raw: await _sql.suggestion()
  //     raw: List.generate(randomNumber, (_) => {'word': 'random $randomNumber ${collection.suggestQuery}'}),
  //   );
  //   notify();
  //   debugPrint('suggestionGenerate in ${suggestionWatch.elapsedMilliseconds} ms');
  // }

  Future<void> suggestionGenerate() async {
    // this.suggestionList = await _sql.suggestion(collection.searchQuery);
    // if (collection.cacheSuggestion.query != collection.suggestQuery) {
    //   collection.cacheSuggestion = SuggestionType(
    //     query: collection.suggestQuery,
    //     raw: await _sql.suggestion(),
    //   );
    //   notify();
    // }
    // debugPrint('suggestionGenerate in ${suggestionWatch.elapsedMilliseconds} ms');
    collection.cacheSuggestion = SuggestionType(
      query: collection.suggestQuery,
      raw: await _sql.suggestion(),
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

    rawSense = await _sql.search(collection.searchQuery);
    if (rawSense.isEmpty) {
      root = await _sql.rootWord(collection.searchQuery);
      if (root.isNotEmpty) {
        final i = root.map((e) => e['word'].toString()).toSet().toList();
        for (String e in i) {
          final r = await _sql.search(e);
          if (r.isNotEmpty) {
            raw.addAll(r);
          }
        }
      }
    } else {
      root = await _sql.baseWord(collection.searchQuery);
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
    final thes = await _sql.thesaurus(word);
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
