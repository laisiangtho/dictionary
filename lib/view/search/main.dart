import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lidea/scroll.dart';
import 'package:lidea/provider.dart';

import 'package:dictionary/widget.dart';
import 'package:dictionary/core.dart';
// import 'package:dictionary/model.dart';
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

  final core = Core();

  @override
  void initState() {
    super.initState();
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';
    textController.addListener(() async {
      final word = textController.text.replaceAll(RegExp(' +'), ' ').trim();
      core.collection.notify.suggestQuery.value = word;
      core.collection.notify.suggestResult.value = await core.suggestionGenerate(word);
    });
    // focusNode.addListener(() {
    //   if(focusNode.hasFocus) {
    //     textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
    //   }
    // });
  }

  @override
  dispose() {
    controller.dispose();
    focusNode.dispose();
    textController.dispose();
    core.collection.notify.suggestQuery.dispose();
    core.collection.notify.suggestResult.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  // NOTE: used in bar, suggest & result
  void search(BuildContext context, String word) async {
    if (word.isNotEmpty && core.collection.hasNotHistory(word)){
      final index = core.collection.history.length;
      core.collection.history.add(word);
      if (core.listKeyHistory.currentState != null){
        core.listKeyHistory.currentState.insertItem(index);
      }
    }
    this.focusNode?.unfocus();
    // FocusScope.of(context).unfocus();
    // FormNotifier form = context.read<FormNotifier>();
    // context.read<FormNotifier>().searchQuery = word;
    // context.read<FormNotifier>().searchQuery = word;
    // Provider.of<FormNotifier>(context,listen: false).searchQuery = word;
    // FormNotifier form = Provider.of<FormNotifier>(context,listen: false);
    // if (form.keyword != word) {
    //   form.keyword = word;
    // }
    core.collection.notify.suggestQuery.value = word;

    // if (form.searchQuery != word && word.isNotEmpty) {
    //   form.searchQuery = word;
    //   core.analyticsSearch(word);
    // }
    core.collection.notify.searchQuery.value = word;
    // this.textController.text = word;
    core.collection.notify.searchResult.value = await core.definition(word);
    controller.animateTo(
      controller.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 700)
    );
  }
}
