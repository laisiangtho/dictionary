part of "root.dart";

// NOTE: only type
class EnvironmentType {
  String name;
  String description;
  String package;
  String version;
  String buildNumber;

  String settingName;
  String settingKey;
  SettingType setting;

  List<SynsetType> synset;
  List<SynmapType> synmap;

  List<APIType> api;
  List<ProductsType> products;

  EnvironmentType({
    this.name,
    this.description,
    this.package,
    this.version,
    this.buildNumber,
    this.settingName,
    this.settingKey,
    this.setting,
    this.synset,
    this.synmap,
    this.api,
    this.products
  });

  factory EnvironmentType.fromJSON(Map<String, dynamic> o) {
    return EnvironmentType(
      name: o["name"]??"MyOrdbok",
      description: o["description"]??"A comprehensive Myanmar online dictionary",
      package: o["package"]??"",
      version: o["version"]??"1.0.0",
      buildNumber: o["buildNumber"]??"0",
      settingName: o["settingName"]??"0",
      settingKey: o["settingKey"]??"0",
      setting: SettingType.fromJSON(o["setting"]),
      synset: o["synset"].map<SynsetType>((o) => SynsetType.fromJSON(o)).toList(),
      synmap: o["synmap"].map<SynmapType>((o) => SynmapType.fromJSON(o)).toList(),
      api: o['api'].map<APIType>((e) => APIType.fromJSON(e)).toList(),
      products: o['products'].map<ProductsType>((e) => ProductsType.fromJSON(e)).toList()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "name":name,
      "description":description,
      "package":package,
      "version":version,
      "buildNumber":buildNumber,
      "settingName":settingName,
      "settingKey":settingKey,
      "setting":setting.toString(),
      "api":api.map((e)=>e.toJSON()).toList(),
      "products":products.map((e)=>e.toJSON()).toList()
    };
  }

  APIType get word => this.api.firstWhere((e) => e.uid == 'word');
  APIType get sense => this.api.firstWhere((e) => e.uid == 'sense');
  APIType get derive => this.api.firstWhere((e) => e.uid == 'derive');
  APIType get thesaurus => this.api.firstWhere((e) => e.uid == 'thesaurus');

  SynsetType grammar(int id) => this.synset.firstWhere((e) => e.id == id);
  SynmapType pos(int id) => this.synmap.firstWhere((e) => e.id == id);
}

// NOTE: only type, EnvironmentType child
class APIType {
  String uid;
  String tableName;
  Map<dynamic, String> query;
  List<String> src;

  APIType({
    this.uid,
    this.tableName,
    this.query,
    this.src
  });
  // map<K2, V2>((K, V) => MapEntry<K2, V2>) => Map<K2, V2>)

  factory APIType.fromJSON(Map<String, dynamic> o) {
    return APIType(
      uid: o["uid"] as String,
      tableName: o["tableName"] as String,
      query: (o['query']??{}).map<dynamic, String>(
        (k, v) => MapEntry(k, v.toString().replaceFirst('??', o["tableName"]))
      ),
      src: List.from((o['src']??[]).map((e)=>e.split('').reversed.join())),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "uid":uid,
      "tableName":tableName,
      "query":query,
      "src":src.toList()
    };
  }

  String get db => '$uid.db';
  Iterable<MapEntry<dynamic, String>> get listQuery => query.entries;
  // String get createTable => listQuery.firstWhere((e) => e.key == 'create').value;
  // String get dropTable => listQuery.firstWhere((e) => e.key == 'drop').value;
  // String get deleteTable => listQuery.firstWhere((e) => e.key == 'delete').value;

  String get importQuery => listQuery.firstWhere((e) => e.key == 'import').value;
  String get createIndex => listQuery.firstWhere((e) => e.key == 'createIndex').value;
}

// NOTE: only type, EnvironmentType child
class HistoryType {
  int id;
  String word;

  HistoryType({
    this.id,
    this.word
  });

  factory HistoryType.fromJSON(Map<String, dynamic> o) {
    return HistoryType(
      id: o["id"] as int,
      word: o["word"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id":id,
      "word":word
    };
  }
}

// NOTE: only type, EnvironmentType child
class ProductsType {
  String cart;
  String name;
  String type;

  ProductsType({
    this.cart,
    this.name,
    this.type,
  });

  factory ProductsType.fromJSON(Map<String, dynamic> o) {
    return ProductsType(
      cart: o["cart"] as String,
      name: o["name"] as String,
      type: o["type"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "cart":cart,
      "name":name,
      "type":type
    };
  }
}

// NOTE: only type, EnvironmentType child
class SynsetType {
  final int id;
  final String name;
  final String shortname;
  SynsetType({this.id, this.name, this.shortname});

  factory SynsetType.fromJSON(Map<String, dynamic> o) {
    return SynsetType(
      id: o["id"],
      name: o["name"],
      shortname: o["shortname"]
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "name": name,
      "shortname": shortname
    };
  }
}

// NOTE: only type, EnvironmentType child
class SynmapType {
  final int id;
  final int type;
  final String name;
  SynmapType({this.id, this.type, this.name});

  factory SynmapType.fromJSON(Map<String, dynamic> o) {
    return SynmapType(
      id: o["id"] as int,
      type: o["type"] as int,
      name: o["name"]
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "type": type,
      "name": name
    };
  }
}
