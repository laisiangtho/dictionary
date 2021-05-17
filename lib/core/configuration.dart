part of 'main.dart';

mixin _Configuration  {
  SQLite? sql;
  Store? store;
  final Collection collection = Collection();

  final listKeyHistory = GlobalKey<SliverAnimatedListState>();
}
