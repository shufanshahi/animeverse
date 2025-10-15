import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/bottom_nav_provider.dart';
import 'chatbot/presentation/screens/chatbot_screen.dart';
import 'home/presentation/screens/home_screen.dart';
import 'profile/presentation/screens/profile_screen.dart';
import 'shop/presentation/screens/shop_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

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
          children: const [
            HomeScreen(),
            ProfileScreen(),
            ShopScreen(),
            ChatbotScreen(),
          ],
        ),
        bottomNavigationBar: Material(
          elevation: 8,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            currentIndex: currentIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            onTap: (index) => ref.read(bottomNavProvider.notifier).setIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chatbot',
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
