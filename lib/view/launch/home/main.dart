import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/cached_network_image.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'refresh.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/home';
  static const icon = LideaIcon.search;
  static const name = 'Home';
  static const description = '...';
  // static final uniqueKey = UniqueKey();
  // static final navigatorKey = GlobalKey<NavigatorState>();
  // static late final scaffoldKey = GlobalKey<ScaffoldState>();
  // static const scaffoldKey = Key('launch-adfeeppergt');

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;

  final scrollController = ScrollController();

  Authentication get authenticate => context.read<Authentication>();
  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
    // Future.microtask((){});
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

  String get searchQuery => core.searchQuery;
  set searchQuery(String ord) {
    core.searchQuery = ord;
  }

  String get suggestQuery => core.suggestQuery;
  set suggestQuery(String ord) {
    core.suggestQuery = ord.replaceAll(RegExp(' +'), ' ').trim();
  }

  void onSearch(String ord) {
    suggestQuery = ord;
    searchQuery = suggestQuery;

    Future.microtask(() {
      core.conclusionGenerate();
    });
    core.navigate(to: '/search-result');
  }

  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }

  bool get canPop => Navigator.of(context).canPop();
}

class _View extends _State with _Bar, _Refresh {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      // key: widget.key,
      // controller: scrollController,
      child: body(),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        refresh(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 7),
              child: Hero(
                tag: 'searchHero',
                child: GestureDetector(
                  child: Material(
                    type: MaterialType.transparency,
                    child: MediaQuery(
                      data: MediaQuery.of(context),
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: preference.text.aWordOrTwo,
                          prefixIcon: const Icon(LideaIcon.find, size: 20),
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    core.navigate(to: '/search');
                  },
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 17),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      preference.text.recentSearch(true),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                      child: WidgetLabel(
                        icon: Icons.more_horiz,
                        message: preference.text.addTo(preference.text.recentSearch(true)),
                      ),
                      // child: const Text('more'),
                      onPressed: () {
                        core.navigate(to: '/recent-search');
                      },
                    ),
                  ],
                ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  // margin: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                  margin: const EdgeInsets.only(top: 17),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: researchWrap(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 17),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      preference.text.favorite(true),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                      child: WidgetLabel(
                        icon: Icons.more_horiz,
                        message: preference.text.addTo(preference.text.favorite(true)),
                      ),
                      // child: const Text('more'),
                      onPressed: () {
                        core.navigate(to: '/favorite');
                      },
                    ),
                  ],
                ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  // margin: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                  margin: const EdgeInsets.only(top: 17),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: favoriteWrap(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Text('promote'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search: suggest'),
                  onTap: () => core.navigate(to: '/search'),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search: result'),
                  onTap: () => core.navigate(to: '/search-result'),
                ),
                ListTile(
                  leading: const Icon(Icons.manage_search_rounded),
                  title: const Text('Recent search'),
                  onTap: () => core.navigate(to: '/recent-search'),
                ),
                ListTile(
                  leading: const Icon(Icons.low_priority_outlined),
                  title: const Text('Navigate to Blog'),
                  onTap: () => core.navigate(to: '/blog'),
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Navigate to article'),
                  onTap: () => core.navigate(to: '/article'),
                ),
                ListTile(
                  leading: const Icon(LideaIcon.bookOpen),
                  title: const Text('Navigate to reader'),
                  onTap: () => core.navigate(to: '/read'),
                ),
                ListTile(
                  leading: const Icon(Icons.sort),
                  title: const Text('Reorderable with Swipe for more'),
                  onTap: () => core.navigate(to: '/reorderable'),
                ),
                ListTile(
                  leading: const Icon(Icons.list_rounded),
                  title: const Text('Dismissible'),
                  onTap: () => core.navigate(to: '/dismissible'),
                ),
                ListTile(
                  leading: const Icon(Icons.note_alt),
                  title: const Text('Note'),
                  onTap: () => core.navigate(to: '/note'),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory_rounded),
                  title: const Text('Store'),
                  onTap: () => core.navigate(to: '/store'),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    // textStyle: TextStyle(color: Colors.blue),
                    // backgroundColor: Colors.white,
                    // shape:RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(24.0),
                    // ),
                  ),
                  icon: const Icon(Icons.baby_changing_station),
                  label: const Text('TextButton NoSplash'),
                  onPressed: () => core.mockTest1(),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.icecream_outlined),
                  label: const Text('TextButton.icon'),
                  onPressed: () => core.mockTest2(),
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xfffbba3d).withOpacity(0.3),
                    ),
                  ),
                  child: const Text('TextButton custom overlayColor'),
                  onPressed: () => false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    WidgetLabel(
                      label: 'abc',
                    ),
                    WidgetLabel(
                      label: '23',
                    ),
                    WidgetLabel(
                      icon: CupertinoIcons.back,
                      label: 'ပြန်',
                    ),
                    WidgetLabel(
                      icon: CupertinoIcons.back,
                      label: 'Back',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Chip(
                      avatar: Icon(Icons.style_sharp),
                      label: Text(
                        'Chip',
                        strutStyle: StrutStyle(),
                      ),
                    ),
                    const Chip(
                      avatar: Icon(Icons.style_sharp),
                      label: Text(
                        'စမ်းသပ်မှု',
                        strutStyle: StrutStyle(),
                      ),
                    ),
                    CupertinoButton(
                      child: const Chip(
                        avatar: Icon(CupertinoIcons.back),
                        labelPadding: EdgeInsets.zero,
                        label: Text(
                          'Back',
                          strutStyle: StrutStyle(),
                        ),
                      ),
                      onPressed: () => {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      child: const Chip(
                        avatar: Icon(CupertinoIcons.back),
                        labelPadding: EdgeInsets.zero,
                        label: Text(
                          'ပြန်',
                          strutStyle: StrutStyle(),
                        ),
                      ),
                      onPressed: () => {},
                    ),
                    CupertinoButton(
                      child: const Chip(
                        avatar: Icon(CupertinoIcons.back),
                        labelPadding: EdgeInsets.zero,
                        label: Text(
                          'နောက်',
                          strutStyle: StrutStyle(),
                        ),
                      ),
                      onPressed: () => {},
                    ),
                    CupertinoButton(
                      child: const Chip(
                        avatar: Icon(CupertinoIcons.back),
                        labelPadding: EdgeInsets.zero,
                        label: Text(
                          'အိမ်',
                          strutStyle: StrutStyle(),
                        ),
                      ),
                      onPressed: () => {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget researchWrap() {
    return Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.recentSearches.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
        if (items.isEmpty) {
          return const Icon(LideaIcon.dotHoriz);
        }
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          textDirection: TextDirection.ltr,
          children: items.take(3).map(
            (e) {
              return CupertinoButton(
                child: Text(
                  e.value.word,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: () => onSearch(e.value.word),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget favoriteWrap() {
    return Selector<Core, List<MapEntry<dynamic, FavoriteType>>>(
      selector: (_, e) => e.collection.favorites.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, FavoriteType>> items, Widget? __) {
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
        if (items.isEmpty) {
          return const Icon(LideaIcon.dotHoriz);
        }
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          textDirection: TextDirection.ltr,
          children: items.take(3).map(
            (e) {
              return CupertinoButton(
                child: Text(
                  e.value.word,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: () => onSearch(e.value.word),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
