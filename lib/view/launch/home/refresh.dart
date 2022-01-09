part of 'main.dart';

mixin _Refresh on _State {
  Widget refresh() {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 100,
      refreshIndicatorExtent: 70,
      builder: (
        BuildContext _,
        RefreshIndicatorMode mode,
        pulledExtent,
        triggerPullDistance,
        indicatorExtent,
      ) {
        // debugPrint('indicatorExtent $indicatorExtent pulledExtent $pulledExtent triggerPullDistance $triggerPullDistance');
        final double percentage = (pulledExtent / triggerPullDistance).clamp(0.0, 1.0);
        final size = (40 * percentage).clamp(10, 35).toDouble();
        return Center(
          child: SizedBox(
            height: size,
            width: size,
            child: _refreshIndicator(mode, percentage),
          ),
        );
      },
      onRefresh: _refreshTrigger,
    );
  }

  Future<void> _refreshTrigger() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // debugPrint('alive update is disabled');
    debugPrint('refresh: ??');
  }

  Widget _refreshIndicator(RefreshIndicatorMode mode, double percentageComplete) {
    // debugPrint('radius $radius');
    switch (mode) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. Note that the opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        // const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        // return Opacity(
        //   // opacity: opacityCurve.transform(percentageComplete),
        //   opacity: percentageComplete.clamp(0.3, 1.0),
        //   // child: CupertinoActivityIndicator.partiallyRevealed(radius: radius, progress: percentageComplete),
        //   child: _refreshAnimation(percentageComplete,1.0)
        // );
        return _refreshWidget(percentageComplete);
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        // return CupertinoActivityIndicator(radius: radius);
        return _refreshWidget(null);
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        // return CupertinoActivityIndicator(radius: radius * percentageComplete);
        return _refreshWidget(null);
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        return Container();
    }
  }

  Widget _refreshWidget(double? percentage) {
    return CircularProgressIndicator(
      semanticsLabel: 'percentage',
      semanticsValue: percentage.toString(),
      strokeWidth: 2.0,
      // strokeWidth: percentage ==null?2.0:percentage,
      value: percentage,
      // valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }
}
