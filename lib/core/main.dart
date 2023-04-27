library data.core;

import 'dart:async';
import 'package:flutter/material.dart';

// NOTE: Preference
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// NOTE: Authentication
// import 'package:lidea/firebase/auth.dart';
import 'package:lidea/unit/authenticate.dart';

// NOTE: Core notify and Initializing properties
import 'package:lidea/unit/core.dart';

// NOTE: Analytics
import 'package:lidea/unit/analytics.dart';

// NOTE: Individual
import 'package:lidea/unit/store.dart';
import 'package:lidea/unit/sqlite.dart';
import 'package:lidea/unit/speech.dart';

// NOTE: view ???
import 'package:lidea/view/main.dart' show ViewScroll, ViewData;
export 'package:lidea/view/main.dart';

// NOTE: route
import '/view/routes.dart' show RouteDelegate;
// show MainDelegate, NestDelegate, NestedView, RouteNotifier, RouteParser
export '/view/routes.dart';

// NOTE: scroll ???
// import '../unit/view.md' show ScrollNotifier;
// export '../unit/view.md' show ScrollNotifier;

// NOTE: Nest and Type
import '/type/main.dart';
export '/type/main.dart';

part 'abstract.dart';
part 'mock.dart';
part 'search.dart';
part 'view.dart';

part 'preference.dart';
part 'authenticate.dart';
part 'analytics.dart';

part 'store.dart';
part 'sqlite.dart';
part 'speech.dart';

class Core extends _Search {
  Future<void> initialized(BuildContext context) async {
    Stopwatch initWatch = Stopwatch()..start();
    preference.setContext(context);

    await prepareInitialized();

    await store.init();
    // await sql.init();
    // await speech.init();
    // await poll.init();
    // await mockTest();

    data.suggestQuery = data.searchQuery;

    Future.microtask(() {
      message.value = '';
    });
    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }
}
