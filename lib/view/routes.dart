import 'package:flutter/material.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';

import 'main.dart' as root;

import 'launch/main.dart' as launch;
import 'launch/home/main.dart' as home;
import 'launch/recent_search/main.dart' as recent_search;
import 'launch/favorite_word/main.dart' as favorite_word;
import 'launch/store/main.dart' as store;

import 'search/main.dart' as search_page;
import 'search/result/main.dart' as search_result;
import 'search/suggest/main.dart' as search_suggest;

import 'user/main.dart' as user;

class AppRoutes {
  static String rootInitial = root.Main.route;
  static Map<String, Widget Function(BuildContext)> rootMap = {
    root.Main.route: (BuildContext _) {
      return const root.Main();
    },
  };

  static GlobalKey<NavigatorState> homeNavigator = launch.Main.navigator;

  static String homeInitial({String? name}) => name ?? launch.Main.route;

  static Widget _homePage(RouteSettings route) {
    switch (route.name) {
      case search_page.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      // case search_page.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);
      case search_suggest.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      case search_result.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_result.Main.route,
        );
      // case search_result.Main.route:
      //   return search_page.Main(arguments: route.arguments);

      // case search_result.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);

      case user.Main.route:
        return user.Main(arguments: route.arguments);

      case favorite_word.Main.route:
        return favorite_word.Main(arguments: route.arguments);
      case store.Main.route:
        return store.Main(arguments: route.arguments);
      case recent_search.Main.route:
        return recent_search.Main(arguments: route.arguments);

      case home.Main.route:
      default:
        // throw Exception('Invalid route: ${route.name}');
        return home.Main(arguments: route.arguments);
    }
  }

  // static Route<void> homeBuilder(RouteSettings route) {
  //   return MaterialPageRoute<void>(
  //     settings: route,
  //     fullscreenDialog: true,
  //     builder: (BuildContext context) {
  //       return _homePage(route);
  //     },
  //   );
  // }

  static Route<dynamic>? homeBuilder(RouteSettings route) {
    return PageRouteBuilder(
      settings: route,
      pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) {
        return _homePage(route);
      },
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      // transitionsBuilder: (
      //   BuildContext context,
      //   Animation<double> animation,
      //   Animation<double> secondaryAnimation,
      //   Widget child,
      // ) {
      //   // return Align(
      //   //   child: SizeTransition(
      //   //     sizeFactor: animation,
      //   //     child: child,
      //   //   ),
      //   // );
      //   return SlideTransition(
      //     position: Tween<Offset>(
      //       begin: const Offset(0.0, 1.0),
      //       end: Offset.zero,
      //     ).animate(animation),
      //     child: child, // child is the value returned by pageBuilder
      //   );
      // },
      fullscreenDialog: true,
    );
  }

  static String searchInitial({String? name}) => name ?? search_result.Main.route;

  static Route<dynamic>? searchBuilder(RouteSettings route, Object? args) {
    return PageRouteBuilder(
      settings: route,
      pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) {
        switch (route.name) {
          case search_suggest.Main.route:
            return search_suggest.Main(arguments: args);
          case search_result.Main.route:
          default:
            return search_result.Main(arguments: args);
        }
      },
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      fullscreenDialog: true,
    );
  }
}

// AppPageView AppPageNavigation
class AppPageNavigation {
  static List<ViewNavigationModel> button(Preference preference) {
    return [
      ViewNavigationModel(
        key: 0,
        icon: launch.Main.icon,
        name: launch.Main.name,
        description: preference.text.home,
      ),
      ViewNavigationModel(
        key: 1,
        icon: recent_search.Main.icon,
        name: recent_search.Main.name,
        description: preference.text.recentSearch(false),
      ),
      ViewNavigationModel(
        key: 2,
        icon: favorite_word.Main.icon,
        name: favorite_word.Main.name,
        description: preference.text.favorite(false),
      ),
      ViewNavigationModel(
        key: 3,
        icon: store.Main.icon,
        name: store.Main.name,
        description: preference.text.store,
      ),
    ];
  }

  static List<Widget> page = [
    ViewKeepAlive(
      key: launch.Main.uniqueKey,
      child: const launch.Main(),
    ),
    ViewKeepAlive(
      key: recent_search.Main.uniqueKey,
      child: const recent_search.Main(),
    ),
    ViewKeepAlive(
      key: favorite_word.Main.uniqueKey,
      child: const favorite_word.Main(),
    ),
    // WidgetKeepAlive(
    //   key: setting.Main.uniqueKey,
    //   child: const setting.Main(),
    // ),
    ViewKeepAlive(
      key: store.Main.uniqueKey,
      child: const store.Main(),
    ),
  ];
}
