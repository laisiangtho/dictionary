part of 'main.dart';

class View extends _State with _Bar, _Data {

  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      key: scaffoldKey,
      controller: controller.master,
      child: _body()
    );
  }

  Widget _body() {
    return Container(
      child: Center(
        child: Text('Hello'),
      )
    );
  }
}