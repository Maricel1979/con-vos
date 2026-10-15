import 'package:flutter/material.dart';
import 'package:convos/screens/discover_users_screen.dart';
import 'package:convos/widgets/live_room_screen.dart';
import 'package:convos/screens/profile_screen.dart';
import 'package:convos/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Lista de pantallas conectadas al menú inferior
  final List<Widget> _screens = [
    const DiscoverUsersScreen(), // Index 0: Descubrir
    const LiveRoomScreen(roomId: 'room_101'), // Index 1: Sala en Vivo
    const ProfileScreen(), // Index 2: Mi Perfil
    const SettingsScreen(), // Index 3: Billetera y Ajustes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF8B5CF6),
        unselectedItemColor: Colors.white54,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'En Vivo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Billetera',
          ),
        ],
      ),
    );
  }
}
