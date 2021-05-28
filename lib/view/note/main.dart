import 'package:dictionary/core/type/main.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view.dart';

import 'package:dictionary/core.dart';
import 'package:dictionary/icon.dart';
import 'package:dictionary/widget.dart';

// import 'suggestion.dart';
// import 'definition.dart';
// import 'AnimateExpansion.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final _scaffoldDefinition = UniqueKey();

  final scrollController = ScrollController();

  late Core core;

  @override
  void initState() {
    super.initState();

    core = context.read<Core>();
    // history = core.collection.boxOfHistory;
    // historyTest = core.collection.boxOfHistory.values.toList();
    // core.collection.boxOfHistory.listenable();

    // Future.microtask((){
    //   core.historyGenerate();
    // });
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void onClearAll(){
    Future.microtask((){
      core.historyClear();
    });
  }

  void onSearch(String word){
    ViewNotify.navigation.value = 0;
    Future.delayed(const Duration(milliseconds: 200), () {
      core.definitionGenerate(word);
    });
    Future.delayed(Duration.zero, () {
      core.historyAdd(word);
    });
  }

  void onDelete(String word){
    // Future.microtask((){});
    Future.delayed(Duration.zero, () {
      core.historyDelete(word);
    });
  }

}

class _View extends _State with _Bar{

  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      controller: scrollController,
      child: Selector<Core,List<MapEntry<dynamic, HistoryType>>>(
        selector: (_, e) => e.collection.boxOfHistory.toMap().entries.toList(),
        builder: (BuildContext context, List<MapEntry<dynamic, HistoryType>> items, Widget? child) => NestedScrollView(
          floatHeaderSlivers: true,
          controller: scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // dragStartBehavior: DragStartBehavior.start,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            bar(innerBoxIsScrolled, items.length)
          ],
          body:body(items)
        ),
      )
    );
  }

  CustomScrollView body(List<MapEntry<dynamic, HistoryType>> items){
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
    return CustomScrollView(
      primary: true,
      // controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        // if(items.length > 0)listContainer(items)
        if(items.length > 0) listContainer(items),
        if(items.length == 0) messageContainer(),
      ]
    );
  }

  Widget messageContainer(){
    return new SliverFillRemaining(
      child: WidgetMsg(message: ':)',),
    );
  }

  SliverList listContainer(Iterable<MapEntry<dynamic, HistoryType>> box){
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => itemContainer(index, box.elementAt(index)),
        childCount: box.length>30?30:box.length
      )
    );
  }

  Dismissible itemContainer(int index,MapEntry<dynamic, HistoryType> history){
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(history.value.word),
      direction: DismissDirection.endToStart,
      child: decoration(
        child: ListTile(
          // contentPadding: EdgeInsets.zero,
          title: Text(history.value.word,
            style: TextStyle(
              fontSize: 20,
              // color: Theme.of(context).textTheme.caption!.color,
              color: Theme.of(context).primaryTextTheme.button!.color,
              fontWeight: FontWeight.w300
            ),
          ),
          minLeadingWidth : 10,
          leading: Icon(Icons.history),
          // leading: CircleAvatar(
          //   // radius:10.0,
          //   // backgroundColor: Colors.grey.shade800,
          //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //   child: Text(NumberFormat.compact().format(history.value.hit),textAlign: TextAlign.center,),
          // ),
          trailing:(history.value.hit> 1)?Chip(
            avatar: CircleAvatar(
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.saved_search_outlined, color: Theme.of(context).primaryColor,),
              // child: Text('#',style: TextStyle(color: Theme.of(context).primaryColor,),),
            ),
            label: Text(history.value.hit.toString()),
          ):null,
          onTap: ()=> this.onSearch(history.value.word),
        )
      ),
      background: dismissiblesFromRight(),
      // secondaryBackground: dismissiblesFromLeft(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Do you want to delete "${history.value.word}"?
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            message: 'Do you want to delete "${history.value.word}"?'
          );
          if (confirmation != null && confirmation){
            onDelete(history.value.word);
            return true;
          }
          return false;
        } else {
          // Navigate to edit page;
        }
      }
    );
  }

  Widget decoration({required Widget child}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0,vertical:0.6),
      // margin: EdgeInsets.symmetric(horizontal:0,vertical:0.2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0.6,
            offset: Offset(0.0, .0)
          )
        ]
      ),
      child:child
    );
  }

  Widget dismissiblesFromRight() {
    return Container(
      color: Theme.of(context).highlightColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Icon(
            //   Icons.delete,
            //   color: Colors.white,
            // ),
            Text(
              "Delete",
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
