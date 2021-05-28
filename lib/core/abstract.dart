
part of 'main.dart';

abstract class _Abstract extends CoreNotifier with _Configuration, _Utility {
  Future<void> initEnvironment() async {
    // type 'Null' is not a subtype of type 'String'
    // collection.env = await UtilDocument.loadBundleAsString('env.json').then(
    //   (e) => EnvironmentType.fromJSON(UtilDocument.decodeJSON(e))
    // );

    collection.env = EnvironmentType.fromJSON(UtilDocument.decodeJSON(await UtilDocument.loadBundleAsString('env.json')));
  }

  Future<void> initSetting() async {
    // Box<SettingType> box = await Hive.openBox<SettingType>(collection.env.settingName);
    // SettingType active = collection.boxOfSetting.get(collection.env.settingKey,defaultValue: collection.env.setting)!;
    collection.boxOfSetting = await Hive.openBox<SettingType>(collection.env.settingName);
    SettingType active = collection.setting;

    if (collection.boxOfSetting.isEmpty){
      collection.boxOfSetting.put(collection.env.settingKey,collection.env.setting);
    } else if (active.version != collection.env.setting.version){
      collection.boxOfSetting.put(collection.env.settingKey,active.merge(collection.env.setting));
    }

    collection.boxOfPurchase = await Hive.openBox<PurchaseType>('purchase-tmp');
    // collection.setting = active;
    // collection.boxOfSetting.clear();
  }

  Future<void> initHistory() async {
    // collection.boxOfHistory = await Hive.openBox<String>('history');
    // await collection.boxOfHistory.clear();
    // collection.boxOfHistory = await Hive.openBox<String>('history');
    // boxOfHistoryWorking

    collection.boxOfHistory = await Hive.openBox<HistoryType>('history-tmp');

    // await collection.boxOfHistory.clear();
    historyGenerate();
  }

  FutureOr<void> historyGenerate() async {
    notifyListeners();
  }

  FutureOr<void> historyClear() async {
    await collection.boxOfHistory.clear();
    notifyListeners();
  }

  // boxOfHistoryAdd
  FutureOr<void> historyAdd(String ord) async {
    if (collection.boxOfHistoryAdd(ord)){
      notifyListeners();
    }
  }

  FutureOr<void> historyDelete(String ord) async {
    if (collection.boxOfHistoryDeleteByWord(ord)){
      notifyListeners();
    }
  }

  // ignore: todo
  // TODO: analytics
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }
}
