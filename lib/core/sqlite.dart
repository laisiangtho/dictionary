part of 'core.dart';

class SQLite {
  final Collection collection;
  // static final SQLite _instance = new SQLite.internal();
  // factory SQLite() => _instance;
  // SQLite.internal();

  Database _instance;
  final int version = 1;

  SQLite({this.collection});

  APIType get _wordContext => collection.env.word;
  String get _wordTable => _wordContext.tableName;

  APIType get _senseContext => collection.env.sense;
  String get _senseTable => _senseContext.tableName;

  APIType get _deriveContext => collection.env.derive;
  String get _deriveTable => _deriveContext.tableName;

  APIType get _thesaurusContext => collection.env.thesaurus;
  String get _thesaurusTable => _thesaurusContext.tableName;

  Future<Database> get db async {
    if (_instance == null) {
      _instance = await init();
    }
    return _instance;
  }

  FutureOr<Database> init() async {
    final String file = await UtilDocument.fileName(_wordContext.db);
    debugPrint('load start');
    await this.load(_wordContext);
    debugPrint('load end');
    return await openDatabase(
      file,
      version: this.version,
      onConfigure: this.onConfigure,
      onCreate: this.onCreate,
      onUpgrade: this.onUpgrade,
      onDowngrade: this.onDowngrade,
      onOpen: this.onOpen,
      singleInstance: true
    );
  }

  FutureOr<void> onConfigure(Database db) {
    // ALTER TABLE table_name ADD PRIMARY KEY(col1, col2,...)
  }

  FutureOr<void> onCreate(Database db, int v) async {
    // batch.execute(_senseContext.dropTable);
    // batch.execute(_senseContext.createTable);
    // batch.execute(_senseContext.createTable);

    collection.notify.progress.value = null;
    // debugPrint('transaction start');
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      batch.execute(_wordContext.createIndex);
      batch.execute(_senseContext.createIndex);
      batch.execute(_deriveContext.createIndex);
      batch.execute(_thesaurusContext.createIndex);
      // debugPrint('import start');
      await this.import(_senseContext, batch).whenComplete(
        () async {
          // debugPrint('batch.commit start');
          await batch.commit(noResult: true);
          // debugPrint('batch.commit end');
        }
      );
      // debugPrint('import end');
    });
    // debugPrint('transaction end');
  }

  FutureOr<void> onUpgrade(Database db, int ov, int nv) async {
    collection.notify.progress.value = null;
    // debugPrint('transaction start');
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      // debugPrint('import start');
      await this.import(_senseContext, batch).whenComplete(
        () async {
          // debugPrint('batch.commit start');
          await batch.commit(noResult: true);
          // debugPrint('batch.commit end');
        }
      );
      // debugPrint('import end');
    });
    // debugPrint('transaction end');
  }

  FutureOr<void> onDowngrade(Database db, int ov, int nv) async {
    collection.notify.progress.value = null;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      await this.import(_senseContext, batch).whenComplete(
        () async => await batch.commit(noResult: true)
      );
    });
  }

  FutureOr<void> onOpen(Database db) {
    collection.notify.progress.value = 0.4;
    // debugPrint('opening');
    // String _filePath = await UtilDocument.fileName(senseContext.file);
    // await lethil.rawQuery("ATTACH DATABASE '$_filePath' AS mean");
  }

  FutureOr<void> load(APIType id) async{
    String file = await UtilDocument.exists(id.db);
    if (file.isEmpty){
      List<int> data;
      String _fileOrUrl = id.src.first;
      bool _validURL = Uri.parse(_fileOrUrl).isAbsolute;
      if (_validURL){
        data = await this.loadFromHostByte(_fileOrUrl);
      } else {
        data = await this.loadFromAssetByte(_fileOrUrl);
      }
      await UtilDocument.writeAsByte(id.db, data, true);
    }
  }

  /// make request
  Future<io.HttpClientResponse> requestClient(String url) async {
    final client = new io.HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    // if (response.statusCode != 200) throw "Error on initializing data";
    if (response.statusCode != 200) return Future.error("Error on initializing data");
    return response;
  }

  /// load word from assets
  Future<List<int>> loadFromAssetByte(String fileName) async {
    final data = await UtilDocument.loadBundleAsByte(fileName);
    // return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return await compute(UtilDocument.byteToListInt, data);
  }


  /// load word from client
  Future<List<int>> loadFromHostByte(String url) async {
    final data = await this.requestClient(url);
    return await consolidateHttpClientResponseBytes(data);
  }

  Future<void> import(APIType id, Batch batch) async{
    List<dynamic> raw;
    // String item = id.src.first;

    for (var item in id.src) {
      String res;
      bool _validURL = Uri.parse(item).isAbsolute;
      // debugPrint('loop: $_validURL $item');
      if (_validURL){
        res = await UtilClient.request(item).catchError((e){
          return null;
        }).then((value) {
          return value;
        });
      } else {
        res = await UtilDocument.loadBundleAsString(item);
      }
      if (res != null && res.isNotEmpty) {
        raw = await parseListDyanmic(res).catchError((e){
          // debugPrint('parse error $e');
          return null;
        });
        if (raw != null){
          break;
        }
      }
    }

    if (raw != null){
      raw.forEach((row) => batch.execute(id.importQuery,row));
    }
  }

  Future<List<dynamic>> parseListDyanmic(String response) async{
    try {
      return await UtilDocument.decodeJSON(response).cast<List<dynamic>>();
    } on Exception catch (exception) {
      return Future.error(exception);
    } catch (error) {
      return Future.error(error);
    }
  }

  /// get suggestion
  Future<List<Map<String, Object>>> suggestion(String keyword) async {
    // return await _instance.query(_senseTable, columns:['word'],where: 'word LIKE ?',whereArgs: [keyword+'%'] ,orderBy: 'word',limit: 10);
    // return await _instance.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 10;",[keyword+'%']);
    return await this.db.then(
      (e) => e.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 30;",['$keyword%'])
    );
  }

  /// get definition
  Future<List<Map<String, Object>>> search(String keyword) async {
    return await this.db.then(
      (e) => e.rawQuery("SELECT word, wrte, sense, exam FROM $_senseTable WHERE word LIKE ? ORDER BY wrte, wseq;",[keyword])
    );
  }

  /// get root
  /// d.word, c.wrte, c.dete, c.wirg, w.word AS derived
  Future<List<Map<String, Object>>> rootWord(String keyword) async {

    return await _instance.rawQuery("""SELECT
      d.word, c.wrte, c.dete, c.wirg, w.word AS derived
    FROM $_wordTable AS w
      INNER JOIN $_deriveTable c ON w.id = c.wrid
        INNER JOIN $_wordTable d ON c.id = d.id
    WHERE w.word = ?;
    """,[keyword]);
  }

  /// get base
  /// w.word, c.wrte, c.dete, c.wirg, d.word AS derived
  Future<List<Map<String, Object>>> baseWord(String keyword) async {
    return await _instance.rawQuery("""SELECT
      w.word, c.wrte, c.dete, c.wirg, d.word AS derived
    FROM $_wordTable AS w
      INNER JOIN $_deriveTable c ON w.id = c.id
        INNER JOIN $_wordTable d ON c.wrid = d.id
    WHERE w.word = ?;
    """,[keyword]);
  }

  /// get thesaurus
  /// w.id AS root, c.wlid AS wrid, d.word, d.derived
  Future<List<Map<String, Object>>> thesaurus(String keyword) async {
    return await _instance.rawQuery("""SELECT
      d.word, d.derived
    FROM $_wordTable AS w
      INNER JOIN $_thesaurusTable c ON w.id = c.wrid
        INNER JOIN $_wordTable d ON c.wlid = d.id
    WHERE w.word = ?;
    """,[keyword]);
  }

  /// temp: get number of tables
  Future<List<Map<String, Object>>> countTable() async {
    var client = await this.db;
    return await client.rawQuery("SELECT count(*) as count FROM sqlite_master WHERE type = 'table';");
  }
}
