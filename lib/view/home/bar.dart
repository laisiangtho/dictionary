part of 'main.dart';

mixin _Bar on _State {
  Widget bar( bool innerBoxIsScrolled){
    return SliverAppBar(
      pinned: true,
      floating: true,
      // snap: false,
      // centerTitle: true,
      elevation: 0.7,
      forceElevated: focusNode.hasFocus|innerBoxIsScrolled,
      title: barTitle(),
      expandedHeight: !focusNode.hasFocus?120:50,
      // backgroundColor: innerBoxIsScrolled?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: focusNode.hasFocus?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
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
      // actions: [
      //   CupertinoButton(
      //     child: Icon(
      //       CupertinoIcons.checkmark_shield_fill
      //     ),
      //     onPressed: null
      //   )
      // ],
      // flexibleSpace: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) => FlexibleSpaceBar()
      // ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          height: 35.0,
          // width: double.infinity,
          margin: EdgeInsets.fromLTRB(16.0, 7.0, 5.0, 10.0),
          // padding: EdgeInsets.fromLTRB(16.0, 7.0, 6.0, 7.0),
          // width: double.infinity,
          child: barSearch(innerBoxIsScrolled),
        ),
      ),
    );
  }

  Widget barTitle() {
    // final focus = !context.watch<Core>().nodeFocus;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: focusNode.hasFocus?0:null,
      height: focusNode.hasFocus?0:null,
      child: Semantics(
        label: "Setting",
        child: Text(
          'MyOrdbok',
          semanticsLabel: 'core.collection.env.name',
          style: TextStyle(
            // fontFamily: "sans-serif",
            // color: Color.lerp(Colors.white, Colors.white24, stretch),
            // color: Colors.black,
            // fontWeight: FontWeight.w300,
            // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
            // fontSize:35.0,
            // fontSize:(35*stretch).clamp(25.0, 35.0),
            // shadows: <Shadow>[
            //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
            // ]
          )
        )
      ),
    );
    // return AnimateExpansion(
    //   animate: !context.watch<Core>().nodeFocus,
    //   axisAlignment: 1.0,
    //   child: Semantics(
    //     label: "Setting",
    //     child: Text(
    //       'MyOrdbok',
    //       semanticsLabel: 'core.collection.env.name',
    //       style: TextStyle(
    //         // fontFamily: "sans-serif",
    //         // color: Color.lerp(Colors.white, Colors.white24, stretch),
    //         // color: Colors.black,
    //         // fontWeight: FontWeight.w300,
    //         // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
    //         // fontSize:35.0,
    //         // fontSize:(35*stretch).clamp(25.0, 35.0),
    //         // shadows: <Shadow>[
    //         //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
    //         // ]
    //       )
    //     )
    //   )
    // );

    // return Semantics(
    //   label: "Setting",
    //   child: Text(
    //     'MyOrdbok',
    //     semanticsLabel: 'core.collection.env.name',
    //     style: TextStyle(
    //       fontFamily: "sans-serif",
    //       // color: Color.lerp(Colors.white, Colors.white24, stretch),
    //       // color: Colors.black,
    //       fontWeight: FontWeight.w300,
    //       // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
    //       fontSize:25,
    //       // fontSize:(35*stretch).clamp(25.0, 35.0),
    //       // shadows: <Shadow>[
    //       //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
    //       // ]
    //     )
    //   )
    // );
  }

  Widget barSearch(bool innerBoxIsScrolled){
    // BuildContext context,double offset,bool overlaps, double shrink, double stretch
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            // margin: EdgeInsets.only(left:12,right:widget.focusNode.hasFocus?0:12, top: 7, bottom: 7),
            margin: EdgeInsets.only(left:0,right:focusNode.hasFocus?0:12,),
            child: Builder(builder: (BuildContext context) => barForm(innerBoxIsScrolled))
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: focusNode.hasFocus?70:0,
          child: focusNode.hasFocus?Semantics(
            enabled: true,
            label: "Cancel",
            child: new CupertinoButton(
              // onPressed: () => widget.search(context,core.collection.notify.searchQuery.value),
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              minSize: 35.0,
              child:Text(
                'Cancel',
                semanticsLabel: "search",
                maxLines: 1
              )
            )
          ):null,
        )
      ]
    );
  }

  Widget barForm(bool innerBoxIsScrolled){
    // BuildContext context, double shrink, double stretch
    return Focus(
      key: _focusKey,
      canRequestFocus:true,
      onFocusChange: (hasFocus) {
        context.read<Core>().nodeFocus = hasFocus;
        // Provider.of<Core>(context,listen: false).nodeFocus = true;
      },
      child: Semantics(
        label: "Search for definition",
        textField: true,
        // enabled: context.watch<Core>().nodeFocus,
        child: TextFormField(
          controller: textController,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          // onChanged: (String word) => widget.textController.text = word.replaceAll(RegExp(' +'), ' ').trim(),
          // onFieldSubmitted: (String word) => widget.search(context,word.replaceAll(RegExp(' +'), ' ').trim()),
          onChanged: (String str) => onSuggest(str),
          onFieldSubmitted: (String str) => onSearch(str),
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
            fontSize: 17,
            // fontSize: 15 + (2*stretch),
            // fontSize: 17 + (2*shrink),
            // fontSize: 20 + (2*shrink),

            // color: Colors.black
            color: Theme.of(context).colorScheme.primaryVariant
          ),

          decoration: InputDecoration(
            // (focusNode.hasFocus && textController.text.isNotEmpty)?
            // context.select((Core core) => focusNode.hasFocus && core.suggestionQuery.isNotEmpty)
            // suffixIcon: SizedBox.shrink(
            //   child: Semantics(
            //     label: "Clear",
            //     child: new CupertinoButton (
            //       onPressed: () {
            //         textController.clear();
            //         context.read<Core>().suggestionQuery = '';
            //       },
            //       // minSize: 20,
            //       // padding: EdgeInsets.zero,
            //       padding: EdgeInsets.symmetric(horizontal: 0,vertical:0),
            //       child:Icon(
            //         CupertinoIcons.xmark_circle_fill,
            //         color:Colors.grey,
            //         size: 20,
            //         semanticLabel: "input"
            //       ),
            //     )
            //   )
            // ),
            suffixIcon: Selector<Core, bool>(
              selector: (BuildContext _, Core core) => core.nodeFocus && core.suggestionQuery.isNotEmpty,
              builder: (BuildContext _, bool word, Widget? child) {
                return word?SizedBox.shrink(
                  child: Semantics(
                    label: "Clear",
                    child: new CupertinoButton (
                      onPressed: () {
                        textController.clear();
                        // textController.text ='';
                        // context.read<Core>().suggestionQuery = '';
                        // Provider.of<Core>(context,listen: true).suggestionQuery = '';
                        // word = '';
                      },
                      // minSize: 20,
                      // padding: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical:0),
                      child:Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color:Colors.grey,
                        size: 20,
                        semanticLabel: "input"
                      ),
                    )
                  )
                ):child!;
              },
              child: SizedBox(),
            ),
            prefixIcon: Icon(
              MyOrdbokIcon.find,
              color:Theme.of(context).hintColor,
              size: 17
            ),
            hintText: " ... a word or two",
            hintStyle: TextStyle(color: Colors.grey),
            // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (7*shrink)),
            contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (10*shrink)),
            // fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
            fillColor: focusNode.hasFocus?Theme.of(context).scaffoldBackgroundColor:Theme.of(context).backgroundColor,
          )
        ),
      )
    );
  }
}
