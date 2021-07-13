
part of 'main.dart';

abstract class _Abstract extends CoreNotifier with _Configuration, _Utility {
  Future<void> initEnvironment() async {
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
    // collection.boxOfSetting.clear();

    collection.boxOfHistory = await Hive.openBox<HistoryType>('history-tmp');
    // await collection.boxOfHistory.clear();
  }

  void historyClearNotify() => collection.boxOfHistory.clear().whenComplete(notify);

  // ignore: todo
  // TODO: analytics
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }
}
