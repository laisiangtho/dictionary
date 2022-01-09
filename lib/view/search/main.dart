import 'package:flutter/material.dart';

import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import 'result/main.dart' as result;
import 'suggest/main.dart' as suggest;

class Main extends StatefulWidget {
  const Main({
    Key? key,
    this.arguments,
    this.defaultRouteName,
  }) : super(key: key);

  // final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;
  final String? defaultRouteName;

  static const route = '/search';
  static const icon = LideaIcon.search;
  static const name = 'Search';
  static const description = 'Search';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();
  // static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Main> {
  final key = GlobalKey<NavigatorState>();

  // ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  // GlobalKey<NavigatorState> get navigator => arguments.navigator;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeroControllerScope(
        controller: MaterialApp.createMaterialHeroController(),
        child: Navigator(
          key: key,
          initialRoute: widget.defaultRouteName ?? suggest.Main.route,
          restorationScopeId: 'search',
          onGenerateRoute: (RouteSettings settings) {
            final arguments = ViewNavigationArguments(navigator: key, args: widget.arguments);
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
                switch (settings.name) {
                  case suggest.Main.route:
                    return suggest.Main(arguments: arguments);
                  case result.Main.route:
                  default:
                    return result.Main(arguments: arguments);
                }
              },
              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              fullscreenDialog: true,
            );
          },
        ),
      ),
    );
  }
}
