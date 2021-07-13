part of 'main.dart';

mixin _Suggest on _State {

  Widget suggest(){
    return Selector<Core,SuggestionType>(
      selector: (_, e) => e.collection.cacheSuggestion,
      builder: (BuildContext context,SuggestionType o, Widget? child) {
        if (o.query.isEmpty){
          return _suggestNoQuery();
        } else if (o.raw.length > 0){
          return _suggestBlock(o);
        } else {
          return _suggestNoMatch();
        }
      }
    );
  }

  Widget _suggestNoQuery(){
    return WidgetMessage(
      message: 'suggest: no query',
    );
  }

  Widget _suggestNoMatch(){
    return WidgetMessage(
      message: 'suggest: not found',
    );
  }

  Widget _suggestBlock(SuggestionType o){
    return new SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final suggestion = o.raw.elementAt(index);
            String word = suggestion.values.first.toString();
            int hightlight = searchQuery.length < word.length
                ? searchQuery.length
                : word.length;
            return _suggestItem(word, hightlight);
          },
          childCount: o.raw.length
        )
    );
  }

  Widget _suggestItem(String word, int hightlight) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 1),
      // color: Theme.of(context).primaryColor,
      margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.1,
            offset: Offset(0.0, .0)
          )
        ]
      ),
      child: ListTile(
        title: RichText(
          // strutStyle: StrutStyle(height: 1.0),
          text: TextSpan(
            text: word.substring(0, hightlight),
            semanticsLabel: word,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.caption!.color,
              // fontWeight: FontWeight.w500
            ),
            children: <TextSpan>[
              TextSpan(
                text: word.substring(hightlight),
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.button!.color,
                  // fontWeight: FontWeight.w300
                )
              )
            ]
          )
        ),
        minLeadingWidth: 10,
        leading: Icon(
          CupertinoIcons.arrow_turn_down_right,
          semanticLabel: 'Suggestion'
        ),
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
}
