import 'package:flutter/material.dart';
import 'package:lidea/icon.dart';

/// NOTE: Core, Components
import '/app.dart';

class MenuSidebar extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MenuSidebar({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          // right: 2,
          // top: viewPadding.top,
          // bottom: viewPadding.bottom,
          // left: viewPadding.left,
          ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5) ),
            // color: context.theme.scaffoldBackgroundColor,
            // color: context.theme.disabledColor,
            // color: context.theme.primaryColor,
            // color: context.theme.dividerColor.withOpacity(0.1),
            // boxShadow: [
            //   BoxShadow(
            //     color: context.theme.dividerColor,
            //     offset: const Offset(0, 0),
            //     blurRadius: 2,
            //     spreadRadius: 1,
            //   )
            // ],
            ),
        child: navigationColumn(context),
      ),
    );
  }

  Widget navigationRail(BuildContext context) {
    return NavigationRail(
      leading: const Text('lead'),
      trailing: const Text('trail'),
      // groupAlignment: 1.0,
      // extended: true,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(LideaIcon.flag),
          label: Text(context.lang.home),
          // tooltip: context.lang.home,
        ),
        NavigationRailDestination(
          icon: const Icon(LideaIcon.bookOpen),
          label: Text(context.lang.read),
          // tooltip: context.lang.read,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.loyalty),
          label: Text(context.lang.favorite('')),
          // tooltip: context.lang.favorite(''),
        ),
        NavigationRailDestination(
          icon: const Icon(LideaIcon.listNested),
          label: Text(context.lang.recentSearch('')),
          // tooltip: context.lang.recentSearch(''),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.shopping_bag),
          label: Text(context.lang.store),
          // tooltip: context.lang.store,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.bug_report_rounded),
          label: Text(context.lang.about),
          // tooltip: context.lang.store,
        ),
      ],
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (int index) {
        shell.goBranch(index, initialLocation: index == shell.currentIndex);
      },
    );
  }

  Widget navigationColumn(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const Text('h'),
        // const SizedBox(
        //   width: double.infinity,
        //   child: DecoratedBox(
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //     ),
        //     child: Text('h'),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(top: context.viewPaddingOf.top),
          child: SizedBox(
            child: ViewButtons(
              // padding: EdgeInsets.zero,
              // padding : const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
              // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              constraints: const BoxConstraints(minWidth: 50, maxHeight: kToolbarHeight),
              onPressed: App.core.menuToggle,
              child: const ViewMarks(
                // icon: Icons.segment_rounded,
                icon: Icons.chevron_left_rounded,
                // icon: LideaIcon.bible,
              ),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: ViewMenuSidebar(
              items: const [
                ViewMarks(
                  icon: LideaIcon.flag,
                ),
                ViewMarks(
                  icon: LideaIcon.bookOpen,
                ),
                ViewMarks(
                  icon: Icons.loyalty,
                ),
                ViewMarks(
                  icon: LideaIcon.listNested,
                ),
                ViewMarks(
                  icon: Icons.shopping_bag,
                ),
                ViewMarks(
                  icon: Icons.bug_report_rounded,
                ),
              ],
              currentIndex: shell.currentIndex,
              onTap: (int index) {
                shell.goBranch(index, initialLocation: index == shell.currentIndex);
              },
            ),
          ),
        ),
        // Flex(
        //   direction: Axis.horizontal,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text('${App.core.message.value} ???'),
        //   ],
        // ),
        // const Text('f'),
        Padding(
          padding: EdgeInsets.only(bottom: context.viewPaddingOf.bottom),
          child: const SizedBox(
            height: kBottomNavigationBarHeight,
            child: ViewMarks(
              child: Text('f'),
            ),
          ),
        ),
      ],
    );
  }
}
