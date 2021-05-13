part of "root.dart";

class Notify {

  final ValueNotifier<double> progress = ValueNotifier<double>(null);

  final ValueNotifier<String> suggestQuery = ValueNotifier<String>('');
  final ValueNotifier<List<Map<String, Object>>> suggestResult = ValueNotifier<List<Map<String, Object>>>([]);

  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  final ValueNotifier<List<Map<String, dynamic>>> searchResult = ValueNotifier<List<Map<String, dynamic>>>([]);

}