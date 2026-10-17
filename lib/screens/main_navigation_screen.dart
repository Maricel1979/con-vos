import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'terms_conditions_screen.dart';
import 'discover_users_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../widgets/live_room_screen.dart'; // O la ruta correcta donde esté live_room

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarTerminos();
    });
  }

  Future<void> _verificarTerminos() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    // Consultamos si el usuario ya aceptó los términos
    final response = await Supabase.instance.client
        .from('profiles')
        .select('terms_accepted')
        .eq('id', userId)
        .maybeSingle();

    final bool acepto = response?['terms_accepted'] ?? false;

    // Si no aceptó, le mostramos la pantalla de Términos exigiendo aceptación
    if (!acepto && mounted) {
      final resultado = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TermsConditionsScreen(requireAcceptance: true),
        ),
      );

      // Cuando toca "Continuar", guardamos la confirmación en Supabase
      if (resultado == true && userId != null) {
        await Supabase.instance.client
            .from('profiles')
            .update({
              'terms_accepted': true,
              'terms_version': 'v1.0_2026',
              'terms_accepted_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      }
    }
  }

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
