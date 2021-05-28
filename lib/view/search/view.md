# ?

```dart
part of 'main.dart';

class View extends _State {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: scaffoldKey,
      // controller: controller,
      child: _scroll()
    );
  }

  CustomScrollView _scroll() {
    print('search scroll');
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        Bar(focusNode: focusNode, textController: textController, search: this.search),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          // sliver: context.watch<NodeNotifier>().focus?suggestionWidget:definitionWidget
          sliver: Selector<Core, bool>(
            selector: (_, e) => e.nodeFocus,
            builder: (BuildContext _, bool focus, Widget? child) => focus?suggestionWidget:definitionWidget
          )
        )
      ]
    );
  }

  // core.collection.notify.suggestQuery.value
  Widget get suggestionWidget => ViewSuggestion(query: '',search: this.search);
  Widget get definitionWidget => ViewResult(query: '',search: this.search);

}
