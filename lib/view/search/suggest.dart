part of 'main.dart';

class ViewSuggestion extends StatelessWidget {
  ViewSuggestion({Key key,this.searchQuery}) : super(key: key);

  final String searchQuery;
  final core = Core();

  @override
  Widget build(BuildContext context) {

    if (this.searchQuery.isEmpty) return WidgetMessage(message: 'suggestion $searchQuery');

    return FutureBuilder(
      key: key,
      future: core.suggestion(searchQuery),
      builder: (BuildContext context, AsyncSnapshot<List<WordType>> snapshot)  {
        if (snapshot.hasError) {
          return WidgetMessage(message: snapshot.error.toString());
        }
        return _suggestionKeyword(core.collection.suggestion);
      }
    );
  }

  Widget _suggestionKeyword(List<WordType> _list) {
    if (_list.length == 0) return WidgetContent(atLeast: 'found no contain\nof ',enable:this.searchQuery,task: '\nin ',message:'bibleInfo?.name');
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          WordType data = _list.elementAt(index);
          return new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                child: Text(data.v),
              ),
            ]
          );
        },
        childCount: _list.length
      )
    );
  }
}
