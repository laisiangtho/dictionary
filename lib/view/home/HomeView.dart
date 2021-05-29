part of 'main.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      delegate: new SliverChildListDelegate(
        <Widget>[]
      )
    );
  }
}