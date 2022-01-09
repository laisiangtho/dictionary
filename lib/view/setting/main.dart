import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:lidea/hive.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/intl.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import 'package:lidea/view/demo/button_style.dart';
import 'package:lidea/view/demo/do_confirm.dart';
import 'package:lidea/view/demo/sliver_grid.dart';
import 'package:lidea/view/demo/sliver_list.dart';
import 'package:lidea/view/demo/text_height.dart';
import 'package:lidea/view/demo/text_translate.dart';
import 'package:lidea/view/demo/text_size.dart';

import '/core/main.dart';
import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  // final GlobalKey<NavigatorState>? navigatorKey;

  static const route = '/settings';
  // static const icon = Icons.settings;
  static const icon = LideaIcon.cog;
  static const name = 'Settings';
  static const description = 'Settings';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final Core core = context.read<Core>();
  // late final SettingsController settings = context.read<SettingsController>();
  // late final AppLocalizations translate = AppLocalizations.of(context)!;
  late final Authentication authenticate = context.read<Authentication>();
  late final scrollController = ScrollController();

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();

  Preference get preference => core.preference;

  List<String> get themeName => [
        preference.text.automatic,
        preference.text.light,
        preference.text.dark,
      ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final abc = Localizations.localeOf(context).languageCode;
      debugPrint('core.collection.locale: $abc');
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onClearAll() {
    Future.microtask(() {});
  }

  void onSearch(String word) {}

  void onDelete(String word) {
    Future.delayed(Duration.zero, () {});
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      controller: scrollController,
      child: body(),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              CupertinoButton(
                child: Text(core.collection.language('offlineaccess')),
                onPressed: () {
                  core.collection.language('offlineaccess');
                },
              ),
              CupertinoButton(
                child: const Text('offlineaccess: none'),
                onPressed: () {
                  core.collection.language('offlineaccess');
                },
              ),
              CupertinoButton(
                child: const Text('translate: hello'),
                onPressed: () {
                  core.collection.language('hello');
                },
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: WidgetLabel(
                          icon: Icons.lightbulb,
                          label: preference.text.themeMode,
                        ),
                      ),
                      const Divider(),
                      Selector<Preference, ThemeMode>(
                        selector: (_, e) => e.themeMode,
                        builder: (BuildContext context, ThemeMode theme, Widget? child) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ThemeMode.values.map<Widget>((e) {
                            bool active = theme == e;
                            return CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              child: WidgetLabel(
                                enable: !active,
                                label: themeName[e.index],
                              ),
                              onPressed: active ? null : () => preference.updateThemeMode(e),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: WidgetLabel(
                          icon: Icons.translate,
                          label: preference.text.locale,
                        ),
                      ),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: preference.supportedLocales.length,
                        // itemCount: Localizations.localeOf(context).,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          final lang = preference.supportedLocales[index];

                          Locale locale = Localizations.localeOf(context);
                          final String localeName = Intl.canonicalizedLocale(lang.languageCode);
                          final bool isCurrent = locale.languageCode == lang.languageCode;

                          return ListTile(
                            selected: isCurrent,
                            leading: Icon(isCurrent
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked),
                            title: Text(localeName),
                            onTap: () => preference.updateLocale(lang),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoTextTranslate(
          itemCount: preference.text.itemCount,
          itemCountNumber: preference.text.itemCountNumber,
          formatDate: preference.text.formatDate,
          confirmToDelete: preference.text.confirmToDelete,
          formatCurrency: preference.text.formatCurrency,
        ),
        const DemoButtonStyle(),
        const DemoDoConfirm(),
        const DemoSliverGrid(),
        const DemoSliverList(),
        const DemoTextHeight(),
        DemoTextSize(
          headline: preference.text.headline,
          subtitle: preference.text.subtitle,
          text: preference.text.text,
          caption: preference.text.caption,
          button: preference.text.button,
          overline: preference.text.overline,
        ),
      ],
    );
  }
}
