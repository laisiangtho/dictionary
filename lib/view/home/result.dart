part of 'main.dart';

mixin _Result on _State {

  Widget result(){
    return Selector<Core,DefinitionType>(
      selector: (_, e) => e.collection.cacheDefinition,
      builder: (BuildContext context, DefinitionType o, Widget? child) {
        if (o.query.isEmpty){
          return _resultNoQuery();
        } else if (o.raw.length > 0){
          return _resultBlock(o);
        } else {
          return _resultNoMatch();
        }
      }
    );
  }

  Widget _resultNoQuery(){
    return WidgetMessage(
      message: 'result: no query',
    );
  }

  Widget _resultNoMatch(){
    return WidgetMessage(
      message: 'result: not found',
    );
  }

  Widget _resultBlock(DefinitionType o){
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => _resultContainer(o.raw.elementAt(i)),
        childCount: o.raw.length
      )
    );
  }

  Widget _resultContainer(Map<String, dynamic> item) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _wordContainer(item['word']),
        ListView.builder(
          // key: UniqueKey(),
          shrinkWrap: true,
          primary: false,
          itemCount: item['sense'].length,
          itemBuilder: (context, index) => _senseContainer(item['sense'].elementAt(index))
        ),
        // _thesaurusContainer(item['thesaurus'])
        _thesaurusContainer(item['word'])
      ]
    );
  }

  Widget _wordContainer(String word) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.zero,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 27,
                child: Icon(
                  // CupertinoIcons.hand_thumbsup_fill,
                  CupertinoIcons.zzz,
                ),
                onPressed: null
              )
            )
          ),
          Expanded(
            flex: 5,
            child: Text(
              word,
              semanticsLabel: word,
              style:TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                shadows: <Shadow>[
                  Shadow(offset: Offset(0.2, 0.2),blurRadius: 0.4,color:Theme.of(context).backgroundColor)
                ]
              )
            )
          ),
        ],
      ),
    );
  }

  Widget _senseContainer(Map<String, dynamic> sense){
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
      shadowColor: Theme.of(context).backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      elevation: 10,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _posContainer(sense['pos']),
          _clueContainer(sense['clue'])
        ]
      ),
    );
  }

  Widget _posContainer(String pOS){
    return Container(
      padding: EdgeInsets.only(top:10, bottom:10, left:25, right:35),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(100)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor.withOpacity(0.3),
            spreadRadius: 0.7,
            offset: Offset(0.2, .2),
          )
        ]
      ),
      child: Text(
        pOS,
        semanticsLabel: pOS,
        style:TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          shadows: <Shadow>[
            Shadow(offset: Offset(0.2, 0.2),blurRadius: 0.4,color: Theme.of(context).scaffoldBackgroundColor)
          ]
        )
      ),
    );
  }

  Widget _clueContainer(List<Map<String, dynamic>> clue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: clue.length,
        itemBuilder: (BuildContext context, int index){
          return new ListBody(
            children: <Widget>[
              _clueMeaning(clue[index]['mean']),
              _examContainer(clue[index]['exam'])
            ]
          );
        }
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
            padding: EdgeInsets.symmetric(vertical:10),
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
            style: TextStyle(
              fontSize: 17,
              height: 1.9
            )
          )
        )
      ]
    );
  }

  Widget _examContainer(List<dynamic>? exam) {
    if (exam == null || exam.length == 0){
      return Container();
    }
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 0.4
          )
        )
      ),
      child: ListView.builder(
        // key: UniqueKey(),
        shrinkWrap: true,
        primary: false,
        itemCount: exam.length,
        itemBuilder: (context, index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical:8),
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: Theme.of(context).backgroundColor,
                    // color: Theme.of(context).primaryTextTheme.button.color
                  ),
                )
              ),
              Expanded(
                flex: 8,
                // child: Text(exam[index]),
                child: Highlight(
                  str:exam[index],
                  search: onSearch,
                  style:TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                    height: 1.5
                    // fontSize: 15,
                    // height: 1.3
                  )
                )
              )
            ]
          );
        }
      ),
    );
  }

  Widget _thesaurusContainer(String keyword) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: Provider.of<Core>(context,listen: false).thesaurusGenerate(keyword),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                textDirection: TextDirection.ltr,
                children: snapshot.data!.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    child: CupertinoButton(
                      child: Text(e['word'].toString(),style: TextStyle(fontSize:19),),
                      // color: Colors.blue,
                      color: Theme.of(context).backgroundColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      padding: EdgeInsets.symmetric(vertical:3, horizontal:15),
                      // minSize:42,
                      minSize:35,
                      onPressed: () => onSearch(e['word'].toString())
                    ),
                  )
                ).toList()
              ),
            );
          default:
            return Container();
        }
      }
    );
  }

}
