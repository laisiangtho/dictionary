part of 'main.dart';

class Store extends UnitStore {
  late Collection collection;

  Store({required void Function() notify, required this.collection}) : super(notify: notify);

  @override
  Future<void> init() async {
    kProducts = collection.env.products;
    super.init();
  }

  Iterable<PurchaseType> get data => collection.boxOfPurchase.values;

  @override
  MapEntry<dynamic, PurchaseType> purchaseDataExist(String? purchaseId) {
    return collection.boxOfPurchase.toMap().entries.firstWhere(
          (e) => e.value.purchaseId == purchaseId,
          orElse: () => MapEntry(null, PurchaseType()),
        );
  }

  @override
  bool purchaseDataDelete(String purchaseId) {
    final notEmpty = super.purchaseDataDelete(purchaseId);
    if (notEmpty) {
      final purchase = purchaseDataExist(purchaseId);
      if (purchase.key != null) {
        collection.boxOfPurchase.delete(purchase.key);
        return true;
      }
    }
    return false;
  }

  @override
  Future<int> purchaseDataClear() {
    return collection.boxOfPurchase.clear();
  }

  @override
  void purchaseDataInsert(PurchaseType value) {
    collection.boxOfPurchase.add(value);
  }

  @override
  bool purchasedCheck(String productId) {
    return !isConsumable(productId) && data.where((o) => o.productId == productId).isNotEmpty;
  }

  /// is item upgradeable?
  // bool isUpgradeable(String productId) {
  //   if (super.purchasedCheck(productId)) {
  //     return data.where((o) => o.productId == productId).isNotEmpty;
  //     // return data.where((o) => o.productId == productId).isEmpty;
  //   }
  //   return false;
  // }

}
