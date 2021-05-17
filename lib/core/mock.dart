part of 'main.dart';

/// check
mixin _Mock on _Abstract {

  Future<dynamic> mockTest() async {
    Stopwatch mockWatch = new Stopwatch()..start();
    // check db are in place
    // load db and create index
    // check network
    // await mockCheckDatabaseFiles();
    // await archivePassageMock();
    // print('abc');

    // final toLoads = collection.env.primary;
    // await loadArchiveMock(toLoads).catchError((e){
    //   print('asdf $e');
    // });

    // final result = await initArchive();
    // print('result $result');
    await definition('love');

    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  Future<bool> initArchive() async{
    bool toChecks = false;
    for (var item in collection.env!.listOfDatabase) {
      toChecks = await UtilDocument.exists(item.db).then(
        (e) => e.isEmpty
      ).catchError((_)=>true);
      if (toChecks){
        // stop checking at ${item.uid}
        debugPrint('stop checking at ${item.uid}');
        break;
      }
      // continuous checking on ${item.uid}
      debugPrint('continuous checking on ${item.uid}');
    }
    if (toChecks) {
      return await loadArchiveMock(collection.env!.primary).then((e) => true).catchError((_)=>false);
    }
    // Nothing to unpack so everything is Ok!
    debugPrint('Nothing to unpack, everything seems fine!');
    return true;
  }

  // Archive: extract File
  Future<List<String>> loadArchiveMock(APIType id) async{
    for (var item in id.src) {
      List<int>? bytes;
      bool _validURL = Uri.parse(item).isAbsolute;
      if (_validURL){
        bytes = await UtilClient(item).get<Uint8List?>().catchError((_) => null);
      } else {
        bytes = await UtilDocument.loadBundleAsByte(item).then(
          (value) => UtilDocument.byteToListInt(value).catchError((_) => null)
        ).catchError((e) => null);
      }
      if (bytes != null && bytes.isNotEmpty) {
        // load at $item
        debugPrint('load at $item');
        final res = await UtilArchive().extract(bytes).catchError((_) => null);
        if (res != null) {
          // loaded file $res
          debugPrint('loaded file $res');
          return res;
        }
      }
    }
    return Future.error("Failed to load");
  }

  Future<dynamic> mockCheckDatabaseFiles() async {
    // final abc = new GistData(token:collection.env.token.key,id:collection.env.token.id);
    // return await abc.test();
    print('token: ${collection.env!.token.key}, id: ${collection.env!.token.id}');
    // print(collection.env.listOfDBfile.map((e) => e.toJSON()).toList());
  }

  Future<List<Map<String, Object?>>> suggestionGenerate(String word) async {

    // final List<Map<String, Object>> result = [
    //   {"word","abc"} as Map
    // ];
    // result.add({"word","suggestion"} as Map);
    // yield result;
    final List<Map<String, Object?>> result = await sql!.suggestion(word);
    // print(result.toString());
    return result;
    // result.first.values
    // final abc = result.elementAt(0);
    // final words = abc.values.first;
    // print(words);
    // final apple = this.suggestQuery.stream.toList();
    // print(word);
    //
    // this.suggestList.add(result);
    // this.suggestList.sink.add(result);
  }

  // ignore: todo
  // TODO: definition on multi words
  Future<List<Map<String, dynamic>>> definition(String word) async {

    if (word.isNotEmpty && collection.setting!.searchQuery != word){
      this._settingUpdate(collection.setting!.copyWith(searchQuery: word));
    }
    List<Map<String, Object?>> raw = [];
    List<Map<String, Object?>> root;
    List<Map<String, Object?>> rawSense;

    rawSense = await sql!.search(word);
    if (rawSense.isEmpty){
      root = await sql!.rootWord(word);
      if (root.isNotEmpty){
        final i = root.map((e) => e['word'].toString()).toSet().toList();
        for (String e in i){
          final r = await sql!.search(e);
          if (r.isNotEmpty){
            raw.addAll(r);
          }
        }
      }
    } else {
      root = await sql!.baseWord(word);
      raw.addAll(rawSense);
    }
    if (root.isNotEmpty){
      final tmp = this.groupByBase(root);
      raw.addAll(tmp);
    }

    final result = this.groupByWord(raw);

    final words = raw.map((e) => e['word'].toString()).toSet().toList();
    for (String str in words){
      final thes = await sql!.thesaurus(str);
      if (thes.isNotEmpty){
        final wordBlock = result.firstWhere((e) => e['word'] == str);
        wordBlock['thesaurus'] = thes.map((e) => e['word'].toString()).toSet().toList();
      }
    }

    return result;
  }

  List<Map<String, dynamic>> groupByWord(List<Map<String, Object?>> raw) {
    return raw.fold(Map<String, List<dynamic?>>(), (Map<String, List<dynamic?>> a, b) {
      a.putIfAbsent(b['word'].toString(), () => []).add(b);
      return a;
    }).values.map((e) =>{
      'word': e.first['word'],
      'sense': this.groupByPOS(e),
      'thesaurus': []
    }).toList();
  }

  List<Map<String, dynamic>> groupByPOS(List<dynamic> raw) {
    return raw.fold(Map<int, List<Map<String, dynamic>>>(), (Map<int, List<Map<String, dynamic>>> a, b) {
      a.putIfAbsent(b['wrte'], () => []).add(b);
      return a;
    }).values.map((e) => {
      'pos': collection.env!.grammar(e.first['wrte']).name,
      'clue': this.groupSense(e)
    }).toList();
  }

  List<Map<String, dynamic>> groupSense(List<Map<String, dynamic>> raw) {
    final List<Map<String, dynamic>> result = [];
    for (var row in raw) {
      String mean;
      List<String> exam = [];
      if (row.containsKey('sense')){
        if (row['exam'] !=null){
          exam = row['exam'].split("\r\n");
        }
        mean = row['sense'];
      } else {
        final pos = collection.env!.pos(row['dete']).name;
        // final pos = collection.env.grammar(row['wrte']).name;
        mean = '[~:${row['derived']}] ($pos)';
      }
      result.add({'mean':mean,'exam':exam});
    }
    return result;
  }

  List<Map<String, dynamic>> groupByBase(List<dynamic> raw) {
    return raw.fold(Map<int, List<Map<String, dynamic>>>(), (Map<int, List<Map<String, dynamic>>> a, b) {
      a.putIfAbsent(b['wrte'], () => []).add(b);
      return a;
    }).values.map((e) => {
      'word': e.first['word'],
      'wrte': e.first['wrte'],
      'sense': e.map<String>(
        (o) {
          final _derived = o['derived'];
          final _pos = collection.env!.pos(o['dete']).name;
          return '[~:$_derived] ($_pos)';
        }
      ).join('; '),
      'exam': null
    }).toList();
  }

}
