part of 'main.dart';

class Bar extends StatelessWidget {
  Bar({
    Key key,
    this.focusNode,
    this.textController
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textController;
  final core = Core();

  @override
  Widget build(BuildContext context) {
    return new SliverPersistentHeader(
      key: key,
      pinned: true,
      floating:true,
      delegate: new ScrollHeaderDelegate(_barMain,minHeight: 40, maxHeight: 50)
    );
  }

  Widget _barDecoration({BuildContext context, double stretch, Widget child}){
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
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

  Widget sf( Widget child){
    return Consumer<FormNotifier>(
      builder: (BuildContext context, FormNotifier form, Widget _) {
        // var abcs = Provider.of<FormNotifier>(context,listen: false);
        if (form.keyword != textController.text){
          textController.text = form.keyword;
        }
        return child;
      }
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return _barDecoration(
      context:context,
      stretch: overlaps?1.0:stretch,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.only(left:12,right:focusNode.hasFocus?0:12, top: 7, bottom: 7),
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
                  // onPressed: this.focusNode?.unfocus,
                  onPressed: (){
                    this.focusNode?.unfocus();
                    FormNotifier word = context.read<FormNotifier>();
                    if (this.textController.text != word.searchQuery) {
                      this.textController.text = word.searchQuery;
                      word.keyword = word.searchQuery;
                    }
                  },
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
      child: TextFormField(
        controller: this.textController,
        focusNode: this.focusNode,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        onChanged: (String word){
          context.read<FormNotifier>().keyword = word;
        },
        onFieldSubmitted: (String word){
          context.read<FormNotifier>().searchQuery = word;
          core.analyticsSearch(word);
        },
        // autofocus: true,
        enableInteractiveSelection: true,
        enabled: true,
        // maxLength: 5,
        // initialValue: null,
        // showCursor: true,
        // cursorHeight:22.0,
        enableSuggestions: true,
        // buildCounter: (BuildContext a, {int currentLength, bool isFocused, int maxLength}) {},
        // textAlign: focusNode.hasFocus?TextAlign.start:TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'sans-serif',
          // fontSize: (10+(15-10)*stretch),
          fontWeight: FontWeight.w300,
          height: 1,
          // fontSize: 15 + (2*stretch),
          fontSize: 15 + (2*shrink),
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
                  this.textController.clear();
                  // context.read<FormNotifier>().keyword = '';
                },
                // color: Colors.orange,
                padding: EdgeInsets.zero,
                // child:Icon(Icons.clear,color:Colors.grey,size: 17),
                child:Icon(CustomIcon.cancel,color:Colors.grey,size: 10),
              ):null
            )
          ),
          // prefixIcon: Icon(CustomIcon.find,color:Colors.grey[focusNode.hasFocus?100:400],size: 20),
          prefixIcon: Icon(CustomIcon.find,color:Theme.of(context).backgroundColor,size: 20),
          hintText: "... a word or two",
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (3*shrink)),
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
      ),
      onFocusChange: (hasFocus) {
        context.read<NodeNotifier>().focus = hasFocus;
      },
    );
  }
}
