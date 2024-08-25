part of 'main.dart';

abstract class _State<T extends StatefulWidget> extends SearchViews<T> {
  @override
  late final Core app = App.core;

  // @override
  // bool get canPop => Navigator.of(context).canPop();

  @override
  String? get labelSearchHint => preference.text.aWordOrTwo;

  @override
  String? get labelSearchCancel => preference.text.cancel;

  @override
  String? get labelSearchClear => preference.text.clear;

  @override
  Widget? get iconSearchPrefix {
    // return Selector<Core, BooksType>(
    //   selector: (_, e) => e.scripturePrimary.info,
    //   builder: (BuildContext _, BooksType info, Widget? child) {
    //     return labelSearchPrefix(label: info.langCode.toUpperCase());
    //   },
    // );
    // return ViewMarks(
    //   margin: const EdgeInsets.all(7),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).scaffoldBackgroundColor,
    //     // color: Colors.red,
    //     borderRadius: const BorderRadius.all(
    //       Radius.circular(4),
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
    //   labelStyle: Theme.of(context).textTheme.labelSmall,
    //   labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    //   label: 'EN',
    // );
    return const ViewMarks(
      margin: EdgeInsets.all(7),
      icon: LideaIcon.find,
    );
  }
}
