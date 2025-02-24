import 'package:boilerplate_flutter/features/post/presentation/pages/post_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  final List<Widget> _pages = [
    const PostPage(),
    const Center(child: Text('Chat')),
    const Center(child: Text('Profile')),
    const Center(child: Text('Settings'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_page],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _page,
        onDestinationSelected: (int index) => setState(
          () => _page = index,
        ),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat),
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
