import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'package:lidea/scroll.dart';

import 'package:dictionary/core.dart';
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

  // NOTE: used in bar, suggest & result
  void search(String word) async{
    core.collection.notify.searchQuery.value = word;
    controller.master.bottom.pageChange(0);
    final result = await core.definition(word);
    Future.delayed(const Duration(milliseconds: 200), () {
      core.collection.notify.searchResult.value = result;
    });

    // controller.animateTo(
    //   controller.position.minScrollExtent,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 700)
    // );
  }
}
