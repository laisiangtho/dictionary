part of 'main.dart';

abstract class _State extends CommonStates<Main> {
  late final ScrollController scrollController = ScrollController();

  // late final boxOfBookmarks = data.boxOfBookmarks;
  late final boxOfFavoriteWord = data.boxOfFavoriteWord;

  late final ValueNotifier<double> _itemFavoriteBackgroundNotifier = ValueNotifier(0.0);

  // @override
  // void initState() {
  //   super.initState();
  //   // setIfFavoriteWordEmpty();
  // }

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
      message: lang.confirmToDelete('all'),
      title: lang.confirmation,
      cancel: lang.cancel,
      confirm: lang.confirm,
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
  //   // App.routeOld.pushNamed('home/search', arguments: {'keyword': ord});
  //   // Future.microtask(() {
  //   //   core.conclusionGenerate();
  //   // });
  //   core.conclusionGenerate().whenComplete(() {
  //     routeOld.pushNamed('home/search', arguments: {'keyword': ord});
  //   });
  // }

  void onSearch(String ord) {
    if (data.searchQuery != ord) {
      data.boxOfSettings.searchQuery(value: ord);
      data.boxOfSettings.suggestQuery(value: ord);
      App.core.conclusionGenerate();
    }
    // routeOld.pushNamed(
    //   'home/search',
    //   arguments: {'keyword': ord},
    // );
    app.route.page.push('/search', extra: {'keyword': ord});
    // app.route.page.
    // app.to.push();
    // app.router.push()
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
  //   //   App.routeOld.pushNamed('read');
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
  //     message: lang.confirmToDelete(''),
  //     title: lang.confirmation,
  //     cancel: lang.cancel,
  //     confirm: lang.confirm,
  //   ).then((confirmation) {
  //     if (confirmation != null && confirmation) {
  //       core.deleteBookmarkWithNotify(index);
  //       return true;
  //     }
  //     return false;
  //   });
  // }
}
