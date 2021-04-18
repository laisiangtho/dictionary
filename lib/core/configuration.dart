part of 'core.dart';

mixin _Configuration  {
  EnvironmentType env;
  final Collection collection = Collection.init();
  // final Store store = new Store();
  Store store;

  final listKeyHistory =  GlobalKey<SliverAnimatedListState>();
}
