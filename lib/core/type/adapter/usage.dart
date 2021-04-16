part of '../root.dart';

class UsageAdapter extends TypeAdapter<UsageType> {
  @override
  final int typeId = 3;

  @override
  UsageType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsageType()
      ..i = fields[0] as int
      ..v = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, UsageType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.i)
      ..writeByte(1)
      ..write(obj.v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}