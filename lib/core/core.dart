import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:dictionary/model.dart';

part 'configuration.dart';
part 'collection.dart';
part 'utility.dart';
part 'mock.dart';


// class Core extends _Collection with _Bible, _Bookmark, _Speech, _Mock
// abstract class _Collection with _Configuration, _Utility
// mixin _Configuration
// mixin _Bible on _Collection
// mixin _Bookmark on _Bible
// mixin _Speech
// mixin _Mock
// mixin _Utility

class Core extends _Collection with _Mock {
  // Creates instance through `_internal` constructor
  static Core _instance = new Core.internal();
  Core.internal();

  factory Core() => _instance;

  // retrieve the instance through the app
  static Core get instance => _instance;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    await _settingInit();

    await _historyInit();

    Hive.registerAdapter(WordAdapter());
    await _wordInit();

    Hive.registerAdapter(SenseAdapter());
    await _senseInit();

    Hive.registerAdapter(UsageAdapter());
    await _usageInit();

    Hive.registerAdapter(SynsetAdapter());
    await _synsetInit();

    Hive.registerAdapter(SynmapAdapter());
    await _synmapInit();

    Hive.registerAdapter(ThesaurusAdapter());
    await _thesaurusInit();
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }
}
