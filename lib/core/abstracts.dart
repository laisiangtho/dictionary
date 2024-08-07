part of 'main.dart';

abstract class _Abstracts extends UnitCore {
  /// API
  /// ```dart
  /// final Data data = Data.internal();
  /// late final Data data = Data(state: state);
  /// ```
  late final Data data = Data(state: state);

  /// Scroll notifier, ScrollNotifier
  late final ViewData viewData = ViewData();

  /// Theme and locales
  late final Preference preference = Preference(data);

  /// Firebase Authentication
  late final Authenticate authenticate = Authenticate(data);

  /// Analytics
  late final Analytics analytics = Analytics();

  /// Individual: Store, SQLite, Speech, Audio
  late final store = Store(data);
  late final sql = SQLite(data);
  late final speech = Speech();
  late final audio = Audio(data);

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
