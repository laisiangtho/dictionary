part of 'main.dart';

class View extends _State with _Bar {

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return new ScrollPage(
      key: scaffoldKey,
      controller: controller,
      child: _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new SliverList(
          delegate: new SliverChildListDelegate(
            <Widget>[
              Text('abc')
            ],
          ),
        ),

        // new SliverToBoxAdapter(
        //   child: null
        // ),

        // new SliverPadding(
        //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        //   sliver: SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //       (context, index) => null,
        //       childCount: 20,
        //       // addAutomaticKeepAlives: true
        //     ),
        //   ),
        // ),

        // new SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) => ,
        //     childCount: 20,
        //   ),
        // )
      ]
    );
  }
}