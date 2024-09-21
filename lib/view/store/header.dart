part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayouts(
      data: data,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        label: lang.store,
        data: data,
      ),
      right: [
        ViewButtons(
          message: lang.restorePurchase('true'),
          onPressed: onRestore,
          child: const ViewMarks(
            icon: Icons.restore_rounded,
          ),
        ),
      ],
    );
  }
}
