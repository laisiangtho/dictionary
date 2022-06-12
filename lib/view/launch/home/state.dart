part of 'main.dart';

abstract class _State extends WidgetState with TickerProviderStateMixin {
  late final args = argumentsAs<ViewNavigationArguments>();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _scrollController.addListener(() {
      //   print('scrolling');
      // });
      // _scrollController.position.isScrollingNotifier.dispose();

      scrollController.position.isScrollingNotifier.addListener(() {
        if (!scrollController.position.isScrollingNotifier.value) {
          // if (_animationController.isDismissed && snap.shrink == 1.0) {
          //   _animationController.forward();
          // } else if (_animationController.isCompleted && snap.shrink < 1.0) {
          //   _animationController.reverse(from: snap.shrink);
          // }
          final userScrollIndex = scrollController.position.userScrollDirection.index;
          // final userScrollName = _scrollController.position.userScrollDirection.name;
          if (userScrollIndex == 1 && _animationController.value < 1.0) {
            _animationController.forward(from: _animationController.value);
          } else if (userScrollIndex == 2 && _animationController.value > 0.0) {
            _animationController.reverse(from: _animationController.value);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSearch(String ord) {
    suggestQuery = ord;
    searchQuery = suggestQuery;

    Future.microtask(() {
      core.conclusionGenerate();
    });
    core.navigate(to: '/search-result');
  }
}
