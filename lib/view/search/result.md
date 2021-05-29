# ?

```dart
part of 'main.dart';

class ViewResult extends StatefulWidget {
  ViewResult({
    Key? key,
    required this.query,
    required this.search
  }) : super(key: key);

  final String query;
  final void Function(String word) search;

  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  final core = Core();

  @override
  Widget build(BuildContext context) {
    // if (widget.query.isEmpty) return this.noQuery;

    // try {
    //   if (core.definition(widget.query).length > 0) {
    //     return result(core.collection.definition);
    //   } else if (widget.query.isEmpty) {
    //     return this.noQuery;
    //   } else {
    //     return WidgetContent(key: widget.key, atLeast: 'no result \n',enable:widget.query,task: '\nin ',message:'definition');
    //   }
    // } catch (e) {
    //   return WidgetMessage(key: widget.key, message: e.toString());
    // }

    // return ValueListenableBuilder<List<Map<String, dynamic>>>(
    //   key: widget.key,
    //   valueListenable: core.collection.notify.searchResult,
    //   builder: (BuildContext context, List<Map<String, dynamic>> value, Widget? child) => this.result(value),
    //   child: noQuery,
    // );
    // return ValueListenableBuilder<String>(
    //   key: widget.key,
    //   valueListenable: core.collection.notify.searchQuery,
    //   builder: (BuildContext context, String value, Widget child) => ValueListenableBuilder<List<Map<String, dynamic>>>(
    //     valueListenable: core.collection.notify.searchResult,
    //     builder: (BuildContext context, List<Map<String, dynamic>> value, Widget child) => this.result(value),
    //     child: noQuery,
    //   ),
    //   child: noQuerys,
    // );
    return new SliverList(
      delegate: new SliverChildListDelegate(
        <Widget>[
          ElevatedButton(
            child: Text('popup'),
            onPressed: (){
              navigateAndDisplaySelection(context);
            }
          )
        ]
      )
    );
  }

  void navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    // final result = await Navigator.push(context,
    //   MaterialPageRoute(builder: (context) => SuggestionView()),
    // );
    final result = await Navigator.push(context, CustomNavRoute(
      builder: (context) => SearchBar(isSearching: false)
      )
    );
    // final result = await Navigator.pushReplacement(context, CustomNavRoute(
    //   builder: (context) => SuggestionView()
    //   )
    // );


    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }

  Widget get noQuery => new WidgetContent(atLeast: 'search\na',enable:' Word ',task: 'or two\nfor ',message:'definition');

  Widget result(List<Map<String, dynamic>> _r) {
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => _resultContainer(index: i, data: _r.elementAt(i)),
        childCount: _r.length
      )
    );
  }

  Widget _resultContainer({required int index, required Map<String, dynamic> data}) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _wordContainer(data['word']),
        ListView.builder(
          // key: UniqueKey(),
          shrinkWrap: true,
          primary: false,
          itemCount: data['sense'].length,
          itemBuilder: (context, index) => _senseContainer(data['sense'].elementAt(index))
        ),
        _thesaurusContainer(data['thesaurus'])
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
                  CupertinoIcons.hand_thumbsup_fill,
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
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
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(100)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
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
            padding: EdgeInsets.symmetric(vertical:12),
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
            search: widget.search,
            style: TextStyle(
              fontSize: 17,
              height: 1.7
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
                  padding: EdgeInsets.symmetric(vertical:9),
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
                  search: widget.search,
                  style:TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    height: 1.3
                  )
                )
              )
            ]
          );
        }
      ),
    );
  }

  Widget _thesaurusContainer(List<dynamic> thes) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        textDirection: TextDirection.ltr,
        children: List<Widget>.generate(thes.length,
          (int index) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: CupertinoButton(
              child: Text(thes[index],style: TextStyle(fontSize:17),),
              // color: Colors.blue,
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              padding: EdgeInsets.symmetric(vertical:5, horizontal:15),
              minSize:35,
              onPressed: () => widget.search(thes[index])
            ),
          )
        )
      ),
    );
  }
}