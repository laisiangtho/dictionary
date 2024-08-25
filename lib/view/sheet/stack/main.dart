import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'sheet-stack';
  static String label = 'Sheet';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _State();
}

class _State extends DraggableSheets<Main> {
  @override
  late final Core app = App.core;
}
