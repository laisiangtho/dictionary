import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
// import '/widget/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.navigatorKey, this.arguments}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/search-suggest';
  static const icon = LideaIcon.search;
  static const name = 'Suggestion';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

/*
on initState(searchQuery)
  get -> core.collection.searchQuery
onSearch
  set -> core.collection.searchQuery from core.searchQuery
onCancel
  restore -> core.searchQuery from core.collection.searchQuery
  update -> textController.text
*/
abstract class _State extends State<Main> with TickerProviderStateMixin {
  late Core core;

  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  GlobalKey<NavigatorState> get navigator => arguments.navigator!;
  ViewNavigationArguments get parent => arguments.args as ViewNavigationArguments;
  bool get canPop => arguments.args != null;

  late final AnimationController clearController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  ); //..repeat();
  late final Animation<double> clearAnimation = CurvedAnimation(
    parent: clearController,
    curve: Curves.fastOutSlowIn,
  );
  // late final Animation<double> clearAnimation = Tween(
  //   begin: 0.0,
  //   end: 1.0,
  // ).animate(clearController);
  // late final Animation clearAnimations = ColorTween(
  //   begin: Colors.red, end: Colors.green
  // ).animate(clearController);

  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    onQuery();

    focusNode.addListener(() {
      core.nodeFocus = focusNode.hasFocus;
    });

    scrollController.addListener(() {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
        Future.microtask(() {
          clearToggle(false);
        });
      }
    });

    // FocusScope.of(context).requestFocus(FocusNode());
    // FocusScope.of(context).unfocus();

    textController.addListener(() {
      clearToggle(textController.text.isNotEmpty);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    clearController.dispose();
    super.dispose();
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  String get searchQuery => core.searchQuery;
  set searchQuery(String ord) {
    core.searchQuery = ord;
  }

  String get suggestQuery => core.suggestQuery;
  set suggestQuery(String ord) {
    core.suggestQuery = ord.replaceAll(RegExp(' +'), ' ').trim();
  }

  void onQuery() async {
    Future.microtask(() {
      textController.text = core.suggestQuery;
    });
  }

  void onClear() {
    textController.clear();
    suggestQuery = '';
    core.suggestionGenerate();
  }

  void clearToggle(bool show) {
    if (show) {
      clearController.forward();
    } else {
      clearController.reverse();
    }
  }

  void onCancel() {
    focusNode.unfocus();
    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      suggestQuery = searchQuery;
      onQuery();
      Navigator.of(context).pop(false);
      // navigator.currentState!.maybePop();
      // Navigator.of(context).maybePop(false);
    });
  }

  void onSuggest(String ord) {
    // suggestQuery = str;
    // Future.microtask(() {
    //   core.suggestionGenerate();
    // });
    suggestQuery = ord;
    // on recentHistory select
    if (textController.text != ord) {
      textController.text = ord;
      if (focusNode.hasFocus == false) {
        Future.delayed(const Duration(milliseconds: 400), () {
          focusNode.requestFocus();
        });
      }
    }
    Future.microtask(() {
      core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String ord) {
    suggestQuery = ord;
    searchQuery = suggestQuery;
    // Future.microtask(() {});
    // Navigator.of(context).pop(true);

    if (focusNode.hasFocus) {
      Future.microtask(() {
        focusNode.unfocus();
      });
    }
    Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
      Navigator.of(context).pop(true);
      // _parent.navigator.currentState!.pop(true);
      // navigator.currentState!.pushReplacementNamed('/search/result', arguments: _arguments);
      // navigator.currentState!.popAndPushNamed('/search/result', arguments: _arguments);
    });

    Future.microtask(() {
      core.conclusionGenerate();
    });

    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    // });

    // debugPrint('suggest onSearch $canPop');
    // scrollController.animateTo(
    //   scrollController.position.minScrollExtent,
    //   curve: Curves.fastOutSlowIn, duration: const Duration(milliseconds: 800)
    // );
    // Future.delayed(Duration.zero, () {
    //   core.collection.historyUpdate(searchQuery);
    // });

    // suggestQuery = str;
    // searchQuery = suggestQuery;

    // core.conclusionGenerate().whenComplete(() => Navigator.of(context).pop(true));
    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    // });

    // debugPrint('suggest onSearch $canPop');
    // scrollController.animateTo(
    //   scrollController.position.minScrollExtent,
    //   curve: Curves.fastOutSlowIn, duration: const Duration(milliseconds: 800)
    // );
    // Future.delayed(Duration.zero, () {
    //   core.collection.historyUpdate(searchQuery);
    // });
  }

  bool onDelete(String ord) => core.collection.recentSearchDelete(ord);
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      // controller: scrollController,
      child: body(),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        Selector<Core, bool>(
          selector: (BuildContext _, Core e) => e.nodeFocus,
          builder: (BuildContext _, bool word, Widget? child) {
            return bar();
          },
        ),
        Selector<Core, SuggestionType>(
          selector: (_, e) => e.collection.cacheSuggestion,
          builder: (BuildContext context, SuggestionType o, Widget? child) {
            if (o.query.isEmpty) {
              return _suggestNoQuery();
            } else if (o.raw.isNotEmpty) {
              return _suggestBlock(o);
            } else {
              return _msg('suggest: not found');
            }
          },
        )
      ],
    );
  }

  Widget _msg(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: true,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _suggestNoQuery() {
    // return const SliverToBoxAdapter(
    //   child: Text('suggest: no query'),
    // );
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.recentSearch(),
      builder: (BuildContext _a, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? _b) {
        if (items.isNotEmpty) {
          return SliverToBoxAdapter(
            child: _recentBlock(items),
          );
        }
        return _msg(preference.text.aWordOrTwo);
      },
    );
  }

  // listView
  Widget _suggestBlock(SuggestionType o) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final snap = o.raw.elementAt(index);
          int ql = suggestQuery.length;
          String word = snap.values.first.toString();
          int wl = word.length;
          return _suggestItem(word, ql < wl ? ql : wl);

          // final suggestion = o.raw.elementAt(index);
          // String word = suggestion.values.first.toString();
          // int hightlight =
          //     suggestQuery.length < word.length ? suggestQuery.length : word.length;

          // debugPrint('- $word + $suggestQuery ');
          // return _suggestItem(word, hightlight);
        },
        childCount: o.raw.length,
      ),
    );
  }

  // Widget _listItem(String word, int hightlight) {
  //   return ListTile(
  //     title: RichText(
  //       // strutStyle: StrutStyle(height: 1.0),
  //       text: TextSpan(
  //         text: word.substring(0, hightlight),
  //         semanticsLabel: word,
  //         style: TextStyle(
  //           fontSize: 20,
  //           color: Theme.of(context).textTheme.caption!.color,
  //           // fontWeight: FontWeight.w500
  //         ),
  //         children: <TextSpan>[
  //           TextSpan(
  //             text: word.substring(hightlight),
  //             style: TextStyle(
  //               color: Theme.of(context).primaryTextTheme.button!.color,
  //               // fontWeight: FontWeight.w300
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     minLeadingWidth: 10,
  //     leading: const Icon(CupertinoIcons.arrow_turn_down_right, semanticLabel: 'Suggestion'),
  //     onTap: () => true,
  //   );
  // }
  Widget _suggestItem(String word, int hightlight) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 1),
      // color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.1,
            offset: const Offset(0.0, .0),
          )
        ],
      ),
      child: ListTile(
        title: RichText(
          // strutStyle: StrutStyle(height: 1.0),
          text: TextSpan(
            text: word.substring(0, hightlight),
            semanticsLabel: word,
            style: TextStyle(
              fontSize: 22,
              // color: Theme.of(context).textTheme.caption!.color,
              // color: Theme.of(context).highlightColor,
              color: Theme.of(context).primaryColorDark,
              // fontWeight: FontWeight.w500
            ),
            children: <TextSpan>[
              TextSpan(
                text: word.substring(hightlight),
                // style: Theme.of(context).primaryTextTheme.bodyText2,
                style: TextStyle(
                  // color: Theme.of(context).primaryTextTheme.button!.color,
                  color: Theme.of(context).primaryTextTheme.bodyText1!.color,
                  // color: Theme.of(context).primaryColor,
                  // fontWeight: FontWeight.w300
                ),
              )
            ],
          ),
        ),
        // minLeadingWidth: 10,
        leading: const Icon(CupertinoIcons.arrow_turn_down_right, semanticLabel: 'Suggestion'),
        // leading: Icon(Icons.history),
        // leading: CircleAvatar(
        //   // radius:10.0,
        //   // backgroundColor: Colors.grey.shade800,
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   child: Text(NumberFormat.compact().format(history.value.hit),textAlign: TextAlign.center,),
        // ),
        onTap: () => onSearch(word),
      ),
    );
  }

  // Recent searches
  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Text(preference.text.recentSearch(false)),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _recentContainer(index, items.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 0);
            },
          ),
        )
      ],
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        // minLeadingWidth: 10,
        // leading: Icon(Icons.manage_search_rounded),
        leading: const Icon(
          CupertinoIcons.arrow_turn_down_right,
          semanticLabel: 'Suggestion',
        ),
        title: _recentItem(item.value.word),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Wrap(
        //       children: item.value.lang
        //           .map(
        //             (e) => Text(e),
        //           )
        //           .toList(),
        //     ),
        //     Chip(
        //       backgroundColor: Theme.of(context).backgroundColor,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(7),
        //       ),
        //       avatar: const CircleAvatar(
        //         // backgroundColor: Colors.transparent,
        //         radius: 7,
        //         // child: Icon(
        //         //   Icons.hdr_strong,
        //         //   // color: Theme.of(context).primaryColor,
        //         // ),
        //       ),
        //       label: Text(
        //         item.value.hit.toString(),
        //       ),
        //     ),
        //   ],
        // ),
        onTap: () => onSuggest(item.value.word),
      ),
      background: _recentDismissibleBackground(),
      // secondaryBackground: _recentListDismissibleSecondaryBackground),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
      },
    );
  }

  Widget _recentItem(String word) {
    int hightlight = suggestQuery.length < word.length ? suggestQuery.length : word.length;
    return RichText(
      // strutStyle: StrutStyle(height: 1.0),
      text: TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        style: TextStyle(
          fontSize: 22,
          // color: Theme.of(context).highlightColor,
          color: Theme.of(context).primaryColorDark,
          // color: Theme.of(context).textTheme.caption!.color,
          // color: Theme.of(context).primaryTextTheme.button!.color,
          fontWeight: FontWeight.w300,
        ),
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              // color: Theme.of(context).primaryTextTheme.button!.color,
              color: Theme.of(context).primaryTextTheme.bodyText1!.color,
            ),
          )
        ],
      ),
    );
  }

  Widget _recentDismissibleBackground() {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 0),
      color: Theme.of(context).errorColor,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              preference.text.delete,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
