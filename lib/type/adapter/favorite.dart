part of '../main.dart';

class FavoriteAdapter extends TypeAdapter<FavoriteType> {
  @override
  final int typeId = 2;

  @override
  FavoriteType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // this.identify:'',
    // this.date,
    // this.bookId:1,
    // this.chapterId:1,
    return FavoriteType(word: '')
      ..word = fields[0] as String
      ..date = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, FavoriteType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
