part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void onSort() {
  //   debugPrint('sorting');
  //   // if ()
  //   // dragController.forward()
  //   if (dragController.isCompleted) {
  //     dragController.reverse();
  //   } else {
  //     dragController.forward();
  //   }
  // }

  // final List<String> itemList = List<String>.generate(20, (i) => "Item ${i + 1}");

  void onSearch(String ord) {
    searchQuery = ord;
    suggestQuery = ord;
    core.navigate(to: '/search-result');
    Future.microtask(() {
      core.conclusionGenerate();
    });
  }

  void onDelete(String ord) {
    Future.delayed(Duration.zero, () {
      collection.favoriteDelete(ord);
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
          collection.boxOfFavoriteWord.clearAll().whenComplete(core.notify);
        });
      }
    });
  }
}
