part of 'core.dart';


mixin _Configuration  {
  String appName = 'MyOrdbok';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  final String appDescription = 'A comprehensive Myanmar online dictionary';

  final String _settingName = 'settingPrimary';
  final String _settingKey = 'setting';

  // final Collection collection = Collection(setting: SettingType(),grammar: Grammar.init());
  final Collection collection = Collection.init();

  // final String appAnalytics = 'UA-18644721-1';
  // final String assetsFolder = 'assets';
  // final String assetsCollection = 'book.json';
  // // final String assetsCollection = 'collection.json';
  // final String _liveBookJSON = 'nosj.koob/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth';

  // final keyBookmarkList = GlobalKey<SliverAnimatedListState>();

  // Collection collection;

  // Scripture scripturePrimary, scriptureParallel;

  // // primaryId, parallelIdentify
  // String get primaryId => collection.setting.identify;
  // set primaryId(String id) => collection.setting.identify = id;

  // String get parallelId => collection.setting.parallel;
  // set parallelId(String id) => collection.setting.parallel = id;

  // int get testamentId => this.bookId > 39?2:1;

  // int get bookId => collection.setting.bookId;
  // set bookId(int id) => collection.setting.bookId = id;
  // int get chapterId => collection.setting.chapterId;
  // set chapterId(int id) => collection.setting.chapterId = id;

  // double fontSize = 24.0;
  // double get fontSize => collection.setting.fontSize;
  // set fontSize(double id) => collection.setting.fontSize = id;

  // String langShortName = 'my';
  // String get langShortName => collection.setting.fontSize;
  // set langShortName(double id) => collection.setting.fontSize = id;

  // String searchQuery = '';
  // String get searchQuery => collection.setting.searchQuery??'';
  // set searchQuery(String searchQuery) => collection.setting.searchQuery = searchQuery;

  // /// convert (Int or Number of String), chapterId, verseId into it's written language
  // // String digit(dynamic e) => (e is String?e:e.toString()).replaceAllMapped(
  // //   new RegExp(r'[0-9]'), (i) => userBiblePrimary == null?i.group(0):userBiblePrimary.digit[int.parse(i.group(0))]
  // // );
  // String digit(dynamic e) => scripturePrimary.digit(e);
  // // int get uniqueIdentify => new DateTime.now().millisecondsSinceEpoch;

}