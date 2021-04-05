part of 'app.dart';

class ScreenLauncher extends StatelessWidget {
  final String message;
  ScreenLauncher({this.message});

  // A comprehensive Myanmar online dictionary

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      // drawerEnableOpenDragGesture: false,
      // endDrawerEnableOpenDragGesture: false,
      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              // strutStyle: StrutStyle(),
              text: TextSpan(
                text: '"',
                semanticsLabel: Core.instance.appDescription,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 33,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:'A',
                    style: TextStyle(
                      fontSize: 19,
                    )
                  ),
                  TextSpan(
                    text: ' comprehensive\n',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 20,
                    )
                  ),
                  TextSpan(
                    text: 'Myanmar\n',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    )
                  ),
                  TextSpan(
                    text: 'online ',
                    style: TextStyle(
                      // color: Colors.brown,
                      fontSize: 19,
                    )
                  ),
                  TextSpan(
                    text: 'dictionary',
                    style: TextStyle(
                      fontSize: 22,
                    )
                  ),
                  TextSpan(
                    text: '"'
                  ),
                ]
              )
            ),
            // CircularProgressIndicator(
            //   value: progress+0.1,
            //   backgroundColor: Colors.grey[300],
            //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
            //   strokeWidth: 1
            // ),
            // SizedBox(
            //   height: 25,
            //   width: 25,
            //   child: CircularProgressIndicator(
            //     semanticsLabel: 'Loading',
            //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            //     strokeWidth: 2
            //   ),
            // ),
            Container(
              margin: EdgeInsets.symmetric(vertical:40),
              padding: EdgeInsets.symmetric(vertical:7, horizontal: 27),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(50),
              ),
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
            // Row(
            //   // mainAxisSize: MainAxisSize.min,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       height: 20,
            //       width: 20,
            //       child: CircularProgressIndicator(
            //         semanticsLabel: 'Loading',
            //         // value: progress+0.1,
            //         // backgroundColor: Colors.grey[300],
            //         valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            //         strokeWidth: 2
            //       ),
            //     ),
            //     Text(
            //       message,
            //       semanticsLabel: message,
            //       style: TextStyle(
            //         color: Colors.red,
            //         fontSize: 30,
            //       ),
            //     ),
            //   ]
            // ),
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: CircularProgressIndicator(
            //     // value: progress+0.1,
            //     backgroundColor: Colors.grey[300],
            //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
            //     strokeWidth: 1
            //   ),
            // ),
            Text(
              Core.instance.appName,
              semanticsLabel: Core.instance.appName,
              style: TextStyle(
                fontSize: 22,
                // color: Colors.grey
              )
            ),
          ],
        ),
      ),
      // bottomNavigationBar: name(),
    );
  }

  Widget name(){
    return Container(
      height: 70,
      child: Center(
        child: Text(
          // store.appVersion,
          // Store.apple
          Core.instance.version,
          // '...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w200,
            // foreground: Paint()
            //   ..style = PaintingStyle.stroke
            //   ..strokeWidth = 2
            //   ..color = Colors.grey[200],
            shadows: <Shadow>[
              // Shadow(
              //   offset: Offset(0.3, 0.5),
              //   blurRadius: 0.2,
              //   color: Colors.black
              // ),
              // Shadow(
              //   offset: Offset(2.0, 1.0),
              //   blurRadius: 20.0,
              //   color: Colors.red,
              // ),
            ],
          ),
        )
      ),
    );
  }
}