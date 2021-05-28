part of 'main.dart';

mixin _Utility {
  final UtilAnalytics utilAnalytics = new UtilAnalytics();

  Future<void> analyticsSearch(String searchTerm) async {
    if (searchTerm.isNotEmpty) await utilAnalytics.search(searchTerm);
  }

  Future<void> analyticsScreen(String name, String classes) async {
    // await new FirebaseAnalytics().setCurrentScreen(creenName: 'home',screenClassOverride: 'HomeState');
    // debugPrint('analyticsScreen $name $classes');
    await utilAnalytics.send.setCurrentScreen(screenName: name,screenClassOverride: classes);
  }
}