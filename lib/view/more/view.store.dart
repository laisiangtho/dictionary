part of 'main.dart';

class StoreView extends StatefulWidget {
  @override
  __StoreState createState() => __StoreState();
}

class __StoreState extends State<StoreView> {
  final core = Core();

  @override
  Widget build(BuildContext context) {

    List<Widget> _lst = [];

    // final iserror = context.watch<Store>().msgPurchaseError;
    final iserror = core.store.msgPurchaseError;

    if (iserror == null) {
      _lst.add(
        Column(
          children: [
            _buildProductList(),
            _buildDescription(),
            _buildLifeSubscription()
          ],
        ),
      );
    } else {
      _lst.add(
        Center(
          child: Text(core.store.msgPurchaseError),
        )
      );
    }

    // final ispending = context.watch<Store>().isPurchasePending;
    final ispending = core.store.isPurchasePending;
    if (ispending) {
      print('ispending');
      _lst.add(
        CircularProgressIndicator()
      );
    }

    return new SliverList(
      delegate: new SliverChildListDelegate(_lst)
    );
  }

  Widget _buildDescription() {
    Widget msgWidget = Text('Getting products...');
    Widget msgIcon = CircularProgressIndicator();
    if (core.store.isLoading) {
      // NOTE: Connecting to store...
    } else if (core.store.isPurchaseAvailable) {
      // NOTE: Purchase is ready, Purchase is available
      msgWidget = Text('Ready to contribute!');
      msgIcon = Icon(CupertinoIcons.checkmark_shield,size: 50);
    } else {
      // NOTE: Connected to store, but purchase is not ready yet
      msgWidget = Text('Purchase unavailable');
      msgIcon = Icon(Icons.error_outlined,size: 50);
    }
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: msgIcon
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: msgWidget
          ),
          stars(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Text('Any contribution makes a huge difference for the future of MyOrdbok.',textAlign: TextAlign.center,)
          )
        ]
      ),
    );
    // return Card(
    //   child: ListTile(
    //     contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
    //     leading: msgIcon,
    //     title: msgWidget,
    //     // stars
    //     subtitle: Column(
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.symmetric(vertical: 4),
    //           child: Text('Any contribution makes a huge difference for the future of MyOrdbok.')
    //         ),
    //         stars()
    //       ]
    //     )
    //   )
    // );

  }

  Widget _buildProductList() {
    List<Widget> productList = <Widget>[];
    // This app needs special configuration to run. Please see example/README.md for instructions.
    // if (core.store.listOfNotFoundId.isNotEmpty) {
    //   productList.add(
    //     Padding(
    //       padding: EdgeInsets.symmetric( vertical: 10),
    //       // child: Text('[${core.store.listOfNotFoundId.join(", ")}] not found',
    //       //   style: TextStyle(color: ThemeData.light().errorColor)
    //       // )
    //       child: RichText(
    //         text: TextSpan(
    //           text: 'Unavailable ',
    //           style: TextStyle(color: Theme.of(context).primaryColor),
    //           children: core.store.listOfNotFoundId.map((String e) => TextSpan(
    //             style: TextStyle(color: Theme.of(context).errorColor),
    //             text: "$e, "
    //             )
    //           ).toList()
    //         )
    //       )
    //     )
    //   );
    // }

    Map<String, PurchaseDetails> purchases = core.store.previousPurchase;

    productList.addAll(core.store.listOfProductDetail.map(
      (ProductDetails productDetails) {
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        final bool hasPreviousPurchase = previousPurchase != null;
        print(previousPurchase?.productID);
        return _buildCart(productDetails,hasPreviousPurchase, );
      },
    ));

    // return Card(
    //   child: Column(
    //     children: productList
    //   )
    // );
    return Column(
      children: productList
    );
  }

  Widget _buildCart(ProductDetails productDetails, bool hasPurchased) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical:5, horizontal:7),
      child: Semantics(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          leading: hasPurchased?Icon(
            CupertinoIcons.checkmark_shield_fill,
            size: 35
          ):null,
          title: Text(
            productDetails.title,//.replaceAll(RegExp(r'\(.+?\)$'), ""),
            semanticsLabel: productDetails.title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.primaryVariant,
              fontSize: 18
            )
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top:10),
            child: Text(
              productDetails.description,
              semanticsLabel: productDetails.description,
              // textScaleFactor:0.9,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontWeight: FontWeight.w300
              )
            ),
          ),
          trailing: hasPurchased?Text(
            productDetails.price,
            semanticsLabel: productDetails.price,
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w200,
              // color: Theme.of(context).backgroundColor,
              fontSize: 13
            ),
          ):TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size(90, 30),
              padding: EdgeInsets.symmetric(vertical:3, horizontal:7),
              backgroundColor: hasPurchased?null:Theme.of(context).primaryColorDark,
              // backgroundColor: hasPurchased?null:Colors.red,
              // primary: Theme.of(context).primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
              )
            ),
            // icon: Icon(
            //   hasPurchased?Icons.verified:CupertinoIcons.cart_fill,
            //   size: hasPurchased?40:20,
            // ),
            child: Text(
              productDetails.price,
              semanticsLabel: productDetails.price,
              style: TextStyle(
                color: Theme.of(context).primaryColorLight
              )
            ),
            onPressed: hasPurchased?null:() => core.store.doPurchase(productDetails)
          )
        ),
      ),
    );
  }

  // Widget _buildConsumable() {
  //   // final isloading = context.watch<Store>().isLoading;
  //   return Consumer<Store>(
  //     builder: (_, a, child) => child,
  //     child: Card(
  //       child: Wrap(
  //         children: core.store.listOfConsumable.map((MapEntry<dynamic, StoreType> e) {
  //           return ListTile(
  //             title: Text(e.value.name),
  //             subtitle: Text(e.value.type),
  //             onTap: ()=>consumer(e.key)
  //           );
  //         }).toList()
  //       )
  //     ),
  //   );
  // }

  Widget stars() {
    return ValueListenableBuilder(
      valueListenable: core.store.db.listenable(),
      builder: (context, Box<StoreType> box, _) {
        return Wrap(
          children: box.toMap().entries.where((e) => e.value.type == core.store.consumableId).map(
            (MapEntry<dynamic, StoreType> e) {
              return IconButton(
                icon: Icon(Icons.star),
                iconSize: 35,
                color: Theme.of(context).primaryColorDark,
                // icon: Text(e.value.name),
                // subtitle: Text(e.value.type +': press to consume it'),
                onPressed: () => consumer(context, e.key)
              );
            }
          ).toList()
        );
      }
    );
  }

  Widget _buildLifeSubscription() {
    return ValueListenableBuilder(
      valueListenable: core.store.db.listenable(),
      builder: (context, Box<StoreType> box, _) {
        return Card(
          child: Wrap(
            children: box.toMap().entries.where((e) => e.value.type != core.store.consumableId).map(
              (MapEntry<dynamic, StoreType> e) {
                return ListTile(
                  title: Text(e.value.name),
                  subtitle: Text(e.value.type +': press to consume it'),
                  onTap: () async => consumer(context, e.key)
                );
              }
            ).toList()
          ),
        );
      }
    );
  }

  void consumer(BuildContext context, dynamic id) async {
    final bool confirmation = await showDialog<bool>(
      context: context,
      barrierLabel: "Are you sure to remove?",
      builder: (context) => AlertDialog(
        title: Text('Are you sure',
          textAlign: TextAlign.center
        ),
        content: Text('Do you want to remove?',
          textAlign: TextAlign.center
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text('Yes'),
            onPressed: ()=>Navigator.of(context, rootNavigator: true).pop(true)
          ),
          CupertinoButton(
            child: Text('No'),
            onPressed: ()=>Navigator.of(context, rootNavigator: true).pop(false)
          )
        ]
      )
    );
    if (confirmation != null && confirmation){
      core.store.doConsume(id);
    }
  }
}
