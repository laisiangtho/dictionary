part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayouts(
      data: data,
      left: [
        OptionButtons.back(
          navigator: state.navigator,
          label: preference.text.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        label: preference.text.store,
        data: data,
      ),
      right: [
        ViewButtons(
          message: preference.text.restorePurchase('true'),
          onPressed: onRestore,
          child: const ViewMarks(
            icon: Icons.restore_rounded,
          ),
        ),
      ],
    );
  }
}
