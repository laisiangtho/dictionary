part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final innerBoxIsScrolled = constraints.scrollOffset > 0;
        return ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          padding: MediaQuery.of(context).viewPadding,
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
      decoration: InputDecoration(
        hintText: preference.text.aWordOrTwo,
        prefixIcon: const Icon(LideaIcon.find),
        fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
      ),
    );
  }
}
