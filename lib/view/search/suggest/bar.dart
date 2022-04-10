part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _formField(),
          ),
          WidgetButton(
            padding: const EdgeInsets.only(left: 15),
            child: WidgetMark(
              mainAxisAlignment: MainAxisAlignment.start,
              label: preference.text.cancel,
            ),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }

  Widget _formField() {
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(LideaIcon.find),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: clearAnimation,
              child: Semantics(
                enabled: true,
                label: preference.text.clear,
                child: WidgetButton(
                  onPressed: onClear,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
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
