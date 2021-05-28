import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/connectivity.dart';
// import 'package:lidea/scroll.dart';
import 'package:lidea/view.dart';

// import 'package:dictionary/notifier.dart';
import 'package:dictionary/core.dart';
import 'package:dictionary/widget.dart';
import 'package:dictionary/icon.dart';

import 'package:dictionary/view/home/main.dart' as Home;
// import 'package:dictionary/view/search/main.dart' as Home;
import 'package:dictionary/view/note/main.dart' as Note;
import 'package:dictionary/view/more/main.dart' as More;
// import 'package:dictionary/view/app.nestedScroll.dart' as More;

part 'app.launcher.dart';
part 'app.view.dart';

class AppMain extends StatefulWidget {
  AppMain({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => AppView();
}

abstract class _State extends State<AppMain> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  // final core = Core();
  final viewNotifyNavigation = ViewNotify.navigation;

  // final GlobalKey<Home.View> _home = GlobalKey<Home.View>();
  // final GlobalKey<Note.View> _note = GlobalKey<Note.View>();
  // final GlobalKey<More.View> _more = GlobalKey<More.View>();
  final _home = GlobalKey<ScaffoldState>();
  final _note = GlobalKey<ScaffoldState>();
  final _more = GlobalKey<ScaffoldState>();

  final homeKey = UniqueKey();
  final noteKey = UniqueKey();
  final moreKey = UniqueKey();

  final List<Widget> _pageView = [];
  final List<ViewNavigationModel> _pageButton = [];

  late Core core;
  late Future<void> initiator;
  late StreamSubscription<ConnectivityResult> connection;

  @override
  void initState() {
    super.initState();
    // Provider.of<Core>(context, listen: false);
    core = context.read<Core>();
    initiator = core.init();
    // initiator = new Future.delayed(new Duration(seconds: 1));
    connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      // ConnectivityResult.mobile
      // ConnectivityResult.wifi
      // ConnectivityResult.none
      print(result);
    });
    if (_pageView.length == 0){
      _pageButton.addAll([
        // ViewNavigationModel(icon:MyOrdbokIcon.chapter_previous, name:"Previous", description: "Previous search", action: onPreviousHistory() ),
        ViewNavigationModel(icon:MyOrdbokIcon.search, name:"Home", description: "Search dictionary", key: 0),
        // ViewNavigationModel(icon:MyOrdbokIcon.chapter_next, name:"Next", description: "Next search", action: onNextHistory()),

        ViewNavigationModel(icon:MyOrdbokIcon.layers, name:"History", description: "Recent searches", key: 1),
        ViewNavigationModel(icon:CupertinoIcons.settings, name:"Setting", description: "Setting", key: 2),
        // ViewNavigationModel(icon:MyOrdbokIcon.dot_horiz, name:"More", description: "More information", key: 2),
      ]);
      _pageView.addAll([
        WidgetKeepAlive(key:homeKey, child: new Home.Main(key: _home)),
        WidgetKeepAlive(key:noteKey, child: new Note.Main(key: _note)),
        WidgetKeepAlive(key:moreKey, child: new More.Main(key: _more)),
        // WidgetKeepAlive(child: new  TestView())
      ]);
    }

    viewNotifyNavigation.addListener((){
      final index = viewNotifyNavigation.value;
      // navigator.currentState.pushReplacementNamed(index.toString());

      // ViewNavigationModel page = pageButton.firstWhere((e) => e.key == index, orElse: () => pageButton.first);
      // core.analyticsScreen(page.name,'${page.name}State');
      // NOTE: check State isMounted
      // if(page.key.currentState != null){
      //   page.key.currentState.setState(() {});
      // }
      pageController.jumpToPage(index);

      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
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
    // core.store?.subscription?.cancel();
    _controller.dispose();
    viewNotifyNavigation.dispose();
    super.dispose();
    connection.cancel();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void _navView(int index){
    // _controller.master.bottom.pageChange(index);
    viewNotifyNavigation.value = index;
  }

  int history = 0;

  void Function()? onPreviousHistory(){
    // _controller.master.bottom.pageChange(index);
    print('onPreviousHistory');

    // final items = core.collection.boxOfHistory;
    // var abc = items.valuesBetween(startKey:1, endKey: 10);
    // print(abc.map((e) => e.word));
    //   final items = core.collection.boxOfHistory.toMap().values.toList();
    //   items.sort((a, b) => b.date!.compareTo(a.date!));

    // if (items.length > history) {
    //   return (){
    //     // print(items.first.word);
    //     print(items.map((e) => e.word));
    //     onSearch(items.elementAt(1).word);
    //   };
    // }

    return null;
  }

  void Function()? onNextHistory(){
    // _controller.master.bottom.pageChange(index);
    print('onNextHistory');
    return null;
  }

  void onSearch(String word){
    ViewNotify.navigation.value = 0;
    Future.delayed(const Duration(milliseconds: 200), () {
      core.definitionGenerate(word);
    });
    Future.delayed(Duration.zero, () {
      core.historyAdd(word);
    });
  }

  // void _pageChanged(int index){
  //   _controller.master.bottom.pageChange(index);
  // }
}
