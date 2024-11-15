import 'package:flutter/material.dart';
import 'package:lidea/routes.dart';

/// NOTE: Bottom navigation
import 'menu_bottom.dart';

/// NOTE: Launcher
import 'screen_launcher.dart' as launcher;

/// NOTE: Menu
import 'home/main.dart' as home;
import 'user/main.dart' as user;
import 'search/main.dart' as search;
import 'favorite_word/main.dart' as favorite_word;
import 'recent_search/main.dart' as recent_search;
import 'store/main.dart' as store;

/// NOTE: sheet
// import 'sheet/modal/main.dart' as sheets_modal;
// import 'sheet/stack/main.dart' as sheets_stack;
// import 'sheet/parallel/main.dart' as sheet_parallel;
// import 'sheet/filter/main.dart' as sheet_filter;

/// NOTE: Recto
// import 'recto/editor.dart' as recto_editor;

/// NOTE: pop
// import 'pop/options/main.dart' as pop_options;
// import 'pop/bookmarks/main.dart' as pop_bookmarks;
// import 'pop/books/main.dart' as pop_books;
// import 'pop/chapters/main.dart' as pop_chapters;

class RouteConfig extends RouteNavigations {
  late final GlobalKey<NavigatorState> _keyHome = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> _keyFavoriteWord = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> _keyRecentSearch = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> _keyStore = GlobalKey<NavigatorState>();

  @override
  final initialLocation = '/launcher';

  @override
  late final pageRoutes = [
    GoRoute(
      parentNavigatorKey: initialKey,
      path: initialLocation,
      pageBuilder: (context, state) {
        return pages(
          child: const launcher.Main(),
          state: state,
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: initialKey,
      branches: [
        StatefulShellBranch(
          navigatorKey: _keyHome,
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, GoRouterState state) {
                return pages(child: const home.Main(), state: state);
              },
              routes: [
                // GoRoute(
                //   path: 'user',
                //   pageBuilder: (context, state) {
                //     return pages(child: const user.Main(), state: state);
                //   },
                // ),
                GoRoute(
                  path: 'search',
                  pageBuilder: (context, state) {
                    return pages(child: const search.Main(), state: state);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _keyFavoriteWord,
          routes: [
            GoRoute(
              path: '/favorite',
              pageBuilder: (context, state) {
                return pages(child: const favorite_word.Main(), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _keyRecentSearch,
          routes: [
            GoRoute(
              path: '/recent-search',
              pageBuilder: (context, state) {
                return pages(child: const recent_search.Main(), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _keyStore,
          routes: [
            GoRoute(
              path: '/store',
              pageBuilder: (context, state) {
                return pages(child: const store.Main(), state: state);
              },
            ),
          ],
        ),
      ],
      pageBuilder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
        return pages(
          child: _CustomShell(
            shell: shell,
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: initialKey,
      path: '/user',
      pageBuilder: (context, state) {
        return pages(child: const user.Main(), state: state);
      },
    ),
    // GoRoute(
    //   parentNavigatorKey: initialKey,
    //   path: SignUpPage.name,
    //   pageBuilder: (context, state) {
    //     return pages(
    //       child: const SignUpPage(),
    //       state: state,
    //     );
    //   },
    // ),
  ];
}

class _CustomShell extends RouteShellNavigationBottom {
  /// MenuBottom, Sheet etc
  const _CustomShell({required super.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('RouteShells'),
      // ),
      // body: SafeArea(
      //   child: shell,
      // ),
      body: shell,
      bottomNavigationBar: MenuBottom(shell: shell),
    );
  }
}
