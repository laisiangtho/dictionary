part of "root.dart";

class Collection{
  // NOTE: setting
  SettingType setting;

  // NOTE: dictionary
  // Grammar grammar;
  Box<String> history;
  // Box<StoreType> store;

  // NOTE: result
  // String keyword;
  // String searchQuery;
  // List<WordType> suggestion;
  // List<ResultModel> definition;

  EnvironmentType env;

  final Notify notify = Notify();

  // final ValueNotifier<double> progressNotify = ValueNotifier<double>(null);
  // final ValueNotifier<String> suggestQueryNotify = ValueNotifier<String>('');
  // final ValueNotifier<List<Map<String, Object>>> suggestResultNotify = ValueNotifier<List<Map<String, Object>>>([]);
  // final ValueNotifier<String> searchQueryNotify = ValueNotifier<String>('');
  // final ValueNotifier<List<Map<String, Object>>> searchResultNotify = ValueNotifier<List<Map<String, Object>>>([]);

  // promise notify.keyword notify.searchQuery

  Collection({
    this.setting,
    this.env,
    // this.grammar,

    this.history,
    // this.store,
    // this.keyword,
    // this.searchQuery,

    // this.definition
  });

  factory Collection.init() {
    return Collection(
      setting: SettingType(),
      // grammar: Grammar.init(),
      history: null,
      // store: null,
      // keyword:"",
      // searchQuery:"",
      // definition: []
    );
  }

  bool stringCompare(String a, String b) => a.toLowerCase() == b.toLowerCase();

  bool hasNotHistory(String laimal) {
    return this.history.values.firstWhere((e) => stringCompare(e,laimal),orElse: ()=>null) == null;
  }

  void addHistory(String laimal) {
    if (this.history.values.firstWhere((e) => stringCompare(e,laimal),orElse: ()=>null) == null ){
      this.history.add(laimal);
    }

    // if (collection.history.values.firstWhere((e) => collection.stringCompare(e, word), orElse: ()=> null) == null){
    //   collection.history.add(word);
    // }
  }
  void removeHistory(String laimal) {
    // this.history.values.toList()
    var test = this.history.values.firstWhere((e) => stringCompare(e,laimal),orElse: ()=>null);
    if (test == null || test.isNotEmpty){
      this.history.add(laimal);
    }
  }

  Map<int, String> get mapHistory {
    return this.history?.toMap()?.map(
      (key, value) => MapEntry(key, value)
    );
  }

  void toTest() {
    // this.env.synset.
  }
}
