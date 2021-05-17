
import 'package:flutter/foundation.dart';
// import 'package:dictionary/core.dart';

// class FormNotifier extends ChangeNotifier {
//   String _suggestionWord;
//   String _searchWord;
//   String get keyword => _suggestionWord;
//   set keyword(String word) {
//     if (_suggestionWord != word){
//       _suggestionWord = word;
//       notifyListeners();
//     }
//   }

//   String get searchQuery => _searchWord;
//   set searchQuery(String word) {
//     _searchWord = word;
//     notifyListeners();
//   }
// }

// class FormData {
//   String keyword = Core.instance.collection.setting.searchQuery;
//   String searchQuery = Core.instance.collection.setting.searchQuery;
// }

class HistoryNotifier extends ChangeNotifier {
  int _current = 0;
  int _next = 0;
  int _previous = 0;

  int get next => _next;
  int get previous => _previous;

  int get current => _current;
  set current(int index) {
    _current = index;
    notifyListeners();
  }
}

class NodeNotifier extends ChangeNotifier {
  bool _hasFocus = false;

  bool get focus => _hasFocus;
  set focus(bool newFocus) {
    if (newFocus != _hasFocus){
      _hasFocus = newFocus;
      notifyListeners();
    }
  }
}

// class TestNotifier extends ChangeNotifier {
//   String _value = '';

//   String get word => _value;
//   set word(String v) {
//     if (v != _value){
//       _value = v;
//       notifyListeners();
//     }
//   }
// }

// class SuggestQueryNotifier extends ChangeNotifier {
//   String _value = '';

//   String get word => _value;
//   set word(String v) {
//     if (v != _value){
//       _value = v;
//       notifyListeners();
//     }
//   }
// }

// class SuggestListNotifier extends ChangeNotifier {
//   List<Map<String, Object>> _value;

//   List<Map<String, Object>> get data => _value;
//   set data(List<Map<String, Object>> v) {
//     _value = v;
//     notifyListeners();
//   }
// }
