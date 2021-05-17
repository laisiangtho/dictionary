part of 'main.dart';

class View extends _State with _Bar {

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return ViewPage(
      key: scaffoldKey,
      // controller: controller,
      child: _body()
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new StoreView(),
        new SliverToBoxAdapter(
          child: buildMode()
        )
      ]
    );
  }

  Widget buildMode() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      elevation: 2,
      margin: EdgeInsets.all(12.0),
      // child: Text('abc'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Semantics(
                label: "Switch theme mode",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb,size:20),
                    Text('Switch theme',
                      style: TextStyle(
                        fontSize: 18
                      )
                    )
                  ],
                ),
              )
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ThemeMode.values.map<Widget>((e){
                  bool active = IdeaTheme.of(context).themeMode == e;
                  // IdeaTheme.update(context,IdeaTheme.of(context).copyWith(themeMode: ThemeMode.system));
                  return Semantics(
                    label: "Switch to",
                    selected: active,
                    child: CupertinoButton(
                      borderRadius: new BorderRadius.circular(30.0),
                      padding: EdgeInsets.symmetric(vertical:5, horizontal:10),
                      minSize: 20,
                      // color: Theme.of(context).primaryColorDark,
                      child: Text(
                        themeName[e.index],
                        semanticsLabel: themeName[e.index],
                      ),
                      onPressed: active?null:()=>IdeaTheme.update(context,IdeaTheme.of(context).copyWith(themeMode: e))
                    ),
                  );
                }).toList()
              )
            )
          ]
        ),
      )
    );
  }
}
