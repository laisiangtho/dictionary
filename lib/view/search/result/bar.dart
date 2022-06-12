part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSuggest,
              child: _formField(),
            ),
          ),
          WidgetButton(
            padding: const EdgeInsets.only(left: 15),
            show: args!.hasParam,
            onPressed: param?.currentState!.maybePop,
            child: const WidgetLabel(icon: LideaIcon.home),
          ),
        ],
      ),
    );
  }

  Widget _formField() {
    return TextFormField(
      readOnly: true,
      enabled: false,
      maxLines: 1,
      controller: textController,
      decoration: InputDecoration(
        hintText: preference.text.aWordOrTwo,
        prefixIcon: const Icon(LideaIcon.find),
        fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
      ),
    );
  }
}
