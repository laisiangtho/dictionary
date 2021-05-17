
part of 'main.dart';

abstract class _Abstract with _Configuration, _Utility {
  Future<void> initEnvironment() async {
    collection.env = await UtilDocument.loadBundleAsString('env.json').then(
      (e) => EnvironmentType.fromJSON(UtilDocument.decodeJSON(e))
    );
  }

  Future<void> initSetting() async {
    Box<SettingType> box = await Hive.openBox<SettingType>(collection.env!.settingName);
    SettingType? active = box.get(collection.env!.settingKey,defaultValue: collection.env!.setting);

    if (box.isEmpty){
      box.put(collection.env!.settingKey,collection.env!.setting);
    } else if (active!.version != collection.env!.setting.version){
      box.put(collection.env!.settingKey,active.merge(collection.env!.setting));
    }
    collection.setting = active;
    // box.clear();
  }

  void _settingUpdate(SettingType? data){
    if (data != null) {
      Hive.box<SettingType>(collection.env!.settingName).put(collection.env!.settingKey,data);
    }
  }

  Future<void> initHistory() async {
    collection.history = await Hive.openBox<String>('history');
    // await collection.history.clear();
  }

  // ignore: todo
  // TODO: analytics
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }
}
