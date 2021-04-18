import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

// import 'package:lidea/provider.dart';
import 'package:lidea/scroll.dart';
import 'package:lidea/idea.dart';

// import 'package:dictionary/notifier.dart';
import 'package:dictionary/core.dart';
import 'package:dictionary/model.dart';

part 'view.store.dart';
part 'bar.dart';
part 'view.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final core = Core();
  final controller = ScrollController();

  AnimationController animationController;

  int testCounter = 0;
  final List<String> themeName = ["System","Light","Dark"];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animationController.animateTo(1.0);
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}
