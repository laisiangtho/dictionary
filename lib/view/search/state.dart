part of 'main.dart';

abstract class _State<T extends StatefulWidget> extends SearchEngineStates<T> {
  @override
  String? get labelSearchHint => lang.aWordOrTwo;

  @override
  String? get labelSearchCancel => lang.cancel;

  @override
  String? get labelSearchClear => lang.clear;

  // @override
  // Widget? get iconSearchPrefix {
  //   return const ViewMarks(
  //     margin: EdgeInsets.all(7),
  //     icon: LideaIcon.find,
  //     iconSize: 22,
  //   );
  // }
}
