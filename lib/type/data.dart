part of data.type;

class Data extends DataNest {
  // late final boxOfBooks = BoxOfBooks<BooksType>();
  // late final boxOfBookmarks = BoxOfBookmarks<BookmarksType>();

  // List<DefinitionBible> cacheBible = [];

  // retrieve the instance through the app
  // Collection.internal();
  // Collection.internal() : super.internal();

  late List<SynsetType> synset;
  late List<SynmapType> synmap;

  SuggestionType<OfRawType> cacheSuggestion = const SuggestionType();
  ConclusionType<Map<String, dynamic>> cacheConclusion = const ConclusionType();

  Data({required super.notify});

  @override
  Future<void> ensureInitialized() async {
    await super.ensureInitialized();
    // boxOfBooks.registerAdapter(BooksAdapter());
    // boxOfBookmarks.registerAdapter(BookmarksAdapter());
  }

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();
    // await boxOfBooks.open('book');
    // await boxOfBookmarks.open('bookmark');

    synset = env.attach['synset'].map<SynsetType>((o) => SynsetType.fromJSON(o)).toList();
    synmap = env.attach['synmap'].map<SynmapType>((o) => SynmapType.fromJSON(o)).toList();
  }

  /// Every database
  // Iterable<APIType> get listOfDatabase => env.api.where((e) => e.src.length > 0);
  Iterable<APIType> get listOfDatabase => env.api.where((e) => e.localName.isNotEmpty);

  /// Every table
  // Iterable<APIType> get listOfTable => env.api.where((e) => e.table.isNotEmpty);

  /// the primary database and table
  // APIType get primary => env.api.firstWhere((e) => e.isMain, orElse: () => null!);
  APIType get primary => env.api.firstWhere((e) => e.isMain);

  /// the primary database and it table except primary table
  Iterable<APIType> get children => env.api.where((e) => e.isChild);

  /// Other database to attached
  Iterable<APIType> get secondary => env.api.where((e) => e.isAttach);

  SynsetType partOfGrammar(int id) => synset.firstWhere((e) => e.id == id);
  SynmapType partOfSpeech(int id) => synmap.firstWhere((e) => e.id == id);

  // NOTE: Favorite
  /// get all favorite favoriteEntries
  Iterable<MapEntry<dynamic, FavoriteWordType>> get favorites {
    return boxOfFavoriteWord.entries;
  }

  /// favorite is EXIST by word
  MapEntry<dynamic, FavoriteWordType> favoriteExist(String ord) {
    return favorites.firstWhere(
      (e) => UtilString.stringCompare(e.value.word, ord),
      orElse: () => MapEntry(null, FavoriteWordType(word: ord)),
    );
  }

  /// favorite UPDATE on exist, if not INSERT
  bool favoriteUpdate(String ord) {
    if (ord.isNotEmpty) {
      final ob = favoriteExist(ord);
      ob.value.date = DateTime.now();
      if (ob.key == null) {
        boxOfFavoriteWord.box.add(ob.value);
      } else {
        boxOfFavoriteWord.box.put(ob.key, ob.value);
      }
      // print('recentSearchUpdate ${ob.value.hit}');
      return true;
    }
    return false;
  }

  /// favorite DELETE by word
  bool favoriteDelete(String ord) {
    if (ord.isNotEmpty) {
      final ob = favoriteExist(ord);
      if (ob.key != null) {
        boxOfFavoriteWord.deleteAtKey(ob.key);
        return true;
      }
    }
    return false;
  }

  /// favorite DELETE on exist, if not INSERT
  bool favoriteSwitch(String ord) {
    if (ord.isNotEmpty) {
      final ob = favoriteExist(ord);
      if (ob.key != null) {
        favoriteDelete(ord);
      } else {
        return favoriteUpdate(ord);
      }
    }
    return false;
  }
}
