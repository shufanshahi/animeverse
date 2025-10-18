import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/providers/bottom_nav_provider.dart';
import 'anime_wishlist/presentation/screens/anime_wishlist_screen.dart';
import 'home/presentation/screens/home_screen.dart';
import 'profile/presentation/screens/profile_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    // List of screens for IndexedStack
    final screens = const [
      HomeScreen(),
      AnimeWishlistScreen(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          ref.read(bottomNavProvider.notifier).setIndex(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Material(
          elevation: 8,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              currentIndex: currentIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: (index) =>
                  ref.read(bottomNavProvider.notifier).setIndex(index),
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house, size: 20),
                  activeIcon:
                  FaIcon(FontAwesomeIcons.solidHouse, size: 20),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.bookmark, size: 20),
                  activeIcon:
                  FaIcon(FontAwesomeIcons.solidBookmark, size: 20),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.user, size: 20),
                  activeIcon:
                  FaIcon(FontAwesomeIcons.solidUser, size: 20),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
