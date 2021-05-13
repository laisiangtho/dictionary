import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:sqflite/sqflite.dart';

import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:dictionary/model.dart';
// import 'package:dictionary/notifier.dart';

part 'configuration.dart';
part 'collection.dart';
part 'store.dart';
part 'sqlite.dart';
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

  FutureOr<void> init() async {
    await _environmentInit();
    collection.notify.progress.value = 0.1;

    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    await settingInit();

    collection.notify.progress.value = 0.2;

    store = new Store(env: collection.env);
    Hive.registerAdapter(StoreAdapter());
    await store.init();
    collection.notify.progress.value = 0.3;

    sql = new SQLite(collection: collection);
    await sql.init();
    collection.notify.progress.value = 0.5;

    await historyInit();
    collection.notify.progress.value = 1.0;
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }

}
