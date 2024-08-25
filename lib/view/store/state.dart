part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController scrollController = ScrollController();

  late final Store store = app.store;
  @override
  void initState() {
    store.init();
    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void onRestore() {
    // await InAppPurchase.instance.restorePurchases().whenComplete(() =>setState);
    store.doRestore().whenComplete(() {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(store.isAvailable ? 'Restore purchase completed.' : 'Not available'),
        ),
      );
    });
  }
}
