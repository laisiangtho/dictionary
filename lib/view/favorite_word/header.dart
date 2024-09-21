part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vhd.snapShrink,
        ),
        label: lang.favorite('false'),
        data: vhd,
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
