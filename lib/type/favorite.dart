part of 'main.dart';

// NOTE: adapter/favorite.dart
@HiveType(typeId: 2)
class FavoriteType {
  @HiveField(0)
  String word;

  @HiveField(1)
  DateTime? date;

  FavoriteType({
    required this.word,
    this.date,
  });

  factory FavoriteType.fromJSON(Map<String, dynamic> o) {
    return FavoriteType(
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
