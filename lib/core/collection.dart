
part of 'core.dart';

abstract class _Collection with _Configuration, _Utility {
  /// TODO: analytics
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }

  Future<void> _environmentInit() async {
    collection.env = await UtilDocument.loadBundleAsString('env.json').then(
      (e) => EnvironmentType.fromJSON(UtilDocument.decodeJSON(e))
    );
  }

  Future<void> settingInit() async {
    Box<SettingType> box = await Hive.openBox<SettingType>(collection.env.settingName);
    SettingType active = box.get(collection.env.settingKey,defaultValue: collection.env.setting);

    if (box.isEmpty){
      // debugPrint('Import ${env.settingName}');
      box.put(collection.env.settingKey,collection.env.setting);
    } else if (active.version != collection.env.setting.version){
      // debugPrint('Upgrade ${env.settingName} ${collection.env.setting.toJSON()}');
      box.put(collection.env.settingKey,active?.merge(collection.env.setting));
    } else {
      // debugPrint('Ok ${env.settingName}');
    }
    collection.setting = active;
    // box.clear();
  }

  void _settingUpdate(SettingType data){
    if (data != null) {
      Hive.box<SettingType>(collection.env.settingName).put(collection.env.settingKey,data);
    }
  }

  Future<void> historyInit() async {
    collection.history = await Hive.openBox<String>('history');
    // await collection.history.clear();
  }
}
