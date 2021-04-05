part of 'root.dart';

class SenseAdapter extends TypeAdapter<SenseType> {
  @override
  final int typeId = 2;

  @override
  SenseType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SenseType()
      ..i = fields[0] as int
      ..w = fields[1] as int
      ..t = fields[2] as int
      ..v = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, SenseType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.i)

      ..writeByte(1)
      ..write(obj.w)

      ..writeByte(2)
      ..write(obj.t)

      ..writeByte(3)
      ..write(obj.v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}