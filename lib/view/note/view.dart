part of 'main.dart';

class View extends _State with _Bar {

  @override
  Widget build(BuildContext context) {
    return new ScrollPage(
      key: scaffoldKey,
      controller: controller,
      child: _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new SliverAnimatedList(
          key: core.listKeyHistory,
          initialItemCount: core.collection.history.length,
          itemBuilder: (BuildContext _, int index, Animation<double> animation) => HistoryItem(
            key: ValueKey(index),
            animation: animation,
            word:core.collection.history.getAt(index),
            index: index,
            launch: () => this.search(core.collection.history.getAt(index)),
            // launch: () {
            //   // FormNotifier form = Provider.of<FormNotifier>(context,listen: false);
            //   // form.searchQuery = core.collection.history.getAt(index);
            //   core.collection.notify.searchQuery.value = core.collection.history.getAt(index);
            //   controller.master.bottom.pageChange(0);
            //   // print(core.collection.history.getAt(index));
            // },
            delete: (){
              // core.listKeyHistory.currentState.removeItem(
              //   index,
              //   (_, animation) => HistoryItem(index: index, animation: animation, word: "",)
              // );
              SliverAnimatedList.of(_).removeItem(index,
                (_, animation) => HistoryItem(key:ValueKey(index),index: index, animation: animation, word: "",)
              );
              core.collection.history.deleteAt(index);
            }
          )
        )
      ]
    );
  }

}

class HistoryItem extends StatefulWidget {
  const HistoryItem({
    Key key,
    this.index,
    this.word,
    this.delete,
    this.launch,
    this.animation,
  }) : super(key: key);

  final int index;
  final String word;
  final void Function() delete;
  final void Function() launch;
  final Animation<double> animation;

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      key: widget.key,
      sizeFactor: widget.animation,
      child:list()
    );
  }

  Widget list(){
    return new SlideableAnimatedList(
      key: ValueKey(widget.index),
      animation: widget.animation,
      menu: menu(),
      right: <Widget>[
        new CupertinoButton(
          child: new Icon(
            CupertinoIcons.trash,
            color: Colors.grey,
            size: 20
          ),
          onPressed: widget.delete
        ),
      ]
    );
  }

  Widget decoration({Widget child}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.6,
            offset: Offset(0.0, .0)
          )
        ]
      ),
      child:child
    );
  }

  Widget menu(){
    return decoration(
      child: CupertinoButton(
        // padding: EdgeInsets.symmetric(horizontal:13,vertical:5),
        padding: EdgeInsets.symmetric(horizontal:13,vertical:17),
        onPressed: widget.launch,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Icon(
                  CupertinoIcons.timer,
                  color: Theme.of(context).backgroundColor,
                  // size: 22
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                widget.word,
                style: TextStyle(
                  height: 1.0
                  // fontSize: 20
                )
              )
            )
          ]
        )
      )
    );
  }
}