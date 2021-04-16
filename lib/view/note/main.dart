// import 'package:dictionary/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lidea/provider.dart';

import 'package:lidea/scroll.dart';

import 'package:dictionary/core.dart';
import 'package:dictionary/notifier.dart';
import 'package:dictionary/widget.dart';

part 'bar.dart';
part 'view.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final controller = ScrollController();
  final core = Core();

  @override
  void initState() {
    super.initState();
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
