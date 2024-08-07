part of 'main.dart';

// abstract class _State extends State<Main> {
abstract class _State extends StateAbstract<Main> with TickerProviderStateMixin {
  late final ScrollController scrollController = ScrollController();

  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final textController = TextEditingController();
  late final _focusNode = FocusNode();

  bool get autoFocus {
    return state.hasArguments && args!['focus'] != null;
  }

  late final AnimationController _clearController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  ); //..repeat();
  late final Animation<double> _clearAnimation = CurvedAnimation(
    parent: _clearController,
    curve: Curves.fastOutSlowIn,
  );
  late final AnimationController _backController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );
  late final AnimationController _cancelController = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );
  // late final Animation<double> _focusAnimation = CurvedAnimation(
  //   parent: _focusController,
  //   curve: Curves.fastOutSlowIn,
  // );

  String get searchQuery => data.searchQuery;
  set searchQuery(String ord) {
    data.searchQuery = ord;
  }

  String get suggestQuery => data.suggestQuery;
  set suggestQuery(String ord) {
    data.suggestQuery = ord;
  }

  final ValueNotifier<bool> _suggestNotifier = ValueNotifier(false);
  final ValueNotifier<double> _recentNotifier = ValueNotifier(0.0);

  int get lengthOfSuggestQuery => suggestQuery.length;

  late final bool canPop = state.navigator.canPop();

  late final Future<void> _initiator = core.conclusionGenerate(init: true);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // _cancelController.forward();
        // if (canPop) {
        //   _backController.reverse();
        // }
        onSuggest(searchQuery);
        _layout(true);
      } else {
        // _cancelController.reverse();
        // if (canPop) {
        //   _backController.forward();
        // }
      }
      // _suggestNotifier.value = _focusNode.hasFocus;
    });

    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        _clearController.forward();
      } else {
        _clearController.reverse();
      }
    });

    scrollController.addListener(() {
      if (_focusNode.hasFocus) {
        Future.microtask(() {
          _focusNode.unfocus();
        });
      }
    });

    Future.microtask(() {
      if (canPop) {
        _backController.forward();
      }
    });

    // Future.delayed(const Duration(milliseconds: 400), () {
    //   debugPrint('didChangeDependencies autoFocus');
    //   // if (autoFocus) {
    //   //   _focusNode.requestFocus();
    //   // }
    //   if (hasArgs) {
    //     final String asdf = args!['keyword'];
    //     debugPrint('didChangeDependencies $asdf');
    //   }
    // });
    // if (hasArgs) {
    //   final String asdf = args!['keyword'];
    //   debugPrint('didChangeDependencies $asdf');
    // }
    Future.microtask(() {
      if (state.hasArguments && args!['keyword'] != null) {
        onQuery(args!['keyword'] as String);
      } else {
        onQuery(searchQuery);
      }
    }).whenComplete(() {
      if (_focusNode.canRequestFocus && autoFocus) {
        _focusNode.requestFocus();
      }
    });
    // Future.microtask(() {
    //   // if (hasArgs) {
    //   //   textController.text = args!['keyword'] as String;
    //   // }
    //   debugPrint('autoFocus ${_focusNode.canRequestFocus} $autoFocus $hasArgs');
    //   if (_focusNode.canRequestFocus && autoFocus) {
    //     _focusNode.requestFocus();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textController.dispose();
    _focusNode.dispose();
    scrollController.bottom.dispose();
  }

  void _layout(bool val) {
    _suggestNotifier.value = val;
    if (val) {
      _cancelController.forward();
      if (canPop) {
        _backController.reverse();
      }
    } else {
      _cancelController.reverse();
      if (canPop) {
        _backController.forward();
      }
    }
  }

  void onQuery(String str) {
    if (textController.text != str) {
      textController.text = str;
    }
    if (searchQuery != str) {
      searchQuery = str;
    }
  }

  void onClear() {
    textController.clear();
    suggestQuery = '';
    Future.microtask(() {
      App.core.suggestionGenerate();
    });
  }

  void onCancel() {
    _layout(false);
    _focusNode.unfocus();
    // _focusNode.addListener(() { })
    Future.delayed(Duration(milliseconds: _focusNode.hasPrimaryFocus ? 200 : 0), () {
      suggestQuery = searchQuery;
      textController.text = suggestQuery;
    });
  }

  void onSuggest(String str) {
    suggestQuery = str;
    // on recentHistory select
    // if (textController.text != str) {
    //   textController.text = str;
    //   if (_focusNode.hasFocus == false) {
    //     Future.delayed(const Duration(milliseconds: 400), () {
    //       _focusNode.requestFocus();
    //     });
    //   }
    // }
    Future.microtask(() {
      App.core.suggestionGenerate();
    });
  }

  // NOTE: used in bar, suggest & result
  void onSearch(String str) {
    _layout(false);
    _focusNode.unfocus();
    suggestQuery = str;
    searchQuery = suggestQuery;

    // Future.microtask(() {});
    // Navigator.of(context).pop(true);

    // Future.delayed(Duration(milliseconds: _focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    //   // _parent.navigator.currentState!.pop(true);
    //   // navigator.currentState!.pushReplacementNamed('/search-result', arguments: _arguments);
    //   // navigator.currentState!.popAndPushNamed('/search-result', arguments: _arguments);
    // });

    App.core.conclusionGenerate();

    // Future.delayed(Duration(milliseconds: focusNode.hasPrimaryFocus ? 200 : 0), () {
    //   Navigator.of(context).pop(true);
    // });

    // debugPrint('suggest onSearch $canPop');
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 800),
    );

    Future.microtask(() {
      if (textController.text != str) {
        textController.text = str;
      }
    });
  }

  /// when definition result is generated by other view like recent_search, favorite_word
  /// textController.value needed to update with corrent keyword
  void onResult() {
    Future.microtask(() {
      if (textController.text != searchQuery) {
        textController.text = searchQuery;
      }
    });
  }

  void onSwitchFavorite() {
    data.favoriteSwitch(core.searchQuery);
    core.state.notify();
  }

  bool onDeleteRecents(String str) => data.boxOfRecentSearch.delete(str);
}
