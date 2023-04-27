part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        label: App.preference.text.store,
        data: data,
      ),
      right: [
        ViewButton(
          message: App.preference.text.restorePurchase(true),
          onPressed: onRestore,
          child: const ViewMark(
            icon: Icons.restore_rounded,
          ),
        ),
      ],
    );
  }
}
