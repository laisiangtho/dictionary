part of 'main.dart';

class InspectProcess extends StatefulWidget {
  const InspectProcess({super.key});

  static String route = 'test-inspect';
  static String label = 'Inspect';
  static IconData icon = Icons.ac_unit;

  @override
  State<InspectProcess> createState() => _InspectProcessState();
}

abstract class _InspectProcessAbstract extends StateAbstract<InspectProcess> {}

class _InspectProcessState extends _InspectProcessAbstract {
  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return ViewFlats(
      child: SizedBox(
        height: 130.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('updateToken (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    // updateToken
                    App.data.updateToken().then((e) {
                      debugPrint('updateToken done');
                    }).catchError((e) {
                      debugPrint('updateToken $e');
                    });
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('File (test)'),
                  // subtitle: const Text('...'),
                  onTap: () async {
                    //  App.core.u
                    // final docs = Docs.user;
                    // docs.dir.then((e) {
                    //   final test = e != null;
                    //   debugPrint('file test: $test');
                    //   if (test) {
                    //     debugPrint('file test: ${e.path}/test.txt');
                    //     // docs.writeAsJSON('test.json', {"done": true});
                    //     docs.writeAsString('test.txt', 'Ok');
                    //   }
                    // });

                    // if (docs != null) {
                    //   final dir = docs.path;
                    //   // join(await directory.then((e) => e.path), name);
                    //   debugPrint('file: $dir');
                    //   debugPrint('file: ${docs.absolute.uri}');
                    //   // join(await directory.then((e) => e.path), name);
                    // }
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('Card (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.route.pushNamed('home/test-card');
                  },
                ),
              ),
            ),
            ViewCards(
              elevation: 0,
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('OfBook (test)'),
                  onTap: () {},
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('Sliver (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.route.pushNamed('home/test-sliver');
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('Search (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.route.pushNamed('home/test-search');
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('Section (test)'),
                  subtitle: const Text('preferred language'),
                  onTap: () {
                    App.route.pushNamed('home/leaf-section');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
