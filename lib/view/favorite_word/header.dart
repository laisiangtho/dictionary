part of 'main.dart';

mixin _Header on _State {
  Widget _headerMobile(BuildContext context, ViewBarData vbd) {
    return ViewBarLayouts(
      data: vbd,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewBarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vbd.snapShrink,
        ),
        label: lang.favorite('false'),
        data: vbd,
      ),
      right: [
        // ValueListenableBuilder(
        //   key: const ValueKey('fe'),
        //   valueListenable: data.boxOfFavoriteWord.listen(),
        //   // valueListenable: data.boxOfBooks.listen(),
        //   builder: (BuildContext context, Box<FavoriteWordType> box, Widget? child) {
        //     return ViewButtons(
        //       enable: box.isNotEmpty,
        //       onPressed: onDeleteAllConfirmWithDialog,
        //       child: const ViewMarks(
        //         icon: Icons.clear_all_rounded,
        //       ),
        //     );
        //   },
        // ),
        ViewButtons(
          enable: boxOfFavoriteWord.isNotEmpty,
          onPressed: onDeleteAllConfirmWithDialog,
          child: const ViewMarks(
            icon: Icons.clear_all_rounded,
          ),
        ),
      ],
    );
  }
}
