import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:lidea/idea.dart';

import 'package:dictionary/theme.dart';
import 'package:dictionary/view/app.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  return runApp(Dictionary());
}

class Dictionary extends StatelessWidget {
  Dictionary({Key key, this.initialRoute}) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context){
    return IdeaModel(
      initialModel: IdeaTheme(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        platform: defaultTargetPlatform,
        isTesting: true
      ),
      child: app()
    );
  }

  Widget app(){
    return Builder(
      builder: (context) => uiOverlayStyle(
        has: IdeaTheme.of(context).resolvedSystemBrightness == Brightness.light,
        brightness: IdeaTheme.of(context).resolvedSystemBrightness,
        child: MaterialApp(
          title: "MyOrdbok",
          debugShowCheckedModeBanner: false,
          darkTheme: IdeaData.dark.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          theme: IdeaData.light.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          themeMode: IdeaTheme.of(context).themeMode,
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          // supportedLocales: GalleryLocalizations.supportedLocales,
          locale: IdeaTheme.of(context).locale,
          localeResolutionCallback: (locale, supportedLocales) => locale,
          initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            builder: (context) => ApplyTextOptions(
              child: AppMain(key: key)
            ),
            settings: settings
          )
          // onUnknownRoute: RouteConfiguration.onUnknownRoute,
        )
      )
    );
  }

  Widget uiOverlayStyle({Brightness brightness, bool has, Widget child}){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
        systemNavigationBarColor: has?IdeaData.darkScheme.primary:IdeaData.lightScheme.primary,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness
      ),
      child: child
    );
  }
}