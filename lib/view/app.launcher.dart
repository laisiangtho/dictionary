part of 'app.dart';

class ScreenLauncher extends StatelessWidget {
  final String message;
  ScreenLauncher({this.message});

  // A comprehensive Myanmar online dictionary

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MergeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                // strutStyle: StrutStyle(),
                text: TextSpan(
                  text: '"',
                  semanticsLabel: "open quotation mark",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 33,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:'A',
                      semanticsLabel: "A",
                      style: TextStyle(
                        fontSize: 19,
                      )
                    ),
                    TextSpan(
                      text: ' comprehensive\n',
                      semanticsLabel: "comprehensive",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                      )
                    ),
                    TextSpan(
                      text: 'Myanmar\n',
                      semanticsLabel: "Myanmar",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 36
                      )
                    ),
                    TextSpan(
                      text: 'online ',
                      semanticsLabel: "online",
                      style: TextStyle(
                        // color: Colors.brown,
                        fontSize: 19,
                      )
                    ),
                    TextSpan(
                      text: 'dictionary',
                      semanticsLabel: "dictionary",
                      style: TextStyle(
                        fontSize: 22
                      )
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark"
                    )
                  ]
                )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical:40),
              padding: EdgeInsets.symmetric(vertical:7, horizontal: 27),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Semantics(
                label: "Message",
                child: Text(
                  message,
                  semanticsLabel: message,
                  style: TextStyle(
                    // color: Colors.white,
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Semantics(
              label: "App name",
              child: Text(
                "MyOrdbok",
                semanticsLabel: "MyOrdbok",
                style: TextStyle(
                  fontSize: 22
                )
              )
            )
          ]
        )
      )
    );
  }

  // Widget name(){
  //   return Container(
  //     height: 70,
  //     child: Center(
  //       child: Text(
  //         // store.appVersion,
  //         // Store.apple
  //         'Core.instance.version',
  //         // '...',
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: Colors.grey,
  //           fontWeight: FontWeight.w200,
  //           // foreground: Paint()
  //           //   ..style = PaintingStyle.stroke
  //           //   ..strokeWidth = 2
  //           //   ..color = Colors.grey[200],
  //           shadows: <Shadow>[
  //             // Shadow(
  //             //   offset: Offset(0.3, 0.5),
  //             //   blurRadius: 0.2,
  //             //   color: Colors.black
  //             // ),
  //             // Shadow(
  //             //   offset: Offset(2.0, 1.0),
  //             //   blurRadius: 20.0,
  //             //   color: Colors.red,
  //             // ),
  //           ],
  //         ),
  //       )
  //     ),
  //   );
  // }
}