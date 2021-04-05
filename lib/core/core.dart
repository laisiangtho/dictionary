// import 'dart:async';
// import 'dart:convert' show json;
// import 'dart:io';
// // import 'dart:math';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter_tts/flutter_tts.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

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
    // final appDocumentary = await UtilDocument.directory;
    // Hive.init(appDocumentary.path);
    await Hive.initFlutter();
    await _settingPrimary();
    await _wordPrimary();
    await _sensePrimary();
    await _usagePrimary();
    await _synsetPrimary();
    await _synmapPrimary();

    // await definition();
    // await partOfSpeech();
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }
}
