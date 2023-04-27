part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    _searchController.animateTo(data.shrinkOffsetDouble(30));
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, -.3),
          data.snapShrink,
        ),
        // label: 'Back Settings',
        label: preference.language('MyOrdbok'),
        data: data,
      ),
      right: const [
        UserProfileIcon(),
      ],
      secondary: Positioned(
        right: 0,
        left: 0,
        bottom: 20,
        height: data.shrinkWith(40),
        child: Padding(
          // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FadeTransition(
            opacity: _searchController,
            child: SizeTransition(
              sizeFactor: _searchAnimation,
              child: TextFormField(
                // initialValue: searchQuery,
                readOnly: true,
                // enabled: false,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: App.preference.text.aWordOrTwo,
                  prefixIcon: const Icon(
                    LideaIcon.find,
                  ),
                ),
                onTap: () {
                  App.route.pushNamed(
                    'home/search',
                    arguments: {'focus': true, 'keyword': App.data.searchQuery},
                  );
                  // core.navigate(to: '/search');
                  // args?.currentState!.pushNamed('/search');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
