import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'recent-search';
  static String label = 'Recent search';
  static IconData icon = LideaIcon.listNested;

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends SearchRecentsStates<Main> {
  @override
  void onSearch(RecentSearchType item) {
    router.go('/');
    router.push('/search', extra: {'keyword': item.word});
  }

  @override
  String get doConfirmMessage => lang.confirmToDelete('all');
  @override
  String get doConfirmTitle => lang.confirmation;
  @override
  String get doConfirmCancel => lang.cancel;
  @override
  String get doConfirmSubmit => lang.confirm;
  @override
  String get labelBack => lang.back;
  @override
  String get labelHeaderTitle => lang.keyword(boxOfRecentSearch.plural.toString());
  @override
  String get labelSectionTitle => lang.recentSearch('false');
  @override
  String get labelDismissibleBackground => lang.delete;
  @override
  String messageOnEmpty(int test) => lang.recentSearchCount(0);
  @override
  String labelItemTrailing(RecentSearchType item) => preference.digit(context, item.hit);
}
