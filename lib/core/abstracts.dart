part of 'main.dart';

abstract class _Abstracts extends UnitCore {
  @override
  late final Data data = Data(state: state);

  @override
  late final Preference preference = Preference(data);

  @override
  late final Authenticate authenticate = Authenticate(data);

  @override
  late final RouteConfig route = RouteConfig();

  @override
  late final Analytics analytics = Analytics();

  @override
  late final Store store = Store(data);

  @override
  late final SQLite sql = SQLite(data);

  @override
  late final Speech speech = Speech();

  @override
  late final Audio audio = Audio(data);

  @override
  Future<void> ensureInitialized() async {
    Stopwatch initWatch = Stopwatch()..start();

    await super.ensureInitialized();

    await data.ensureInitialized();
    await data.prepareInitialized();
    await preference.ensureInitialized();
    await authenticate.ensureInitialized();

    // if (authentication.id.isNotEmpty && authentication.id != data.setting.userId) {
    //   final ou = data.setting.copyWith(userId: authentication.id);
    //   await data.settingUpdate(ou);
    // }

    debugPrint('ensureInitialized in ${initWatch.elapsedMilliseconds} ms');
  }
}
