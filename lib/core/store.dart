part of 'main.dart';

class Store extends UnitStore {
  Store({required super.data});

  @override
  Future<void> init() async {
    kProducts = data.env.products;
    super.init();
  }

  Iterable<PurchasesType> get list => data.boxOfPurchases.values;

  @override
  MapEntry<dynamic, PurchasesType> purchaseDataExist(String? purchaseId) {
    return data.boxOfPurchases.entries.firstWhere(
      (e) => e.value.purchaseId == purchaseId,
      orElse: () => MapEntry(null, PurchasesType()),
    );
  }

  @override
  bool purchaseDataDelete(String purchaseId) {
    final notEmpty = super.purchaseDataDelete(purchaseId);
    if (notEmpty) {
      final purchase = purchaseDataExist(purchaseId);
      if (purchase.key != null) {
        data.boxOfPurchases.box.delete(purchase.key);
        return true;
      }
    }
    return false;
  }

  @override
  Future<int> purchaseDataClear() {
    return data.boxOfPurchases.box.clear();
  }

  @override
  void purchaseDataInsert(PurchasesType value) {
    data.boxOfPurchases.box.add(value);
  }

  @override
  bool purchasedCheck(String productId) {
    return !isConsumable(productId) && list.where((o) => o.productId == productId).isNotEmpty;
  }

  /// is item upgradeable?
  // bool isUpgradeable(String productId) {
  //   if (super.purchasedCheck(productId)) {
  //     return list.where((o) => o.productId == productId).isNotEmpty;
  //     // return list.where((o) => o.productId == productId).isEmpty;
  //   }
  //   return false;
  // }
}
