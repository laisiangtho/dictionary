part of 'main.dart';

class Bar extends StatefulWidget {
  Bar({
    Key key,
    this.focusNode,
    this.textController,
    this.search
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
      key: widget.key,
      pinned: true,
      floating:true,
      delegate: new ScrollHeaderDelegate(bar,minHeight: 40, maxHeight: 50)
    );
  }

  Widget decoration({BuildContext context, double stretch, Widget child}){
    return DecoratedBox(
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
      child: sf(child)
    );
  }

  Widget sf(Widget child){
    return Consumer<FormNotifier>(
      builder: (BuildContext context, FormNotifier form, Widget _) {
        // var abcs = Provider.of<FormNotifier>(context,listen: false);
        if (form.keyword != widget.textController.text){
          widget.textController.text = form.keyword;
        }
        return child;
      }
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return decoration(
      context:context,
      stretch: overlaps?1.0:stretch,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.only(left:12,right:widget.focusNode.hasFocus?0:12, top: 7, bottom: 7),
              child: Builder(builder: (BuildContext context) => form(context,shrink,stretch))
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints){
              var hasFocus = context.watch<NodeNotifier>().focus;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: hasFocus?70:0,
                child: hasFocus?new CupertinoButton (
                  onPressed: () => widget.search(context,widget.textController.text),
                  padding: EdgeInsets.zero,
                  minSize: 35.0,
                  child:Text('Cancel', maxLines: 1, style: TextStyle(fontSize: 14))
                ):Container()
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
      child: TextFormField(
        controller: widget.textController,
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        onChanged: (String word){
          context.read<FormNotifier>().keyword = word;
        },
        onFieldSubmitted: (String word) => widget.search(context,word),
        // autofocus: true,
        enableInteractiveSelection: true,
        enabled: true,
        // maxLength: 5,
        // initialValue: null,
        // showCursor: true,
        // cursorHeight:15.0,
        enableSuggestions: true,
        // buildCounter: (BuildContext a, {int currentLength, bool isFocused, int maxLength}) {},
        // textAlign: focusNode.hasFocus?TextAlign.start:TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'sans-serif',
          // fontSize: (10+(15-10)*stretch),
          fontWeight: FontWeight.w300,
          height: 1.3,
          // fontSize: 15 + (2*stretch),
          fontSize: 17 + (2*shrink),
          // color: Colors.black
        ),

        decoration: InputDecoration(
          // labelText: 'Search',
          // isDense: true,
          // (widget.focusNode.hasFocus && textController.text.isNotEmpty)?
          suffixIcon: Opacity(
            opacity: shrink,
            child: SizedBox.shrink(
              // context.read<NodeNotifier>().focus && this.textController.value.isNotEmpty)
              child: (context.watch<NodeNotifier>().focus && context.watch<FormNotifier>().keyword.isNotEmpty)?new CupertinoButton (
                // onPressed: ()=> this.textController.clear,
                onPressed: () {
                  widget.textController.clear();
                },
                // color: Colors.orange,
                padding: EdgeInsets.zero,
                // child:Icon(Icons.clear,color:Colors.grey,size: 17),
                child:Icon(CustomIcon.cancel,color:Colors.grey,size: 10),
              ):null
            )
          ),
          // prefixIcon: Icon(CustomIcon.find,color:Colors.grey[focusNode.hasFocus?100:400],size: 20),
          prefixIcon: Icon(CustomIcon.find,color:Theme.of(context).backgroundColor,size: 17),
          hintText: "... a word or two",
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (7*shrink)),
          fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).backgroundColor.withOpacity(shrink),width: 0.8),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).backgroundColor.withOpacity(shrink),width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.0),
            // borderRadius: BorderRadius.all(Radius.circular(10)),
          )
        )
      )
    );
  }
}
