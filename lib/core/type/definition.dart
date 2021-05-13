part of "root.dart";

// class ResultModel{
//   String word;
//   List<SenseModel> sense;
//   List<String> thesaurus;

//   ResultModel({
//     this.word,
//     this.sense,
//     this.thesaurus,
//   });

//   factory ResultModel.fromJSON(Map<String, dynamic> o) {
//     return ResultModel(
//       word: o["w"] as String,
//       sense: [],
//       thesaurus: [],
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "word":word,
//       "sense":sense.map((e)=>e.toJSON()).toList(),
//       "thesaurus":thesaurus.toList()
//     };
//   }
// }

// class SenseModel{
//   String pos;
//   List<ClueModel> clue;

//   SenseModel({
//     this.pos,
//     this.clue
//   });

//   factory SenseModel.fromJSON(Map<String, dynamic> o) {
//     return SenseModel(
//       pos: o["w"] as String,
//       clue: []
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "pos":pos,
//       "clue":clue.map((e)=>e.toJSON()).toList()
//     };
//   }
// }

// class ClueModel{
//   String mean;
//   List<String> exam;

//   ClueModel({
//     this.mean,
//     this.exam
//   });

//   factory ClueModel.fromJSON(Map<String, dynamic> o) {
//     return ClueModel(
//       mean: o["w"] as String,
//       exam: []
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "mean": mean,
//       "exam": exam.toList()
//     };
//   }
// }
