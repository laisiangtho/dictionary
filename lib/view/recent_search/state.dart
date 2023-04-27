part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  late final boxOfRecentSearch = App.core.data.boxOfRecentSearch;

  late final ValueNotifier<double> _itemRecentBackgroundNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
  }

  void onSearch(String ord) {
    debugPrint('recent-search new: $ord old: ${data.searchQuery}');
    if (data.searchQuery != ord) {
      // debugPrint('needed to upate definition $ord');
      data.boxOfSettings.searchQuery(value: ord);
      data.boxOfSettings.suggestQuery(value: ord);
      App.core.conclusionGenerate();
    }
    App.route.pushNamed(
      'home/search',
      arguments: {'keyword': ord},
    );
  }

  Future<bool?> onDelete(String ord) async {
    return boxOfRecentSearch.delete(ord);
  }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      message: App.preference.text.confirmToDelete('all'),
      title: App.preference.text.confirmation,
      cancel: App.preference.text.cancel,
      confirm: App.preference.text.confirm,
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          // App.core.clearBookmarkWithNotify();
          boxOfRecentSearch.clearAll();
        });
      }
    });
  }
}
