part of data.type;

// NOTE: only type, EnvironmentType child
class SynsetType {
  final int id;
  final String name;
  final String shortname;
  SynsetType({required this.id, required this.name, required this.shortname});

  factory SynsetType.fromJSON(Map<String, dynamic> o) {
    return SynsetType(
        id: o["id"] as int, name: o["name"] as String, shortname: (o["shortname"] ?? '') as String);
  }

  Map<String, dynamic> toJSON() {
    return {"id": id, "name": name, "shortname": shortname};
  }
}
