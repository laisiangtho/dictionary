part of 'core.dart';

mixin _Mock on _Collection {
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

  Future<void> _settingPrimary() async {
    final String _settingName = 'settingPrimary';
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
    // collection.setting = active;
    // debugPrint('active ${active.version} ${box.length} ${box.isOpen}');
    // box.clear();
  }

  Future<void> _wordPrimary() async {
    final String _wordName = 'wordPrimary';
    // Hive.registerAdapter(WordAdapter());
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
    collection.word = box.values;

    // WordType selected = box.get(2);
    // WordType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _sensePrimary() async {
    final String _senseName = 'sensePrimary';
    // Hive.registerAdapter(SenseAdapter());
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
    collection.sense = box.values;

    // SenseType selected = box.get(2);
    // SenseType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _usagePrimary() async {
    final String _usageName = 'usagePrimary';
    // Hive.registerAdapter(UsageAdapter());
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
    collection.usage = box.values;

    // UsageType selected = box.get(2);
    // UsageType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _synsetPrimary() async {
    final String _synsetName = 'synsetPrimary';
    // Hive.registerAdapter(SynsetAdapter());
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
    collection.synset = box.values;

    // SynsetType selected = box.get(2);
    // SynsetType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _synmapPrimary() async {
    final String _synmapName = 'synmapPrimary';
    // Hive.registerAdapter(SynmapAdapter());
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
    collection.synmap = box.values;

    // SynmapType selected = box.get(2);
    // SynmapType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<Iterable<WordType>> suggestion(String keyword) async {
    return collection.wordStartWith(keyword);
  }

  List<ResultModel> definitionResult = [];
  String definitionKeyword='';
  final Grammar definitionGrammar = Grammar.fromJSON();

  Future<List<ResultModel>> definition({String keyword}) async {

    if (definitionKeyword == keyword){
      debugPrint('definition cache');
      return definitionResult;
    } else {
      definitionKeyword = keyword;
      definitionResult = [];
      debugPrint('definition');
    }
    if (keyword == null || keyword.isEmpty) {
      return definitionResult;
    }
    SynistType pos = partOfSpeech(keyword: keyword);

    Iterable<WordType> words;
    words = collection.wordExactMatch(keyword);

    // await Hive.openBox<SenseType>(_senseName);
    // await Hive.openBox<UsageType>(_usageName);

    if (words.length == 0 && pos.root.length > 0 && collection.stringCompare(pos.root.first.v, keyword) == false){
      words = collection.wordExactMatch(pos.root.first.v);
    }

    for (var w1 in words) {
      ResultModel newWord = ResultModel(word: w1.v, sense:[]);
      definitionResult.add(newWord);

      var d1 = collection.sense.where((e) => e.w == w1.w);
      var g1 = d1.map((e) => e.t).toSet();
      for (var gId in g1) {
        // Gaset  grammarPos = definitionGrammar.pos.firstWhere((i) => i.id == gId);
        // SenseModel newSense = SenseModel(pos: grammarPos.name, clue:[]);
        SenseModel newSense = SenseModel(pos: definitionGrammar.posName(gId), clue:[]);
        newWord.sense.add(newSense);

        var d2 = d1.where((e) => e.t == gId);
        for (var d3 in d2) {
          ClueModel newClue = ClueModel(mean: d3.v, exam:[]);
          var u1 = collection.usage.where((e) => e.i == d3.i);
          newSense.clue.add(newClue);
          for (var u2 in u1) {
            newClue.exam.addAll(u2.v.split('\r\n'));
          }
        }
        // var abcd = pos.form.where((e) => e.t == gId).map(
        //   (e) {
        //     // Gamap grammarForm = definitionGrammar.form.firstWhere((i) => i.id == e.d && i.type == gId);
        //     Gamap grammarForm = definitionGrammar.form.firstWhere((i) => i.id == e.d && i.type == e.t);
        //     return '${e.v} (${grammarForm.name})';
        //   }
        // ).join('; ');
        var abcd = pos.form.where((e) => e.t == gId).map(
          (e) => definitionGrammar.formName(e)
        ).join('; ');
        newSense.clue.add(ClueModel(mean: abcd, exam:[]));
      }
      // debugPrint(newWord.sense.length);
    }
    // debugPrint(definitionResult.map((e)=>e.toJSON()).toList());

    return definitionResult;
  }


  SynistType partOfSpeech({String keyword}) {

    var grammar = collection.synset;
    var form = collection.synmap;

    SynistType result = SynistType(root:[],form: []);
    List<SynsetType> type = form.where(
      (s) => collection.stringCompare(s.v, keyword) && s.t < 10 && grammar.where((e) => e.w == s.w).length > 0
    ).map(
      (o) => grammar.firstWhere((s) => s.w == o.w)
    ).toSet().toList();

    if (type.length > 0) {
      // NOTE: loves, loved, loving
      // debugPrint('backward');
      result.root = type;
      var formAssociate = form.where(
        (m) => m.d > 0 && type.where((e)=>e.w == m.w).length > 0
      ).toList();
      if (formAssociate.length > 0) result.form = formAssociate;
    }

    List<SynsetType> pos = grammar.where(
      (s) => collection.stringCompare(s.v,keyword)
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
