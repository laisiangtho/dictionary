part of 'main.dart';

abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  late final AnimationController _searchController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _searchAnimation = CurvedAnimation(
    parent: _searchController,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();

    // _searchController.forward();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _scrollController.addListener(() {
      //   print('scrolling');
      // });
      // _scrollController.position.isScrollingNotifier.dispose();

      _controller.position.isScrollingNotifier.addListener(() {
        if (!_controller.position.isScrollingNotifier.value) {
          // if (_searchController.isDismissed && snap.shrink == 1.0) {
          //   _searchController.forward();
          // } else if (_searchController.isCompleted && snap.shrink < 1.0) {
          //   _searchController.reverse(from: snap.shrink);
          // }
          final userScrollIndex = _controller.position.userScrollDirection.index;
          // final userScrollName = _scrollController.position.userScrollDirection.name;
          if (userScrollIndex == 1 && _searchController.value < 1.0) {
            _searchController.forward(from: _searchController.value);
          } else if (userScrollIndex == 2 && _searchController.value > 0.0) {
            _searchController.reverse(from: _searchController.value);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
