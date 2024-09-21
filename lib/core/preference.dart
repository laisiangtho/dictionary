part of 'main.dart';

class Preference extends PreferenceNest {
  Preference(super.data);

  // Future<AppLocalizations> get l10n {
  //   // final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //   // List<Locale>
  //   // final preferred = widgetsBinding.window.locales;

  //   final preferred = listOfLocale;
  //   const supported = AppLocalizations.supportedLocales;
  //   final locale = basicLocaleListResolution(preferred, supported);
  //   return AppLocalizations.delegate.load(locale);
  // }

  // void tmp(BuildContext context) async {
  //   // final abc = await l10n;
  //   // abc.back;
  //   // textTmp(context).back;
  // }

  @override
  AppLocalizations lang(BuildContext context) => AppLocalizations.of(context)!;

  // @override
  // List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  late final Iterable<LocalizationsDelegate<dynamic>> localeDelegates = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// English, Norwegian, Myanmar
  // @override
  // Iterable<Locale> get listOfLocale => const [
  //       Locale('en', 'GB'),
  //       Locale('no', 'NO'),
  //       Locale('my', 'MM'),
  //     ];

  @override
  ThemeData? light(BuildContext context) {
    return ThemeNest.theme(
      text: Theme.of(context).textTheme.merge(
            ThemeNest.textTheme(),
          ),
      color: const ColorNest.light(),
    );
  }

  @override
  ThemeData? dark(BuildContext context) {
    return ThemeNest.theme(
      text: Theme.of(context).textTheme.merge(
            ThemeNest.textTheme(),
          ),
      color: const ColorNest.dark(),
    );
  }
}
