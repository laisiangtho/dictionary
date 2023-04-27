part of 'main.dart';

mixin _Suggest on _State {
  // Widget suggestView() {
  //   // return CustomScrollView(
  //   //   primary: true,
  //   //   slivers: [
  //   //     Selector<Core, SuggestionType<OfRawType>>(
  //   //       selector: (_, e) => e.cacheSuggestion,
  //   //       builder: (BuildContext context, SuggestionType<OfRawType> o, Widget? child) {
  //   //         if (o.emptyQuery) {
  //   //           return const _Recents();
  //   //         } else if (o.emptyResult) {
  //   //           return child!;
  //   //         } else {
  //   //           return _suggestBlock(o);
  //   //         }

  //   //         // return suggests(o);
  //   //       },
  //   //       child: ViewFeedback.message(
  //   //         label: App.preference.text.searchNoMatch,
  //   //       ),
  //   //     ),
  //   //   ],
  //   // );
  //   return Selector<Core, SuggestionType<OfRawType>>(
  //     selector: (_, e) => e.data.cacheSuggestion,
  //     builder: (BuildContext context, SuggestionType<OfRawType> o, Widget? child) {
  //       if (o.emptyQuery) {
  //         return recentView();
  //       } else if (o.emptyResult) {
  //         return child!;
  //       } else {
  //         return _suggestBlock(o);
  //       }
  //     },
  //     child: ViewFeedback.message(
  //       label: App.preference.text.searchNoMatch,
  //     ),
  //   );
  // }

  Widget _suggestBlock(SuggestionType<OfRawType> o) {
    return ViewSection(
      // primary: false,
      headerTitle: ViewLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.suggestion(o.raw.length > 1),
      ),
      // headerTrailing: ViewButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.more_horiz),
      // ),
      footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
      child: ViewBlockCard.fill(
        // child: ListBody(
        //   children: [
        //     ViewButton(
        //       onPressed: () {},
        //       child: const Text('ViewButton'),
        //     ),
        //     ViewButton(
        //       child: Text(o.query),
        //     ),
        //   ],
        // ),
        child: ViewListBuilder(
          primary: false,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final snap = o.raw.elementAt(index);

            int ql = suggestQuery.length;
            String word = snap.term;
            int wl = word.length;
            return _suggestItem(word, ql < wl ? ql : wl);
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
          itemCount: o.raw.length,
        ),
      ),
    );
  }

  Widget _suggestItem(String word, int hightlight) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      leading: const Icon(Icons.north_east_rounded),
      title: Text.rich(
        TextSpan(
          text: word.substring(0, hightlight),
          semanticsLabel: word,
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: word.substring(hightlight),
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
              ),
            )
          ],
        ),
      ),
      onTap: () => onSearch(word),
    );
  }
}
