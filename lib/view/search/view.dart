part of 'main.dart';

class View extends _State {
  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      key: scaffoldKey,
      controller: controller.master,
      child: _scroll()
    );
  }

  CustomScrollView _scroll() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        Bar(focusNode: focusNode, textController: textController),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          sliver: context.watch<NodeNotifier>().focus?suggestion:definition
        )
      ]
    );
  }

  Widget get suggestion {
    return ViewSuggestion(
      key: suggestionKey,
      searchQuery: context.watch<FormNotifier>().keyword
    );
  }

  Widget get definition {
    return ViewResult(
      key: resultKey,
      searchQuery: context.watch<FormNotifier>().searchQuery
    );
    // return Consumer<FormNotifier>(
    //   builder: (BuildContext context, FormNotifier form, Widget child) => ViewResult(
    //     key: UniqueKey(),
    //     searchQuery: form.searchQuery
    //   )
    // );
  }

}
