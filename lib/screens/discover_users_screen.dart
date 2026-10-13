import 'package:flutter/material.dart';

import '../widgets/live_room_screen.dart';

class DiscoverUsersScreen extends StatelessWidget {
  const DiscoverUsersScreen({Key? key}) : super(key: key);

  // Lista de ejemplo de usuarios (pueden venir de Supabase)
  final List<Map<String, String>> users = const [
    {'id': 'usr_001', 'name': 'María López', 'status': 'En vivo'},
    {'id': 'usr_002', 'name': 'Carlos Gómez', 'status': 'Disponible'},
    {'id': 'usr_003', 'name': 'Ana Martínez', 'status': 'En vivo'},
  ];

  void _startCallOrLive(BuildContext context, String userId, String userName) {
    // Generamos un nombre de canal dinámico basado en el ID del usuario
    final String dynamicChannelName = 'room_$userId';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveRoomScreen(roomId: dynamicChannelName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir Usuarios'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF8B5CF6),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                user['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user['status']!,
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.video_call, size: 18),
                label: const Text('Conectar'),
                onPressed: () =>
                    _startCallOrLive(context, user['id']!, user['name']!),
              ),
            ),
          );
        },
      ),
    );
  }
}
