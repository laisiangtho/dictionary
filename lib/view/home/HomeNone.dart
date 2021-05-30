part of 'main.dart';

class HomeNone extends StatelessWidget {
  HomeNone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      delegate: new SliverChildListDelegate(
        <Widget>[]
      )
    );
  }
}