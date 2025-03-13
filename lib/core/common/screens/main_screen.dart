import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate_flutter/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:boilerplate_flutter/features/chat/presentation/pages/chat_page.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/camera_page.dart';
import 'package:boilerplate_flutter/features/post/presentation/pages/post_page.dart';
import 'package:boilerplate_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    const ChatPage(),
    const CameraPage(),
    const Scaffold(
      body: Center(child: Text('Profile')),
    ),
    const SettingsPage(),
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
            selectedIcon: Icon(Icons.camera),
            icon: Icon(Icons.camera_outlined),
            label: 'Camera',
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
