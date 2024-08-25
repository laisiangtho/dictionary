import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

part 'state.dart';
part 'header.dart';
part 'inspect_process.dart';
part 'inspect_route.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'home';
  static String label = 'Home';
  static IconData icon = LideaIcon.flag;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  // late final abc = core.sql.testDeleteIt('love');
  // late final xyz = core.sql.search('love');

  @override
  Widget build(BuildContext context) {
    debugPrint('home->build');

    // core.sql.search('love').then((value) {
    //   debugPrint('db-query $value');
    // });

    // xyz.then((value) {
    //   debugPrint('db-query $value');
    // });
    // $uid.$name

    // await txn.rawQuery('SELECT * FROM sqlite_master WHERE type =?;', ['index']).then((tid) {
    //     debugPrint('db-type-index $tid');
    //     debugPrint('db-PRAGMA database_list $dl');
    //     debugPrint('db-??? ${_wordContext.createIndex}');
    //     debugPrint('db-??? ${_deriveContext.createIndex}');
    //     if (tid.isEmpty) {
    //       batch.execute(_wordContext.createIndex!);
    //       batch.execute(_deriveContext.createIndex!);
    //     }
    //   });

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: scrollController.bottom,
          notifier: app.bottom,
        ),

        // snap: _viewSnap,
        child: CustomScrollView(
          controller: scrollController,
          slivers: _slivers,
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
        heights: const [kToolbarHeight, 100],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      const PullToRefresh(),
      // const InspectProcess(),
      // const InspectRoute(),

      /// Favorite book
      // ValueListenableBuilder(
      //   valueListenable: App.core.data.boxOfBooks.listen(),
      //   builder: bookList,
      // ),

      /// Recent search
      ValueListenableBuilder(
        valueListenable: App.core.data.boxOfRecentSearch.listen(),
        builder: recentSearch,
      ),
    ];
  }

  Widget recentSearch(BuildContext context, Box<RecentSearchType> box, Widget? child) {
    // return const SliverToBoxAdapter(
    //   child: Text('abc'),
    // );
    // items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    final items = box.values.toList();

    items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewSections(
      show: items.isNotEmpty,
      headerTitle: Text(
        preference.text.recentSearch('true'),
      ),
      headerTrailing: ViewButtons(
        message: preference.text.addTo(preference.text.recentSearch('true')),
        onPressed: () {
          route.pushNamed('home/recent-search');
        },
        child: const ViewMarks(
          icon: Icons.more_horiz,
        ),
      ),
      child: ViewCards(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.ltr,
            children: items.take(3).map(
              (e) {
                return ViewButtons(
                  style: state.theme.textTheme.bodyLarge,
                  child: ViewMarks(
                    // padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    label: e.word,
                  ),
                  // onPressed: () => onSearch(e.value.word),
                  onPressed: () {
                    route.pushNamed(
                      'home/search',
                      arguments: {'keyword': e.word},
                    );
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class PullToRefresh extends PullToActivate {
  const PullToRefresh({super.key});

  @override
  State<PullToActivate> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  // late final Core core = context.read<Core>();
  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    // await App.core.updateBookMeta();
    // await Future.delayed(const Duration(milliseconds: 100));
    // await App.core.data.updateToken();
    // await Future.delayed(const Duration(milliseconds: 400));
  }
}
