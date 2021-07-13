
part of 'main.dart';

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
      version: o.version,
      mode: o.mode,
      fontSize: o.fontSize,
      searchQuery: o.searchQuery
    );
  }

  SettingType copyWith({
    int? version,
    int? mode,
    double? fontSize,
    String? searchQuery
  }) {
    return SettingType(
      version: version??this.version,
      mode: mode??this.mode,
      fontSize: fontSize??this.fontSize,
      searchQuery: searchQuery??this.searchQuery
    );
  }
}
