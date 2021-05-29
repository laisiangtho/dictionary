part of 'main.dart';

class SuggestionNone extends StatelessWidget {
  SuggestionNone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      delegate: new SliverChildListDelegate(
        <Widget>[]
      )
    );
  }
}