// NOTE: Material
import 'package:flutter/material.dart';

// NOTE: SystemUiOverlayStyle
// import 'package:flutter/services.dart';

// NOTE: Privider: state management
import 'package:lidea/provider.dart';

import 'app.dart';
import 'initialize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  await App.core.ensureInitialized();

  runApp(const MyOrdbok());
}

class MyOrdbok extends StatelessWidget {
  const MyOrdbok({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('AppMain->build');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Core>(
          create: (context) => App.core,
        ),
        // ChangeNotifierProvider<Preference>(
        //   create: (context) => App.preference,
        // ),
        ChangeNotifierProvider<Authenticate>(
          create: (context) => App.authenticate,
        ),
      ],
      builder: builder,
    );
  }

  Widget builder(BuildContext context, Widget? child) {
    return AnimatedBuilder(
      animation: App.preference,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,

          restorationScopeId: 'lidea',
          // // locale: Localizations.localeOf(context),
          locale: App.preference.locale,
          localizationsDelegates: App.preference.localeDelegates,
          supportedLocales: App.preference.listOfLocale,
          theme: App.preference.light(context),
          darkTheme: App.preference.dark(context),
          // darkTheme: App.preference.dark(context: context),
          themeMode: App.preference.themeMode,
          onGenerateTitle: (BuildContext context) => App.core.data.env.name,

          // routeInformationParser: NavigatorRouteInformationParser(),
          routeInformationParser: RouteParser(),
          routerDelegate: App.routeDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        );
      },
    );
  }
}
