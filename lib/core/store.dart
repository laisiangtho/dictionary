part of 'core.dart';

class Store extends ChangeNotifier {
  final EnvironmentType env;
  final bool autoConsume = true;

  final InAppPurchaseConnection instance = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> subscription;

  Store({this.env});

  String get offlineAccessId => this.env.products.firstWhere((e) => e.name == "offline").cart;
  String get consumableId => this.env.products.firstWhere((e) => e.name == "donate").cart;
  String get upgradeId => this.env.products.firstWhere((e) => e.name == "upgrade").cart;
  String get silverSubscriptionId => this.env.products.firstWhere((e) => e.name == "silver").cart;
  String get goldSubscriptionId => this.env.products.firstWhere((e) => e.name == "gold").cart;
  List<String> get listOfProductId => this.env.products.map((e) => e.cart).toList();

  // List<String> listOfNotFoundId = [];
  // List<ProductDetails> listOfProductDetail = [];
  // List<PurchaseDetails> listOfPurchaseDetail = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool e) {
    if (_isLoading != e){
      _isLoading = e;
      notifyListeners();
    }
  }

  bool _isPurchasePending = false;
  bool get isPurchasePending => _isPurchasePending;
  set isPurchasePending(bool e) {
    if (_isPurchasePending != e){
      _isPurchasePending = e;
      notifyListeners();
    }
  }

  bool _isPurchaseAvailable = false;
  bool get isPurchaseAvailable => _isPurchaseAvailable;
  set isPurchaseAvailable(bool e) {
    if (_isPurchaseAvailable != e){
      _isPurchaseAvailable = e;
      notifyListeners();
    }
  }

  String _msgPurchaseError;
  String get msgPurchaseError => _msgPurchaseError;
  set msgPurchaseError(String e) {
    if (_msgPurchaseError != e){
      _msgPurchaseError = e;
      notifyListeners();
    }
  }

  List<String> _ofNotFoundId = [];
  List<String> get listOfNotFoundId => _ofNotFoundId;
  set listOfNotFoundId(List<String> e) {
    if (e != null){
      _ofNotFoundId = e;
      notifyListeners();
    }
  }

  List<ProductDetails> _ofProductDetail = [];
  List<ProductDetails> get listOfProductDetail => _ofProductDetail;
  set listOfProductDetail(List<ProductDetails> e) {
    if (e != null){
      _ofProductDetail = e;
      notifyListeners();
    }
  }

  List<PurchaseDetails> _ofPurchaseDetail = [];
  List<PurchaseDetails> get listOfPurchaseDetail => _ofPurchaseDetail;
  set listOfPurchaseDetail(List<PurchaseDetails> e) {
    if (e != null){
      _ofPurchaseDetail = e;
      notifyListeners();
    }
  }

  Future<void> init() async {
    await openBox();
    // this.db.add(StoreType(name: "zero",type: this.consumableId));
    // this.db.add(StoreType(name: "one",type: this.consumableId));
    // this.db.add(StoreType(name: "Gold",type: this.goldSubscriptionId));

    // final Stream<List<PurchaseDetails>> purchaseUpdated = this.instance.purchaseUpdatedStream;
    subscription = this.instance.purchaseUpdatedStream.listen(
      this.purchaseOnUpdate,
      onDone:this.purchaseOnDone,
      onError: this.purchaseOnError,
      cancelOnError: true
    );

    await initStoreInfo();
  }

  Future<void> openBox() async {
    await Hive.openBox<StoreType>('store');
  }

  Box<StoreType> get db => Hive.box<StoreType>('store');

  /// ...map((MapEntry<int, StoreType> e) => Text(e.value+' '+e.key));
  List<MapEntry<dynamic, StoreType>> get listOfConsumable => this.db.toMap().entries.where((e) => e.value.type == this.consumableId).toList();

  bool isConsume(PurchaseDetails purchaseDetails) => purchaseDetails.productID == consumableId;

  Future<void> doConsume(dynamic index) async => this.db.delete(index);

  Future<void> initStoreInfo() async {
    final bool isAvailable = await this.instance.isAvailable();
    if (!isAvailable) {
      isPurchaseAvailable = isAvailable;
      // listOfProductDetail = [];
      // listOfPurchaseDetail = [];
      // listOfNotFoundId = [];
      // isPurchasePending = false;
      isLoading = false;
      // setState(() {});
      return;
    }

    ProductDetailsResponse productDetailResponse = await this.instance.queryProductDetails(listOfProductId?.toSet());
    if (productDetailResponse.error != null) {
      msgPurchaseError = productDetailResponse.error.message;
      isPurchaseAvailable = isAvailable;
      listOfProductDetail = productDetailResponse.productDetails;
      // listOfPurchaseDetail = [];
      listOfNotFoundId = productDetailResponse.notFoundIDs;
      // isPurchasePending = false;
      isLoading = false;
      // setState(() {});
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      msgPurchaseError = null;
      isPurchaseAvailable = isAvailable;
      listOfProductDetail = productDetailResponse.productDetails;
      // listOfPurchaseDetail = [];
      listOfNotFoundId = productDetailResponse.notFoundIDs;
      // isPurchasePending = false;
      isLoading = false;
      // setState(() {});
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse = await this.instance.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await purchaseVerification(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }

    isPurchaseAvailable = isAvailable;
    listOfProductDetail = productDetailResponse.productDetails;
    listOfPurchaseDetail = verifiedPurchases;
    listOfNotFoundId = productDetailResponse.notFoundIDs;
    // isPurchasePending = false;
    isLoading = false;
    // setState(() { });
  }

  void purchaseOnUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        handlePending();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await purchaseVerification(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!autoConsume && this.isConsume(purchaseDetails)) {
            await this.instance.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await this.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void purchaseOnDone() {
    this.subscription.cancel();
  }

  void purchaseOnError(dynamic error) {
  }

  void handlePending() {
    isPurchasePending = true;
    // setState(() {});
  }

  void handleError(IAPError error) {
    isPurchasePending = false;
    // setState(() {});
  }

  Future<bool> purchaseVerification(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    // if (this.isConsume(purchaseDetails)) {
    //   return Future<bool>.value(false);
    // }
    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    this.db.add(StoreType(type: purchaseDetails.productID, name: purchaseDetails.purchaseID));
    if (purchaseDetails.productID != consumableId) {
      listOfPurchaseDetail.add(purchaseDetails);
    }
    isPurchasePending = false;
  }

  /// handle invalid purchase here if purchaseVerification` failed.
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
  }

  // This is just to demonstrate a subscription upgrade or downgrade.
  // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
  // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
  // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
  // Please remember to replace the logic of finding the old subscription Id as per your app.
  // The old subscription is only required on Android since Apple handles this internally
  // by using the subscription group feature in iTunesConnect.
  PurchaseDetails getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    PurchaseDetails oldSubscription;
    if (productDetails.id == silverSubscriptionId && purchases[goldSubscriptionId] != null) {
      oldSubscription = purchases[goldSubscriptionId];
    } else if (productDetails.id == goldSubscriptionId && purchases[silverSubscriptionId] != null) {
      oldSubscription = purchases[silverSubscriptionId];
    }
    return oldSubscription;
  }

  /// NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
  /// verify the latest status of you your subscription by using server side receipt validation
  /// and update the UI accordingly. The subscription purchase status shown
  /// inside the app may not be accurate.
  void doPurchase(ProductDetails productDetails) {
    final oldSubscription = this.getOldSubscription(productDetails, this.previousPurchase);
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
        changeSubscriptionParam: Platform.isAndroid &&
                oldSubscription != null
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: oldSubscription,
                prorationMode:
                    ProrationMode.immediateWithTimeProration)
            : null);
    if (productDetails.id == this.consumableId) {
      this.instance.buyConsumable(purchaseParam: purchaseParam, autoConsume: this.autoConsume || Platform.isIOS);
    } else {
      this.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  // This loading previous purchases code is just a demo. Please do not use this as it is.
  // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
  // We recommend that you use your own server to verify the purchase data.
  Map<String, PurchaseDetails> get previousPurchase {
    return Map.fromEntries(this.listOfPurchaseDetail.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        this.instance.completePurchase(purchase);
        // InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
  }

}
