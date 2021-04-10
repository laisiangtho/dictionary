part of 'main.dart';

class ViewResult extends StatelessWidget {
  ViewResult({Key key,this.searchQuery}) : super(key: key);

  final String searchQuery;
  final core = Core();

  @override
  Widget build(BuildContext context) {
    if (this.searchQuery.isEmpty) {
      return new WidgetContent(key: key,atLeast: 'search\na',enable:' Word ',task: 'or two\nto get ',message:'definition');
    }
    return FutureBuilder(
      key: key,
      future: core.definition(searchQuery),
      builder: (BuildContext context, AsyncSnapshot<List<ResultModel>> snapshot) {
        if (snapshot.hasError) {
          return WidgetMessage(message: snapshot.error.toString());
        }
        return _resultWord(core.collection.definition);
      }
    );
  }

  Widget _resultWord(List<ResultModel> data) {
    if (data.length == 0) return WidgetContent(atLeast: '...found no contain\nof ',enable:searchQuery,task: '\nin ',message:'??');
    return new SliverList(
      // key: UniqueKey(),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          // BOOK book = bible.book[bookIndex];
          ResultModel book = data[index];
          // book.sense
          return new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  book.word,
                  semanticsLabel: book.word,
                  style:TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    shadows: <Shadow>[
                      Shadow(offset: Offset(0.9, 0.2),blurRadius: 0.4,color: Colors.black54)
                    ]
                  )
                ),
              ),
              ListView.builder(
                key: UniqueKey(),
                shrinkWrap: true,
                primary: false,
                // itemCount: chapters.length,
                itemCount: book.sense.length,
                itemBuilder: (context, index){
                  SenseModel sense = book.sense[index];
                  return new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        sense.pos,
                        style:TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          // shadows: <Shadow>[
                          //   Shadow(offset: Offset(0.9, 0.2),blurRadius: 0.4,color: Colors.black54)
                          // ]
                        )
                      ),
                      _clueContainer(sense.clue)

                    ]
                  );
                }
              )
            ]
          );
        },
        childCount: data.length
      )
    );
  }


  Widget _clueContainer(List<ClueModel> clue) {
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      itemCount: clue.length,
      itemBuilder: (context, index){
        return new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(clue[index].mean),
            _examContainer(clue[index].exam)
          ]
        );
      }
    );
  }

  Widget _examContainer(List<String> exam) {
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      primary: false,
      itemCount: exam.length,
      itemBuilder: (context, index){
        return Text(
          exam[index]
        );
      }
    );
  }
}

/*
class ViewDefinition extends StatelessWidget {
  ViewDefinition({Key key,this.searchQuery}) : super(key: key);

  final String searchQuery;
  final core = Core();
  final ValueNotifier<int> myValueListenable = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      key: key,
      delegate: new SliverChildListDelegate(
        <Widget>[
          Text('definition'),
          ValueListenableBuilder<int>(
            valueListenable: myValueListenable,
            builder: (context, value, _) {
              // return Provider<int>.value(
              //   value: value,
              //   child: Text('ValueListenableBuilder $value'),
              // );
              return Text('ValueListenableBuilder $value');
            }
          ),
          new CupertinoButton (
            onPressed: (){
              myValueListenable.value++;
            },
            padding: EdgeInsets.zero,
            minSize: 35.0,

            child:Text('ValueListenableBuilder update ${myValueListenable.value}', maxLines: 1, style: TextStyle(fontSize: 14))
          ),
          WordTesting()
        ],
      ),
    );
  }
}



class WordTesting extends StatelessWidget {

  final core = Core();

  @override
  Widget build(BuildContext context) {
    // final word = context.read<FormNotifier>();
    final keyword = context.watch<FormNotifier>().keyword;
    // final searchQuery = context.watch<FormNotifier>().searchQuery;
    // return Container(
    //   child: getContextfromChildWidget(),
    // );
    return Column(
      children: <Widget>[
        Text('keyword $keyword'),
        getContextfromChildWidget(),
        new CupertinoButton (
          onPressed: (){
            var abc = Provider.of<FormNotifier>(context,listen: false);
            abc.searchQuery = 'apple';

          },
          padding: EdgeInsets.zero,
          minSize: 35.0,
          child:Text('Provider.of', maxLines: 1, style: TextStyle(fontSize: 14))
        )
      ]
    );

  }
  Widget getContextfromChildWidget() {
    return Consumer<FormNotifier>(
      builder: (BuildContext context, FormNotifier form, Widget child) {
        return Text(form.searchQuery);
      }
    );
    // return Provider<WordNotifier>(
    //   create: (_) => WordNotifier(),
    //   // we use `builder` to obtain a new `BuildContext` that has access to the provider
    //   builder: (context,a) {
    //     return Text(context.watch<WordNotifier>().word);
    //   }
    // );

  }

  Widget cancelInputButton(){

    return Consumer<NodeNotifier>(
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (BuildContext context, NodeNotifier node, Widget child) {
        // return Text(context.watch<NodeNotifier>().focus);
        // return Text(context.read<NodeNotifier>().focus);
        // print(context.read<NodeNotifier>().focus);
        // print(node.focus);
        return new CupertinoButton (
          onPressed: null,
          padding: EdgeInsets.zero,
          minSize: 35.0,
          color: node.focus?Colors.red:Colors.blue,
          child:Text('Cancel', maxLines: 1, style: TextStyle(fontSize: 14))
        );
      }
    );
  }
}
*/