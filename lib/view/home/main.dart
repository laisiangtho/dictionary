import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:dictionary/core.dart';
import 'package:dictionary/icon.dart';
import 'package:dictionary/widget.dart';

// import 'TaskView.dart';

part 'SuggestionView.dart';
part 'DefinitionView.dart';
part 'DefinitionNone.dart';
part 'SuggestionNone.dart';
part 'HomeView.dart';
part 'HomeNone.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final _formKey = GlobalKey<FormState>();
  // final _focusKey = GlobalKey<FormState>();

  final _scaffoldSuggestion = UniqueKey();
  final _scaffoldDefinition = UniqueKey();

  final scrollController = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();
  // late ScrollController scrollController;

  late Core core;

  // late TextEditingController textController;
  // late FocusNode focusNode;
  // late String searchQuery;
  // final core = Core();

  @override
  void initState() {
    super.initState();
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';
    core = context.read<Core>();
    Future.microtask(() {
      textController.text = core.suggestionQuery;
    });

    // scrollController = ScrollController()..addListener(() {});
    focusNode.addListener(() {
      // if(focusNode.hasFocus) {
      //   textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      // }
      context.read<Core>().nodeFocus = focusNode.hasFocus;
    });

    textController.addListener(() {
      final word = textController.text.replaceAll(RegExp(' +'), ' ').trim();
      core.suggestionQuery = word;
    });
  }

  @override
  dispose() {
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String keyWords(String words) {
    return words.replaceAll(RegExp(' +'), ' ').trim();
  }

  void onCancel() {
    focusNode.unfocus();
  }

  void onSuggest(String str) {
    Future.microtask(() {
      // core.suggestionQuery = keyWords(str);
      core.suggestionGenerate(keyWords(str));
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    final word = keyWords(str);
    this.focusNode.unfocus();

    Future.microtask(() {
      // context.read<Core>().definitionQuery = word;
      // context.read<Core>().definitionGenerate(word);
      core.definitionGenerate(word);
    }).whenComplete(() {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 800));
    });

    Future.delayed(Duration.zero, () {
      core.historyAdd(word);
    });
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    debugPrint('home build');
    return ViewPage(
      key: widget.key,
      // controller: scrollController,
      child: Selector<Core, bool>(
        selector: (_, e) => e.nodeFocus,
        builder: (BuildContext context, bool focus, Widget? child) =>
          NestedScrollView(
            floatHeaderSlivers: true,
            controller: scrollController,
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            // dragStartBehavior: DragStartBehavior.start,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
              <Widget>[bar(innerBoxIsScrolled)],
            body: body()
          ),
      )
    );
  }

  Widget body() {
    return CustomScrollView(
      primary: true,
      // controller: scrollController,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        if (focusNode.hasFocus)
          WidgetKeepAlive(
            key: _scaffoldSuggestion,
            child: new SuggestionView(search: onSearch)
          ),

        if (!focusNode.hasFocus)
          WidgetKeepAlive(
            key: _scaffoldDefinition,
            child: new DefinitionView(search: onSearch)
          ),

        Consumer<Core>(
          builder: (BuildContext _, Core core, Widget? child) {
            if (focusNode.hasFocus && core.suggestionList.length == 0) {
              return SuggestionNone();
            } else if (!focusNode.hasFocus &&
                core.definitionQuery.isNotEmpty &&
                core.definitionList.length == 0) {
              return DefinitionNone();
            } else if (!focusNode.hasFocus && core.definitionQuery.isEmpty) {
              return HomeView();
            } else {
              return child!;
            }
          },
          child: new HomeNone(),
        ),
        // new TaskView()
      ]
    );
  }
}
