import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// import 'package:lidea/icon.dart';

import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'sheet-filter';
  static String label = 'Filter';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends DraggableSheets<Main> {
  @override
  late final Core app = App.core;

  @override
  late final actualInitialSize = 0.6;
  @override
  late final actualMinSize = 0.4;
}
