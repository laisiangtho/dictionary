part of 'main.dart';

mixin _Configuration  {
  final Collection collection = Collection.internal();
  final listKeyHistory = GlobalKey<SliverAnimatedListState>();

  late SQLite _sql;
  late Store store;

  late List<Map<String, Object?>> suggestionList = [];
  late List<Map<String, Object?>> definitionList = [];
}
