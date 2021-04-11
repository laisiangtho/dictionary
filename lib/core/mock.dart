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

  Future<void> _settingInit() async {
  // final String _settingName = 'settingPrimary';
  // final String _settingKey = 'setting';
    Box<SettingType> box = await Hive.openBox<SettingType>(this._settingName);

    SettingType settingDefault = SettingType(version:1);
    SettingType active = box.get(this._settingKey,defaultValue: settingDefault);

    if (box.isEmpty){
      debugPrint('Import $_settingName');
      box.put(this._settingKey,settingDefault);
    } else if (active.version != settingDefault.version){
      debugPrint('Upgrade $_settingName ${settingDefault.toJSON()}');
      box.put(this._settingKey,active?.merge(settingDefault));
    } else {
      debugPrint('Ok $_settingName');
    }
    collection.setting = active;
    // print(collection.setting);
    // debugPrint('active ${active.searchQuery} ${collection.settingBox.length} ${collection.settingBox.isOpen}');
    // box.clear();
  }

  void _settingUpdate(SettingType data){
    if (data != null) {
      Hive.box<SettingType>(this._settingName).put(this._settingKey,data);
    }
  }

  Future<void> _wordInit() async {
    final String _boxName = 'word';
    // Hive.registerAdapter(WordAdapter());
    Box<WordType> box = await Hive.openBox<WordType>(_boxName);
    if (box.isEmpty){
      debugPrint('Import $_boxName');
      Iterable<WordType> parsed = await UtilDocument.loadBundleAsString('assets/en-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<WordType>((o) => WordType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_boxName');
    }
    collection.word = box.values;

    // WordType selected = box.get(2);
    // WordType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _senseInit() async {
    final String _boxName = 'sense';
    // Hive.registerAdapter(SenseAdapter());
    Box<SenseType> box = await Hive.openBox<SenseType>(_boxName);
    if (box.isEmpty){
      debugPrint('Import $_boxName');
      Iterable<SenseType> parsed = await UtilDocument.loadBundleAsString('assets/sense-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<SenseType>((o) => SenseType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_boxName');
    }
    collection.sense = box.values;

    // SenseType selected = box.get(2);
    // SenseType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _usageInit() async {
    final String _boxName = 'usage';
    // Hive.registerAdapter(UsageAdapter());
    Box<UsageType> box = await Hive.openBox<UsageType>(_boxName);
    if (box.isEmpty){
      debugPrint('Import $_boxName');
      Iterable<UsageType> parsed = await UtilDocument.loadBundleAsString('assets/usage-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<UsageType>((o) => UsageType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_boxName');
    }
    collection.usage = box.values;

    // UsageType selected = box.get(2);
    // UsageType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _synsetInit() async {
    final String _boxName = 'synset';
    // Hive.registerAdapter(SynsetAdapter());
    Box<SynsetType> box = await Hive.openBox<SynsetType>(_boxName);
    if (box.isEmpty){
      debugPrint('Import $_boxName');
      Iterable<SynsetType> parsed = await UtilDocument.loadBundleAsString('assets/synset-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<SynsetType>((o) => SynsetType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_boxName');
    }
    collection.synset = box.values;

    // SynsetType selected = box.get(2);
    // SynsetType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _synmapInit() async {
    final String _boxName = 'synmap';
    // Hive.registerAdapter(SynmapAdapter());
    Box<SynmapType> box = await Hive.openBox<SynmapType>(_boxName);
    if (box.isEmpty){
      debugPrint('Import $_boxName');
      Iterable<SynmapType> parsed = await UtilDocument.loadBundleAsString('assets/synmap-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<SynmapType>((o) => SynmapType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_boxName');
    }
    collection.synmap = box.values;

    // SynmapType selected = box.get(2);
    // SynmapType selected = box.values.firstWhere((e)=>e.v != null && e.v.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  Future<void> _thesaurusInit() async {
    final String _boxName = 'thesaurus';
    // Hive.registerAdapter(ThesaurusAdapter());
    Box<ThesaurusType> box = await Hive.openBox<ThesaurusType>(_boxName);
    if (box.isEmpty){
      debugPrint('Import $_boxName');
      Iterable<ThesaurusType> parsed = await UtilDocument.loadBundleAsString('assets/thesaurus-mock.v1.json').then(
        (e) => UtilDocument.decodeJSON(e).map<ThesaurusType>((o) => ThesaurusType.fromJSON(o)).toList()
      );
      await box.addAll(parsed);
    } else {
      debugPrint('Ok $_boxName');
    }
    // collection.thesaurus = box.values;

    // ThesaurusType selected = box.values.firstWhere((e)=>e.w != null && e.w.toLowerCase() == 'hate');
    // debugPrint('selected: ${selected.v} ${selected.toJSON()}');
    // debugPrint('total: ${box.length} ${box.keys}');
    // await box.clear();
  }

  List<WordType> suggestion(String word) {
    return collection.suggest(word);
  }

  List<ResultModel> definition(String word) {
    if (word.isNotEmpty && collection.setting.searchQuery != word){
      this._settingUpdate(collection.setting.copyWith(searchQuery: word));
    }
    return collection.search(word);
  }

}
