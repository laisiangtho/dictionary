part of 'main.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverFillRemaining(
      key: key,
      child: WidgetMsg(message: 'Hi there!',),
    );
  }
}