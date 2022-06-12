import 'package:flutter/material.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
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

  static const route = '/search-suggest';
  static const icon = LideaIcon.search;
  static const name = 'Suggestion';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      // Selector<Core, bool>(
      //   selector: (BuildContext _, Core e) => e.nodeFocus,
      //   builder: (BuildContext _, bool word, Widget? child) {
      //     return bar();
      //   },
      // ),
      SliverLayoutBuilder(
        builder: (BuildContext context, constraints) {
          final innerBoxIsScrolled = constraints.scrollOffset > 0;
          return ViewHeaderSliverSnap(
            pinned: true,
            floating: false,
            padding: MediaQuery.of(context).viewPadding,
            heights: const [kToolbarHeight],
            // overlapsBackgroundColor: Theme.of(context).primaryColor,
            overlapsBorderColor: Theme.of(context).shadowColor,
            // overlapsForce:focusNode.hasFocus,
            // overlapsForce:core.nodeFocus,
            overlapsForce: innerBoxIsScrolled,
            // borderRadius: Radius.elliptical(20, 5),
            builder: bar,
          );
        },
      ),
      Selector<Core, SuggestionType<OfRawType>>(
        selector: (_, e) => e.collection.cacheSuggestion,
        builder: (BuildContext context, SuggestionType<OfRawType> o, Widget? child) {
          if (o.query.isEmpty) {
            return _suggestNoQuery();
          } else if (o.raw.isNotEmpty) {
            return _suggestBlock(o);
          } else {
            // return _msg('No suggestion);
            return _msg(preference.text.noItem(preference.text.suggestion(false)));
          }
        },
      )
    ];
  }

  Widget _msg(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _suggestNoQuery() {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.boxOfRecentSearch.entries,
      builder: (BuildContext _, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        return WidgetBlockSection(
          show: items.isNotEmpty,
          duration: const Duration(milliseconds: 270),
          headerLeading: WidgetLabel(
            label: preference.text.recentSearch(items.length > 1),
          ),
          placeHolder: _msg(preference.text.aWordOrTwo),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
            child: Material(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).shadowColor,
                  width: 0.5,
                ),
              ),
              child: _recentBlock(items),
            ),
          ),
        );
      },
    );
  }

  // listView
  Widget _suggestBlock(SuggestionType<OfRawType> o) {
    return WidgetBlockSection(
      headerLeading: WidgetLabel(
        label: preference.text.suggestion(o.raw.length > 1),
      ),
      child: WidgetBlockFill(
        child: WidgetListBuilder(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final snap = o.raw.elementAt(index);

            int ql = suggestQuery.length;
            String word = snap.term;
            int wl = word.length;
            return _suggestItem(word, ql < wl ? ql : wl);
          },
          itemSeparator: (BuildContext context, int index) {
            return const WidgetListDivider();
          },
          itemCount: o.raw.length,
        ),
      ),
    );
  }

  Widget _suggestItem(String word, int hightlight) {
    return ListTile(
      leading: const Icon(Icons.north_east_rounded),
      title: Text.rich(
        TextSpan(
          text: word.substring(0, hightlight),
          semanticsLabel: word,
          style: TextStyle(
            fontSize: 22,
            // color: Theme.of(context).textTheme.bodySmall!.color,
            // color: Theme.of(context).highlightColor,
            color: Theme.of(context).primaryColorDark,
            // fontWeight: FontWeight.w500
          ),
          children: <TextSpan>[
            TextSpan(
              text: word.substring(hightlight),
              // style: Theme.of(context).primaryTextTheme.bodyMedium,
              style: TextStyle(
                // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
                color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
                // color: Theme.of(context).primaryColor,
                // fontWeight: FontWeight.w300
              ),
            )
          ],
        ),
      ),
      onTap: () => onSearch(word),
    );
  }

  // Recent searches
  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return WidgetListBuilder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _recentContainer(index, items.elementAt(index));
      },
      itemSeparator: (BuildContext context, int index) {
        return const WidgetListDivider();
      },
      itemCount: items.length,
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      background: _listDismissibleBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
        return null;
      },
      child: ListTile(
        leading: const Icon(Icons.north_east_rounded),
        title: _recentItem(item.value.word),
        onTap: () => onSuggest(item.value.word),
      ),
    );
  }

  Widget _recentItem(String word) {
    int hightlight = suggestQuery.length < word.length ? suggestQuery.length : word.length;
    return Text.rich(
      TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        style: TextStyle(
          fontSize: 22,
          // color: Theme.of(context).highlightColor,
          color: Theme.of(context).primaryColorDark,
          // color: Theme.of(context).textTheme.bodySmall!.color,
          // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
          fontWeight: FontWeight.w300,
        ),
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
              color: Theme.of(context).primaryTextTheme.bodyLarge!.color,
            ),
          )
        ],
      ),
    );
  }

  Widget _listDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          preference.text.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
