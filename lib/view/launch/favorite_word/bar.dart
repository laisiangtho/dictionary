part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          show: hasArguments,
          onPressed: args?.currentState!.maybePop,
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
        ),
      ],
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          org.snapShrink,
        ),
        label: preference.text.favorite(false),
        shrink: org.shrink,
      ),
      rightAction: [
        WidgetButton(
          enable: collection.favorites.isNotEmpty,
          onPressed: onDeleteAllConfirmWithDialog,
          child: const WidgetMark(
            icon: Icons.clear_all_rounded,
          ),
        ),
      ],
    );
  }
}
