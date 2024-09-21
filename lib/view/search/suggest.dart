part of 'main.dart';

mixin _Suggest on _State<Main> {
  Widget _suggestBlock(SuggestionType<OfRawType> o) {
    return CustomScrollView(
      key: PageStorageKey('search-suggest-${o.query}'),
      // controller: scrollController,
      slivers: [
        ViewSections(
          headerTitle: Text(
            lang.suggestion((o.raw.length > 1).toString()),
            style: state.style.titleSmall,
          ),
          // headerTitle: ViewLabels(
          //   alignment: Alignment.centerLeft,
          //   label: lang.suggestion((o.raw.length > 1).toString()),
          // ),
          // headerTrailing: ViewButtons(
          //   onPressed: () {},
          //   child: const Icon(Icons.more_horiz),
          // ),
          // footerTitle: const Text('...'),
          child: ViewCards.fill(
            child: ViewLists.separator(
              itemBuilder: (BuildContext context, int index) {
                final snap = o.raw.elementAt(index);

                int ql = lengthOfSuggestQuery;
                String word = snap.term;
                int wl = word.length;
                return _suggestItem(word, ql < wl ? ql : wl);
              },
              itemSnap: const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                leading: Icon(Icons.north_east_rounded),
              ),
              separator: (BuildContext context, int index) {
                return const ViewDividers();
              },
              itemCount: o.raw.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _suggestItem(String word, int hightlight) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: const Icon(Icons.north_east_rounded),
      title: Text.rich(
        TextSpan(
          text: word.substring(0, hightlight),
          semanticsLabel: word,
          style: state.style.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: word.substring(hightlight),
              style: TextStyle(
                color: state.theme.primaryColorDark,
              ),
            )
          ],
        ),
      ),
      onTap: () => onSearch(word),
    );
  }
}
