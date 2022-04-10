part of data.type;

class BoxOfFavoriteWord<E> extends BoxOfAbstract<FavoriteWordType> {}

@HiveType(typeId: 2)
class FavoriteWordType {
  @HiveField(0)
  String word;

  @HiveField(1)
  DateTime? date;

  FavoriteWordType({
    required this.word,
    this.date,
  });

  factory FavoriteWordType.fromJSON(Map<String, dynamic> o) {
    return FavoriteWordType(
      word: o["word"] as String,
      date: o["date"] as DateTime,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "word": word,
      "date": date,
    };
  }
}

class FavoriteWordAdapter extends TypeAdapter<FavoriteWordType> {
  @override
  final int typeId = 2;

  @override
  FavoriteWordType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // this.identify:'',
    // this.date,
    // this.bookId:1,
    // this.chapterId:1,
    return FavoriteWordType(word: '')
      ..word = fields[0] as String
      ..date = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, FavoriteWordType obj) {
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
      other is FavoriteWordAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
