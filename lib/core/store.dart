part of 'main.dart';

class Store extends ChangeNotifier {
  final EnvironmentType? env;
  final bool autoConsume = true;

  // final InAppPurchase instance = InAppPurchase.instance;
  // StreamSubscription<List<PurchaseDetails>> subscription;


  Store({this.env});

  String get offlineAccessId => this.env!.products.firstWhere((e) => e.name == "offline").cart;
  String get consumableId => this.env!.products.firstWhere((e) => e.name == "donate").cart;
  String get upgradeId => this.env!.products.firstWhere((e) => e.name == "upgrade").cart;
  String get silverSubscriptionId => this.env!.products.firstWhere((e) => e.name == "silver").cart;
  String get goldSubscriptionId => this.env!.products.firstWhere((e) => e.name == "gold").cart;
  List<String> get listOfProductId => this.env!.products.map((e) => e.cart).toList();

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

  Future<void> init() async {
    await openBox();
    // this.db.add(StoreType(name: "zero",type: this.consumableId));
    // this.db.add(StoreType(name: "one",type: this.consumableId));
    // this.db.add(StoreType(name: "Gold",type: this.goldSubscriptionId));


    await initStoreInfo();
  }

  Future<void> openBox() async  => Hive.openBox<StoreType>('store');
  Box<StoreType> get db => Hive.box<StoreType>('store');

  List<MapEntry<dynamic, StoreType>> get listOfConsumable => this.db.toMap().entries.where((e) => e.value.type == this.consumableId).toList();

  Future<void> doConsume(dynamic index) async => this.db.delete(index);

  Future<void>? initStoreInfo(){
    return null;
  }

}
