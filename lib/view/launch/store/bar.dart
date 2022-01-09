part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight, 50],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: canPop ? 30 : 0, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: canPop
                        ? (align == 0)
                            ? Hero(
                                tag: 'appbar-left-$canPop',
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 30,
                                  onPressed: () {
                                    arguments.navigator!.currentState!.maybePop();
                                  },
                                  child: WidgetLabel(
                                    icon: CupertinoIcons.left_chevron,
                                    label: preference.text.back,
                                    // label: AppLocalizations.of(context)!.back,
                                  ),
                                ),
                              )
                            : WidgetLabel(
                                icon: CupertinoIcons.left_chevron,
                                label: preference.text.back,
                              )
                        : const SizedBox(),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                snap.shrink,
              )!,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    preference.text.store,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: (30 * org.shrink).clamp(22, 30).toDouble()),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                child: Hero(
                  tag: 'appbar-right',
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 30,
                    child: WidgetLabel(
                        icon: Icons.restore,
                        // icon: LideaIcon.history,
                        // icon: CupertinoIcons.restart,
                        message: preference.text.restorePurchase(true)),
                    onPressed: () {
                      // await InAppPurchase.instance.restorePurchases().whenComplete(() =>setState);
                      core.store.doRestore().whenComplete(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Restore purchase completed.'),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
