part of "root.dart";

class Collection{
  SettingType? setting;
  EnvironmentType? env;
  Box<String?>? history;
  // Box<StoreType> store;

  final Notify notify = Notify();

  /// final time = watch..start(); time.elapsedMilliseconds
  // final Stopwatch watch = new Stopwatch();

  Collection({
    this.setting,
    this.env,
    this.history
  });

  bool stringCompare(String? a, String b) => a!.toLowerCase() == b.toLowerCase();

  bool hasNotHistory(String laimal) {
    return this.history!.values.firstWhere((e) => stringCompare(e,laimal),orElse: ()=>null) == null;
  }

  void addHistory(String laimal) {
    if (this.hasNotHistory(laimal)){
      this.history!.add(laimal);
    }

    // if (collection.history.values.firstWhere((e) => collection.stringCompare(e, word), orElse: ()=> null) == null){
    //   collection.history.add(word);
    // }
  }
  void removeHistory(String laimal) {
    // this.history.values.toList()
    bool test = this.history!.values.firstWhere((e) => stringCompare(e,laimal),orElse: ()=>null) != null;
    if (test){
      this.history!.add(laimal);
    }
  }

  Map<int, String?> get mapHistory {
    return this.history!.toMap().map(
      (key, value) => MapEntry(key, value)
    );
  }

  void toTest() {
    // this.env.synset.
  }
}
