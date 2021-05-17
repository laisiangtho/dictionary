part of 'main.dart';

class Bar extends StatefulWidget {
  Bar({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.search
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textController;
  final void Function(BuildContext context, String word) search;

  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> {
  final core = Core();

  @override
  Widget build(BuildContext context) {
    return new SliverPersistentHeader(

      pinned: true,
      floating:true,
      // delegate: new ViewHeaderDelegate(bar,minHeight: 40)
      delegate: new ViewHeaderDelegate(bar,minHeight: 60)
    );
  }

  Widget decoration({required BuildContext context, required double stretch, required Widget child}){
    // DecoratedBox
    return Container(
      padding: EdgeInsets.only(top:7, bottom:7),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // borderRadius: new BorderRadius.vertical(
        //   bottom: Radius.elliptical(3, 2)
        // ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor.withOpacity(stretch >= 0.5?stretch:0.0),
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: child
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return decoration(
      context:context,
      stretch: overlaps?1.0:stretch,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              // margin: EdgeInsets.only(left:12,right:widget.focusNode.hasFocus?0:12, top: 7, bottom: 7),
              margin: EdgeInsets.only(left:12,right:widget.focusNode.hasFocus?0:12, top: 3, bottom: 3),
              child: Builder(builder: (BuildContext context) => form(context,shrink,stretch))
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints){
              var hasFocus = context.watch<NodeNotifier>().focus;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: hasFocus?70:0,
                // child: hasFocus?new CupertinoButton(
                //   onPressed: () => widget.search(context,widget.textController.text),
                //   padding: EdgeInsets.zero,
                //   minSize: 35.0,
                //   child:Text(
                //     'Cancel',
                //     maxLines: 1,
                //     semanticsLabel: "Cancel search",
                //     style: TextStyle(fontSize: 14)
                //   )
                // ):Container()
                child: hasFocus?Semantics(
                  enabled: true,
                  label: "Cancel",
                  child: new CupertinoButton(
                    onPressed: () => widget.search(context,core.collection.notify.searchQuery.value),
                    padding: EdgeInsets.zero,
                    minSize: 35.0,
                    child:Text(
                      'Cancel',
                      semanticsLabel: "search",
                      maxLines: 1
                    )
                  )
                ):null
              );
          })
        ]
      ),
    );
  }

  Widget form(BuildContext context, double shrink, double stretch){
    return Focus(
      canRequestFocus:true,
      onFocusChange: (hasFocus) {
        context.read<NodeNotifier>().focus = hasFocus;
      },
      child: Semantics(
        label: "Search for definition",
        textField: true,
        enabled: context.watch<NodeNotifier>().focus,
        child: TextFormField(
          controller: widget.textController,
          focusNode: widget.focusNode,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          // onChanged: (String word) => widget.textController.text = word.replaceAll(RegExp(' +'), ' ').trim(),
          onFieldSubmitted: (String word) => widget.search(context,word.replaceAll(RegExp(' +'), ' ').trim()),
          // autofocus: true,
          enableInteractiveSelection: true,
          enabled: true,
          enableSuggestions: true,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'sans-serif',
            // fontSize: (10+(15-10)*stretch),
            fontWeight: FontWeight.w300,
            height: 1.1,
            // fontSize: 15 + (2*stretch),
            // fontSize: 17 + (2*shrink),
            fontSize: 20 + (2*shrink),
            // color: Colors.black
            color: Theme.of(context).colorScheme.primaryVariant
          ),

          decoration: InputDecoration(
            suffixIcon: Opacity(
              opacity: shrink,
              child: SizedBox.shrink(
                child: ValueListenableBuilder<String>(
                  valueListenable: core.collection.notify.suggestQuery,
                  builder: (context, value, _) => (context.watch<NodeNotifier>().focus && value.isNotEmpty)?_!:Container(),
                  child: Semantics(
                    label: "Clear",
                    child: new CupertinoButton (
                      onPressed: () {
                        widget.textController.clear();
                      },
                      // padding: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(horizontal: 1,vertical: (10*shrink)),
                      child:Icon(
                      CupertinoIcons.xmark_circle_fill,
                        color:Colors.grey,
                        size: 20,
                        semanticLabel: "input"
                      ),
                    )
                  ),
                )
              )
            ),
            prefixIcon: Icon(
              CustomIcon.find,
              color:Theme.of(context).backgroundColor,
              size: 17
            ),
            hintText: "... a word or two",
            hintStyle: TextStyle(color: Colors.grey),
            // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (7*shrink)),
            contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (10*shrink)),
            fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).backgroundColor.withOpacity(shrink),width: 0.9),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).backgroundColor.withOpacity(shrink),width: 0.9),
              // borderSide: BorderSide(color: Theme.of(context).shadowColor.withOpacity(shrink),width: 0.3),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 3.0),
              // borderRadius: BorderRadius.all(Radius.circular(10)),
            )
          )
        ),
      )
    );
  }
}
