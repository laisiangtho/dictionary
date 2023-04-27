import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'recent-search';
  static String label = 'Recent search';
  static IconData icon = Icons.layers;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('recent-search->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
        ),
        child: ValueListenableBuilder(
          valueListenable: boxOfRecentSearch.listen(),
          builder: (BuildContext _, Box<RecentSearchType> __, Widget? ___) {
            return CustomScrollView(
              controller: _controller,
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
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight, kToolbarHeight],
        // overlapsBackgroundColor: state.theme.primaryColor,
        // overlapsBorderColor: state.theme.shadowColor,
        // overlapsBorderColor: state.theme.dividerColor.withOpacity(0.5),
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      ViewSection(
        show: boxOfRecentSearch.isNotEmpty,

        onAwait: const ViewFeedback.await(),
        // onAwait: ViewFeedback.message(
        //   label: App.preference.text.aMoment,
        // ),
        onEmpty: ViewFeedback.message(
          label: App.preference.text.recentSearchCount(0),
        ),
        child: ViewBlockCard.fill(
          child: listContainer(),
        ),
        // child: ViewBlockCard(
        //   clipBehavior: Clip.hardEdge,
        //   child: _recentBlock(items),
        // ),
      ),
    ];
  }

  Widget listContainer() {
    final items = boxOfRecentSearch.values.toList();
    items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewListBuilder(
      primary: false,
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          leading: Icon(Icons.north_east_rounded),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(
          primary: false,
        );
      },
      itemCount: items.length,
      duration: kThemeChangeDuration,
    );
  }

  Widget itemContainer(int index, RecentSearchType item) {
    // final abc = App.core.scripturePrimary.bookById(bookmark.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(item.date.toString()),
      direction: DismissDirection.startToEnd,
      background: _recentDismissibleBackground(),
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.8,
        DismissDirection.endToStart: 0.1,
      },

      confirmDismiss: (direction) async {
        // DismissDirection.startToEnd
        if (direction == DismissDirection.startToEnd) {
          return await onDelete(item.word);
        }
        return false;
      },
      onUpdate: (detail) {
        _itemRecentBackgroundNotifier.value = detail.progress;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        title: Text(
          // history.value.word,
          item.word,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),
        trailing: Text(
          // App.core.scripturePrimary.digit(bookmark.chapterId),
          item.hit.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () => onSearch(item.word),
        // onTap: () {
        //   App.route.pushNamed(
        //     'home/search',
        //     arguments: {'keyword': item.word},
        //   );
        // },
      ),
    );
  }

  Widget _recentDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ValueListenableBuilder<double>(
        valueListenable: _itemRecentBackgroundNotifier,
        builder: (context, val, child) {
          return Padding(
            padding: EdgeInsets.only(left: 15 * val),
            child: child,
          );
        },
        child: Text(
          preference.text.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
