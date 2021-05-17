import 'package:lidea/keep.dart';

// /// A store of consumable items.
// ///
// /// This is a development prototype tha stores consumables in the shared
// /// preferences. Do not use this in real world apps.
class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<String>> load() async {
    return (await KeepUser().preferences).getStringList(_kPrefKey) ?? [];
  }

  static Future<void> _doSave(String id) async {
    List<String> cached = await load();
    cached.add(id);
    await KeepUser().setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    List<String> cached = await load();
    cached.remove(id);
    await KeepUser().setStringList(_kPrefKey, cached);
  }
}

// const String _kConsumableId = 'consumable_testing';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'subscription_silver';
// const String _kGoldSubscriptionId = 'offlineaccess'
// final hasNotAdded = _purchases.firstWhere((e) => e.purchaseID == purchaseDetails.purchaseID, orElse: () =>null) == null;
// if (hasNotAdded){}
// Container(
//   child: ElevatedButton(
//     child: Text('Restore'),
//     onPressed: _restorePurchasesByUser
//   ),
// ),
// Future<void> _restorePurchasesByUser() async {
//   // print('_restorePurchasesByUser');
//   // await _inAppPurchase.restorePurchases();
//   print('total _purchases $_purchases');


//   // _purchases.addAll(purchaseDetailsList);
//   // setState(() {});
//   // final response = await _inAppPurchase.restorePurchases();

//   // for (PurchaseDetails purchase in response.pastPurchases) {
//   //   if (Platform.isIOS) {
//   //     _inAppPurchase.completePurchase(purchase);
//   //   }
//   // }

//   // setState(() {
//   //   _purchases = response.pastPurchases;
//   // });
// }