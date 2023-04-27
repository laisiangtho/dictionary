part of 'main.dart';

mixin _Result on _State {
  Widget resultView() {
    // return CustomScrollView(
    //   primary: true,
    //   slivers: [
    //     Selector<Core, ConclusionType>(
    //       selector: (_, e) => e.cacheConclusion,
    //       builder: (BuildContext context, ConclusionType o, Widget? child) {
    //         if (o.emptyQuery) {
    //           return _resultNoQuery();
    //         } else if (o.emptyResult) {
    //           return child!;
    //         } else {
    //           return _resultBlock();
    //         }
    //       },
    //       child: ViewFeedback.message(
    //         primary: false,
    //         label: App.preference.text.searchNoMatch,
    //       ),
    //     ),
    //   ],
    // );
    /*
    return Selector<Core, ConclusionType>(
      selector: (_, e) => e.data.cacheConclusion,
      builder: (BuildContext context, ConclusionType o, Widget? child) {
        if (o.emptyQuery) {
          return _resultNoQuery();
        } else if (o.emptyResult) {
          return child!;
        } else {
          return _resultBlock(o);
        }
      },
      child: ViewFeedback.message(
        label: App.preference.text.searchNoQuery,
      ),
    );
    */
    return FutureBuilder(
      future: _initiator,
      builder: (BuildContext _, AsyncSnapshot<void> snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return ViewFeedback.message(
              label: App.preference.text.aMoment,
            );
          default:
            // return Selector<Core, ConclusionType>(
            //   selector: (_, e) => e.data.cacheConclusion,
            //   builder: (BuildContext context, ConclusionType o, Widget? child) {
            //     if (o.query.isEmpty) {
            //       return _msg(preference.text.aWordOrTwo);
            //     } else if (o.raw.isNotEmpty) {
            //       return _resultBlock(o);
            //     } else {
            //       return _msg(preference.text.searchNoMatch);
            //     }
            //   },
            // );
            return Selector<Core, ConclusionType>(
              selector: (_, e) => e.data.cacheConclusion,
              builder: (BuildContext context, ConclusionType o, Widget? child) {
                onResult();
                if (o.emptyQuery) {
                  return _resultNoQuery();
                } else if (o.emptyResult) {
                  return child!;
                } else {
                  return _resultBlock(o);
                }
              },
              child: ViewFeedback.message(
                label: App.preference.text.searchNoQuery,
              ),
            );
        }
      },
    );
  }

  Widget _resultNoQuery() {
    // return ViewSection(
    //   headerTitle: const Text('Result no query'),
    //   headerTrailing: ViewButton(
    //     onPressed: () {},
    //     child: const Icon(Icons.more_horiz),
    //   ),
    //   footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
    //   child: ViewBlockCard(
    //     child: ListBody(
    //       children: [
    //         ViewButton(
    //           onPressed: () {},
    //           child: const Text('ViewButton'),
    //         ),
    //         ViewButton(
    //           child: Text(suggestQuery),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return ViewFeedback.message(
      label: App.preference.text.searchNoMatch,
    );
  }

  // Widget _resultBlock(ConclusionType o) {
  //   return ViewSection(
  //     headerTitle: const Text('Result ???'),
  //     headerTrailing: ViewButton(
  //       onPressed: () {},
  //       child: const Icon(Icons.more_horiz),
  //     ),
  //     footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
  //     child: ViewBlockCard(
  //       child: ListBody(
  //         children: [
  //           ViewButton(
  //             onPressed: () {},
  //             child: const Text('ViewButton'),
  //           ),
  //           ViewButton(
  //             child: Text(suggestQuery),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _resultBlock(ConclusionType o) {
    return ViewListBuilder(
      // primary: false,
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final snap = o.raw.elementAt(index);
        // return ListTile(
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        //   leading: const Icon(Icons.north_east_rounded),
        //   title: Text('data $index'),
        // );
        return _resultContainer(snap);
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          leading: Icon(Icons.north_east_rounded),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(primary: false);
      },
      itemCount: o.raw.length,
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
    /*
    return ViewButton(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      onPressed: onSwitchFavorite,
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
                child: ViewButton(
                  child: ViewLabel(
                    icon: Icons.campaign_rounded,
                    iconColor: state.theme.shadowColor,
                  ),
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
    );
    */
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      horizontalTitleGap: 0,
      leading: ViewLabel(
        icon: Icons.campaign_rounded,
        iconColor: state.theme.shadowColor,
        iconSize: 30,
        // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        // margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      ),
      // leading: Icon(
      //   Icons.campaign_rounded,
      //   color: state.theme.shadowColor,
      // ),
      title: Text(
        word,
        semanticsLabel: word,
        style: state.textTheme.headlineSmall,
        // style: TextStyle(
        //   fontSize: 25,
        //   fontWeight: FontWeight.w400,
        //   shadows: <Shadow>[
        //     Shadow(
        //       offset: const Offset(0.2, 0.2),
        //       blurRadius: 0.4,
        //       color: Theme.of(context).backgroundColor,
        //     ),
        //   ],
        // ),
      ),
      trailing: ViewButton(
        onPressed: onSwitchFavorite,
        child: Selector<Core, bool>(
          selector: (_, e) => e.searchQueryFavorited,
          builder: (BuildContext context, bool isFavorited, Widget? child) {
            return Icon(
              Icons.favorite,
              color: isFavorited ? Theme.of(context).highlightColor : null,
            );
          },
        ),
      ),
      onTap: () {
        core.speech.speak(word);
      },
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
            padding: const EdgeInsets.symmetric(vertical: 11),
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
                  padding: const EdgeInsets.symmetric(vertical: 6),
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
                    return ViewButton(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                      // constraints: const BoxConstraints(maxHeight: 43),
                      child: ViewLabel(
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
