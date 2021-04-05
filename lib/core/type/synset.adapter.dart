part of 'root.dart';

class SynsetAdapter extends TypeAdapter<SynsetType> {
  @override
  final int typeId = 4;

  @override
  SynsetType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SynsetType()
      ..w = fields[0] as int
      ..v = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, SynsetType obj) {
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
      other is SynsetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}