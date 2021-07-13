part of 'main.dart';

class Collection{
  late EnvironmentType env;
  late Box<SettingType> boxOfSetting;
  late Box<PurchaseType> boxOfPurchase;
  late Box<HistoryType> boxOfHistory;

  SuggestionType cacheSuggestion = SuggestionType();
  DefinitionType cacheDefinition = DefinitionType();

  // final time = watch..start(); time.elapsedMilliseconds
  // final Stopwatch watch = new Stopwatch();

  static final Collection _instance = new Collection.internal();
  factory Collection() => _instance;
  Collection.internal();
  // retrieve the instance through the app
  static Collection get instance => _instance;

  SettingType get setting => boxOfSetting.get(env.settingKey,defaultValue: env.setting)!;

  Future<void> settingUpdate(SettingType? value) async{
    if (value != null) {
      boxOfSetting.put(env.settingKey,value);
    }
  }

  String get searchQuery => setting.searchQuery;
  // set searchQuery(String searchQuery) => setting.searchQuery = searchQuery;
  set searchQuery(String word) {
    if (setting.searchQuery != word){
      setting.searchQuery = word;
      this.settingUpdate(setting);
    }
  }

  bool stringCompare(String? a, String b) => a!.toLowerCase() == b.toLowerCase();

  // boxOfHistory addWordHistory
  // bool hasNotHistory(String ord) => this.boxOfHistory.values.firstWhere((e) => stringCompare(e,ord),orElse: ()=>'') == null;
  // bool hasNotHistory(String ord) => this.boxOfHistory.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '')!.isEmpty;

  MapEntry<dynamic, PurchaseType> boxOfPurchaseExist(String id) => this.boxOfPurchase.toMap().entries.firstWhere(
    (e) => stringCompare(e.value.purchaseId,id),
    orElse: ()=> MapEntry(null,PurchaseType())
  );

  bool boxOfPurchaseDeleteByPurchaseId(String id) {
    if (id.isNotEmpty){
      final purchase = this.boxOfPurchaseExist(id);
      if (purchase.key != null){
        // this.boxOfHistory.deleteAt(history.key);
        this.boxOfPurchase.delete(purchase.key);
        return true;
      }
    }
    return false;
  }

  // NOTE: History
  Iterable<MapEntry<dynamic, HistoryType>> get historyIterable => boxOfHistory.toMap().entries;

  MapEntry<dynamic, HistoryType> historyExist(String ord) => historyIterable.firstWhere(
    (e) => stringCompare(e.value.word,ord),
    orElse: () => MapEntry(null,HistoryType(word: ord))
  );

  bool historyUpdate(String ord) {
    if (ord.isNotEmpty){
      final history = this.historyExist(ord);
      history.value.date = DateTime.now();
      history.value.hit++;
      if (history.key == null){
        this.boxOfHistory.add(history.value);
      } else {
        this.boxOfHistory.put(history.key, history.value);
      }
      return true;
    }
    return false;
  }

  bool historyDeleteByWord(String ord) {
    if (ord.isNotEmpty){
      final history = this.historyExist(ord);
      if (history.key != null){
        this.boxOfHistory.delete(history.key);
        return true;
      }
    }
    return false;
  }

  Iterable<MapEntry<dynamic, HistoryType>> history() {
    if (searchQuery.isEmpty){
      return historyIterable;
    } else {
      return historyIterable.where(
        (e) => e.value.word.toLowerCase().startsWith(searchQuery.toLowerCase())
      );
    }
  }

  void boxOfHistoryClear() {
    this.boxOfHistory.clear();
  }
}
