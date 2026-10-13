import 'package:flutter/material.dart';

import '../widgets/live_room_screen.dart';

class DiscoverUsersScreen extends StatefulWidget {
  const DiscoverUsersScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverUsersScreen> createState() => _DiscoverUsersScreenState();
}

class _DiscoverUsersScreenState extends State<DiscoverUsersScreen> {
  final List<Map<String, String>> _allUsers = const [
    {'id': 'usr_001', 'name': 'María López', 'status': 'En vivo'},
    {'id': 'usr_002', 'name': 'Carlos Gómez', 'status': 'Disponible'},
    {'id': 'usr_003', 'name': 'Ana Martínez', 'status': 'En vivo'},
  ];

  List<Map<String, String>> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
    _searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final name = user['name']!.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startCallOrLive(BuildContext context, String userId, String userName) {
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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Descubrir Usuarios'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar usuario por nombre...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8B5CF6)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron usuarios',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.video_call, size: 18),
                            label: const Text('Conectar'),
                            onPressed: () => _startCallOrLive(
                              context,
                              user['id']!,
                              user['name']!,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
