part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();
  // late final bool _hasNav = widget.arguments != null;
  // late final _nav = widget.arguments as ViewNavigationArguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSearch(String ord) {
    /*
    // core.navigate(to: '/search/result', routePush: true);
    // core.navigate(to: '/search/result', routePush: true);
    core.searchQuery = word;
    // core.conclusionGenerate().whenComplete(() => core.navigate(to: '/search/result'));
    // core.navigate(to: '/search/result');
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   core.navigate(to: '/search-result');
    // });
    Future.microtask(() {
      core.navigate(to: '/search-result');
    });
    */
    searchQuery = ord;
    suggestQuery = ord;
    //  core.conclusionGenerate();
    Future.microtask(() {
      core.navigate(to: '/search-result');
      // args?.currentState!.pushNamed('/search-result');
    }).whenComplete(() {
      core.conclusionGenerate();
    });
  }

  void onDelete(String ord) {
    Future.delayed(Duration.zero, () {
      collection.boxOfRecentSearch.delete(ord);
    }).whenComplete(core.notify);
  }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      // message: 'Do you really want to delete all?',
      message: preference.text.confirmToDelete('all'),
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          collection.boxOfRecentSearch.box.clear().whenComplete(core.notify);
        });
      }
    });
  }
}
