part of 'main.dart';

abstract class _State extends WidgetState<Main> {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final param = args?.param<ViewNavigationArguments>();
  late final Future<void> initiator = core.conclusionGenerate(init: true);

  @override
  void initState() {
    arguments ??= widget.arguments;
    super.initState();
    onQuery();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onUpdate(bool status) {
    if (status) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
      onQuery();
    }
  }

  void onQuery() async {
    Future.microtask(() {
      textController.text = core.searchQuery;
    });
  }

  void onSuggest() {
    args?.currentState!.pushNamed('/search-suggest', arguments: false).then((word) {
      onUpdate(word != null);
    });
  }

  void onSearch(String ord) async {
    searchQuery = ord;
    suggestQuery = ord;
    await core.conclusionGenerate();
    onQuery();
    onUpdate(searchQuery.isNotEmpty);
  }

  void onSwitchFavorite() {
    collection.favoriteSwitch(core.searchQuery);
    core.notify();
  }
}
