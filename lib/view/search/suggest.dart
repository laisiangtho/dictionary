part of 'main.dart';

class ViewSuggestion extends StatelessWidget {
  ViewSuggestion({
    Key? key,
    required this.query,
    required this.search
  }) : super(key: key);

  final String query;
  final void Function(BuildContext context, String word) search;

  final core = Core();



  @override
  Widget build(BuildContext context){
    // if (this.query.isEmpty) return this.noQuery;

    // try {
    //   if (core.suggestion(this.query).length > 0) {
    //     return suggestion(core.collection.suggestion);
    //   } else if (this.query.isEmpty) {
    //     return this.noQuery;
    //   } else {
    //     return WidgetMessage(key: this.key,message: this.query);
    //   }
    // } catch (e) {
    //   return WidgetMessage(key: this.key,message: '???');
    // }

    return ValueListenableBuilder<List<Map<String, Object?>>>(
      key: this.key,
      valueListenable: core.collection.notify.suggestResult,
      builder: (BuildContext context, List<Map<String, dynamic>> value, Widget? child) => this.suggestion(value),
      child: noQuery,
    );
  }

  Widget get noQuery => WidgetMessage(message: 'suggestion');

  Widget suggestion(List<Map<String, Object?>> _r) {
    return new SliverList(
      // key: this.key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => _SuggestionList(query: core.collection.notify.suggestQuery.value, search: this.search, index: i, data: _r.elementAt(i)),
        childCount: _r.length
      )
    );
  }
}

class _SuggestionList extends StatelessWidget {
  _SuggestionList({
    Key? key,
    required this.query,
    required this.search,
    required this.data,
    required this.index
  }): super(key: key);
  final String query;
  final void Function(BuildContext context, String word) search;
  final Map<String, Object?> data;
  final int index;

  String get word => data.values.first.toString();
  int get hightlight => this.query.length < word.length?this.query.length:word.length;
  // String get abc => 'asf';

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

  Widget container({required BuildContext context}){
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal:13,vertical:18),
      onPressed: () => this.search(context, word),
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
                text: word.substring(0, hightlight),
                semanticsLabel: word,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textTheme.caption!.color,
                  fontWeight: FontWeight.w300
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: word.substring(hightlight),
                    style: TextStyle(
                      // color: Theme.of(context).textTheme.caption.color,
                      // color: Theme.of(context).colorScheme.primaryVariant,
                      color: Theme.of(context).primaryTextTheme.button!.color
                      // fontWeight: FontWeight.w400
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
