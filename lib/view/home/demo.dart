import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

// import 'package:lidea/provider.dart';
import 'package:lidea/intl.dart' as intl;
// import 'package:lidea/view.dart';

// import 'package:dictionary/core.dart';
// import 'package:dictionary/icon.dart';
// import 'package:dictionary/widget.dart';

class DemoView extends StatelessWidget {
  DemoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      key: key,
      delegate: new SliverChildListDelegate(
        <Widget>[
          ElevatedButton(
            child: Text("DateTime.now"),
            onPressed: () {
              final abc = DateTime.now();
              debugPrint('$abc');
            },
          ),
          ElevatedButton(
            child: Text("wordHistory.test"),
            onPressed: () {
              // final abc = core.collection.wordHistory.values.where((e) => core.collection.stringCompare(e.word,'ord'));
              // debugPrint('total  ${abc.length}');
            },
          ),
          ElevatedButton(
            child: Text("wordHistory.test"),
            onPressed: () {
              var _formattedNumber = intl.NumberFormat.compact().format(1500);
              debugPrint('Formatted Number is $_formattedNumber');
            },
          ),
        ]
      )
    );
  }
}