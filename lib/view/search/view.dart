part of 'main.dart';

class View extends _State {
  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      key: scaffoldKey,
      controller: controller,
      child: _scroll()
    );
  }

  CustomScrollView _scroll() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        Bar(focusNode: focusNode, textController: textController, search: this.search),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          sliver: context.watch<NodeNotifier>().focus?suggestionWidget:definitionWidget
        )
      ]
    );
  }

  // core.collection.notify.suggestQuery.value
  Widget get suggestionWidget => ViewSuggestion(query: '',search: this.search);
  Widget get definitionWidget => ViewResult(query: '',search: this.search);

}
