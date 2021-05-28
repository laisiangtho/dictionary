part of 'main.dart';

class SuggestionNone extends StatelessWidget {
  SuggestionNone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverFillRemaining(
      key: key,
      child: WidgetMsg(message: 'no suggestion :)',),
    );
  }
}