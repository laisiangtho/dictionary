import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({Key? key}) : super(key: key);

  static String route = 'sheet-parallel';
  static String label = 'Parallel';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  @override
  bool get persistent => true;

  // @override
  // List<Widget> slivers() {
  //   return <Widget>[
  //     const SliverAppBar(
  //       // floating: true,
  //       pinned: true,
  //       // snap: true,
  //       title: Text('sheet stack'),
  //     ),
  //     SliverToBoxAdapter(
  //       child: ElevatedButton(
  //         onPressed: () {
  //           draggableController
  //               .animateTo(
  //             0.0,
  //             duration: const Duration(milliseconds: 200),
  //             curve: Curves.ease,
  //           )
  //               .whenComplete(() {
  //             // draggableController.reset();
  //           });
  //         },
  //         child: const Text('.animateTo(defaultInitial)'),
  //       ),
  //     ),
  //   ];
  // }

  @override
  Widget decoration({Widget? child}) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 30),
      // margin: const EdgeInsets.only(top: kToolbarHeight),
      decoration: BoxDecoration(
        // color: persistent ? theme.scaffoldBackgroundColor.withOpacity(0.5) : theme.primaryColor,
        // color: theme.primaryColor,
        // color: Theme.of(context).primaryColor,
        color: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
        // color: Colors.transparent,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
          // top: Radius.elliptical(15, 15),
        ),

        // borderRadius: const BorderRadius.vertical(
        //   top: Radius.circular(10),
        //   // top: Radius.elliptical(15, 15),
        // ),
        // border: Border.all(color: Colors.blueAccent),
        // border: Border(
        //   top: BorderSide(width: 0.5, color: theme.shadowColor),
        // ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,

            // color: theme.shadowColor.withOpacity(0.9),
            // color: theme.backgroundColor.withOpacity(0.6),
            blurRadius: 0.5,
            spreadRadius: 0.0,
            offset: const Offset(0, 0),
          )
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}
