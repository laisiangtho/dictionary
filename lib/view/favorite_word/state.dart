part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  // late final boxOfBookmarks = App.core.data.boxOfBookmarks;
  late final boxOfFavoriteWord = App.core.data.boxOfFavoriteWord;

  late final ValueNotifier<double> _itemFavoriteBackgroundNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    // setIfFavoriteWordEmpty();
  }

  // void setIfFavoriteWordEmpty() {
  //   if (boxOfFavoriteWord.isEmpty) {
  //     boxOfFavoriteWord.clearAll().whenComplete(() {
  //       boxOfFavoriteWord.box.addAll([
  //         FavoriteWordType(word: 'abc', date: DateTime.now()),
  //         FavoriteWordType(word: '345', date: DateTime.now()),
  //         FavoriteWordType(word: 'ab2fc', date: DateTime.now()),
  //       ]);
  //     });
  //   }
  // }

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
          // collection.boxOfBookmark.clear().whenComplete(core.notify);
          // App.core.clearBookmarkWithNotify();
          boxOfFavoriteWord.clearAll();
        });
      }
    });
  }

  Future<bool?> onDelete(dynamic key) {
    return boxOfFavoriteWord.deleteAtKey(key);
  }

  // void onSearch(String ord) {
  //   // data.searchQuery = ord;
  //   // data.suggestQuery = ord;
  //   // core.navigate(to: '/search-result');
  //   // App.route.pushNamed('home/search', arguments: {'keyword': ord});
  //   // Future.microtask(() {
  //   //   core.conclusionGenerate();
  //   // });
  //   core.conclusionGenerate().whenComplete(() {
  //     route.pushNamed('home/search', arguments: {'keyword': ord});
  //   });
  // }

  void onSearch(String ord) {
    if (data.searchQuery != ord) {
      data.boxOfSettings.searchQuery(value: ord);
      data.boxOfSettings.suggestQuery(value: ord);
      App.core.conclusionGenerate();
    }
    App.route.pushNamed(
      'home/search',
      arguments: {'keyword': ord},
    );
  }

  // Future<void> onDelete(int index) {
  //   return Future.microtask(() {
  //     // boxOfFavoriteWord.delete(ord);
  //     boxOfFavoriteWord.deleteAtIndex(index);
  //   }).whenComplete(core.notify);

  //   // Future.microtask((){
  //   //   boxOfFavoriteWord.delete(ord);
  //   // }).whenComplete(core.notify);
  // }

  // void onNav(int book, int chapter) {
  //   // NotifyNavigationButton.navigation.value = 1;
  //   // core.chapterChange(bookId: book, chapterId: chapter);
  //   // Future.delayed(const Duration(milliseconds: 150), () {
  //   //   // core.definitionGenerate(word);
  //   //   // core.navigate(at: 1);
  //   //   App.route.pushNamed('read');
  //   // });
  //   // // Future.delayed(Duration.zero, () {
  //   // //   core.historyAdd(word);
  //   // // });
  // }

  // Future<bool> onDelete(int index) {
  //   // Future.microtask((){});
  //   // Future.delayed(Duration.zero, () {
  //   // });
  //   // Do you want to delete this Bookmark?
  //   // Do you want to delete all the Bookmarks?
  //   return doConfirmWithDialog(
  //     context: context,
  //     // message: 'Do you want to delete this Bookmark?',
  //     message: preference.text.confirmToDelete(''),
  //     title: preference.text.confirmation,
  //     cancel: preference.text.cancel,
  //     confirm: preference.text.confirm,
  //   ).then((confirmation) {
  //     if (confirmation != null && confirmation) {
  //       core.deleteBookmarkWithNotify(index);
  //       return true;
  //     }
  //     return false;
  //   });
  // }
}
