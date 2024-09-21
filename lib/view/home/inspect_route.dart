part of 'main.dart';

class InspectRoute extends StatefulWidget {
  const InspectRoute({super.key});

  static String route = 'test-inspect';
  static String label = 'Inspect';
  static IconData icon = Icons.ac_unit;

  @override
  State<InspectRoute> createState() => _InspectRouteState();
}

abstract class _InspectRouteAbstract extends CommonStates<InspectRoute> {}

class _InspectRouteState extends _InspectRouteAbstract {
  @override
  Widget build(BuildContext context) {
    // ViewLists();
    // ListView();
    // SliverList.list();
    return ViewLists.static(
      children: [
        ViewSections(
          sliver: false,
          headerTitle: const Text('Extended search'),
          child: ViewCards(
            child: ListBody(
              children: [
                ViewButtons(
                  onPressed: () {
                    router.push('/search');
                  },
                  child: const Text('to search'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('/search', extra: {'keyword': 'love', 'focus': true});
                  },
                  child: const Text('search: love and focus'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('/search', extra: {'keyword': 'kings'});
                  },
                  child: const Text('search: kings'),
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          sliver: false,
          headerTitle: const Text('View section'),
          headerTrailing: ViewButtons(
            onPressed: () {},
            child: const Icon(Icons.more_horiz),
          ),
          // footerTitle: const Text('View note'),
          child: ViewCards(
            child: ListBody(
              children: [
                ViewButtons(
                  onPressed: app.sql.init,
                  child: const Text('SQL Init'),
                ),
                ViewButtons(
                  onPressed: () {
                    app.sql.checkTypeIndex().then((value) {
                      debugPrint('-- $value');
                    }).catchError((e) {
                      debugPrint('$e');
                    });
                  },
                  child: const Text('checkTypeIndex .'),
                ),
                ViewButtons(
                  onPressed: () {
                    app.sql.checkTypeIndex(table: 'sense').then((value) {
                      debugPrint('-- $value');
                    }).catchError((e) {
                      debugPrint('$e');
                    });
                  },
                  child: const Text('checkTypeIndex sense'),
                ),
                ViewButtons(
                  onPressed: () {
                    app.sql.checkTypeIndex(table: 'thesaurus').then((value) {
                      debugPrint('-- $value');
                    }).catchError((e) {
                      debugPrint('$e');
                    });
                  },
                  child: const Text('checkTypeIndex thesaurus'),
                ),
                ViewButtons(
                  onPressed: () {
                    app.sql.search('love').then((value) {
                      debugPrint('db-query $value');
                    }).catchError((e) {
                      debugPrint('$e');
                    });
                  },
                  child: const Text('search'),
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('View section with fill'),
          child: ViewCards.fill(
            child: ListBody(
              children: [
                ViewButtons(
                  onPressed: () {
                    doConfirmWithDialog(context: context, message: 'Confirm');
                  },
                  child: const Text('ViewButtons'),
                ),
                const ViewButtons(
                  child: Text('ViewButtons disable'),
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('Search: home/search'),
          child: ViewCards(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('go to search (default)'),
                  subtitle: const Text('same as bottom navigation'),
                  onTap: () {
                    router.push('/search');
                  },
                ),
                ListTile(
                  title: const Text('go to search and focus'),
                  subtitle: const Text('ready to type'),
                  onTap: () {
                    router.push('/search', extra: {'focus': true, 'keyword': 'love'});
                  },
                ),
                ListTile(
                  title: const Text('go to search (instantly)'),
                  subtitle: const Text('get result (working)'),
                  onTap: () {
                    router.push('/search');
                  },
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('Swipe: home/bible'),
          child: ViewCards(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('go to bible (default)'),
                  subtitle: const Text('same as more from home'),
                  onTap: () {
                    router.push('/bible');
                  },
                ),
                ListTile(
                  title: const Text('go to bible as coming from parallel'),
                  subtitle: const Text('ready to select for parallel'),
                  onTap: () {
                    router.push('/bible', extra: {'parallel': true});
                  },
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('???'),
          child: ViewCards.fill(
            child: ListBody(
              children: [
                ViewButtons(
                  onPressed: () {
                    router.push('/reader/user-profile-test-child');
                  },
                  child: const Text('reader/user-profile-test-child'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('//user-profile-test-child');
                  },
                  child: const Text('/user-profile-test-child'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('//reader');
                  },
                  child: const Text('/reader'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('/read/2');
                  },
                  child: const Text('read/2'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('//read');
                  },
                  child: const Text('/read'),
                ),
                ViewButtons(
                  onPressed: () {
                    router.push('/swipe');
                  },
                  child: const Text('home/swipe'),
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('Sign in buttons'),
          child: Card(
            child: ListBody(
              children: [
                ViewSignIns(
                  icon: Icons.abc,
                  label: 'Sign in with Google',
                  onPressed: () {},
                ),
                ViewSignIns(
                  icon: Icons.abc,
                  label: 'Sign in with Apple',
                  onPressed: () {},
                ),
                ViewSignIns(
                  icon: Icons.abc,
                  label: 'Sign in with Facebook',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('ViewButtons'),
          child: Card(
            child: ListBody(
              children: [
                ViewButtons(
                  color: Colors.red,
                  onPressed: () {},
                  child: const Text('ViewButtons'),
                ),
                const ViewButtons.filled(
                  child: Text('ViewButtons disable filled'),
                ),
                const ViewButtons(
                  child: Text('ViewButtons disable'),
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('routeOld.showSheetModal'),
          child: Card(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('routeOld.showSheetModal sheet-modal'),
                  onTap: () {
                    // routeOld.showSheetModal(context: context, name: 'sheet-modal');
                  },
                ),
                ListTile(
                  title: const Text('routeOld.showSheetStack sheet-stack'),
                  onTap: () {
                    /// ??? routeOld.showSheetStack(context: context, name: 'sheet-stack');
                    // routeOld.showSheetModal(context: context, name: 'sheet-stack');
                  },
                ),
              ],
            ),
          ),
        ),
        const ViewDividers(),
        ViewSections(
          headerTitle: const Text('Go to'),
          child: Card(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('Store'),
                  subtitle: const Text('routeOld.pushNamed(home/store)'),
                  onTap: () {
                    router.push('/store');
                  },
                ),
                ListTile(
                  title: const Text('Gallery'),
                  subtitle: const Text('routeOld.pushNamed(home/gallery)'),
                  onTap: () {
                    router.push('/gallery');
                  },
                ),
                ListTile(
                  title: const Text('Stage'),
                  subtitle: const Text('routeOld.pushNamed(stage)'),
                  onTap: () {
                    router.push('/stage');
                  },
                ),
                ListTile(
                  title: const Text('Read: 2'),
                  subtitle: const Text('routes.pushNamed(/read/2)'),
                  onTap: () {
                    router.push('//read/2');
                  },
                ),
                ListTile(
                  title: const Text('Read: 1'),
                  subtitle: const Text('routes.pushNamed(read/1)'),
                  onTap: () {
                    router.push('/read/1');
                  },
                ),
                ListTile(
                  title: const Text('Other'),
                  subtitle: const Text('routes.pushNamed(/other)'),
                  onTap: () {
                    router.push('//other');
                  },
                ),
                ListTile(
                  title: const Text('a page thats not on current navigator'),
                  subtitle: const Text('routes.pushNamed(name: /none)'),
                  onTap: () {
                    router.push('//none');
                  },
                ),
              ],
            ),
          ),
        ),
        ViewSections(
          headerTitle: const Text('Navigator.of(context)'),
          child: Card(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('Go to a page thats not on current navigator, Non existent'),
                  subtitle: const Text('Navigator.of(context).pushNamed(/none)'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/none');
                  },
                ),
                ListTile(
                  title: const Text('Go to Stage'),
                  subtitle: const Text('Navigator.of(context).pushNamed(/stage)'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/stage');
                  },
                ),
                ListTile(
                  title: const Text('Go to Read: 2'),
                  subtitle: const Text('Navigator.of(context).pushNamed(/read/2)'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/read/2');
                  },
                ),
                ListTile(
                  title: const Text('Go to Other'),
                  subtitle: const Text('Navigator.of(context).pushNamed(/other)'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/other');
                  },
                ),
                ListTile(
                  title: const Text('Go to a page thats not on current navigator, Non existent'),
                  subtitle:
                      const Text('Navigator.of(context, rootNavigator: true).pushNamed(/none)'),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed('/none');
                  },
                ),
                ListTile(
                  title: const Text('Go out of ButtomNavigation'),
                  subtitle:
                      const Text('Navigator.of(context, rootNavigator: true).pushNamed(/other)'),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed('/other');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
