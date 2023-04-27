part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  late final Store store = App.core.store;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(store.isAvailable ? 'Restore purchase completed.' : 'Not available'),
        ),
      );
    });
  }
}
