import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:lidea/scroll.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}

class View extends _State with _Bar{

  Widget build(BuildContext context) {
    // super.build(context);
    return ScrollPage(
      key: scaffoldKey,
      controller: controller,
      depth: 1,
      child: body()
    );
  }

  Widget body() {
    return NestedScrollView(
      // floatHeaderSlivers: true,
      controller: controller,
      // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // dragStartBehavior: DragStartBehavior.start,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        // print('innerBoxIsScrolled $innerBoxIsScrolled');
        return <Widget>[
          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: _SliverAppBarDelegate(
          //     child: PreferredSize(
          //       preferredSize: Size.fromHeight(120.0),
          //       child: Container(
          //         color: Theme.of(context).primaryColor,
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Text('SliverPersistentHeader', style: TextStyle(color: Colors.white, fontSize: 20.0))
          //             ],
          //           ),
          //         ),
          //       ),
          //     )
          //   ),
          // ),
          // sliverPersistentHeader(),
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // backgroundColor: Colors.transparent,
            title: Text(
              "Test",
            ),
            elevation: 1,
            forceElevated: innerBoxIsScrolled,
            // centerTitle: true,
            pinned: true,
            floating: true,
            expandedHeight: 120,
            // shape: CustomShapeBorder(),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              // child: Text('a'),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
                child: Container(
                  height: 36.0,
                  width: double.infinity,
                  child: CupertinoTextField(
                    keyboardType: TextInputType.text,
                    placeholder: 'Filtrar por nombre o nombre corto',
                    placeholderStyle: TextStyle(
                      color: Color(0xffC4C6CC),
                      fontSize: 17.0,
                      fontFamily: 'Brutal',
                    ),
                    prefix: Padding(
                      padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                      child: Icon(
                        Icons.search,
                        color: Color(0xffC4C6CC),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      // color: Color(0xffF0F1F5),
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Reading Now",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              // background: Image.network(
              //     "https://i.stack.imgur.com/1lN0b.png",
              //     fit: BoxFit.fill,
              //   ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: LayoutBuilder(
          builder: (context, constraints) => ListView.builder(
            // key: UniqueKey(),
            // key: new PageStorageKey<int>(1),
            primary: true,
            // shrinkWrap: true,
            // controller: controller,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            // Let the ListView know how many items it needs to build.
            itemCount: 30,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('title $index'),
                subtitle: Text('sub'),
              );
            },
          )
        ),
      )
      // body: ListView.builder(
      //   // key: UniqueKey(),
      //   // key: new PageStorageKey<int>(1),
      //   // primary: true,
      //   // shrinkWrap: true,
      //   // controller: controller,
      //   physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //   // Let the ListView know how many items it needs to build.
      //   itemCount: 30,
      //   // Provide a builder function. This is where the magic happens.
      //   // Convert each item into a widget based on the type of item it is.
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text('title $index'),
      //       subtitle: Text('sub'),
      //     );
      //   },
      // )
    );
  }
}

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
        'AppName',
        semanticsLabel: 'AppName',
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

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {

    final double innerCircleRadius = 150.0;

    Path path = Path();
    path.lineTo(0, rect.height);
    path.quadraticBezierTo(rect.width / 2 - (innerCircleRadius / 2) - 30, rect.height + 15, rect.width / 2 - 75, rect.height + 50);
    path.cubicTo(
        rect.width / 2 - 40, rect.height + innerCircleRadius - 40,
        rect.width / 2 + 40, rect.height + innerCircleRadius - 40,
        rect.width / 2 + 75, rect.height + 50
    );
    path.quadraticBezierTo(rect.width / 2 + (innerCircleRadius / 2) + 30, rect.height + 15, rect.width, rect.height);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }
}
