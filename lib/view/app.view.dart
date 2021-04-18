part of 'app.dart';

class AppView extends _State {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FormData()),
        ChangeNotifierProxyProvider<FormData, FormNotifier>(
          create: (context) => FormNotifier(),
          update: (context, data, form) {
            if (form == null) throw ArgumentError.notNull('form');
            form.searchQuery = data.searchQuery;
            form.keyword = data.keyword;
            return form;
          },
        ),
        ChangeNotifierProvider<NodeNotifier>(
          create: (context) => NodeNotifier(),
        ),
        ChangeNotifierProvider<Store>(
          create: (context) => Store(),
        ),
      ],
      child: FutureBuilder(
        future: initiator,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return ScreenLauncher(message:'A moment');
              break;
            case ConnectionState.active:
              return ScreenLauncher(message:'...wait');
              break;
            case ConnectionState.none:
              return ScreenLauncher(message:'getting ready...');
              break;
            // case ConnectionState.done:
            //   return _start();
            //   break;
            default:
              return _start();
          }
        }
      )
    );
  }

  Widget _start() {
    return Scaffold(
      key: scaffoldKey,
      primary: true,
      resizeToAvoidBottomInset: true,
      // body: Navigator(key: navigator, onGenerateRoute: _routeGenerate, onUnknownRoute: _routeUnknown ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        // onUnknownRoute: routeUnknown,
        child: new PageView.builder(
          controller: pageController,
          // onPageChanged: _pageChanged,
          allowImplicitScrolling:false,
          physics:new NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => pageView[index],
          itemCount: pageView.length,
        )
      ),
      // extendBody: true,
      bottomNavigationBar: bottom()
    );
  }

  Widget bottom() {
    return ScrollPageBottom(
      controller: _controller,
      items: pageButton,
      builderDecoration: bottomDecoration,
      builderButton: buttonItem
    );
  }

  Widget bottomDecoration({Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        // color: Theme.of(context).backgroundColor,
        borderRadius: new BorderRadius.vertical(
          top: Radius.elliptical(3, 2),
          // bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            // color: Colors.black38,
            spreadRadius: 0.7,
            offset: Offset(-0.1, -0.5),
          )
        ]
      ),
      child: child
    );
  }

  Widget buttonItem({int index, ModelPage item, bool current, bool route}) {
    return Tooltip(
      message: item.description,
      child: CupertinoButton(
        minSize: 50,
        padding: EdgeInsets.symmetric(horizontal:22),
        child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal:0,vertical:10),
          child: Icon(
            item.icon,
            size: route?26:18,
            // color: route?null:Colors.blueGrey,
            // color: route?null:Theme.of(context).hintColor,
            // color: route?null:Theme.of(context).hintColor,
            // size:current?25:27
          )
        ),
        disabledColor: route?CupertinoColors.quaternarySystemFill:Theme.of(context).hintColor,
        // onPressed: current?null:()=>route?_navView(index):item.action(context)
        onPressed: buttonPressed(context, item,index,current)
      ),
    );
  }

  int get asdfasdfasd => core.collection.history.length;

  Function buttonPressed(BuildContext context, ModelPage item, int index, bool disable) {
    if (disable) {
      return null;
    } else if (item.action == null) {
      return ()=>_navView(index);
    } else {
      // _controller.master.bottom.pageChange(0);
      // return ()=>item.action(context);
      // core.collection.history.length;
      // print(core.collection.history.length);
      // print(asdfasdfasd.toString());
      // print(core.counter.toString());
      // int total = asdfasdfasd;
      // // int currentPosition=0;
      // // int nextButton = 1;
      // // int previousButton = -1;
      // if (total > 0){
      //   return () {
      //     if (_controller.master.bottom.pageNotify.value != 0){
      //       _navView(0);
      //     }
      //     item.action(context);
      //   };

      // }
    }
    // int abc = context.watch<HistoryNotifier>().current;
    // int abc = context.watch<HistoryNotifier>().next;
    return null;
  }
}