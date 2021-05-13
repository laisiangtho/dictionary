part of 'main.dart';

mixin _Bar on _State {

  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      floating:true,
      pinned: true,
      delegate: new ScrollHeaderDelegate(_barMain,maxHeight: 120)
      // delegate: new ScrollPageBarDelegate(bar)
    );
  }

  Widget _barDecoration({double stretch, Widget child}){
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
            // color: Theme.of(context).backgroundColor.withOpacity(stretch),
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: child
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    // double width = MediaQuery.of(context).size.width/2;
    // print('overlaps $overlaps stretch $stretch shrink $shrink');
    return _barDecoration(
      stretch: overlaps?1.0:shrink,
      // child: Center(child: Text('More: $shrink'))
      child: Stack(
        children: <Widget>[
          // Align(
          //   alignment: Alignment.lerp(Alignment(0.5,0),Alignment(-0.7,0), stretch),
          //   child:Transform.rotate(
          //     angle:6*shrink,
          //     child: Container(
          //       child: Text(core.version),
          //       padding: EdgeInsets.all(2),
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).backgroundColor,
          //         borderRadius: new BorderRadius.all(Radius.circular(3))
          //       )
          //     )
          //   )
          // ),
          Align(
            alignment: Alignment.lerp(Alignment(-0.8,0.2),Alignment(-0.7,0), stretch),
            // alignment: Alignment(-.9,0),
            child: _barTitle(stretch)
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     _barSortButton()
          //   ]
          // ),
          Align(
            // alignment: Alignment(.95,-1),
            alignment: Alignment(.95,0),
            child: _barSortButton(),
          ),
        ]
      )
    );
  }

  Widget _barSortButton(){
    return Tooltip(
        message: 'Restore',
        child: CupertinoButton(
          child: Icon(Icons.restore),
          onPressed: null
        ),
      );
  }

  Widget _barTitle(double shrink){
    return Semantics(
      label: "Setting",
      child: Text(
        core.collection.env.name,
        semanticsLabel: core.collection.env.name,
        style: TextStyle(
          fontFamily: "sans-serif",
          // color: Color.lerp(Colors.white, Colors.white24, stretch),
          // color: Colors.black,
          fontWeight: FontWeight.w200,
          // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
          // fontSize:35 - (16*stretch),
          fontSize:(35*shrink).clamp(25.0, 35.0),
          // shadows: <Shadow>[
          //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
          // ]
        )
      )
    );
  }

}
