import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';


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
part 'app.view.dart';

class AppMain extends StatefulWidget {
  AppMain({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => AppView();
}

abstract class _State extends State<AppMain> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  final core = Core();

  final GlobalKey<Home.View> _home = GlobalKey<Home.View>();
  final GlobalKey<Note.View> _note = GlobalKey<Note.View>();
  final GlobalKey<More.View> _more = GlobalKey<More.View>();

  final homeKey = UniqueKey();
  final noteKey = UniqueKey();
  final moreKey = UniqueKey();

  final List<Widget> pageView = [];
  final List<ModelPage> pageButton = [];

  Future<void> initiator;

  @override
  void initState() {
    super.initState();
    initiator = core.init();
    // initiator = new Future.delayed(new Duration(seconds: 1));
    if (pageView.length == 0){
      pageButton.addAll([
        ModelPage(icon:CustomIcon.chapter_previous, name:"Previous", description: "Previous search", action: historyPrevious ),
        ModelPage(icon:CustomIcon.search, name:"Home", description: "Search dictionary", key: 0),
        ModelPage(icon:CustomIcon.chapter_next, name:"Next", description: "Next search", action: historyNext),

        ModelPage(icon:CustomIcon.layers, name:"History", description: "Recent searches", key: 1),
        ModelPage(icon:CustomIcon.dot_horiz, name:"More", description: "More information", key: 2),
      ]);
      pageView.addAll([
        WidgetKeepAlive(key:homeKey, child: new Home.Main(key: _home)),
        WidgetKeepAlive(key:noteKey, child: new Note.Main(key: _note)),
        WidgetKeepAlive(key:moreKey, child: new More.Main(key: _more))
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
    core.store.subscription.cancel();
    _controller.dispose();
    super.dispose();
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
    print('historyPrevious');
  }

  void historyNext(BuildContext context){
    // _controller.master.bottom.pageChange(index);
    print('historyNext');
  }

  // void _pageChanged(int index){
  //   _controller.master.bottom.pageChange(index);
  // }
}
