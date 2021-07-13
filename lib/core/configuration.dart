part of 'main.dart';

mixin _Configuration  {
  final Collection collection = Collection.internal();

  late SQLite _sql;
  late Store store;
}
