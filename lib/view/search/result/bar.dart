part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final innerBoxIsScrolled = constraints.scrollOffset > 0;
        return ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          reservedPadding: MediaQuery.of(context).padding.top,
          heights: const [kBottomNavigationBarHeight],
          overlapsBackgroundColor: Theme.of(context).primaryColor,
          overlapsBorderColor: Theme.of(context).shadowColor,
          overlapsForce: innerBoxIsScrolled,
          builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Align(
                //   child: Hero(
                //     tag: 'appbar-left-0',
                //     child: SizedBox(),
                //   ),
                // ),
                // const Align(
                //   child: Hero(
                //     tag: 'appbar-title',
                //     child: SizedBox(),
                //   ),
                // ),
                Expanded(
                  child: Hero(
                    tag: 'searchbar-field',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                      // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.5),
                      child: GestureDetector(
                        // child: Selector<Core, String>(
                        //   selector: (BuildContext _, Core e) => e.searchQuery,
                        //   builder: (BuildContext _, String initialValue, Widget? child) {
                        //     return _barForm(initialValue);
                        //   },
                        // ),
                        child: _barForm(),
                        // child: const Text('tmp'),
                        onTap: () {
                          // core.navigate(to: '/search');
                          // final word = await navigator.currentState!.pushNamed('/search');
                          // final word = await navigator.currentState!.pushNamed('/suggest');
                          // final word = await navigator.currentState!.pushNamed('/search-suggest');
                          // onSearch(word as bool);
                          navigator.currentState!
                              .pushNamed('/search-suggest', arguments: arguments)
                              .then((word) {
                            onUpdate(word != null);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: 'appbar-right',
                  child: canPop
                      ? CupertinoButton(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          // padding: EdgeInsets.zero,
                          child: const WidgetLabel(icon: CupertinoIcons.home),
                          onPressed: () {
                            // parent.navigator!.currentState!.maybePop();
                            // Navigator.of(context).pop();
                            // parent.navigator!.currentState!.pop();
                            core.navigate(to: '/home');
                          },
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _barForm() {
    return TextFormField(
      readOnly: true,
      enabled: false,
      maxLines: 1,
      // initialValue: initialValue,
      // textInputAction: TextInputAction.search,
      // keyboardType: TextInputType.text,
      controller: textController,
      strutStyle: const StrutStyle(height: 1.4),
      decoration: InputDecoration(
        hintText: preference.text.aWordOrTwo,
        // hintStyle: const TextStyle(height: 1.3),
        prefixIcon: const Icon(LideaIcon.find, size: 19),
        // prefixIcon: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //     borderRadius: const BorderRadius.all(
        //       Radius.circular(10),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         blurRadius: 0.1,
        //         color: Theme.of(context).shadowColor,
        //         // spreadRadius: 0.1,
        //         offset: const Offset(0, 0),
        //       )
        //     ],
        //   ),
        //   child: Selector<Core, String>(
        //     selector: (BuildContext _, Core e) {
        //       return e.scripturePrimary.bible.info.langCode;
        //     },
        //     builder: (BuildContext _, String langCode, Widget? child) {
        //       return Text(
        //         langCode.toUpperCase(),
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 12,
        //           // fontWeight: FontWeight.bold,
        //           color: Theme.of(context).hintColor,
        //         ),
        //       );
        //     },
        //   ),
        // ),
        fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
      ),
    );
  }
}
