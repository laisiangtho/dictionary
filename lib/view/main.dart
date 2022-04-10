import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/connectivity.dart';
import 'package:lidea/cluster/main.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';
// import '/type/main.dart';
import '/widget/main.dart';

import 'routes.dart';

part 'view.dart';
part 'launcher.dart';
part 'navigator.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static const route = '/root';

  @override
  _State createState() => AppView();
}

abstract class _State extends State<Main> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(keepPage: true);
  final _controller = ScrollController();

  late StreamSubscription<ConnectivityResult> _connection;

  // late final Core core = Provider.of<Core>(context, listen: false);
  late final Core core = context.read<Core>();
  // late final NavigationNotify _navigationNotify = context.read<NavigationNotify>();

  late final Future<void> initiator = core.init(context);

  Preference get preference => core.preference;
  List<ViewNavigationModel> get _pageButton => AppPageNavigation.button(preference);

  late final List<Widget> _pageView = AppPageNavigation.page;

  @override
  void initState() {
    super.initState();
    core.navigate = navigate;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      // ConnectivityResult.mobile
      // ConnectivityResult.wifi
      // ConnectivityResult.none
    });
  }

  @override
  void dispose() {
    // core.store?.subscription?.cancel();
    _controller.dispose();
    super.dispose();
    _connection.cancel();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _navPageViewAction(int index) {
    core.navigation.index = index;
    ViewNavigationModel page = _pageButton.firstWhere(
      (e) => e.key == index,
      orElse: () => _pageButton.first,
    );
    final screenName = UtilString.screenName(page.name);
    final screenClass = UtilString.screenClass(core.navigation.name);

    core.analytics.screen(screenName, screenClass);

    // NOTE: check State isMounted
    // if(page.key.currentState != null){
    //   page.key.currentState.setState(() {});
    // }
    _pageController.jumpToPage(index);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void navigate({int at = 0, String? to, Object? args, bool routePush = true}) {
    if (core.navigation.index != at) {
      _navPageViewAction(at);
    }
    final _vi = AppRoutes.homeNavigator;
    final _state = _vi.currentState;
    if (to != null && _state != null) {
      final _arg = ViewNavigationArguments(key: _vi, args: args);
      if (routePush) {
        _state.pushNamed(to, arguments: _arg);
        // Navigator.of(context).pushNamed(to, arguments: _arg);
      } else {
        // _state.pushReplacementNamed(to, arguments: _arg);
        _state.pushNamedAndRemoveUntil(to, ModalRoute.withName('/'), arguments: _arg);
        // Navigator.of(context).pushReplacementNamed(to, arguments: _arg);
      }

      final screenName = UtilString.screenName(to);
      final screenClass = UtilString.screenClass(core.navigation.name);
      core.analytics.screen(screenName, screenClass);
    }
  }
}
