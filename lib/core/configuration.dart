part of 'core.dart';

mixin _Configuration  {
  SQLite sql;
  final Collection collection = Collection.init();
  // final Store store = new Store();
  Store store;

  final listKeyHistory =  GlobalKey<SliverAnimatedListState>();
}
