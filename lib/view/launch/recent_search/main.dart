import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({
    Key? key,
    this.arguments,
  }) : super(key: key);

  final Object? arguments;

  static const route = '/recent-search';
  static const icon = LideaIcon.layers;
  static const name = 'Recent search';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  late Core core;

  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;

  // AppLocalizations get translate => AppLocalizations.of(context)!;
  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onSearch(String ord) async {
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
    core.searchQuery = ord;
    core.suggestQuery = ord;
    await core.conclusionGenerate();
    Future.microtask(() {
      core.navigate(to: '/search-result');
    }).whenComplete(() async {
      // await core.conclusionGenerate();
    });
  }

  void onDelete(String ord) {
    Future.delayed(Duration.zero, () {
      core.collection.recentSearchDelete(ord);
    }).whenComplete(core.notify);
  }

  void onClearAll() {
    Future.microtask(() {
      core.collection.boxOfRecentSearch.clear().whenComplete(core.notify);
    });
  }
}

// FlutterError (A dismissed Dismissible widget is still part of the tree.
// Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once that handler has fired.
class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      // controller: scrollController,
      child: Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
        selector: (_, e) => e.collection.recentSearches.toList(),
        builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
          return body(items);
        },
      ),
    );
  }

  CustomScrollView body(List<MapEntry<dynamic, RecentSearchType>> items) {
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(items.isNotEmpty),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('...'),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return listContainer(index, items.elementAt(index));
              },
              childCount: items.length,
            ),
          ),
      ],
    );
  }

  Widget listContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    final word = item.value.word;
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) async {
      //   onDelete(index);
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
      // },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            // message: 'Do you want to delete "$word"?',
            message: preference.text.confirmToDelete('this'),
          );
          if (confirmation != null && confirmation) {
            onDelete(word);
            return true;
          } else {
            return false;
          }
        }
      },
      // Show a red background as the item is swiped away.
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(CupertinoIcons.delete_simple),
      ),
      child: Container(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(0),
        // ),
        // margin: const EdgeInsets.only(bottom: 1, top: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: .3,
              color: Theme.of(context).shadowColor,
            ),
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.call_made),
          // minLeadingWidth: 10,
          title: Text(word),
          // trailing: (item.value.hit > 1)
          //     ? Chip(
          //         avatar: const CircleAvatar(
          //           backgroundColor: Colors.transparent,
          //           child: Icon(Icons.timeline),
          //         ),
          //         label: Text(item.value.hit.toString()),
          //       )
          //     : const SizedBox(),
          trailing: (item.value.hit > 1)
              ? Chip(
                  backgroundColor: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  avatar: const CircleAvatar(
                    // backgroundColor: Colors.transparent,
                    radius: 7,
                    // child: Icon(
                    //   Icons.hdr_strong,
                    //   // color: Theme.of(context).primaryColor,
                    // ),
                  ),
                  label: Text(
                    item.value.hit.toString(),
                  ),
                )
              : const SizedBox(),
          onTap: () => onSearch(word),
        ),
      ),
    );
  }
}
