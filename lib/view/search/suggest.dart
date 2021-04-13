part of 'main.dart';

class ViewSuggestion extends StatefulWidget {
  ViewSuggestion({Key key,this.searchQuery}) : super(key: key);

  final String searchQuery;

  @override
  _ViewSuggestionState createState() => _ViewSuggestionState();
}

class _ViewSuggestionState extends State<ViewSuggestion> {
  final core = Core();

  @override
  Widget build(BuildContext context) {
    if (widget.searchQuery.isEmpty) return WidgetMessage(key: widget.key,message: 'suggestion');
    try {
      if (core.suggestion(widget.searchQuery).length > 0) {
        return _suggestionKeyword(core.collection.suggestion);
      } else {
        return WidgetContent(key: widget.key,atLeast: 'found no contain\nof ',enable:widget.searchQuery,task: '\nin ',message:'bibleInfo?.name');
      }
    } catch (e) {
      return WidgetMessage(key: widget.key,message: '???');
    }
  }

  Widget _suggestionKeyword(List<WordType> _r) {
    return new SliverList(
      key: widget.key,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int i) => SuggestionItem(searchQuery: widget.searchQuery, index: i, data: _r.elementAt(i)),
        childCount: _r.length
      )
    );
  }

}

class SuggestionItem extends StatelessWidget {
  SuggestionItem({Key key,this.searchQuery,this.data,this.index}): super(key: key);
  final String searchQuery;
  final WordType data;
  final int index;

  @override
  Widget build(BuildContext context) {
    /*
    return Container(
      margin: EdgeInsets.symmetric(horizontal:5,vertical:2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: new BorderRadius.all(
          // Radius.elliptical(3, 3)
          Radius.elliptical(7, 100)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.6,
            offset: Offset(0.0, .0),
          )
        ]
      ),
      child: new ListTile(
        leading: const Icon(Icons.subdirectory_arrow_right,color: Colors.black26,size: 18.0,),
        // contentPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal:25),
        title: RichText(
          strutStyle: StrutStyle(),
          text: TextSpan(
            text: data.v.substring(0, this.searchQuery.length),
            style: TextStyle(color: Colors.red,height: 1.0,fontSize: 18),
            children: <TextSpan>[
              TextSpan(
                text: data.v.substring(this.searchQuery.length),
                style: TextStyle(color: Theme.of(context).primaryColorDark)
              )
            ]
          )
        ),
        onTap: () {
          var abc = Provider.of<FormNotifier>(context,listen: false);
          abc.searchQuery = data.v;
          abc.keyword = data.v;
          FocusScope.of(context).unfocus();
        }
      ),
    );
    */
    // return container(context:context);
    return Container(
      // padding: EdgeInsets.zero,
      // padding: EdgeInsets.symmetric(horizontal:13,vertical:7),
      // margin: EdgeInsets.symmetric(horizontal:0,vertical:0.5),
      margin: EdgeInsets.only(top:1.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        // borderRadius: new BorderRadius.all(
        //   // Radius.elliptical(3, 3)
        //   Radius.elliptical(7, 100)
        // ),
        // border: Border(
        //   top: BorderSide(color: Theme.of(context).backgroundColor, width: 0.5),
        //   bottom: BorderSide(color: Theme.of(context).backgroundColor, width: 0.5)
        // ),
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

  Widget container({BuildContext context}){
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal:13,vertical:10),
      onPressed: () {
        var abc = Provider.of<FormNotifier>(context,listen: false);
        abc.searchQuery = data.v;
        abc.keyword = data.v;
        FocusScope.of(context).unfocus();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            // child: Icon(CustomIcon.wave_square),
            child: Container(
              // color: Colors.red,
              child: Icon(
                CupertinoIcons.arrow_turn_down_right,
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
          // Container(
          //   color: Colors.red,
          //   child: Icon(CupertinoIcons.arrow_turn_down_right),
          // ),
          Expanded(
            flex: 7,
            child: RichText(
              strutStyle: StrutStyle(height: 1.0,),
              text: TextSpan(
                text: data.v.substring(0, this.searchQuery.length),
                style: TextStyle( fontSize: 18, color: Theme.of(context).textTheme.caption.color, fontWeight: FontWeight.w300),
                children: <TextSpan>[
                  TextSpan(
                    text: data.v.substring(this.searchQuery.length),
                    style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant, fontWeight: FontWeight.w400)
                  )
                ]
              )
            ),
          )
        ],
      ),
    );
    // return new ListTile(
    //   horizontalTitleGap: 0,
    //   minVerticalPadding: 0,
    //   minLeadingWidth: 35,
    //   dense:true,
    //   leading: const Icon(CupertinoIcons.arrow_turn_down_right,size: 18.0, textDirection: TextDirection.ltr,),
    //   // contentPadding: EdgeInsets.zero,
    //   contentPadding: EdgeInsets.symmetric(horizontal:25, vertical: 0),
    //   title: RichText(
    //     strutStyle: StrutStyle(),
    //     text: TextSpan(
    //       text: data.v.substring(0, this.searchQuery.length),
    //       // style: TextStyle(color: Colors.red,height: 1.0,),
    //       style: TextStyle( fontSize: 18, color: Theme.of(context).textTheme.caption.color, fontWeight: FontWeight.w300),
    //       children: <TextSpan>[
    //         TextSpan(
    //           text: data.v.substring(this.searchQuery.length),
    //           // style: TextStyle(color: Theme.of(context).primaryColorDark)
    //           style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant,fontWeight: FontWeight.w400)
    //         )
    //       ]
    //     )
    //   ),
    //   onTap: () {
    //     var abc = Provider.of<FormNotifier>(context,listen: false);
    //     abc.searchQuery = data.v;
    //     abc.keyword = data.v;
    //     FocusScope.of(context).unfocus();
    //   }
    // );
    // return Container(
    //   // padding: EdgeInsets.symmetric(horizontal:13,vertical:7),
    //   // margin: EdgeInsets.symmetric(horizontal:0,vertical:0.5),
    //   // margin: EdgeInsets.only(top:1.0),
    //   padding: EdgeInsets.zero,
    //   margin: EdgeInsets.only(top:1.0),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).primaryColor,
    //     // borderRadius: new BorderRadius.all(
    //     //   // Radius.elliptical(3, 3)
    //     //   Radius.elliptical(7, 100)
    //     // ),
    //     // border: Border(
    //     //   top: BorderSide(color: Theme.of(context).backgroundColor, width: 0.5),
    //     //   bottom: BorderSide(color: Theme.of(context).backgroundColor, width: 0.5)
    //     // ),
    //     boxShadow: [
    //       BoxShadow(
    //         blurRadius: 0.0,
    //         color: Theme.of(context).backgroundColor,
    //         spreadRadius: 0.6,
    //         offset: Offset(0.0, .0),
    //       )
    //     ]
    //   ),
    //   child: new ListTile(
    //     horizontalTitleGap: 0,
    //     minVerticalPadding: 0,
    //     minLeadingWidth: 35,
    //     leading: const Icon(CupertinoIcons.arrow_turn_down_right,color: Colors.black26,size: 18.0, textDirection: TextDirection.ltr,),
    //     // contentPadding: EdgeInsets.zero,
    //     contentPadding: EdgeInsets.symmetric(horizontal:25, vertical: 0),
    //     title: RichText(
    //       strutStyle: StrutStyle(),
    //       text: TextSpan(
    //         text: data.v.substring(0, this.searchQuery.length),
    //         style: TextStyle(color: Colors.red,height: 1.0,),
    //         children: <TextSpan>[
    //           TextSpan(
    //             text: data.v.substring(this.searchQuery.length),
    //             style: TextStyle(color: Theme.of(context).primaryColorDark)
    //           )
    //         ]
    //       )
    //     ),
    //     onTap: () {
    //       var abc = Provider.of<FormNotifier>(context,listen: false);
    //       abc.searchQuery = data.v;
    //       abc.keyword = data.v;
    //       FocusScope.of(context).unfocus();
    //     }
    //   ),
    // );
  }
}
