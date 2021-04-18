part of '../root.dart';

class StoreAdapter extends TypeAdapter<StoreType> {
  @override
  final int typeId = 7;

  @override
  StoreType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreType()
      ..name = fields[0] as String
      ..type = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, StoreType obj) {
    writer
      ..writeByte(2)

      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

}