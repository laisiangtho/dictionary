import "package:hive/hive.dart";

part 'adapter/setting.dart';
part 'adapter/word.dart';
part 'adapter/sense..dart';
part 'adapter/usage.dart';
part 'adapter/synmap.dart';
part 'adapter/synset.dart';
part 'adapter/thesaurus.dart';
part 'adapter/store.dart';
part "definition.dart";
part "grammar.dart";
part "collection.dart";

@HiveType(typeId: 0)
class SettingType {
  @HiveField(0)
  int version;

  // 0 = system 1 = light 2 = dark
  @HiveField(1)
  int mode;

  @HiveField(2)
  double fontSize;

  @HiveField(3)
  String searchQuery;

  SettingType({
    this.version:0,
    this.mode:0,
    this.fontSize:24.0,
    this.searchQuery:""
  });

  factory SettingType.fromJSON(Map<String, dynamic> o) {
    return SettingType(
      version: o["version"] as int,
      mode: o["mode"] as int,
      fontSize: o["fontSize"] as double,
      searchQuery: o["searchQuery"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "version":version,
      "mode":mode,
      "fontSize":fontSize,
      "searchQuery":searchQuery
    };
  }

  SettingType merge(SettingType o) {
    return SettingType(
      version: o.version??this.version,
      mode: o.mode??this.mode,
      fontSize: o.fontSize??this.fontSize,
      searchQuery: o.searchQuery??this.searchQuery
    );
  }

  SettingType copyWith({
    int version,
    int mode,
    double fontSize,
    String searchQuery,
  }) {
    return SettingType(
      version: version??this.version,
      mode: mode??this.mode,
      fontSize: fontSize??this.fontSize,
      searchQuery: searchQuery??this.searchQuery
    );
  }
}

@HiveType(typeId: 1)
class WordType {
  @HiveField(0)
  int w;

  @HiveField(1)
  String v;

  WordType({
    this.w,
    this.v
  });

  factory WordType.fromJSON(Map<String, dynamic> o) {
    return WordType(
      w: o["w"] as int,
      v: o["v"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "w":w,
      "v":v
    };
  }

  bool charStartsWith(String word) {
    return this.v.toLowerCase().startsWith(word.toLowerCase());
  }

  bool charMatchExact(String word) {
    return (this.v.toLowerCase() == word.toLowerCase());
  }

}

@HiveType(typeId: 2)
class SenseType {
  @HiveField(0)
  int i;

  @HiveField(1)
  int w;

  @HiveField(2)
  int t;

  @HiveField(3)
  String v;

  SenseType({
    this.i,
    this.w,
    this.t,
    this.v
  });

  factory SenseType.fromJSON(Map<String, dynamic> o) {
    return SenseType(
      i: o["i"] as int,
      w: o["w"] as int,
      t: o["t"] as int,
      v: o["v"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "i":i,
      "w":w,
      "t":t,
      "v":v
    };
  }
}

@HiveType(typeId: 3)
class UsageType {
  @HiveField(0)
  int i;

  @HiveField(1)
  String v;

  UsageType({
    this.i,
    this.v
  });

  factory UsageType.fromJSON(Map<String, dynamic> o) {
    return UsageType(
      i: o["i"] as int,
      v: o["v"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "i":i,
      "v":v
    };
  }
}

@HiveType(typeId: 4)
class SynsetType {
  @HiveField(0)
  int w;

  @HiveField(1)
  String v;

  SynsetType({
    this.w,
    this.v
  });

  factory SynsetType.fromJSON(Map<String, dynamic> o) {
    return SynsetType(
      w: o["w"] as int,
      v: o["v"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "w":w,
      "v":v
    };
  }
}

@HiveType(typeId: 5)
class SynmapType {
  @HiveField(0)
  int w;

  @HiveField(1)
  String v;

  @HiveField(2)
  int d;

  @HiveField(3)
  int t;

  SynmapType({
    this.w,
    this.v,
    this.d,
    this.t
  });

  factory SynmapType.fromJSON(Map<String, dynamic> o) {
    return SynmapType(
      w: o["w"] as int,
      v: o["v"] as String,
      d: o["d"] as int,
      t: o["t"] as int
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "w":w,
      "v":v,
      "d":d,
      "t":t
    };
  }
}

@HiveType(typeId: 6)
class ThesaurusType {
  @HiveField(0)
  String w;

  @HiveField(1)
  List<String> v;

  ThesaurusType({
    this.w,
    this.v
  });

  factory ThesaurusType.fromJSON(Map<String, dynamic> o) {
    return ThesaurusType(
      w: o["w"] as String,
      v: List.from(o["v"])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "w":w,
      "v":v.toList()
    };
  }
}

@HiveType(typeId: 7)
class StoreType {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  StoreType({
    this.name,
    this.type,
  });

  factory StoreType.fromJSON(Map<String, dynamic> o) {
    return StoreType(
      name: o["name"] as String,
      type: o["type"] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "name":name,
      "type":type
    };
  }
}

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
}

// NOTE: only type, EnvironmentType child
class APIType {
  String uid;
  List<String> src;

  APIType({
    this.uid,
    this.src
  });

  factory APIType.fromJSON(Map<String, dynamic> o) {
    return APIType(
      uid: o["uid"] as String,
      src: List.from(o["src"])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "uid":uid,
      "src":src.toList()
    };
  }
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