part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final innerBoxIsScrolled = constraints.scrollOffset > 0;
        return ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          reservedPadding: MediaQuery.of(context).padding.top,
          heights: const [kBottomNavigationBarHeight],
          overlapsBackgroundColor: Theme.of(context).primaryColor,
          overlapsBorderColor: Theme.of(context).shadowColor,
          // overlapsForce:focusNode.hasFocus,
          // overlapsForce:core.nodeFocus,
          overlapsForce: innerBoxIsScrolled,
          // borderRadius: Radius.elliptical(20, 5),
          builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: 'searchbar-field',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                      child: _barForm(),
                    ),
                  ),
                ),
                Hero(
                  tag: 'appbar-right',
                  child: CupertinoButton(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                    // padding: EdgeInsets.zero,
                    onPressed: onCancel,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        preference.text.cancel,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _barForm() {
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      // autofocus: true,
      // enabled: true,
      // enableInteractiveSelection: true,
      // enableSuggestions: true,
      maxLines: 1,
      strutStyle: const StrutStyle(height: 1.4),
      decoration: InputDecoration(
        prefixIcon: const Icon(LideaIcon.find, size: 19),
        /*
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: clearAnimation,
              // axis: Axis.horizontal,
              // axisAlignment: 1,
              child: Semantics(
                enabled: true,
                label: translate.clear,
                child: CupertinoButton(
                  onPressed: onClear,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                    size: 17,
                    semanticLabel: "input",
                  ),
                ),
              ),
            ),
            // SizeTransition(
            //   sizeFactor: clearAnimation,
            //   axis: Axis.horizontal,
            //   // axisAlignment: 1,
            //   child: Semantics(
            //     enabled: true,
            //     label: translate.clear,
            //     child: CupertinoButton(
            //       onPressed: onClear,
            //       padding: const EdgeInsets.all(0),
            //       child: Icon(
            //         CupertinoIcons.xmark_circle_fill,
            //         color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
            //         size: 17,
            //         semanticLabel: "input",
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        */
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: clearAnimation,
              // axis: Axis.horizontal,
              // axisAlignment: 1,
              child: Semantics(
                enabled: true,
                label: preference.text.clear,
                child: CupertinoButton(
                  onPressed: onClear,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    CupertinoIcons.xmark,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                    size: 17,
                    semanticLabel: "input",
                  ),
                ),
              ),
            ),
          ],
        ),
        // hintText: translate.aWordOrTwo,
        fillColor: Theme.of(context)
            .inputDecorationTheme
            .fillColor!
            .withOpacity(focusNode.hasFocus ? 0.6 : 0.4),
      ),
    );
  }
}
