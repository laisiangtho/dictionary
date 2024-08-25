import 'package:flutter/material.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '../../app.dart';

part 'state.dart';
part 'suggest.dart';
part 'histories.dart';
part 'result.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'search';
  static String label = 'Search';
  static IconData icon = LideaIcon.search;
  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State<Main> with _Suggest, _Result {
  @override
  Widget suggestView() {
    return Selector<Core, SuggestionType<OfRawType>>(
      selector: (_, e) => e.data.cacheSuggestion,
      builder: (BuildContext context, SuggestionType<OfRawType> o, Widget? child) {
        if (o.emptyQuery) {
          return const _Histories();
        } else if (o.emptyResult) {
          return child!;
        } else {
          return _suggestBlock(o);
        }
      },
      child: ViewFeedbacks.message(
        label: preference.text.searchNoMatch,
      ),
    );
  }

  @override
  Widget resultView() {
    return FutureBuilder(
      future: initiator,
      builder: (BuildContext _, AsyncSnapshot<void> snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return ViewFeedbacks.message(
              label: preference.text.aMoment,
            );
          default:
            // return Selector<Core, ConclusionType>(
            //   selector: (_, e) => e.data.cacheConclusion,
            //   builder: (BuildContext context, ConclusionType o, Widget? child) {
            //     if (o.query.isEmpty) {
            //       return _msg(preference.text.aWordOrTwo);
            //     } else if (o.raw.isNotEmpty) {
            //       return _resultBlock(o);
            //     } else {
            //       return _msg(preference.text.searchNoMatch);
            //     }
            //   },
            // );
            return Selector<Core, ConclusionType>(
              selector: (_, e) => e.data.cacheConclusion,
              builder: (BuildContext context, ConclusionType o, Widget? child) {
                onResult();
                if (o.emptyQuery) {
                  return _resultEmptyQuery();
                } else if (o.emptyResult) {
                  return child!;
                } else {
                  return _resultBlock(o);
                }
              },
              child: _resultEmpty(),
            );
        }
      },
    );
  }
}
