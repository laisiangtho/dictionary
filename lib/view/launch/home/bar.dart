part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    _animationController.animateTo(org.shrinkOffsetDouble(20));
    return ViewHeaderLayoutStack(
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, -.3),
          org.snapShrink,
        ),
        label: collection.env.name,
        shrink: org.shrink,
      ),
      rightAction: [
        WidgetButton(
          child: WidgetMark(
            child: Selector<Authentication, bool>(
              selector: (_, e) => e.hasUser,
              builder: userPhoto,
            ),
          ),
          message: preference.text.option(true),
          onPressed: () => core.navigate(to: '/user'),
        ),
      ],
      secondary: Positioned(
        right: 0,
        left: 0,
        bottom: 10,
        height: 40 * org.snapShrink,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: GestureDetector(
            child: Material(
              type: MaterialType.transparency,
              child: MediaQuery(
                data: MediaQuery.of(context),
                child: FadeTransition(
                  opacity: _animation,
                  child: SizeTransition(
                    sizeFactor: _animation,
                    child: TextFormField(
                      // initialValue: searchQuery,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: preference.text.aWordOrTwo,
                        prefixIcon: const Icon(
                          LideaIcon.find,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              core.navigate(to: '/search');
              // args?.currentState!.pushNamed('/search');
            },
          ),
        ),
      ),
    );
  }

  Widget userPhoto(BuildContext _, bool hasUser, Widget? child) {
    final user = authenticate.user;
    if (user != null) {
      if (user.photoURL != null) {
        return CircleAvatar(
          radius: 15,
          child: ClipOval(
            child: Material(
              // child: Image.network(
              //   user.photoURL!,
              //   fit: BoxFit.cover,
              // ),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.face_retouching_natural_rounded,
                      size: 25,
                    ),
                  );
                },
                imageUrl: user.photoURL!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
      return ClipOval(
        child: Material(
          elevation: 10,
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: .5,
            ),
          ),
          shadowColor: Theme.of(context).primaryColor,
          child: const Padding(
            padding: EdgeInsets.all(3),
            child: Icon(
              Icons.face_retouching_natural_rounded,
              // size: 25,
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Material(
        elevation: 30,
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).backgroundColor,
            width: .7,
          ),
        ),
        shadowColor: Theme.of(context).primaryColor,
        child: const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.face,
            size: 25,
          ),
        ),
      ),
    );
  }
}
