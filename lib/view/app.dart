import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lidea/provider.dart';

import 'package:lidea/scroll.dart';

import 'package:dictionary/notifier.dart';
import 'package:dictionary/core.dart';
import 'package:dictionary/widget.dart';
import 'package:dictionary/icon.dart';

import 'package:dictionary/view/search/main.dart' as Home;
import 'package:dictionary/view/note/main.dart' as Note;
import 'package:dictionary/view/more/main.dart' as More;

part 'app.launcher.dart';

class AppView extends StatefulWidget {
  AppView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<AppView> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  final core = Core();

  final GlobalKey<Home.View> home = GlobalKey<Home.View>();
  final GlobalKey<Note.View> note = GlobalKey<Note.View>();
  final GlobalKey<More.View> more = GlobalKey<More.View>();

  final homeKey = UniqueKey();
  final noteKey = UniqueKey();
  final moreKey = UniqueKey();

  final List<Widget> pageView = [];
  final List<ModelPage> pageButton = [];

  Future<void> initiator;
  // HistoryNotifier history;

  @override
  void initState() {
    super.initState();
    initiator = core.init();
    // initiator = new Future.delayed(new Duration(seconds: 1));
    // history = context.watch<HistoryNotifier>();
    if (pageView.length == 0){
      pageButton.addAll([
        ModelPage(icon:CustomIcon.chapter_previous, name:"Previous", description: "Previous", action: historyPrevious ),
        ModelPage(icon:CustomIcon.search, name:"Home", description: "Search dictionary", key: 0),
        ModelPage(icon:CustomIcon.chapter_next, name:"Next", description: "Next", action: historyNext),

        ModelPage(icon:CustomIcon.layers, name:"About", description: "??", key: 1),
        ModelPage(icon:CustomIcon.dot_horiz, name:"More", description: "??", key: 2),
      ]);
      pageView.addAll([
        WidgetKeepAlive(key:homeKey, child: new Home.Main(key: home)),
        WidgetKeepAlive(key:noteKey, child: new Note.Main(key: note)),
        WidgetKeepAlive(key:moreKey, child: new More.Main(key: more))
      ]);
    }

    _controller.master.bottom.pageListener((int index){
      // navigator.currentState.pushReplacementNamed(index.toString());

      ModelPage page = pageButton.firstWhere((e) => e?.key == index, orElse: () => pageButton.first);
      // NOTE: check State isMounted
      // if(page.key.currentState != null){
      //   page.key.currentState.setState(() {});
      // }
      pageController.jumpToPage(index);
      core.analyticsScreen(page.name,'${page.name}State');

      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
      // navigator.currentState.pushNamed(index.toString());
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Note(),
      // ));
      // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => Bible(), maintainState: false));
      // Navigator.of(context, rootNavigator: false).pushNamed(index.toString());
      // Navigator.of(context, rootNavigator: false).pushReplacementNamed(index.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void _navView(int index){
    _controller.master.bottom.pageChange(index);
  }

  void historyPrevious(BuildContext context){
    // _controller.master.bottom.pageChange(index);
    core.counter--;
    print('historyPrevious');
  }

  void historyNext(BuildContext context){
    // _controller.master.bottom.pageChange(index);
    core.counter++;
    print('historyNext');
  }

  // void _pageChanged(int index){
  //   _controller.master.bottom.pageChange(index);
  // }

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
