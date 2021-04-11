part of 'root.dart';

class ThesaurusAdapter extends TypeAdapter<ThesaurusType> {
  @override
  final int typeId = 6;

  @override
  ThesaurusType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThesaurusType()
      ..w = fields[0] as String
      ..v = fields[1] as List<String>;
  }

  @override
  void write(BinaryWriter writer, ThesaurusType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.w)
      ..writeByte(1)
      ..write(obj.v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThesaurusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}