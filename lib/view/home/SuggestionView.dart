part of 'main.dart';

class SuggestionView extends StatefulWidget {
  SuggestionView({
    Key? key,
    required this.search,
    // required this.query,
    // required this.result
  }) : super(key: key);

  final void Function(String word) search;
  // final String query;
  // final List<Map<String, Object?>> result;

  @override
  _SuggestionViewState createState() => _SuggestionViewState();
}

class _SuggestionViewState extends State<SuggestionView> {
  @override
  Widget build(BuildContext context) {
    // return Consumer<Core>(
    //   key: widget.key,
    //   builder: (BuildContext _, Core core, Widget? child){
    //     if (core.nodeFocus){
    //       return _resultPage(
    //         core.suggestionQuery,
    //         core.suggestionList
    //       );
    //     } else {
    //       return child!;
    //     }
    //   },
    //   child: new SliverList(
    //     delegate: new SliverChildListDelegate(
    //       <Widget>[]
    //     )
    //   )
    // );
    return Consumer<Core>(
      key: widget.key,
      builder: (BuildContext _, Core core, Widget? child) => new SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final suggestion = core.suggestionList.elementAt(index);
              String word = suggestion.values.first.toString();
              int hightlight = core.suggestionQuery.length < word.length
                  ? core.suggestionQuery.length
                  : word.length;
              return _resultContainer(word, hightlight);
            },
            childCount: core.suggestionList.length
          )
      ),
    );
    // return new SliverList(
    //   key: widget.key,
    //   delegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) {
    //       final suggestion = widget.result.elementAt(index);
    //       String word = suggestion.values.first.toString();
    //       int hightlight = widget.query.length < word.length?widget.query.length:word.length;
    //       return _resultContainer(word, hightlight);
    //     },
    //     childCount: widget.result.length
    //   )
    // );
  }

  // Widget _resultPage(List<Map<String, Object?>> result) {
  //   return new SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       (BuildContext context, int index) {
  //         final suggestion = result.elementAt(index);
  //         String word = suggestion.values.first.toString();
  //         int hightlight = widget.query.length < word.length?widget.query.length:word.length;
  //         return _resultContainer(
  //           word: word,
  //           hightlight: hightlight
  //         );
  //       },
  //       childCount: result.length
  //     )
  //   );
  // }

  Widget _resultContainer(String word, int hightlight) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      color: Theme.of(context).primaryColor,
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        // tileColor: Theme.of(context).primaryColor,
        title: RichText(
            // strutStyle: StrutStyle(height: 1.0),
            text: TextSpan(
                text: word.substring(0, hightlight),
                semanticsLabel: word,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.caption!.color,
                    fontWeight: FontWeight.w300),
                children: <TextSpan>[
              TextSpan(
                  text: word.substring(hightlight),
                  style: TextStyle(
                      // color: Theme.of(context).textTheme.caption.color,
                      // color: Theme.of(context).colorScheme.primaryVariant,
                      color: Theme.of(context).primaryTextTheme.button!.color
                      // fontWeight: FontWeight.w400
                      ))
            ])),
        minLeadingWidth: 10,
        leading: Icon(CupertinoIcons.arrow_turn_down_right,
            // color: Theme.of(context).backgroundColor,
            semanticLabel: 'Suggestion'),
        // leading: Icon(Icons.history),
        // leading: CircleAvatar(
        //   // radius:10.0,
        //   // backgroundColor: Colors.grey.shade800,
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   child: Text(NumberFormat.compact().format(history.value.hit),textAlign: TextAlign.center,),
        // ),

        onTap: () => widget.search(word),
      ),
    );
  }
}
