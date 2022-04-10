import 'package:flutter/material.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view/main.dart';
// import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/favorite-word';
  static const icon = Icons.loyalty;
  static const name = 'Favorite';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: Selector<Core, List<MapEntry<dynamic, FavoriteWordType>>>(
          selector: (_, e) => e.collection.favorites.toList(),
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext _, List<MapEntry<dynamic, FavoriteWordType>> o, Widget? __) {
    return CustomScrollView(
      controller: scrollController,
      slivers: sliverWidgets(o),
    );
  }

  List<Widget> sliverWidgets(List<MapEntry<dynamic, FavoriteWordType>> items) {
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      WidgetChildBuilder(
        show: items.isNotEmpty,
        duration: kThemeChangeDuration,
        child: WidgetBlockFill(
          child: WidgetListBuilder(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            duration: kThemeChangeDuration,
            itemBuilder: (BuildContext context, int index) {
              return listContainer(index, items.elementAt(index));
            },
            itemSnap: (BuildContext context, int index) {
              return const ListTile(
                leading: Icon(Icons.north_east_rounded),
              );
            },
            itemSeparator: (BuildContext context, int index) {
              return const WidgetListDivider();
            },
            itemCount: items.length,
          ),
        ),
        placeHolder: const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text('...'),
          ),
        ),
      ),
    ];
  }

  Widget listContainer(int index, MapEntry<dynamic, FavoriteWordType> item) {
    final word = item.value.word;
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) async {
      //   onDelete(index);
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
      // },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool? confirmation = await doConfirmWithDialog(
            context: context,
            // message: 'Do you want to delete "$word"?',
            message: preference.text.confirmToDelete('this'),
          );
          if (confirmation != null && confirmation) {
            onDelete(word);
            return true;
          } else {
            return false;
          }
        }
        return false;
      },
      background: _listDismissibleBackground(),
      child: ListTile(
        leading: const Icon(Icons.north_east_rounded),
        title: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: word,
        ),
        onTap: () => onSearch(word),
      ),
    );
  }

  Widget _listDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          preference.text.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
