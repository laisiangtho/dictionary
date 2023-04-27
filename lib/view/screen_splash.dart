part of 'screen_launcher.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
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
                  semanticsLabel: 'open quotation mark',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.labelLarge!.color,
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'A',
                      semanticsLabel: 'A',
                      style: TextStyle(fontSize: 19),
                    ),
                    TextSpan(
                      text: ' comprehensive\n',
                      semanticsLabel: 'comprehensive',
                      style: TextStyle(fontSize: 22),
                    ),
                    TextSpan(
                      text: 'Myanmar\n',
                      semanticsLabel: 'Myanmar',
                      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50),
                    ),
                    TextSpan(
                      text: 'online ',
                      semanticsLabel: 'online',
                      style: TextStyle(fontSize: 19),
                    ),
                    TextSpan(
                      text: 'dictionary',
                      semanticsLabel: 'dictionary',
                      style: TextStyle(fontSize: 25),
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: 'close quotation mark',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
            Semantics(
              label: 'Progress',
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(App.core.message.value),
              ),
            ),
            // Semantics(
            //   label: "Message",
            //   child: Text(
            //     App.core.message,
            //     semanticsLabel: App.core.message,
            //     style: const TextStyle(fontSize: 30),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
