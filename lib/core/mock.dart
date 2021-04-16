part of 'core.dart';

mixin _Mock on _Collection {

  Future<void> _environment() async {
    env = await UtilDocument.loadBundleAsString('assets/env-mock.json').then(
      (e) => EnvironmentType.fromJSON(UtilDocument.decodeJSON(e))
    );
  }

  Future<void> _settingInit() async {
    await _environment();
    Box<SettingType> box = await Hive.openBox<SettingType>(this.env.settingName);
    SettingType active = box.get(this.env.settingKey,defaultValue: this.env.setting);

    if (box.isEmpty){
      debugPrint('Import ${env.settingName}');
      box.put(this.env.settingKey,this.env.setting);
    } else if (active.version != this.env.setting.version){
      debugPrint('Upgrade ${env.settingName} ${this.env.setting.toJSON()}');
      box.put(this.env.settingKey,active?.merge(this.env.setting));
    } else {
      debugPrint('Ok ${env.settingName}');
    }
    collection.setting = active;
    // box.clear();
  }

  void _settingUpdate(SettingType data){
    if (data != null) {
      Hive.box<SettingType>(this.env.settingName).put(this.env.settingKey,data);
    }
  }

  Future<void> _historyInit() async {
    collection.history = await Hive.openBox<String>('history');
    // await collection.history.clear();
  }

  Future<dynamic> loader(APIType id) async {
    // for (var item in id.src) {
    //   bool _validURL = Uri.parse(item).isAbsolute;
    //   print('$item $_validURL');
    //   if (_validURL) {
    //     return UtilClient.request(item).then(
    //       (body) => UtilDocument.decodeJSON(body)
    //     );
    //   } else {
    //     return await UtilDocument.loadBundleAsString(item).then(
    //       (e) => UtilDocument.decodeJSON(e)
    //     );
    //   }
    // }
    String item = id.src.first;
    if (Uri.parse(item).isAbsolute) {
      return await UtilClient.request(item).then(UtilDocument.decodeJSON);
    } else {
      return await UtilDocument.loadBundleAsString(item).then(UtilDocument.decodeJSON);
    }
  }

  Future<void> _wordInit() async {
    final APIType id = this.env.api.firstWhere((e) => e.uid =="word");
    Box<WordType> box = await Hive.openBox<WordType>(id.uid);
    if (box.isEmpty){
      debugPrint('Import ${id.uid}');
      final parsed = await loader(id);
      await box.addAll(parsed.map<WordType>((o) => WordType.fromJSON(o)).toList());
    } else {
      debugPrint('Ok ${id.uid}');
    }
    collection.word = box.values;
    // box.clear();
  }

  Future<void> _senseInit() async {
    final APIType id = this.env.api.firstWhere((e) => e.uid =="sense");
    Box<SenseType> box = await Hive.openBox<SenseType>(id.uid);
    if (box.isEmpty){
      debugPrint('Import ${id.uid}');
      final parsed = await loader(id);
      await box.addAll(parsed.map<SenseType>((o) => SenseType.fromJSON(o)).toList());
    } else {
      debugPrint('Ok ${id.uid}');
    }
    collection.sense = box.values;
  }

  Future<void> _usageInit() async {
    final APIType id = this.env.api.firstWhere((e) => e.uid =="usage");
    Box<UsageType> box = await Hive.openBox<UsageType>(id.uid);
    if (box.isEmpty){
      debugPrint('Import ${id.uid}');
      final parsed = await loader(id);
      await box.addAll(parsed.map<UsageType>((o) => UsageType.fromJSON(o)).toList());
    } else {
      debugPrint('Ok ${id.uid}');
    }
    collection.usage = box.values;
  }

  Future<void> _synsetInit() async {
    final APIType id = this.env.api.firstWhere((e) => e.uid =="synset");
    Box<SynsetType> box = await Hive.openBox<SynsetType>(id.uid);
    if (box.isEmpty){
      debugPrint('Import ${id.uid}');
      final parsed = await loader(id);
      await box.addAll(parsed.map<SynsetType>((o) => SynsetType.fromJSON(o)).toList());
    } else {
      debugPrint('Ok ${id.uid}');
    }
    collection.synset = box.values;
  }

  Future<void> _synmapInit() async {
    final APIType id = this.env.api.firstWhere((e) => e.uid =="synmap");
    Box<SynmapType> box = await Hive.openBox<SynmapType>(id.uid);
    if (box.isEmpty){
      debugPrint('Import ${id.uid}');
      final parsed = await loader(id);
      await box.addAll(parsed.map<SynmapType>((o) => SynmapType.fromJSON(o)).toList());
    } else {
      debugPrint('Ok ${id.uid}');
    }
    collection.synmap = box.values;
  }

  Future<void> _thesaurusInit() async {
    final APIType id = this.env.api.firstWhere((e) => e.uid =="thesaurus");
    Box<ThesaurusType> box = await Hive.openBox<ThesaurusType>(id.uid);
    if (box.isEmpty){
      debugPrint('Import ${id.uid}');
      final parsed = await loader(id);
      await box.addAll(parsed.map<ThesaurusType>((o) => ThesaurusType.fromJSON(o)).toList());
    } else {
      debugPrint('Ok ${id.uid}');
    }
    collection.thesaurus = box.values;
  }

  List<WordType> suggestion(String word) {
    return collection.suggest(word);
  }

  List<ResultModel> definition(String word) {
    if (word.isNotEmpty && collection.setting.searchQuery != word){
      this._settingUpdate(collection.setting.copyWith(searchQuery: word));
    }
    // if (this.collection.hasNotHistory(word)) this.collection.history.add(word);
    return collection.search(word);
  }
}
