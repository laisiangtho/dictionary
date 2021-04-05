part of 'root.dart';

class SynmapAdapter extends TypeAdapter<SynmapType> {
  @override
  final int typeId = 5;

  @override
  SynmapType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SynmapType()
      ..w = fields[0] as int
      ..v = fields[1] as String
      ..d = fields[2] as int
      ..t = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, SynmapType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.w)

      ..writeByte(1)
      ..write(obj.v)

      ..writeByte(2)
      ..write(obj.d)

      ..writeByte(3)
      ..write(obj.t);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SynmapAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}