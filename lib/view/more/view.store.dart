part of 'main.dart';

// const bool _kAutoConsume = true;

// const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'subscription_silver';
// const String _kGoldSubscriptionId = 'subscription_gold';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   _kUpgradeId,
//   _kSilverSubscriptionId,
//   _kGoldSubscriptionId,
// ];

class StoreView extends StatefulWidget {
  @override
  __StoreState createState() => __StoreState();
}

class __StoreState extends State<StoreView> {
  final core = Core();

  @override
  Widget build(BuildContext context) {

    List<Widget> _lst = [];

    return new SliverList(
      delegate: new SliverChildListDelegate(_lst)
    );

  }

  void consumer(BuildContext context, dynamic id) async {
    final bool? confirmation = await showDialog<bool>(
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
      core.store!.doConsume(id);
    }
  }
}
