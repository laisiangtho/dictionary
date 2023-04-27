part of 'main.dart';

// mixin _Recents on _State {
// class _Recents extends StatefulWidget {
//   const _Recents({Key? key, required this.textController}) : super(key: key);
//   // _textController = TextEditingController
//   final TextEditingController textController;

//   @override
//   State<_Recents> createState() => _RecentView();
// }

// abstract class _RecentState extends StateAbstract<_Recents> {
//   final ValueNotifier<double> _recentNotifier = ValueNotifier(0.0);

//   // String get suggestQuery => data.suggestQuery;
//   // set suggestQuery(String ord) {
//   //   data.suggestQuery = ord;
//   // }

//   int get lengths => data.suggestQuery.length;

//   /// getting query from recent-list
//   void onSearch(String ord) {
//     // widget.textController.text = ord;
//     // data.suggestQuery = ord;
//     // Future.microtask(() {
//     //   core.suggestionGenerate();
//     // });

//     data.suggestQuery = ord;
//     data.searchQuery = ord;
//     Future.microtask(() {
//       core.conclusionGenerate();
//     });
//     // data.boxOfSettings.searchQuery(value: ord);
//     // data.boxOfSettings.suggestQuery(value: ord);
//     // App.core.conclusionGenerate();
//     // App.route.pushNamed(
//     //   'home/search',
//     //   arguments: {'keyword': ord},
//     // );
//   }

//   bool onDelete(String str) => data.boxOfRecentSearch.delete(str);
// }

mixin _Recents on _State {
  Widget _recentView() {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.data.boxOfRecentSearch.entries,
      builder: (BuildContext _, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        return ViewSection(
          show: items.isNotEmpty,
          // duration: const Duration(milliseconds: 270),
          headerTitle: ViewLabel(
            alignment: Alignment.centerLeft,
            label: preference.text.recentSearch(items.length > 1),
          ),

          onAwait: ViewFeedback.message(
            label: App.preference.text.aWordOrTwo,
          ),
          child: ViewBlockCard.fill(
            child: _recentBlock(items),
          ),
        );
      },
    );
  }

  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return ViewListBuilder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _recentContainer(index, items.elementAt(index));
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          leading: Icon(Icons.north_east_rounded),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(primary: false);
      },
      itemCount: items.length,
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.startToEnd,
      background: _recentDismissibleBackground(),
      // secondaryBackground: _recentListDismissibleSecondaryBackground),
      confirmDismiss: (direction) async {
        // DismissDirection.startToEnd
        if (direction == DismissDirection.startToEnd) {
          return onDeleteRecents(item.value.word);
        }
        return null;
      },
      onUpdate: (detail) {
        // detail.progress;
        debugPrint('detail ${detail.progress}');
        _recentNotifier.value = detail.progress;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        leading: const Icon(Icons.north_east_rounded),
        title: _recentItem(item.value.word),
        trailing: Text(
          item.value.hit.toString(),
        ),
        // trailing: Chip(
        //   avatar: CircleAvatar(
        //     // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     backgroundColor: Colors.transparent,
        //     child: Icon(
        //       Icons.saved_search_outlined,
        //       color: Theme.of(context).primaryColor,
        //     ),
        //   ),
        //   label: Text(
        //     item.value.hit.toString(),
        //   ),
        // ),
        onTap: () => onSearch(item.value.word),
      ),
    );
  }

  Widget _recentItem(String word) {
    int hightlight = lengthOfSuggestQuery < word.length ? lengthOfSuggestQuery : word.length;
    return Text.rich(
      TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        // style: TextStyle(
        //   fontSize: 22,
        //   color: Theme.of(context).textTheme.bodySmall!.color,
        //   // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
        //   fontWeight: FontWeight.w300,
        // ),
        style: Theme.of(context).textTheme.bodyLarge,
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.labelLarge!.color,
            ),
          )
        ],
      ),
    );
  }

  Widget _recentDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ValueListenableBuilder<double>(
        valueListenable: _recentNotifier,
        builder: (context, val, child) {
          return Padding(
            padding: EdgeInsets.only(left: 15 * val),
            child: child,
          );
        },
        child: Text(
          preference.text.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
