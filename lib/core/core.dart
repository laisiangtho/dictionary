import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:dictionary/model.dart';

part 'configuration.dart';
part 'collection.dart';
part 'utility.dart';
part 'store.dart';
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
    await settingInit();
    store = new Store(env: env);

    Hive.registerAdapter(StoreAdapter());
    await store.init();

    await historyInit();

    // Hive.registerAdapter(WordAdapter());
    // await wordInit();

    // Hive.registerAdapter(SenseAdapter());
    // await senseInit();

    // Hive.registerAdapter(UsageAdapter());
    // await usageInit();

    // Hive.registerAdapter(SynsetAdapter());
    // await synsetInit();

    // Hive.registerAdapter(SynmapAdapter());
    // await synmapInit();

    // Hive.registerAdapter(ThesaurusAdapter());
    // await thesaurusInit();
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }

}
