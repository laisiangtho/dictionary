part of 'app.dart';

class ScreenLauncher extends StatelessWidget {
  final String message;

  ScreenLauncher({this.message:'?'});

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
                    color: Theme.of(context).primaryTextTheme.button!.color,
                    fontSize: 25
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:'A',
                      semanticsLabel: "A",
                      style: TextStyle(
                        fontSize: 19
                      )
                    ),
                    TextSpan(
                      text: ' comprehensive\n',
                      semanticsLabel: "comprehensive",
                      style: TextStyle(
                        fontSize: 22
                      )
                    ),
                    TextSpan(
                      text: 'Myanmar\n',
                      semanticsLabel: "Myanmar",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 50
                      )
                    ),
                    TextSpan(
                      text: 'online ',
                      semanticsLabel: "online",
                      style: TextStyle(
                        fontSize: 19
                      )
                    ),
                    TextSpan(
                      text: 'dictionary',
                      semanticsLabel: "dictionary",
                      style: TextStyle(
                        fontSize: 25
                      )
                    ),
                    TextSpan(
                      text: '"',
                      semanticsLabel: "close quotation mark",
                      style: TextStyle(
                        fontSize: 25
                      )
                    )
                  ]
                )
              ),
            ),
            Semantics(
              label: "Progress",
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:50),
                child: ValueListenableBuilder<double?>(
                  valueListenable: Core.instance.collection.notify.progress,
                  builder: (context, value, _)  => CircularProgressIndicator(
                    semanticsLabel: 'percentage',
                    semanticsValue: value.toString(),
                    strokeWidth: 2.0,
                    value: value,
                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                  )
                )
              )
            ),
            Semantics(
              label: "Message",
              child: Text(
                message,
                semanticsLabel: message,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 30,
                ),
              ),
            )
            // Semantics(
            //   label: "App name",
            //   child: Text(
            //     "MyOrdbok",
            //     semanticsLabel: "MyOrdbok",
            //     style: TextStyle(
            //       fontSize: 22
            //     )
            //   )
            // )
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
  //           fontWeight: FontWeight.w200,
  //           // foreground: Paint()
  //           //   ..style = PaintingStyle.stroke
  //           //   ..strokeWidth = 2
  //           shadows: <Shadow>[
  //             // Shadow(
  //             //   offset: Offset(0.3, 0.5),
  //             //   blurRadius: 0.2,
  //             // ),
  //             // Shadow(
  //             //   offset: Offset(2.0, 1.0),
  //             //   blurRadius: 20.0,
  //             // ),
  //           ],
  //         ),
  //       )
  //     ),
  //   );
  // }
}