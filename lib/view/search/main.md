# ?

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:lidea/view.dart';
import 'package:lidea/provider.dart';

import 'package:dictionary/widget.dart';
import 'package:dictionary/core.dart';
// import 'package:dictionary/model.dart';
import 'package:dictionary/icon.dart';

part 'suggestion.dart';
part 'view.dart';
part 'suggest.dart';
part 'result.dart';
part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final controller = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  final core = Core();

  @override
  void initState() {
    super.initState();
    // this.textController.text = core.collection.notify.searchQuery.value ;
    // this.textController.text = '';
    textController.addListener(() async {
      final word = textController.text.replaceAll(RegExp(' +'), ' ').trim();
      core.collection.notify.suggestQuery.value = word;
      core.collection.notify.suggestResult.value = await core.suggestionGenerateDelete(word);
    });
    // focusNode.addListener(() {
    //   if(focusNode.hasFocus) {
    //     textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
    //   }
    // });
  }

  @override
  dispose() {
    controller.dispose();
    focusNode.dispose();
    textController.dispose();
    core.collection.notify.suggestQuery.dispose();
    core.collection.notify.suggestResult.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }



  // NOTE: used in bar, suggest & result
  void search(String word) async {
    if (word.isNotEmpty && core.collection.hasNotHistory(word)){
      final index = core.collection.history.length;
      core.collection.history.add(word);
      if (core.listKeyHistory.currentState != null){
        core.listKeyHistory.currentState!.insertItem(index);
      }
    }
    this.focusNode.unfocus();
    // FocusScope.of(context).unfocus();
    // FormNotifier form = context.read<FormNotifier>();
    // context.read<FormNotifier>().searchQuery = word;
    // context.read<FormNotifier>().searchQuery = word;
    // Provider.of<FormNotifier>(context,listen: false).searchQuery = word;
    // FormNotifier form = Provider.of<FormNotifier>(context,listen: false);
    // if (form.keyword != word) {
    //   form.keyword = word;
    // }
    core.collection.notify.suggestQuery.value = word;

    // if (form.searchQuery != word && word.isNotEmpty) {
    //   form.searchQuery = word;
    //   core.analyticsSearch(word);
    // }
    core.collection.notify.searchQuery.value = word;
    // this.textController.text = word;
    core.collection.notify.searchResult.value = await core.definitionGenerateDelete(word);
    controller.animateTo(
      controller.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 100)
    );
  }
}

class CustomNavRoute<T> extends MaterialPageRoute<T> {
  CustomNavRoute({required Widget Function(BuildContext) builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
// Navigator.pushReplacement(context,CustomNavRoute(builder: (context) => IntroScreen()));
// Navigator.push(context, CustomNavRoute(builder: (context) => LoginSignup()));

// https://codepen.io/brenodt/pen/vYLxGwj
class SearchBar extends StatelessWidget {
  final bool isSearching;
  SearchBar({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimateExpansion(
            animate: !isSearching,
            axisAlignment: 1.0,
            child: Text('Dynamic  AppBar'),
          ),
          AnimateExpansion(
            animate: isSearching,
            axisAlignment: -1.0,
            child: Search(),
          ),
        ],
      ),
    );
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search for...',
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.white.withOpacity(.4),
        ),
      ),
    );
  }
}

class AnimateExpansion extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double axisAlignment;
  AnimateExpansion({
    this.animate = false,
    required this.axisAlignment,
    required this.child,
  });

  @override
  _AnimateExpansionState createState() => _AnimateExpansionState();
}

class _AnimateExpansionState extends State<AnimateExpansion> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  void _toggle() {
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _toggle();
  }

  @override
  void didUpdateWidget(AnimateExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        sizeFactor: _animation,
        child: widget.child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}