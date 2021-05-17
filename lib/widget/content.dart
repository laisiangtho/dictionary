import 'package:flutter/material.dart';

class WidgetContent extends StatelessWidget {

  WidgetContent({
    Key? key,
    this.startWith:'...',
    this.atLeast:'enable at least\na ',
    this.enable:'Bible',
    this.task:'\nto ',
    this.message:'read',
    this.endWith:'...'
  }): super(key: key);

  final String startWith;
  final String endWith;
  final String atLeast;
  final String enable;
  final String task;
  final String message;

  String get label => '$startWith $atLeast $enable $task $message $endWith'.replaceAll("\n", " ").replaceAll("  ", " ");

  @override
  // enable at least\na Bible to read
  // enable at least\na Bible to search
  // enable at least\na Bible to view bookmarks
  // search\na Word or two in verses
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      key: key,
      fillOverscroll: false,
      hasScrollBody: false,
      child: Center(
        child: Semantics(
          label: "Message",
          child: Text(
            label,
            semanticsLabel: label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4
          )
        ),
        // child: MergeSemantics(
        //   child: RichText(
        //     textAlign: TextAlign.center,
        //     strutStyle: StrutStyle(fontSize: 30.0 ),
        //     text: TextSpan(
        //       text: this.startWith,
        //       style: TextStyle(
        //         // color: Theme.of(context).primaryColor,
        //         color: Colors.grey,
        //         fontSize: 35,
        //         fontWeight: FontWeight.w300,
        //         height: 1.0,
        //         shadows: <Shadow>[
        //           Shadow(
        //             offset: Offset(0.4, 0.5),
        //             blurRadius: 0.2,
        //             color: Color.fromARGB(255, 0, 0, 0),
        //             // color: Theme.of(context).shadowColor
        //           ),
        //           Shadow(
        //             offset: Offset(0.5, 0.5),
        //             blurRadius: 0.4,
        //             color: Color.fromARGB(125, 0, 0, 0),
        //             // color: Theme.of(context).shadowColor
        //           ),
        //         ]
        //       ),
        //       children: <TextSpan>[
        //         TextSpan(
        //           text:this.atLeast
        //         ),
        //         TextSpan(
        //           text: this.enable,
        //           style: TextStyle(
        //             color: Theme.of(context).primaryColorDark
        //           )
        //         ),
        //         TextSpan(
        //           text: this.task,
        //           style: TextStyle(
        //             fontSize: 25
        //           )
        //         ),
        //         TextSpan(
        //           text: this.message,
        //           style: TextStyle(
        //             // color: Theme.of(context).primaryColorLight
        //           )
        //         ),
        //         TextSpan(
        //           text: this.endWith,
        //           style: TextStyle(
        //             fontSize: 40
        //           )
        //         )
        //       ]
        //     )
        //   )
        // )
      )
    );
  }
}