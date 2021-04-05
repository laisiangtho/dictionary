part of 'root.dart';

const List<Map<String, dynamic>> _synset = [
  { "id": 0, "name": "Noun", "shortname": "n" },
  { "id": 1, "name": "Verb", "shortname": "v" },
  { "id": 2, "name": "Adjective", "shortname": "adj" },
  { "id": 3, "name": "Adverb", "shortname": "adv" },
  { "id": 4, "name": "Preposition", "shortname": "prep" },
  { "id": 5, "name": "Conjunction", "shortname": "conj" },
  { "id": 6, "name": "Pronoun", "shortname": "pron" },
  { "id": 7, "name": "Interjection", "shortname": "int" },
  { "id": 8, "name": "Abbreviation", "shortname": "abb" },
  { "id": 9, "name": "Prefix", "shortname": null },
  { "id": 10, "name": "Combining form", "shortname": null },
  { "id": 11, "name": "Phrase", "shortname": 'phra' },
  { "id": 12, "name": "Contraction", "shortname": null },
  { "id": 13, "name": "Punctuation", "shortname": "punc" },
  { "id": 14, "name": "Particle", "shortname": "part" },
  { "id": 15, "name": "Post-positional Marker", "shortname": "ppm" },
  { "id": 16, "name": "Acronym", "shortname": null },
  { "id": 17, "name": "Article", "shortname": null },
  { "id": 18, "name": "Number", "shortname": "tn" }
];

const List<Map<String, dynamic>> _synmap = [
  { "id": 0, "type": 1, "name": "past and past participle"},
  { "id": 1, "type": 0, "name": "plural"},
  { "id": 2, "type": 1, "name": "3rd person"},
  { "id": 3, "type": 1, "name": "past tense" },
  { "id": 4, "type": 1, "name": "past participle"},
  { "id": 5, "type": 1, "name": "present participle"},
  { "id": 6, "type": 2, "name": "comparative"},
  { "id": 7, "type": 2, "name": "superlative"},
  { "id": 8, "type": 1, "name": "1st person"},
  { "id": 9, "type": 1, "name": "2nd person"},
  { "id": 10, "type": 1, "name": "plural past"}
];


class Grammar {
  final List<Gaset> pos;
  final List<Gamap> form;
  Grammar({this.pos, this.form});

  factory Grammar.fromJSON({a:_synset,b:_synmap}) {
    return Grammar(
      pos: a.map<Gaset>((o) => Gaset.fromJSON(o)).toList(),
      form: b.map<Gamap>((o) => Gamap.fromJSON(o)).toList(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'pos': pos.map((e)=>e.toJSON()).toList(),
      'form': form.map((e)=>e.toJSON()).toList()
    };
  }
}

class Gaset {
  final int id;
  final String name;
  final String shortname;
  Gaset({this.id, this.name, this.shortname});

  factory Gaset.fromJSON(Map<String, dynamic> o) {
    return Gaset(
      id: o['id'],
      name: o['name'],
      shortname: o['shortname']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'shortname': shortname
    };
  }
}

class Gamap {
  final int id;
  final int type;
  final String name;
  Gamap({this.id, this.type, this.name});

  factory Gamap.fromJSON(Map<String, dynamic> o) {
    return Gamap(
      id: o['id'] as int,
      type: o['type'] as int,
      name: o['name']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'type': type,
      'name': name
    };
  }
}
