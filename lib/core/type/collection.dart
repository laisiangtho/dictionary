part of 'root.dart';

class Collection{
  SettingType setting;
  // Box<SettingType> settingBox;
  Grammar grammar;
  Iterable<WordType> word;
  Iterable<SenseType> sense;
  Iterable<UsageType> usage;
  Iterable<SynsetType> synset;
  Iterable<SynmapType> synmap;

  // NOTE: result
  String keyword;
  String searchQuery;
  List<WordType> suggestion;
  List<ResultModel> definition;

  List<SynsetType> wordBase;
  List<SynmapType> wordMap;

  Collection({
    this.setting,
    // this.settingBox,
    this.grammar,
    this.word,
    this.sense,
    this.usage,
    this.synset,
    this.synmap,
    this.keyword,
    this.searchQuery,
    this.wordBase,
    this.wordMap,
    this.suggestion,
    this.definition
  });

  factory Collection.init() {
    return Collection(
      setting: SettingType(),
      // settingBox: null,
      grammar: Grammar.init(),
      word: [],
      sense: [],
      synset: [],
      usage: [],
      synmap: [],
      keyword:'',
      searchQuery:'',
      wordBase: [],
      wordMap: [],
      suggestion: [],
      definition: []
    );
  }

  Iterable<WordType> wordStartWith(String keyword) {
    return this.word.where((e) => e.charStartsWith(keyword));
  }

  Iterable<WordType> wordExactMatch(String keyword) {
    return this.word.where((e) => e.charMatchExact(keyword));
  }

  bool stringCompare(String a, String b) => a.toLowerCase() == b.toLowerCase();

  void partOfSpeech(String laimal) {
    var grammar = this.synset;
    var form = this.synmap;
    this.wordBase.clear();
    this.wordMap.clear();

    List<SynsetType> type = form.where(
      (s) => this.stringCompare(s.v, laimal) && s.t < 10 && grammar.where((e) => e.w == s.w).length > 0
    ).map(
      (o) => grammar.firstWhere((s) => s.w == o.w)
    ).toSet().toList();

    if (type.length > 0) {
      // NOTE: loves, loved, loving
      // debugPrint('backward');
      this.wordBase = type;
      // result.root = type;
      var formAssociate = form.where(
        (m) => m.d > 0 && type.where((e)=>e.w == m.w).length > 0
      ).toList();
      if (formAssociate.length > 0) this.wordMap = formAssociate;
    }

    List<SynsetType> pos = grammar.where(
      (s) => this.stringCompare(s.v,laimal)
    ).toList();

    if (pos.length > 0) {
      // NOTE: love, hate
      // debugPrint('forward');
      var posAssociate = form.where(
        (m) => m.d > 0 && pos.where((e)=>e.w == m.w).length > 0
      ).toList();
      if (this.wordMap.length == 0){
        this.wordMap = posAssociate;
      }
      if (this.wordBase.length == 0){
        this.wordBase = pos;
      }
    }
  }

  // NOTE: suggestion
  List<WordType> suggest(String laimal)  {
    if (this.keyword == laimal){
      return this.suggestion;
    }
    this.keyword = laimal;
    this.suggestion = [];

    if (laimal != null && laimal.isNotEmpty) {
      this.suggestion = this.wordStartWith(this.keyword).toList();
    }

    return this.suggestion;
  }

  // NOTE: definition (jazz)
  List<ResultModel> search(String laimal)  {
    if (this.searchQuery == laimal){
      return this.definition;
    } else {
      this.searchQuery = laimal;
      this.definition = [];
    }
    if (laimal == null || laimal.isEmpty) {
      return this.definition;
    }

    this.partOfSpeech(this.searchQuery);

    Iterable<WordType> ord;
    ord = this.wordExactMatch(this.searchQuery);

    if (ord.length == 0 && this.wordBase.length > 0 && this.stringCompare(this.wordBase.first.v, this.searchQuery) == false){
      ord = this.wordExactMatch(this.wordBase.first.v);
    }

    for (var w1 in ord) {
      ResultModel newWord = ResultModel(word: w1.v, sense:[]);
      this.definition.add(newWord);

      var d1 = this.sense.where((e) => e.w == w1.w);
      var g1 = d1.map((e) => e.t).toSet();
      for (var gId in g1) {
        // Gaset  grammarPos = this.grammar.pos.firstWhere((i) => i.id == gId);
        // SenseModel newSense = SenseModel(pos: grammarPos.name, clue:[]);
        SenseModel newSense = SenseModel(pos: this.grammar.posName(gId), clue:[]);
        newWord.sense.add(newSense);

        var d2 = d1.where((e) => e.t == gId);
        for (var d3 in d2) {
          ClueModel newClue = ClueModel(mean: d3.v, exam:[]);
          var u1 = this.usage.where((e) => e.i == d3.i);
          newSense.clue.add(newClue);
          for (var u2 in u1) {
            newClue.exam.addAll(u2.v.split('\r\n'));
          }
        }
        // var abcd = this.wordMap.where((e) => e.t == gId).map(
        //   (e) {
        //     // Gamap grammarForm = this.grammar.form.firstWhere((i) => i.id == e.d && i.type == gId);
        //     Gamap grammarForm = this.grammar.form.firstWhere((i) => i.id == e.d && i.type == e.t);
        //     return '${e.v} (${grammarForm.name})';
        //   }
        // ).join('; ');
        var abcd = this.wordMap.where((e) => e.t == gId).map(
          (e) => this.grammar.formName(e)
        ).join('; ');
        newSense.clue.add(ClueModel(mean: abcd, exam:[]));
      }
    }
    return this.definition;
  }

  void toTest() {
  }
}

// Iterable<WordType> get wordValues => Hive.box<WordType>(_wordName).values;
// Iterable<SenseType> get senseValues => Hive.box<SenseType>(_senseName).values;
// Iterable<UsageType> get usageValues => Hive.box<UsageType>(_usageName).values;
// Iterable<SynsetType> get synsetValues => Hive.box<SynsetType>(_synsetName).values;
// Iterable<SynmapType> get synmapValues => Hive.box<SynmapType>(_synmapName).values;

// Iterable<WordType> suggestion(String word) => wordValues.where((e) => e.v.toLowerCase() == word.toLowerCase());
// Iterable<WordType> suggestion(String word) => wordValues.where((e) => new RegExp(word,caseSensitive: false).hasMatch(e.v));
// Iterable<WordType> wordStartWith(String word) => wordValues.where((e) => e.charStartsWith(word));
// Iterable<WordType> wordExactMatch(String word) => wordValues.where((e) => e.charMatchExact(word));