
part of 'core.dart';

abstract class _Collection with _Configuration, _Utility {
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }
}
// abstract class _Collection with _Configuration {}