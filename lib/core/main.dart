import 'dart:async';
// import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:sqflite/sqflite.dart';

import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:dictionary/model.dart';
// import 'package:dictionary/notifier.dart';

part 'configuration.dart';
part 'abstract.dart';
part 'store.dart';
part 'sqlite.dart';
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
  static Core _instance = new Core.internal();
  Core.internal();

  factory Core() => _instance;

  // retrieve the instance through the app
  static Core get instance => _instance;

  Future<void> init() async {
    Stopwatch initWatch = new Stopwatch()..start();
    // collection.notify.progress.value = 0.6;
    await initEnvironment();
    // collection.notify.progress.value = 0.1;

    await initArchive();

    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    await initSetting();

    // collection.notify.progress.value = 0.2;

    store = new Store(env: collection.env!);
    Hive.registerAdapter(StoreAdapter());
    await store!.init();
    // collection.notify.progress.value = 0.3;

    sql = new SQLite(collection: collection);
    await sql!.init();

    // collection.notify.progress.value = 0.5;

    await initHistory();
    collection.notify.progress.value = 1.0;

    // final helloClient = await mockTestingArchive().catchError((e){
    //   print('mockTestingArchive: $e');
    // });
    // print('helloClient $helloClient');

    await mockTest();

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} Milliseconds');
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }

}
