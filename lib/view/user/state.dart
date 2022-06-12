part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> whenCompleteSignIn() async {
    if (authenticate.message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authenticate.message),
        ),
      );
    }
  }
}
