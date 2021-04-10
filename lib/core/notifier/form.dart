
import 'package:flutter/foundation.dart';
import 'package:dictionary/core.dart';

class FormNotifier extends ChangeNotifier {
  String _suggestionWord;
  String _searchWord;
  String get keyword => _suggestionWord;
  set keyword(String word) {
    _suggestionWord = word;
    notifyListeners();
  }

  String get searchQuery => _searchWord;
  set searchQuery(String word) {
    _searchWord = word;
    notifyListeners();
  }
}

class FormData {
  String keyword = Core.instance.collection.setting.searchQuery;
  String searchQuery = Core.instance.collection.setting.searchQuery;
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
