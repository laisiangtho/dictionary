part of 'main.dart';

class ViewSuggestion extends StatelessWidget {
  ViewSuggestion({Key key,this.query, this.search}) : super(key: key);

  final String query;
  final void Function(BuildContext context, String word) search;

  final core = Core();

  @override
  Widget build(BuildContext context) {
    if (this.query.isEmpty) return this.noQuery;

    try {
      if (core.suggestion(this.query).length > 0) {
        return _suggestionKeyword(core.collection.suggestion);
      } else if (this.query.isEmpty) {
        return this.noQuery;
      } else {
        return WidgetMessage(key: this.key,message: this.query);
      }
    } catch (e) {
      return WidgetMessage(key: this.key,message: '???');
    }
  }

  Widget get noQuery => WidgetMessage(key: this.key,message: 'suggestion');

  Widget _suggestionKeyword(List<WordType> _r) {
    return new SliverList(
      key: this.key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => SuggestionList(query: this.query, search: this.search, index: i, data: _r.elementAt(i)),
        childCount: _r.length
      )
    );
  }
}

class SuggestionList extends StatelessWidget {
  SuggestionList({Key key,this.query, this.search, this.data, this.index}): super(key: key);
  final String query;
  final void Function(BuildContext context, String word) search;
  final WordType data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:1.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.6,
            offset: Offset(0.0, .0),
          )
        ]
      ),
      child:container(context:context)
    );
  }

  Widget container({BuildContext context}){
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal:13,vertical:18),
      onPressed: () => this.search(context, data.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              // color: Colors.red,
              child: Icon(
                CupertinoIcons.arrow_turn_down_right,
                color: Theme.of(context).backgroundColor,
                semanticLabel: 'Recent search icon'
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: RichText(
              strutStyle: StrutStyle(height: 1.0),
              text: TextSpan(
                text: data.v.substring(0, this.query.length),
                semanticsLabel: data.v,
                style: TextStyle(
                  // fontSize: 20,
                  color: Theme.of(context).textTheme.caption.color,
                  fontWeight: FontWeight.w300
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: data.v.substring(this.query.length),
                    style: TextStyle(
                      // color: Theme.of(context).textTheme.caption.color,
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontWeight: FontWeight.w400
                    )
                  )
                ]
              )
            ),
          )
        ],
      ),
    );
  }
}
