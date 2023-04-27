import 'package:flutter/material.dart';
import 'package:lidea/route/main.dart';

export 'package:lidea/route/main.dart' show RouteParser;

import 'screen_launcher.dart';

import 'home/main.dart' as home;
import 'user/main.dart' as user;
// import 'bible/main.dart' as bible;
import 'search/main.dart' as search;
// import 'stage/main.dart' as stage;
// import 'note/main.dart' as note;
import 'recent_search/main.dart' as recent_search;
import 'favorite_word/main.dart' as favorite_word;
// import 'settings/main.dart' as settings;
import 'store/main.dart' as store;
// import 'gallery/main.dart' as gallery;
// NOTE: sheet
import 'sheet/modal/main.dart' as sheets_modal;
import 'sheet/stack/main.dart' as sheets_stack;
import 'sheet/parallel/main.dart' as sheet_parallel;
import 'sheet/filter/main.dart' as sheet_filter;
// NOTE: pop
import 'pop/options/main.dart' as pop_options;
import 'pop/bookmarks/main.dart' as pop_bookmarks;
// import 'pop/books/main.dart' as pop_books;
// import 'pop/chapters/main.dart' as pop_chapters;

/// RouteMainDelegate
class RouteDelegate extends RouteMainDelegate {
  @override
  final RouteNotifier notifier = RouteNotifier();

  @override
  List<RouteType> get routes {
    return [
      RouteType(
        primaryNavigation: true,
        page: ScreenLauncher(delegate: this),
      ),
    ];
  }
}

class InnerDelegate extends RouteInnerDelegate {
  /// RouteInnerDelegate
  InnerDelegate(super.state);
}

/// RouteChangeNotifier
class RouteNotifier extends RouteChangeNotifier {
  @override
  List<RouteType> get routes {
    return [
      RouteType(
        name: home.Main.route,
        primaryNavigation: true,
        icon: home.Main.icon,
        label: home.Main.label,
        route: [
          RouteType(
            page: const home.Main(),
            route: [
              RouteType(
                name: user.Main.route,
                icon: user.Main.icon,
                label: user.Main.label,
                page: const user.Main(),
              ),
              RouteType(
                name: search.Main.route,
                icon: search.Main.icon,
                label: search.Main.label,
                page: const search.Main(),
              ),
              RouteType(
                name: recent_search.Main.route,
                icon: recent_search.Main.icon,
                label: recent_search.Main.label,
                page: const recent_search.Main(),
              ),
              RouteType(
                name: store.Main.route,
                icon: store.Main.icon,
                label: store.Main.label,
                page: const store.Main(),
              ),
            ],
          ),
        ],
      ),
      RouteType(
        name: recent_search.Main.route,
        primaryNavigation: true,
        icon: recent_search.Main.icon,
        label: recent_search.Main.label,
        route: [
          RouteType(
            page: const recent_search.Main(),
          ),
        ],
      ),
      RouteType(
        name: favorite_word.Main.route,
        primaryNavigation: true,
        icon: favorite_word.Main.icon,
        label: favorite_word.Main.label,
        route: [
          RouteType(
            page: const favorite_word.Main(),
          ),
        ],
      ),
      RouteType(
        name: store.Main.route,
        primaryNavigation: true,
        icon: store.Main.icon,
        label: store.Main.label,
        route: [
          RouteType(
            page: const store.Main(),
          ),
        ],
      ),
      RouteType(
        name: sheet_parallel.Main.route,
        icon: sheet_parallel.Main.icon,
        label: sheet_parallel.Main.label,
        page: const sheet_parallel.Main(),
      ),
      RouteType(
        name: sheets_modal.Main.route,
        icon: sheets_modal.Main.icon,
        label: sheets_modal.Main.label,
        page: const sheets_modal.Main(),
      ),
      RouteType(
        name: sheets_stack.Main.route,
        icon: sheets_stack.Main.icon,
        label: sheets_stack.Main.label,
        page: const sheets_stack.Main(),
      ),
      RouteType(
        name: sheet_filter.Main.route,
        icon: sheet_filter.Main.icon,
        label: sheet_filter.Main.label,
        page: const sheet_filter.Main(),
      ),
      RouteType(
        name: pop_options.Main.route,
        icon: pop_options.Main.icon,
        label: pop_options.Main.label,
        page: const pop_options.Main(),
      ),
      RouteType(
        name: pop_bookmarks.Main.route,
        icon: pop_bookmarks.Main.icon,
        label: pop_bookmarks.Main.label,
        page: const pop_bookmarks.Main(),
      ),
    ];
  }

  List<RouteType> get routeListInnerWorking {
    return [
      RouteType(
        name: '',
      ),
      RouteType(
        name: 'book',
        route: [
          RouteType(
            name: '',
          ),
          RouteType(
            name: ':int',
          ),
          RouteType(
            name: 'sub',
          ),
        ],
      ),
      RouteType(
        name: 'name',
        route: [
          RouteType(
            name: ':string',
          ),
        ],
      ),
      RouteType(
        name: 'blog',
        route: [
          RouteType(
            name: ':any',
          ),
        ],
      ),
      RouteType(
        name: 'settings',
        route: [
          RouteType(
            name: 'color',
          ),
        ],
      ),
    ];
  }

  void routeTest(String name) {
    // final lst = routeListInnerWorking();

    // final abc = Uri(path: name);
    // final cols = mapping(uri: abc, routes: lst);

    // final cols = mapping(name: name, routes: routeListInnerWorking);
    final cols = mapping(name: name);
    debugPrint(cols.toString());
    // for (var element in cols) {
    //   debugPrint('element ${element.name}');
    // }
  }
}

class NestDelegate extends RouteNestDelegate {
  /// RouteNestDelegate
  NestDelegate({required super.notifier, required super.routes, super.root});
}

class NestedView extends RouteNestedWidget {
  /// RouteNestedWidget
  const NestedView({super.key, required super.delegate});
}


/*
class Routes extends InheritedNotifier<AppRouteMainDelegate> {
  const Routes({
    Key? key,
    required AppRouteMainDelegate notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static Routes get(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Routes>()!;
  }

  static AppRouteMainDelegate of(BuildContext context) {
    return Routes.get(context).notifier!;
  }

  static AppRouteChangeNotifier state(BuildContext context) {
    return Routes.of(context).state;
  }
  // static AppRouteChangeNotifier delegate(BuildContext context) {
  //   return Routes.of(context).state;
  // }
}
*/

/// get is good and preferred then making variable
/// ```dart
/// // good and preferred
/// RouteNotifier get routes => RouteManager.of(context)
/// // this get setState whenever changes are made
/// late final routes = RouteManager.of(context)
/// RouteManager(
///   notifier: App.routeDelegate,
///   child:?
/// )
/// ```
// class RouteManager extends NavigatorRouteManager<Routes> {
//   const RouteManager({super.key, required super.notifier, required super.child});

//   static RouteManager inheritedWidget(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<RouteManager>()!;
//   }

//   static Routes delegate(BuildContext context) {
//     return RouteManager.inheritedWidget(context).notifier!;
//   }

//   // static GlobalKey<NavigatorState> state(BuildContext context) {
//   //   return RouteManager.delegate(context).navigatorKey;
//   // }

//   static RouteNotifier of(BuildContext context) {
//     return RouteManager.delegate(context).state;
//   }
// }
