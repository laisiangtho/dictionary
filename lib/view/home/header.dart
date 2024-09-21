part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    _searchController.animateTo(vhd.shrinkOffsetDouble(30));

    /// ??? ViewHeaderLayoutStack
    return ViewHeaderLayouts(
      data: vhd,
      left: [
        OptionButtons.back(
          label: lang.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, -.3),
          vhd.snapShrink,
        ),
        // label: 'Back Settings',
        label: preference.text('MyOrdbok'),
        data: vhd,
      ),
      right: const [
        UserProfileIcon(),
      ],
      secondary: Positioned(
        right: 0,
        left: 0,
        bottom: 20,
        height: vhd.shrinkWith(40),
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
                  hintText: lang.aWordOrTwo,
                  prefixIcon: const Icon(LideaIcon.find, size: 20),
                ),
                onTap: () {
                  context.push('/search', extra: {'focus': true, 'keyword': data.searchQuery});
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
