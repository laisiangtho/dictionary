import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetMsg extends StatelessWidget {
  final String message;
  WidgetMsg({Key key, this.message:'?'}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: key,
      child: Container(
        margin: new EdgeInsets.symmetric(horizontal:60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              this.message, textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20,top: 20),
              child: Icon(CupertinoIcons.ellipsis,size: 25,),
            ),
          ],
        )
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
      child: WidgetMsg(message: message,)
    );
  }
}