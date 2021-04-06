part of 'root.dart';

class Collection{
  Grammar grammar;
  Iterable<WordType> word;
  Iterable<SenseType> sense;
  Iterable<UsageType> usage;
  Iterable<SynsetType> synset;
  Iterable<SynmapType> synmap;
  String keyword;
  Iterable<String> test;

  Collection({
    this.grammar,
    this.word,
    this.sense,
    this.usage,
    this.synset,
    this.synmap,
    this.test,
    this.keyword
  });

  factory Collection.fromJSON() {
    return Collection(
      grammar: Grammar.fromJSON(),
      word: [],
      sense: [],
      synset: [],
      usage: [],
      synmap: [],
      test: [],
      keyword:''
    );
  }

  Iterable<WordType> wordStartWith(String keyword) {
    return word.where((e) => e.charStartsWith(keyword));
  }

  Iterable<WordType> wordExactMatch(String keyword) {
    return word.where((e) => e.charMatchExact(keyword));
  }

  bool stringCompare(String a, String b) => a.toLowerCase() == b.toLowerCase();

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