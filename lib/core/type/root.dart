// import 'dart:async';
import 'package:flutter/foundation.dart';
import "package:hive/hive.dart";
import "package:lidea/extension.dart";

part 'adapter/setting.dart';
// part 'adapter/word.dart';
// part 'adapter/sense..dart';
// part 'adapter/usage.dart';
// part 'adapter/synmap.dart';
// part 'adapter/synset.dart';
// part 'adapter/thesaurus.dart';
part 'adapter/store.dart';
part "env.dart";
part "definition.dart";
part "collection.dart";
part "notify.dart";

@HiveType(typeId: 0)
class SettingType {
  @HiveField(0)
  int? version;

  // 0 = system 1 = light 2 = dark
  @HiveField(1)
  int? mode;

  @HiveField(2)
  double? fontSize;

  @HiveField(3)
  String? searchQuery;

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
    int? version,
    int? mode,
    double? fontSize,
    String? searchQuery,
  }) {
    return SettingType(
      version: version??this.version,
      mode: mode??this.mode,
      fontSize: fontSize??this.fontSize,
      searchQuery: searchQuery??this.searchQuery
    );
  }
}


@HiveType(typeId: 7)
class StoreType {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? type;

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
