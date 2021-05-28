part of 'main.dart';

class Collection{
  late EnvironmentType env;
  late Box<SettingType> boxOfSetting;
  late Box<PurchaseType> boxOfPurchase;
  late Box<HistoryType> boxOfHistory;

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

  Future<void> searchQueryUpdate(String word) async{
    if (word.isNotEmpty && setting.searchQuery != word){
      this.settingUpdate(setting.copyWith(searchQuery: word));
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

  // // boxOfHistory
  // void addHistory(String ord) {
  //   if (ord.isNotEmpty && this.hasNotHistory(ord)){
  //     this.boxOfHistory.add(ord);
  //   }
  // }
  // void removeHistory(String ord) {
  //   // this.boxOfHistory.values.toList()
  //   // bool test = this.boxOfHistory.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '') != null;
  //   bool test = this.boxOfHistory.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '')!.isNotEmpty;
  //   if (test){
  //     this.boxOfHistory.add(ord);
  //   }
  // }
  // bool hasNotHistory(String ord) => this.boxOfHistory.values.firstWhere((e) => stringCompare(e.word,ord),orElse: () => Map()) != null;
  // bool boxOfHistoryByWord(String ord) => this.boxOfHistory.values.where((e) => stringCompare(e.word,ord)).length == 0;
  // HistoryType boxOfHistoryFirstWhere(String ord) => this.boxOfHistory.values.firstWhere((e) => stringCompare(e.word,ord), orElse: ()=> HistoryType());//.word == null;
  MapEntry<dynamic, HistoryType> boxOfHistoryExist(String ord) => this.boxOfHistory.toMap().entries.firstWhere(
    (e) => stringCompare(e.value.word,ord),
    orElse: ()=> MapEntry(null,HistoryType())
  );

  bool boxOfHistoryAdd(String ord) {
    if (ord.isNotEmpty){
      final history = this.boxOfHistoryExist(ord);
      if (history.key == null){
        // HistoryType(word: ord, hit: 0, date: DateTime.now())
        history.value.word = ord;
        history.value.hit = 1;
        history.value.date = DateTime.now();
        this.boxOfHistory.add(history.value);
      } else {
        history.value.date = DateTime.now();
        history.value.hit++;
        this.boxOfHistory.put(history.key, history.value);
      }
      return true;
    }
    return false;
  }

  bool boxOfHistoryDeleteByWord(String ord) {
    if (ord.isNotEmpty){
      final history = this.boxOfHistoryExist(ord);
      if (history.key != null){
        // this.boxOfHistory.deleteAt(history.key);
        this.boxOfHistory.delete(history.key);
        return true;
      }
    }
    return false;
  }

  void boxOfHistoryClear() {
    this.boxOfHistory.clear();
  }

  // Map<int, String?> get mapHistory {
  //   return this.boxOfHistory.toMap().map(
  //     (key, value) => MapEntry(key, value)
  //   );
  // }

  void test() {
    // this.env.synset.
  }
}
