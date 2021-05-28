# ?

```dart
part of 'main.dart';

class SuggestionView extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<SuggestionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        title: Text('Returning Data Demo'),
      ),
      // body: Center(child: Text('suggestion working')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Close the screen and return "Yep!" as the result.
                Navigator.pop(context, 'Yep!');
              },
              child: Text('Yep!'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Close the screen and return "Nope." as the result.
                Navigator.pop(context, 'Nope.');
              },
              child: Text('Nope.'),
            ),
          )
        ],
      ),
    );
  }
}