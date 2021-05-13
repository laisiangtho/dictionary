part of 'core.dart';

mixin _Mock on _Collection {

  Future<List<Map<String, Object>>> suggestionGenerate(String word) async {

    // final List<Map<String, Object>> result = [
    //   {"word","abc"} as Map
    // ];
    // result.add({"word","suggestion"} as Map);
    // yield result;
    final List<Map<String, Object>> result = await sql.suggestion(word);
    // print(result.toString());
    return result;
    // result.first.values
    // final abc = result.elementAt(0);
    // final words = abc.values.first;
    // print(words);
    // final apple = this.suggestQuery.stream.toList();
    // print(word);
    //
    // this.suggestList.add(result);
    // this.suggestList.sink.add(result);
  }

  /// TODO: definition on multi words
  Future<List<Map<String, dynamic>>> definition(String word) async {
    debugPrint('search start: $word');
    if (word.isNotEmpty && collection.setting.searchQuery != word){
      this._settingUpdate(collection.setting.copyWith(searchQuery: word));
    }
    List<Map<String, Object>> raw = [];
    List<Map<String, Object>> root;
    List<Map<String, Object>> rawSense;

    rawSense = await sql.search(word);
    if (rawSense.isEmpty){
      root = await sql.rootWord(word);
      if (root.isNotEmpty){
        final i = root.map((e) => e['word'].toString()).toSet().toList();
        for (String e in i){
          final r = await sql.search(e);
          if (r.isNotEmpty){
            raw.addAll(r);
          }
        }
      }
    } else {
      root = await sql.baseWord(word);
      raw.addAll(rawSense);
    }
    if (root.isNotEmpty){
      final tmp = this.groupByBase(root);
      raw.addAll(tmp);
    }

    final result = this.groupByWord(raw);

    final words = raw.map((e) => e['word'].toString()).toSet().toList();
    for (String str in words){
      final thes = await sql.thesaurus(str);
      if (thes.isNotEmpty){
        final wordBlock = result.firstWhere((e) => e['word'] == str);
        wordBlock['thesaurus'] = thes.map((e) => e['word'].toString()).toSet().toList();
      }
    }
    // result.forEach((a1) {
    //   debugPrint('word: ${a1["word"]}');
    //   a1['sense'].forEach((a2) {
    //     debugPrint(' pos: ${a2["pos"]}');
    //     a2['clue'].forEach((a3) {
    //       debugPrint('  def: $a3');
    //     });
    //   });
    //   debugPrint('thesaurus: ${a1["thesaurus"]}');
    // });

    debugPrint('search end: $word');
    return result;
  }

  List<Map<String, dynamic>> groupByWord(List<Map<String, Object>> raw) {
    return raw.fold(Map<String, List<dynamic>>(), (Map<String, List<dynamic>> a, b) {
      a.putIfAbsent(b['word'], () => []).add(b);
      return a;
    }).values.map((e) =>{
      'word': e.first['word'],
      'sense': this.groupByPOS(e),
      'thesaurus': []
    }).toList();
  }

  List<Map<String, dynamic>> groupByPOS(List<dynamic> raw) {
    return raw.fold(Map<int, List<Map<String, dynamic>>>(), (Map<int, List<Map<String, dynamic>>> a, b) {
      a.putIfAbsent(b['wrte'], () => []).add(b);
      return a;
    }).values.map((e) => {
      'pos': collection.env.grammar(e.first['wrte']).name,
      'clue': this.groupSense(e)
    }).toList();
  }

  List<Map<String, dynamic>> groupSense(List<Map<String, dynamic>> raw) {
    final List<Map<String, dynamic>> result = [];
    for (var row in raw) {
      String mean;
      List<String> exam = [];
      if (row.containsKey('sense')){
        if (row['exam'] !=null){
          exam = row['exam'].split("\r\n");
        }
        mean = row['sense'];
      } else {
        final pos = collection.env.pos(row['dete']).name;
        // final pos = collection.env.grammar(row['wrte']).name;
        mean = '[~:${row['derived']}] ($pos)';
      }
      result.add({'mean':mean,'exam':exam});
    }
    return result;
  }

  List<Map<String, dynamic>> groupByBase(List<dynamic> raw) {
    return raw.fold(Map<int, List<Map<String, dynamic>>>(), (Map<int, List<Map<String, dynamic>>> a, b) {
      a.putIfAbsent(b['wrte'], () => []).add(b);
      return a;
    }).values.map((e) => {
      'word': e.first['word'],
      'wrte': e.first['wrte'],
      'sense': e.map<String>(
        (o) {
          final _derived = o['derived'];
          final _pos = collection.env.pos(o['dete']).name;
          return '[~:$_derived] ($_pos)';
        }
      ).join('; '),
      'exam': null
    }).toList();
  }

}
