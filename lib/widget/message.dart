import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetMsg extends StatelessWidget {
  final String message;
  WidgetMsg({Key key, this.message:'?'}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: new EdgeInsets.symmetric(horizontal:60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Semantics(
            label: "Message",
            child: Text(
              this.message,
              semanticsLabel: this.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21
              ),
            ),
          ),
          Semantics(
            label: "Icon",
            child: Padding(
              padding: EdgeInsets.only(bottom: 20,top: 20),
              child: Icon(
                CupertinoIcons.ellipsis,
                semanticLabel: "ellipsis",
                size: 40
              )
            ),
          )
        ]
      )
    );
  }
}

class WidgetMessage extends StatelessWidget {
  final String message;
  WidgetMessage({Key key, this.message:'?'}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return new SliverFillRemaining(
      key: key,
      hasScrollBody: false,
      fillOverscroll: false,
      child: WidgetMsg(message: message)
    );
  }
}