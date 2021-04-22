part of 'core.dart';

Future<String> requestAPI(APIType id) async {
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
    return await UtilClient.request(item);//.then(UtilDocument.decodeJSON);
  } else {
    return await UtilDocument.loadBundleAsString(item);//.then(UtilDocument.decodeJSON);
  }
}

Future<Iterable<WordType>> wordCompute(APIType id) async {
  Box<WordType> box = await Hive.openBox<WordType>(id.uid);
  if (box.isEmpty){
    final response = await requestAPI(id);
    final parsed = await compute(wordParse, response);
    await box.addAll(parsed);
  }
  return box.values;
}
List<WordType> wordParse(String response) {
  final parsed = UtilDocument.decodeJSON(response).cast<Map<String, dynamic>>();
  return parsed.map<WordType>((o) => WordType.fromJSON(o)).toList();
}

Future<Iterable<SenseType>> senseCompute(APIType id) async {
  Box<SenseType> box = await Hive.openBox<SenseType>(id.uid);
  if (box.isEmpty){
    final response = await requestAPI(id);
    final parsed = await compute(senseParse, response);
    await box.addAll(parsed);
  }
  return box.values;
}
List<SenseType> senseParse(String response) {
  final parsed = UtilDocument.decodeJSON(response).cast<Map<String, dynamic>>();
  return parsed.map<SenseType>((o) => SenseType.fromJSON(o)).toList();
}

Future<Iterable<UsageType>> usageCompute(APIType id) async {
  Box<UsageType> box = await Hive.openBox<UsageType>(id.uid);
  if (box.isEmpty){
    final response = await requestAPI(id);
    final parsed = await compute(usageParse, response);
    await box.addAll(parsed);
  }
  return box.values;
}
List<UsageType> usageParse(String response) {
  final parsed = UtilDocument.decodeJSON(response).cast<Map<String, dynamic>>();
  return parsed.map<UsageType>((o) => UsageType.fromJSON(o)).toList();
}

Future<Iterable<SynsetType>> synsetCompute(APIType id) async {
  Box<SynsetType> box = await Hive.openBox<SynsetType>(id.uid);
  if (box.isEmpty){
    final response = await requestAPI(id);
    final parsed = await compute(synsetParse, response);
    await box.addAll(parsed);
  }
  return box.values;
}
List<SynsetType> synsetParse(String response) {
  final parsed = UtilDocument.decodeJSON(response).cast<Map<String, dynamic>>();
  return parsed.map<SynsetType>((o) => SynsetType.fromJSON(o)).toList();
}

Future<Iterable<SynmapType>> synmapCompute(APIType id) async {
  Box<SynmapType> box = await Hive.openBox<SynmapType>(id.uid);
  if (box.isEmpty){
    final response = await requestAPI(id);
    final parsed = await compute(synmapParse, response);
    await box.addAll(parsed);
  }
  return box.values;
}
List<SynmapType> synmapParse(String response) {
  final parsed = UtilDocument.decodeJSON(response).cast<Map<String, dynamic>>();
  return parsed.map<SynmapType>((o) => SynmapType.fromJSON(o)).toList();
}

Future<Iterable<ThesaurusType>> thesaurusCompute(APIType id) async {
  Box<ThesaurusType> box = await Hive.openBox<ThesaurusType>(id.uid);
  if (box.isEmpty){
    final response = await requestAPI(id);
    final parsed = await compute(thesaurusParse, response);
    await box.addAll(parsed);
  }
  return box.values;
}
List<ThesaurusType> thesaurusParse(String response) {
  final parsed = UtilDocument.decodeJSON(response).cast<Map<String, dynamic>>();
  return parsed.map<ThesaurusType>((o) => ThesaurusType.fromJSON(o)).toList();
}


mixin _Mock on _Collection {

  Future<void> _environmentInit() async {
    env = await UtilDocument.loadBundleAsString('assets/env-mock.json').then(
      (e) => EnvironmentType.fromJSON(UtilDocument.decodeJSON(e))
    );
  }

  Future<void> settingInit() async {
    await _environmentInit();

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

  Future<void> historyInit() async {
    collection.history = await Hive.openBox<String>('history');
    // await collection.history.clear();
  }

  Future<void> wordInit() async {
    final APIType id = this.apiName("word");
    collection.word = await wordCompute(id);
  }

  Future<void> senseInit() async {
    final APIType id = this.apiName("sense");
    collection.sense = await senseCompute(id);
  }

  Future<void> usageInit() async {
    final APIType id = this.apiName("usage");
    collection.usage = await usageCompute(id);
  }

  Future<void> synsetInit() async {
    final APIType id = this.apiName("synset");
    collection.synset = await synsetCompute(id);
  }

  Future<void> synmapInit() async {
    final APIType id = this.apiName("synmap");
    collection.synmap = await synmapCompute(id);
  }

  Future<void> thesaurusInit() async {
    final APIType id = this.apiName("thesaurus");
    collection.thesaurus = await thesaurusCompute(id);
  }

  APIType apiName(String name) => this.env.api.firstWhere((e) => e.uid == name);

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
