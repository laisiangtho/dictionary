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
    // debugPrint('abc');

    // final toLoads = collection.env.primary;
    // await loadArchiveMock(toLoads).catchError((e){
    //   debugPrint('asdf $e');
    // });

    // final result = await initArchive();
    // debugPrint('result $result');
    // await _definitionGenerator('love');
    debugPrint(collection.setting.fontSize.toString());
    // collection.setting.purchase.add(WorkingStoreType(productId: 'a',purchaseId: 'b',completePurchase: false,transactionDate: 'c'));
    // collection.setting.purchase.add({"productId":"a","purchaseId":"b","completePurchase":false,"transactionDate":"c"});
    // collection.settingUpdate(collection.setting);
    // debugPrint(collection.setting.purchase.toString());
    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} Milliseconds');

  }

  Future<dynamic> mockCheckDatabaseFiles() async {
    // final abc = new GistData(token:collection.env.token.key,id:collection.env.token.id);
    // return await abc.test();
    debugPrint('token: ${collection.env.token.key}, id: ${collection.env.token.id}');
    // debugPrint(collection.env.listOfDBfile.map((e) => e.toJSON()).toList());
  }

  Future<bool> initArchive() async{
    bool toChecks = false;
    for (var item in collection.env.listOfDatabase) {
      toChecks = await UtilDocument.exists(item.file).then(
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
      return await loadArchiveMock(collection.env.primary).then((e) => true).catchError((_)=>false);
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

  Future<void> suggestionGenerate(String word) async {
    this.suggestionQuery = word;
    this.suggestionList = await _sql.suggestion(word);
    notifyListeners();
  }

  // ignore: todo
  // TODO: definition on multi words
  // see
  Future<void> definitionGenerate(String word) async {
    Stopwatch definitionWatch = new Stopwatch()..start();
    if (this.definitionQuery != word){
      this.definitionList = await _definitionGenerator(word);
      // notifyListeners();
      this.definitionQuery = word;
    }
    collection.searchQueryUpdate(word);
    debugPrint('definitionTest in ${definitionWatch.elapsedMilliseconds} Milliseconds');
    analyticsSearch(word);
  }

  Future<List<Map<String, dynamic>>> _definitionGenerator(String word) async {

    List<Map<String, Object?>> raw = [];
    List<Map<String, Object?>> root;
    List<Map<String, Object?>> rawSense;

    rawSense = await _sql.search(word);
    if (rawSense.isEmpty){
      root = await _sql.rootWord(word);
      if (root.isNotEmpty){
        final i = root.map((e) => e['word'].toString()).toSet().toList();
        for (String e in i){
          final r = await _sql.search(e);
          if (r.isNotEmpty){
            raw.addAll(r);
          }
        }
      }
    } else {
      root = await _sql.baseWord(word);
      raw.addAll(rawSense);
    }
    if (root.isNotEmpty){
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

  Future<List<Map<String, Object?>>> thesaurusGenerate(String word) async{
    await Future.delayed(Duration(milliseconds: 700));
    final thes = await _sql.thesaurus(word);
    return thes;
  }

  List<Map<String, dynamic>> _groupByWord(List<Map<String, Object?>> raw) {
    return raw.fold(Map<String, List<dynamic>>(), (Map<String, List<dynamic>> a, b) {
      a.putIfAbsent(b['word'].toString(), () => []).add(b);
      return a;
    }).values.map((e) =>{
      'word': e.first['word'],
      'sense': _groupByPOS(e),
      // 'thesaurus': []
      // 'thesaurus': e.first['word']
    }).toList();
  }

  List<Map<String, dynamic>> _groupByPOS(List<dynamic> raw) {
    return raw.fold(Map<int, List<Map<String, dynamic>>>(), (Map<int, List<Map<String, dynamic>>> a, b) {
      a.putIfAbsent(b['wrte'], () => []).add(b);
      return a;
    }).values.map((e) => {
      'pos': collection.env.grammar(e.first['wrte']).name,
      'clue': _groupSense(e)
    }).toList();
  }

  List<Map<String, dynamic>> _groupSense(List<Map<String, dynamic>> raw) {
    final List<Map<String, dynamic>> result = [];
    for (var row in raw) {
      String? mean;
      List<String> exam = [];
      // row.containsKey('sense')
      if (row['sense'] != null && row.containsKey('sense')){
        if (row['exam'] !=null){
          exam = row['exam'].split("\r\n");
        }
        // _TypeError (type 'Null' is not a subtype of type 'String')
        mean = row['sense'];
      } else if (row['dete'] != null && row['derived'] != null) {
        final pos = collection.env.pos(row['dete']).name;
        // final pos = collection.env.grammar(row['wrte']).name;
        mean = '[~:${row['derived']}] ($pos)';
      }
      if (mean != null) {
        result.add({'mean':mean,'exam':exam});
      }
    }
    return result;
  }

  List<Map<String, dynamic>> _groupByBase(List<dynamic> raw) {
    return raw.fold(Map<int, List<Map<String, dynamic>>>(), (Map<int, List<Map<String, dynamic>>> a, b) {
      a.putIfAbsent(b['wrte'], () => []).add(b);
      return a;
    }).values.map((e) => {
      'word': e.first['word'],
      'wrte': e.first['wrte'],
      'sense': e.map<String>(
        (o) {
          final _derived = o['derived'];
          final _pos = collection.env.pos(o['dete']).name;
          return '[~:$_derived] ($_pos)';
        }
      ).join('; '),
      'exam': null
    }).toList();
  }

}
