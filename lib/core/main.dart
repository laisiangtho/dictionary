import 'dart:async';
// import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:dictionary/model.dart';
// import 'package:dictionary/notifier.dart';

import 'store.dart';
import 'sqlite.dart';

part 'configuration.dart';
part 'notify.dart';
part 'abstract.dart';
// part 'store.dart';
// part 'sqlite.dart';
part 'utility.dart';
part 'mock.dart';

// class Core extends _Abstract with _Bible, _Bookmark, _Speech, _Mock
// abstract class _Abstract with _Configuration, _Utility
// mixin _Configuration
// mixin _Bible on _Abstract
// mixin _Bookmark on _Bible
// mixin _Speech
// mixin _Mock
// mixin _Utility

class Core extends _Abstract with _Mock {
  // Creates instance through `_internal` constructor
  static final Core _instance = new Core.internal();
  Core.internal();
  factory Core() => _instance;
  // retrieve the instance through the app
  static Core get instance => _instance;

  Future<void> init() async {
    Stopwatch initWatch = new Stopwatch()..start();

    // Collection collectionabc = Collection.internal();
    if (progressPercentage == 1.0) return;

    // progressPercentage = 0.6;
    await initEnvironment();
    progressPercentage = 0.1;

    await initArchive();

    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(PurchaseAdapter());
    await initSetting();

    progressPercentage = 0.3;

    store = new Store(notify:notify,collection: collection);

    await store.init();
    progressPercentage = 0.5;

    _sql = new SQLite(collection: collection);
    await _sql.init();

    progressPercentage = 0.7;

    Hive.registerAdapter(HistoryAdapter());
    await initHistory();

    progressPercentage = 0.9;

    // // final helloClient = await mockTestingArchive().catchError((e){
    // //   debugPrint('mockTestingArchive: $e');
    // // });
    // // debugPrint('helloClient $helloClient');

    await mockTest();

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} Milliseconds');
    progressPercentage = 1.0;
    _message = 'Done';
    // suggestionQuery = 'god';
    // suggestionQuery = collection.setting.searchQuery!;
    // suggestionQuery = collection.setting.searchQuery!;
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }

}
