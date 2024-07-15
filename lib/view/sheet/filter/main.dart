import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/icon.dart';

import '../../../app.dart';

class Main extends SheetsDraggable {
  const Main({super.key});

  static String route = 'sheet-filter';
  static String label = 'Filter';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends SheetsDraggableState<Main> {
  @override
  ViewData get viewData => App.viewData;

  @override
  double get actualInitialSize => 0.6;
  @override
  double get actualMinSize => 0.4;
}
