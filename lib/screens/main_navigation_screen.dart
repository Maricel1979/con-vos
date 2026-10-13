import 'package:flutter/material.dart';

import 'discover_users_screen.dart';
import 'profile_screen.dart'; // <-- Ahora está en la misma carpeta screens/
import '../widgets/live_feed_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Lista de pantallas conectadas a la barra de navegación inferior
  final List<Widget> _screens = [
    const DiscoverUsersScreen(),
    const LiveFeedScreen(),
    const ProfileScreen(), // <-- Pantalla de Perfil ordenada
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF8B5CF6),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Descubrir',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'En Vivo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mi Perfil'),
        ],
      ),
    );
  }
}
