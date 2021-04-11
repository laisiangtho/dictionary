part of 'main.dart';

class ViewResult extends StatefulWidget {
  ViewResult({Key key,this.searchQuery}) : super(key: key);

  final String searchQuery;

  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  final core = Core();

  @override
  Widget build(BuildContext context) {
    if (widget.searchQuery.isEmpty) {
      return new WidgetContent(key: widget.key, atLeast: 'search\na',enable:' Word ',task: 'or two\nto get ',message:'definition');
    }
    try {
      if (core.definition(widget.searchQuery).length > 0) {
        return _resultWord(core.collection.definition);
      } else {
        return WidgetContent(key: widget.key, atLeast: 'found no contain\nof ',enable:this.widget.searchQuery,task: '\nin ',message:'bibleInfo?.name');
      }
    } catch (e) {
      return WidgetMessage(key: widget.key, message: '???');
    }
  }

  Widget _resultWord(List<ResultModel> _list) {
    return new SliverList(
      key: widget.key,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          ResultModel data = _list.elementAt(index);
          return new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  data.word,
                  semanticsLabel: data.word,
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
                itemCount: data.sense.length,
                itemBuilder: (context, index){
                  SenseModel sense = data.sense[index];
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
        childCount: _list.length
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