part of data.type;

// NOTE: only type, EnvironmentType child
class SynmapType {
  final int id;
  final int type;
  final String name;
  SynmapType({required this.id, required this.type, required this.name});

  factory SynmapType.fromJSON(Map<String, dynamic> o) {
    return SynmapType(id: o["id"] as int, type: o["type"] as int, name: o["name"] as String);
  }

  Map<String, dynamic> toJSON() {
    return {"id": id, "type": type, "name": name};
  }
}
