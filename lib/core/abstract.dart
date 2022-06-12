part of data.core;

abstract class _Abstract extends UnitEngine with _Utility {
  final Collection collection = Collection.internal();

  late final Preference preference = Preference(collection);
  late final Authentication authentication = Authentication();
  late final NavigationNotify navigation = NavigationNotify();
  late final Analytics analytics = Analytics();

  late final store = Store(collection: collection, notify: notify);
  late final sql = SQLite(collection: collection);
  late final speech = Speech();

  /// Initiate collection, preference, authentication
  Future<void> ensureInitialized() async {
    Stopwatch initWatch = Stopwatch()..start();

    await collection.ensureInitialized();
    await collection.prepareInitialized();
    await preference.ensureInitialized();
    await authentication.ensureInitialized();

    // if (authentication.id.isNotEmpty && authentication.id != collection.setting.userId) {
    //   final ou = collection.setting.copyWith(userId: authentication.id);
    //   await collection.settingUpdate(ou);
    // }

    debugPrint('ensureInitialized in ${initWatch.elapsedMilliseconds} ms');
  }

  // String get searchQuery => collection.searchQuery.asString;
  // set searchQuery(String ord) {
  //   notifyIf<String>(searchQuery, collection.searchQuery = ord);
  // }

  // String get suggestQuery => collection.suggestQuery;
  // set suggestQuery(String ord) {
  //   final word = ord.replaceAll(RegExp(' +'), ' ').trim();
  //   notifyIf<String>(suggestQuery, collection.suggestQuery = word);
  // }

  String get searchQuery => collection.searchQuery.asString;
  set searchQuery(String ord) {
    notifyIf<String>(searchQuery, collection.searchQuery = ord);
  }

  String get suggestQuery => collection.suggestQuery.asString;
  set suggestQuery(String ord) {
    final word = ord.replaceAll(RegExp(' +'), ' ').trim();
    notifyIf<String>(suggestQuery, collection.suggestQuery = word);
  }

  Future<void> dataInitialized() async {
    // if (collection.requireInitialized) {
    //   APIType api = collection.env.api.firstWhere(
    //     (e) => e.asset.isNotEmpty,
    //   );
    //   await UtilArchive.extractBundle(api.asset);
    // }
    if (collection.requireInitialized) {
      Iterable<APIType> api = collection.env.api.where(
        (e) => e.local.isNotEmpty,
      );

      for (var e in api) {
        await UtilArchive.extractBundle(e.local, noneArchive: true);
      }
    }
  }

  bool get searchQueryFavorited {
    // return collection.favoriteIndex(searchQuery) >= 0;
    return collection.favoriteExist(searchQuery).key != null;
  }
}
