part of 'main.dart';

class DefinitionNone extends StatelessWidget {
  DefinitionNone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      delegate: new SliverChildListDelegate(
        <Widget>[]
      )
    );
  }
}