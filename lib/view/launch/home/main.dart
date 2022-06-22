import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/home';
  static const icon = LideaIcon.search;
  static const name = 'Home';
  static const description = '...';

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: Consumer<Authentication>(
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext context, Authentication aut, Widget? child) {
    return CustomScrollView(
      controller: scrollController,
      slivers: sliverWidgets(),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 70],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        // overlapsBorderColor: Theme.of(context).shadowColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        builder: bar,
      ),
      const PullToRefresh(),

      WidgetBlockSection(
        headerTitle: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.recentSearch(true),
        ),
        headerTrailing: WidgetButton(
          message: preference.text.addTo(preference.text.recentSearch(true)),
          onPressed: () {
            core.navigate(to: '/recent-search');
          },
          child: const WidgetLabel(
            icon: Icons.more_horiz,
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: researchWrap(),
          ),
        ),
      ),
      WidgetBlockSection(
        headerTitle: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.favorite(true),
        ),
        headerTrailing: WidgetButton(
          message: preference.text.addTo(preference.text.favorite(true)),
          onPressed: () {
            core.navigate(to: '/favorite-word');
          },
          child: const WidgetLabel(
            icon: Icons.more_horiz,
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: favoriteWrap(),
          ),
        ),
      ),
      // SliverPadding(
      //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      //   sliver: SliverList(
      //     delegate: SliverChildListDelegate(
      //       [
      //         ListTile(
      //           leading: const Icon(Icons.search),
      //           title: const Text('Search: suggest'),
      //           onTap: () => core.navigate(to: '/search'),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.search),
      //           title: const Text('Search: result'),
      //           onTap: () => core.navigate(to: '/search-result'),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.manage_search_rounded),
      //           title: const Text('Recent search'),
      //           onTap: () => core.navigate(to: '/recent-search'),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.inventory_rounded),
      //           title: const Text('Store'),
      //           onTap: () => core.navigate(to: '/store'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    ];
  }

  Widget researchWrap() {
    return Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.boxOfRecentSearch.entries.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
        if (items.isEmpty) {
          return const Icon(LideaIcon.dotHoriz);
        }
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          textDirection: TextDirection.ltr,
          children: items.take(3).map(
            (e) {
              return WidgetButton(
                child: WidgetMark(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  label: e.value.word,
                ),
                onPressed: () => onSearch(e.value.word),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget favoriteWrap() {
    return Selector<Core, List<MapEntry<dynamic, FavoriteWordType>>>(
      selector: (_, e) => e.collection.favorites.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, FavoriteWordType>> items, Widget? __) {
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
        if (items.isEmpty) {
          return const Icon(LideaIcon.dotHoriz);
        }
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          textDirection: TextDirection.ltr,
          children: items.take(3).map(
            (e) {
              return WidgetButton(
                child: WidgetMark(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  label: e.value.word,
                ),
                onPressed: () => onSearch(e.value.word),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
