import 'package:hive/hive.dart';

part 'setting.adapter.dart';
part 'word.adapter.dart';
part 'sense.adapter.dart';
part 'usage.adapter.dart';
part 'synmap.adapter.dart';
part 'synset.adapter.dart';
part 'definition.dart';
part 'grammar.dart';
part 'collection.dart';

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
    this.searchQuery:''
  });

  factory SettingType.fromJSON(Map<String, dynamic> o) {
    return SettingType(
      version: o['version'] as int,
      mode: o['mode'] as int,
      fontSize: o['fontSize'] as double,
      searchQuery: o['searchQuery'] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'version':version,
      'mode':mode,
      'fontSize':fontSize,
      'searchQuery':searchQuery
    };
  }

  SettingType merge(SettingType o) {
    return SettingType(
      version: o.version??version,
      mode: o.mode??mode,
      fontSize: o.fontSize??fontSize,
      searchQuery: o.searchQuery??searchQuery
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
      w: o['w'] as int,
      v: o['v'] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'w':w,
      'v':v
    };
  }

  bool charStartsWith(String word) {
    return v.startsWith(word);
  }

  bool charMatchExact(String word) {
    return (v.toLowerCase() == word.toLowerCase());
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
      i: o['i'] as int,
      w: o['w'] as int,
      t: o['t'] as int,
      v: o['v'] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'i':i,
      'w':w,
      't':t,
      'v':v
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
      i: o['i'] as int,
      v: o['v'] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'i':i,
      'v':v
    };
  }
}

/*
word -> { w: wordId, v: string }
sense -> { i: uId, w: wordId, t: 0, v: string }
usage -> { i: uId, v: string }
*/

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
      w: o['w'] as int,
      v: o['v'] as String
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'w':w,
      'v':v
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
      w: o['w'] as int,
      v: o['v'] as String,
      d: o['d'] as int,
      t: o['t'] as int
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'w':w,
      'v':v,
      'd':d,
      't':t
    };
  }
}

class SynistType{
  List<SynsetType> root;
  List<SynmapType> form;

  SynistType({
    this.root,
    this.form
  });

  factory SynistType.fromJSON(Map<String, dynamic> o) {
    return SynistType(
      root: [],
      form: []
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'root':root.map((e)=>e.toJSON()).toList(),
      'form':form.map((e)=>e.toJSON()).toList()
    };
  }
}
