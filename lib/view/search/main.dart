import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/view/user/main.dart';

import '../../app.dart';

part 'state.dart';
part 'header.dart';

part 'result.dart';
part 'suggest.dart';
part 'recent.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'search'; // ./result ./suggestion
  static String label = 'Search';
  static IconData icon = LideaIcon.search;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header, _Suggest, _Result, _Recents {
  @override
  Widget build(BuildContext context) {
    debugPrint('search->build');

    // updateQuery(args!['keyword']);

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
        ),
        // child: NestedScrollView(
        //   controller: _controller,
        //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        //     return <Widget>[
        //       ViewHeaderSliver(
        //         pinned: true,
        //         floating: false,
        //         padding: state.fromContext.viewPadding,
        //         heights: const [kToolbarHeight],
        //         // overlapsBackgroundColor: state.theme.primaryColor,
        //         overlapsBorderColor: state.theme.dividerColor,
        //         overlapsForce: innerBoxIsScrolled,
        //         builder: _header,
        //       ),
        //     ];
        //   },
        //   body: ValueListenableBuilder<bool>(
        //     valueListenable: _suggestNotifier,
        //     builder: (context, toggle, child) {
        //       if (toggle) {
        //         return suggestView();
        //       }
        //       return child!;
        //     },
        //     child: resultView(),
        //   ),
        // ),
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            ViewHeaderSliver(
              pinned: true,
              floating: false,
              padding: state.fromContext.viewPadding,
              heights: const [kToolbarHeight],
              // overlapsBackgroundColor: state.theme.primaryColor,
              overlapsBorderColor: state.theme.dividerColor,
              // overlapsForce: innerBoxIsScrolled,
              builder: _header,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _suggestNotifier,
              builder: (context, toggle, child) {
                if (toggle) {
                  return _suggestView();
                }
                return child!;
              },
              child: resultView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestView() {
    return Selector<Core, SuggestionType<OfRawType>>(
      selector: (_, e) => e.data.cacheSuggestion,
      builder: (BuildContext context, SuggestionType<OfRawType> o, Widget? child) {
        if (o.emptyQuery) {
          return _recentView();
        } else if (o.emptyResult) {
          return child!;
        } else {
          return _suggestBlock(o);
        }
      },
      child: ViewFeedback.message(
        label: App.preference.text.searchNoMatch,
      ),
    );
  }
}
