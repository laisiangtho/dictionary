import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lidea/scroll.dart';
import 'package:lidea/provider.dart';
// import 'package:flutter/foundation.dart';
import 'package:dictionary/widget.dart';
import 'package:dictionary/core.dart';
import 'package:dictionary/model.dart';
import 'package:dictionary/icon.dart';
import 'package:dictionary/notifier.dart';
part 'view.dart';
part 'suggest.dart';
part 'result.dart';
part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final controller = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  final suggestionKey = new UniqueKey();
  final resultKey = new UniqueKey();

  // bool inputEnable = true;
  final core = Core();

  // String get searchQuery => this.textController.text;

  // NOTE: show keyboard
  // FocusScope.of(context).requestFocus(focusNode);
  // focusNode.requestFocus();
  // NOTE: hide keyboard
  // FocusScope.of(context).unfocus()
  // focusNode?.unfocus();
  // NOTE: clear textfield
  // textController?.clear()


  @override
  void initState() {
    super.initState();
    this.textController.text = context.read<FormNotifier>().keyword;
    // textController.addListener(() {});
    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      }
    });

  }

  @override
  dispose() {
    controller.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}
