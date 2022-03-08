part of 'main.dart';

class ScreenLauncher extends StatelessWidget {
  const ScreenLauncher({Key? key}) : super(key: key);

  // A comprehensive Myanmar online dictionary
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                // strutStyle: StrutStyle(),
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.labelLarge!.color, fontSize: 25),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'A',
                      semanticsLabel: "A",
                      style: TextStyle(fontSize: 19),
                    ),
                    TextSpan(
                      text: ' comprehensive\n',
                      semanticsLabel: "comprehensive",
                      style: TextStyle(fontSize: 22),
                    ),
                    TextSpan(
                      text: 'Myanmar\n',
                      semanticsLabel: "Myanmar",
                      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50),
                    ),
                    TextSpan(
                      text: 'online ',
                      semanticsLabel: "online",
                      style: TextStyle(fontSize: 19),
                    ),
                    TextSpan(
                      text: 'dictionary',
                      semanticsLabel: "dictionary",
                      style: TextStyle(fontSize: 25),
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
            Semantics(
              label: "Progress",
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text('...'),
              ),
            ),
            Semantics(
              label: "Message",
              child: Selector<Core, String>(
                selector: (_, core) => core.message,
                builder: (BuildContext _, String message, Widget? child) => Text(
                  message,
                  semanticsLabel: message,
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
