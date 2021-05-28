part of 'main.dart';

mixin _Bar on _State {
  Widget bar(bool innerBoxIsScrolled, int count){
    return SliverAppBar(
      pinned: true,
      floating: false,
      // snap: false,
      centerTitle: true,
      elevation: 0.7,
      forceElevated: innerBoxIsScrolled,
      title: barTitle(),
      // expandedHeight: 120,
      // backgroundColor: innerBoxIsScrolled?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
      ),
      automaticallyImplyLeading: false,
      leading: Navigator.canPop(context)?IconButton(
        icon: Icon(CupertinoIcons.back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ):null,
      actions: [
        WidgetHint(
          label: "Recent searches",
          message: "Delete all",
          enabled: count > 0,
          child: CupertinoButton(
            // child: Icon(Icons.delete_sharp),
            child: Icon(MyOrdbokIcon.trash),
            // onPressed: (count > 0)?onClearAll:null
            onPressed: (count > 0)?() {
              doConfirmWithDialog(
                context: context,
                message: 'Do you really want to delete all?'
              ).then(
                (bool? confirmation) {
                  if (confirmation != null && confirmation) onClearAll();
                }
              );
            }:null
          )
        ),
      ],
      // flexibleSpace: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     double top = constraints.biggest.height;
      //     return FlexibleSpaceBar(
      //       // centerTitle: true,
      //       titlePadding: EdgeInsets.symmetric(vertical:10,horizontal:20),
      //       title: AnimatedOpacity(
      //         duration: Duration(milliseconds: 200),
      //         // opacity: top > 71 && top < 91 ? 1.0 : 0.0,
      //         opacity: top < 120 ? 0.0 : 1.0,
      //         child: Text(
      //           'Recent searches',
      //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      //         )
      //       ),
      //       // background: Image.network(
      //       //   "https://images.ctfassets.net/pjshm78m9jt4/383122_header/d79a41045d07d114941f7641c83eea6d/importedImage383122_header",
      //       //   fit: BoxFit.cover,
      //       // )
      //     );
      //   }
      // ),
      // bottom: PreferredSize(
      //   preferredSize: Size.fromHeight(56.0),
      //   // child: Text('a'),
      //   child: Container(
      //     padding: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
      //     height: 20.0,
      //     alignment: Alignment.center,
      //     width: double.infinity,
      //     child: Text('Recent searches'),
      //   ),
      // ),
    );
  }

  Widget barTitle() {
    return Semantics(
      label: "Page",
      child: Text(
        'History',
        semanticsLabel: 'History',
        style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight:FontWeight.w400),
        // style: TextStyle(
        //   // fontFamily: "sans-serif",
        //   // color: Color.lerp(Colors.white, Colors.white24, stretch),
        //   // color: Colors.black,
        //   // fontWeight: FontWeight.w300,
        //   // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
        //   // fontSize:35.0,
        //   // fontSize:(35*stretch).clamp(25.0, 35.0),
        //   // shadows: <Shadow>[
        //   //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
        //   // ]
        // )
      )
    );
  }

}
