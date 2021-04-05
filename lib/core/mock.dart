part of 'core.dart';

mixin _Mock {
  // Future<String> getCollection = Future<String>.delayed(
  //   Duration(seconds: 2),
  //   () => 'Data Loaded',
  // );

  // Future.delayed(const Duration(milliseconds: 500), () {
  //   setState(() {
  //     store.isReady = true;
  //   });
  // });
  // Future<List<String>> getCollection() async {
  //   // return ['abc','xyx'];
  //   return List<String>.generate(50,
  //       (int index) => 'This is sliver child'
  //   );
  // }
  Future<List<String>> getCollectionMock() async {
    // return ['abc','xyx'];
    return List<String>.generate(50,
        (int index) => 'This is sliver child'
    );
  }

  // Future<bool> initCollectionMock() async {
  //   return Future<bool>.delayed(
  //     Duration(milliseconds: 500),
  //     () => true,
  //   );
  // }

  final String _settingName = 'settingPrimary';
  Future<void> _settingPrimary() async {
    final String boxKey = 'setting';

    Hive.registerAdapter(SettingAdapter());
    Box<SettingType> box = await Hive.openBox<SettingType>(_settingName);

    SettingType settingDefault = SettingType(version:1);
    SettingType active = box.get(boxKey,defaultValue: settingDefault);

    if (box.isEmpty){
      debugPrint('Import $_settingName');
      box.put(boxKey,settingDefault);
    } else if (active.version != settingDefault.version){
      debugPrint('Upgrade $_settingName');
      box.put(boxKey,active.merge(settingDefault));
    } else {
      debugPrint('Ok $_settingName');
    }
    // debugPrint('active ${active.version} ${box.length} ${box.isOpen}');
    // box.clear();
  }

  final String _wordName = 'wordPrimary';
  Future<void> _wordPrimary() async {
    Hive.registerAdapter(WordAdapter());
    Box<WordType> box = await Hive.openBox<WordType>(_wordName);
    if (box.isEmpty){
      debugPrint('Import $_wordName');
      Iterable<WordType> parsed = await UtilDocument.loadBundleAsString('assets/en-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<WordType>((o) => WordType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_wordName');
    }

    // WordType selected = box.get(2);
    // WordType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Iterable<WordType> get wordList => Hive.box<WordType>(_wordName).values;
  // Iterable<WordType> suggestion(String word) => wordList.where((e) => e.v.toLowerCase() == word.toLowerCase());
  // Iterable<WordType> suggestion(String word) => wordList.where((e) => new RegExp(word,caseSensitive: false).hasMatch(e.v));
  // Iterable<WordType> wordStartWith(String word) => wordList.where((e) => e.v.startsWith(word));
  Iterable<WordType> wordStartWith(String word) => wordList.where((e) => e.v.startsWith(word));
  Iterable<WordType> wordExactMatch(String word) => wordList.where((e) => e.v.toLowerCase() == word.toLowerCase());

  Future<Iterable<WordType>> suggestion(String word) async {
    await Hive.openBox<WordType>(_wordName);
    return this.wordStartWith(word);
  }


  final String _senseName = 'sensePrimary';
  Future<void> _sensePrimary() async {
    Hive.registerAdapter(SenseAdapter());
    Box<SenseType> box = await Hive.openBox<SenseType>(_senseName);
    if (box.isEmpty){
      debugPrint('Import $_senseName');
      Iterable<SenseType> parsed = await UtilDocument.loadBundleAsString('assets/sense-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<SenseType>((o) => SenseType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_senseName');
    }

    // SenseType selected = box.get(2);
    // SenseType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  final String _usageName = 'usagePrimary';
  Future<void> _usagePrimary() async {
    Hive.registerAdapter(UsageAdapter());
    Box<UsageType> box = await Hive.openBox<UsageType>(_usageName);
    if (box.isEmpty){
      debugPrint('Import $_usageName');
      Iterable<UsageType> parsed = await UtilDocument.loadBundleAsString('assets/usage-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<UsageType>((o) => UsageType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_usageName');
    }

    // UsageType selected = box.get(2);
    // UsageType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  final String _synsetName = 'synsetPrimary';
  Future<void> _synsetPrimary() async {
    Hive.registerAdapter(SynsetAdapter());
    Box<SynsetType> box = await Hive.openBox<SynsetType>(_synsetName);
    if (box.isEmpty){
      debugPrint('Import $_synsetName');
      Iterable<SynsetType> parsed = await UtilDocument.loadBundleAsString('assets/synset-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<SynsetType>((o) => SynsetType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_synsetName');
    }

    // SynsetType selected = box.get(2);
    // SynsetType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  final String _synmapName = 'synmapPrimary';
  Future<void> _synmapPrimary() async {
    Hive.registerAdapter(SynmapAdapter());
    Box<SynmapType> box = await Hive.openBox<SynmapType>(_synmapName);
    if (box.isEmpty){
      debugPrint('Import $_synmapName');
      Iterable<SynmapType> parsed = await UtilDocument.loadBundleAsString('assets/synmap-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<SynmapType>((o) => SynmapType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_synmapName');
    }

    // SynmapType selected = box.get(2);
    // SynmapType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<List<ResultModel>> definition({String keyword}) async {
    List<ResultModel> resultNew=[];

    if (keyword == null || keyword.isEmpty) return resultNew;

    SynistType pos = await partOfSpeech(keyword: keyword);

    final Grammar grammar = Grammar.fromJSON();

    Iterable<WordType> words;
    words = wordExactMatch(keyword);

    // Box<SenseType> def = await Hive.openBox<SenseType>(_senseName);
    // Box<UsageType> usg = await Hive.openBox<UsageType>(_usageName);
    // SenseType def = Hive.box<SenseType>(_senseName);
    // UsageType usg = Hive.open<UsageType>(_usageName);

    var def = Hive.box<SenseType>(_senseName);
    var usg = Hive.box<UsageType>(_usageName);

    if (words.length == 0 && pos.root.length > 0 && chatCompare(pos.root.first.v, keyword) == false){
      words = wordExactMatch(pos.root.first.v);
    }


    for (var w1 in words) {
      ResultModel newWord = ResultModel(word: w1.v, sense:[]);
      resultNew.add(newWord);

      var d1 = def.values.where((e) => e.w == w1.w);
      var g1 = d1.map((e) => e.t).toSet();
      for (var gId in g1) {
        Gaset  grammarPos = grammar.pos.firstWhere((i) => i.id == gId);
        SenseModel newSense = SenseModel(pos: grammarPos.name, clue:[]);
        newWord.sense.add(newSense);

        var d2 = d1.where((e) => e.t == gId);
        for (var d3 in d2) {
          var u1 = usg.values.where((e) => e.i == d3.i);
          ClueModel newClue = ClueModel(mean: d3.v, exam:[]);
          newSense.clue.add(newClue);
          for (var u2 in u1) {
            newClue.exam.addAll(u2.v.split('\r\n'));
          }
        }
        var abcd = pos.form.where((e) => e.t == gId).map(
          (e) {
            Gamap grammarForm = grammar.form.firstWhere((i) => i.id == e.d && i.type == gId);
            return '${e.v} (${grammarForm.name})';
          }
        ).join('; ');
        newSense.clue.add(ClueModel(mean: abcd, exam:[]));
      }
      // debugPrint(newWord.sense.length);
    }
    // debugPrint(resultNew.map((e)=>e.toJSON()).toList());
    return resultNew;
  }

  bool chatCompare(String a, String b) => a.toLowerCase() == b.toLowerCase();

  Future<SynistType> partOfSpeech({String keyword: 'superiors'}) async {
    // Box<SynsetType> grammarBox = await Hive.openBox<SynsetType>(_synsetName);
    // Box<SynmapType> formBox = await Hive.openBox<SynmapType>(_synmapName);
    // Iterable<SynsetType> grammar = grammarBox.values;
    // Iterable<SynmapType> form = formBox.values;
    var grammar = Hive.box<SynsetType>(_synsetName).values;
    var form = Hive.box<SynmapType>(_synmapName).values;


    SynistType result = SynistType(root:[],form: []);
    List<SynsetType> type = form.where(
      (s) => chatCompare(s.v, keyword) && s.t < 10 && grammar.where((e) => e.w == s.w).length > 0
    ).map(
      (o) => grammar.firstWhere((s) => s.w == o.w)
    ).toSet().toList();

    result.root = type;

    // print('root');
    // print(type.map((e)=>e.toJSON()).toList());

    if (type.length > 0) {
      // NOTE: loves, loved, loving
      // debugPrint('backward');
      var formAssociate = form.where(
        (m) => m.d > 0 && type.where((e)=>e.w == m.w).length > 0
      ).toList();
      if (formAssociate.length > 0) result.form = formAssociate;


      // print(type.map((e)=>e.toJSON()).toList());
      // print(formAssociate.map((e)=>e.toJSON()).toList());
    }

    List<SynsetType> pos = grammar.where(
      (s) => chatCompare(s.v,keyword)
    ).toList();

    if (pos.length > 0) {
      // NOTE: love, hate
      // debugPrint('forward');
      var posAssociate = form.where(
        (m) => m.d > 0 && pos.where((e)=>e.w == m.w).length > 0
      ).toList();
       if (result.form.length == 0){
        result.form = posAssociate;
       }
      if (result.root.length == 0){
        result.root = pos;
      }

      // print(pos.map((e)=>e.toJSON()).toList());
      // print(posAssociate.map((e)=>e.toJSON()).toList());
    }

    // List<SynsetType> ae = (result['root'] as List).map((e) => SynsetType.fromJSON(e)).toList();
    // List<SynmapType> ab = (result['form'] as List).map((e) => SynmapType.fromJSON(e)).toList();
    // debugPrint('$ae $ab');
    // var temp = (result['root'] as List<SynsetType>).map((e) => e.toJSON(e)).toList();
    // debugPrint(result['root'].map((e)=>e.toJSON()).toList());
    // debugPrint(result['form'].map((e)=>e.toJSON()).toList());
    // debugPrint('${result.toJSON()}');
    return result;
  }

  // Future<Map<String, dynamic>> parseJSON(String res) async => await compute(parseJSONCompute,res);
}


Map<String, dynamic> parseJSONCompute(String response) => UtilDocument.decodeJSON(response);
// Map<String, dynamic> parseJSONCompute(String response) => UtilDocument.decodeJSON(response);
// Future<Collection> _parseCollection(dynamic res) async => collection = await compute(parseCollectionCompute,res);
