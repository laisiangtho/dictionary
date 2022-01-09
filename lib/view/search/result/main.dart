import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/search-result';
  static const icon = LideaIcon.search;
  static const name = 'Result';
  static const description = '...';
  // static final uniqueKey = UniqueKey();
  // static final navigatorKey = GlobalKey<NavigatorState>();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;

  late final scrollController = ScrollController();
  late final TextEditingController textController = TextEditingController();
  late final Future<void> initiator = core.conclusionGenerate(init: true);

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  GlobalKey<NavigatorState> get navigator => arguments.navigator!;
  ViewNavigationArguments get parent => arguments.args as ViewNavigationArguments;
  bool get canPop => arguments.args != null;
  // bool get canPop => arguments.canPop;
  // bool get canPop => navigator.currentState!.canPop();
  // bool get canPop => Navigator.of(context).canPop();

  // AppLocalizations get translate => AppLocalizations.of(context)!;
  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    onQuery();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onUpdate(bool status) {
    if (status) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
      onQuery();
    }
  }

  void onQuery() async {
    Future.microtask(() {
      textController.text = core.searchQuery;
    });
  }

  void onSearch(String ord) async {
    core.searchQuery = ord;
    core.suggestQuery = ord;
    await core.conclusionGenerate();
    onQuery();
    onUpdate(core.searchQuery.isNotEmpty);
  }

  void onSwitchFavorite() {
    core.collection.favoriteSwitch(core.searchQuery);
    core.notify();
  }
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
        bar(),
        FutureBuilder(
          future: initiator,
          builder: (BuildContext _, AsyncSnapshot<void> snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return _msg(preference.text.aMoment);
              default:
                return Selector<Core, ConclusionType>(
                  selector: (_, e) => e.collection.cacheConclusion,
                  builder: (BuildContext context, ConclusionType o, Widget? child) {
                    if (o.query.isEmpty) {
                      return _msg(preference.text.aWordOrTwo);
                    } else if (o.raw.isNotEmpty) {
                      return _resultBlock(o);
                    } else {
                      return _msg(preference.text.searchNoMatch);
                    }
                  },
                );
            }
          },
        ),
        // Selector<Core, ConclusionType>(
        //   selector: (_, e) => e.collection.cacheConclusion,
        //   builder: (BuildContext context, ConclusionType o, Widget? child) {
        //     if (o.query.isEmpty) {
        //       return _msg(translate.aWordOrTwo);
        //     } else if (o.raw.isNotEmpty) {
        //       return _resultBlock(o);
        //     } else {
        //       return _msg(translate.searchNoMatch);
        //     }
        //   },
        // ),
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

  Widget _resultBlock(ConclusionType o) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => _resultContainer(o.raw.elementAt(i)),
        childCount: o.raw.length,
      ),
    );
  }

  Widget _resultContainer(Map<String, dynamic> item) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _wordContainer(item['word']),
        ListView.builder(
          // key: UniqueKey(),
          shrinkWrap: true,
          primary: false,
          itemCount: item['sense'].length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.zero,
          itemBuilder: (context, index) => _senseContainer(item['sense'].elementAt(index)),
        ),
        // _thesaurusContainer(item['thesaurus'])
        _thesaurusContainer(item['word']),
      ],
    );
  }

  Widget _wordContainer(String word) {
    return CupertinoButton(
      child: Selector<Core, bool>(
        selector: (_, e) => e.searchQueryFavorited,
        builder: (BuildContext context, bool isFavorited, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.favorite,
                  color: isFavorited ? Theme.of(context).highlightColor : null,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  word,
                  semanticsLabel: word,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(0.2, 0.2),
                        blurRadius: 0.4,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      onPressed: onSwitchFavorite,
    );
  }

  Widget _senseContainer(Map<String, dynamic> sense) {
    // return Container(
    //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
    //   clipBehavior: Clip.hardEdge,
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).primaryColor,
    //     borderRadius: BorderRadius.all(Radius.circular(7)),
    //     boxShadow: [
    //       BoxShadow(
    //         blurRadius: 0.0,
    //         color: Theme.of(context).backgroundColor,
    //         spreadRadius: 0.7,
    //         offset: Offset(0.2, .1),
    //       )
    //     ]
    //   ),
    //   child: new Column(
    //     mainAxisSize: MainAxisSize.max,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       _posContainer(sense['pos']),
    //       _clueContainer(sense['clue'])
    //     ]
    //   ),
    // );
    return Card(
      clipBehavior: Clip.hardEdge,
      // shadowColor: Theme.of(context).backgroundColor,
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      // elevation: 3,
      // margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _posContainer(sense['pos']),
          _clueContainer(sense['clue']),
        ],
      ),
    );
  }

  Widget _posContainer(String pOS) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 35),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor.withOpacity(0.7),
            spreadRadius: 0.7,
            offset: const Offset(0.2, .2),
          ),
        ],
      ),
      child: Text(
        pOS,
        semanticsLabel: pOS,
        style: const TextStyle(
            // fontStyle: FontStyle.italic,
            // fontWeight: FontWeight.w300,
            // shadows: <Shadow>[
            //   Shadow(
            //     offset: const Offset(0.2, 0.2),
            //     blurRadius: 0.4,
            //     color: Theme.of(context).scaffoldBackgroundColor,
            //   ),
            // ],
            ),
      ),
    );
  }

  Widget _clueContainer(List<Map<String, dynamic>> clue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: clue.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListBody(
            children: <Widget>[
              _clueMeaning(clue[index]['mean']),
              _examContainer(clue[index]['exam']),
            ],
          );
        },
      ),
    );
  }

  Widget _clueMeaning(String mean) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.5),
            child: Icon(
              CupertinoIcons.circle,
              size: 12,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Highlight(
            str: mean,
            search: onSearch,
            // style: const TextStyle(fontSize: 17, height: 1.9),
            style: Theme.of(context).textTheme.bodyText2!,
          ),
        ),
      ],
    );
  }

  Widget _examContainer(List<dynamic>? exam) {
    if (exam == null || exam.isEmpty) {
      return Container();
    }
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).primaryColorDark, width: 0.4),
        ),
      ),
      child: ListView.builder(
        // key: UniqueKey(),
        shrinkWrap: true,
        primary: false,
        itemCount: exam.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: Theme.of(context).backgroundColor,
                    // color: Theme.of(context).primaryTextTheme.button.color
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                // child: Text(exam[index]),
                child: Highlight(
                  str: exam[index],
                  search: onSearch,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300, fontSize: 17, height: 1.5,
                    // fontSize: 15,
                    // height: 1.3
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _thesaurusContainer(String keyword) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: Provider.of<Core>(context, listen: false).thesaurusGenerate(keyword),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                textDirection: TextDirection.ltr,
                children: snapshot.data!.map(
                  (e) {
                    return Padding(
                      // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                      child: CupertinoButton(
                        child: Text(
                          e['word'].toString(),
                          // style: const TextStyle(fontSize: 19),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        // color: Colors.blue,
                        color: Theme.of(context).backgroundColor,
                        // color: Theme.of(context).backgroundColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 15,
                        ),
                        // minSize:42,
                        minSize: 35,
                        onPressed: () => onSearch(e['word'].toString()),
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
