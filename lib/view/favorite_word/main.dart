import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'favorite-word';
  static String label = 'Favorite';
  static IconData icon = Icons.loyalty;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('favorite-word->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: scrollController.bottom,
          notifier: app.bottom,
        ),
        child: ValueListenableBuilder(
          valueListenable: boxOfFavoriteWord.listen(),
          builder: (BuildContext _, Box<FavoriteWordType> __, Widget? ___) {
            return CustomScrollView(
              controller: scrollController,
              slivers: _slivers,
            );
          },
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.media.viewPadding,
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      // listContainer(),
      ViewSections(
        show: boxOfFavoriteWord.isNotEmpty,
        onAwait: const ViewFeedbacks.await(),
        onEmpty: const ViewFeedbacks.empty(),
        child: ViewCards.fill(
          child: listContainer(),
        ),
      ),
    ];
  }

  Widget listContainer() {
    final items = boxOfFavoriteWord.entries.toList();
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    // final items = boxOfFavoriteWord.values.toList();
    // items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewLists.separator(
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemSnap: const ListTile(
        leading: Icon(Icons.north_east_rounded),
      ),
      separator: (BuildContext context, int index) {
        return const ViewDividers();
      },
      itemCount: items.length,
      duration: kThemeChangeDuration,
    );
  }

  Widget itemContainer(int index, MapEntry<dynamic, FavoriteWordType> item) {
    // final abc = App.core.scripturePrimary.bookById(bookmark.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(item.value.date.toString()),
      // direction: DismissDirection.endToStart,
      // background: dismissiblesFromRight(),

      // confirmDismiss: (direction) async {
      //   if (direction == DismissDirection.endToStart) {
      //     return await onDelete(item.key);
      //   }
      //   return false;
      // },
      direction: DismissDirection.startToEnd,
      // itemDismissibleBackground
      background: _itemDismissibleBackground(),
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.8,
        DismissDirection.endToStart: 0.1,
      },

      confirmDismiss: (direction) async {
        // DismissDirection.startToEnd
        if (direction == DismissDirection.startToEnd) {
          return await onDelete(item.key);
        }
        return false;
      },
      onUpdate: (detail) {
        _itemFavoriteBackgroundNotifier.value = detail.progress;
      },

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        title: Text(
          // history.value.word,
          item.value.word,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),
        // trailing: Text(
        //   // App.core.scripturePrimary.digit(bookmark.chapterId),
        //   item.hit.toString(),
        //   style: const TextStyle(fontSize: 18),
        // ),
        onTap: () {
          onSearch(item.value.word);
        },
      ),
    );
  }

  Widget _itemDismissibleBackground() {
    return ViewMarks(
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
      ),
      mainAxisAlignment: MainAxisAlignment.start,
      badge: '23',
      child: ValueListenableBuilder<double>(
        valueListenable: _itemFavoriteBackgroundNotifier,
        builder: (context, val, child) {
          return Padding(
            padding: EdgeInsets.only(left: 50 * val),
            child: child,
          );
        },
        child: Text(
          lang.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
