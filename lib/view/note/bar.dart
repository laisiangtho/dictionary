part of 'main.dart';

mixin _Bar on _State {

  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      floating:true,
      pinned: true,
      delegate: new ViewHeaderDelegate(_barMain)
      // delegate: new ScrollPageBarDelegate(bar)
    );
  }

  Widget _barDecoration({required double stretch, required Widget child}){
    return Container(
      decoration: BoxDecoration(
        // color: this.backgroundColor??Theme.of(context).primaryColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            // color: Colors.black38,
            color: Theme.of(context).backgroundColor.withOpacity(stretch >= 0.5?stretch:0.0),
            // color: Theme.of(context).backgroundColor,
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: child
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return _barDecoration(
      stretch: overlaps?1.0:shrink,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment(-0.70,0),
              child: Text('History')
            )
          ),
          Expanded(
            flex:0,
            child: ValueListenableBuilder(
              valueListenable: core.collection.history!.listenable(),
              builder: (context, Box<String?> box, _) {
                return CupertinoButton(
                  child: Text('Clear all',
                    style: TextStyle(
                      fontWeight: FontWeight.w300
                    )
                  ),
                  onPressed: (box.length == 0)?null: () async {
                    for (var i = 0; i <= core.collection.history!.length - 1; i++) {
                      Future.delayed(Duration(milliseconds: 500),(){
                        core.listKeyHistory.currentState!.removeItem(0,
                          (BuildContext context, Animation<double> animation) => HistoryItem(index: i, animation: animation, word: "")
                        );
                      });
                    }
                    core.collection.history!.clear();
                  }
                );
              }
            )
          )
        ]
      )
    );
  }

}
