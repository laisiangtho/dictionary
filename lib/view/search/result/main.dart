// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments, this.param}) : super(key: key);

  final Object? arguments;
  final Object? param;

  static const route = '/search-result';
  static const icon = LideaIcon.search;
  static const name = 'Result';
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
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
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
            overlapsForce: innerBoxIsScrolled,
            builder: bar,
          );
        },
      ),
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
    ];
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
    return ListBody(
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
    return WidgetButton(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Selector<Core, bool>(
        selector: (_, e) => e.searchQueryFavorited,
        builder: (BuildContext context, bool isFavorited, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                // child: Icon(
                //   Icons.campaign_rounded,
                //   color: isFavorited ? Theme.of(context).highlightColor : null,
                // ),
                child: WidgetButton(
                  child: const WidgetLabel(icon: Icons.campaign_rounded),
                  onPressed: () {
                    core.speech.speak(word);
                  },
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
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.favorite,
                  color: isFavorited ? Theme.of(context).highlightColor : null,
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
    return Card(
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
        padding: EdgeInsets.zero,
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              Icons.fiber_manual_record_outlined,
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
            style: Theme.of(context).textTheme.bodyLarge!,
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
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).primaryColorDark, width: 0.4),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: exam.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
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
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Highlight(
                  str: exam[index],
                  search: onSearch,
                  // style: const TextStyle(
                  //   fontWeight: FontWeight.w300,
                  //   fontSize: 17,
                  // ),
                  style: Theme.of(context).textTheme.bodySmall!,
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
                spacing: 10,
                runSpacing: 10,
                children: snapshot.data!.map(
                  (e) {
                    return WidgetButton(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                      // constraints: const BoxConstraints(maxHeight: 43),
                      child: WidgetLabel(
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 3,
                        ),
                        label: e['word'].toString(),
                        labelStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () => onSearch(e['word'].toString()),
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
