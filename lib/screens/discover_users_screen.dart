import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Consulta para obtener las visitas desde Supabase
  Future<List<Map<String, dynamic>>> _obtenerMisVisitas() async {
    final miUsuarioId = Supabase.instance.client.auth.currentUser?.id;
    if (miUsuarioId == null) return [];

    try {
      final response = await Supabase.instance.client
          .from('profile_views')
          .select(
            'viewed_at, profiles:visitor_user_id(username, full_name, avatar_url)',
          )
          .eq('visited_user_id', miUsuarioId)
          .order('viewed_at', ascending: false)
          .limit(30);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error al obtener visitas: $e');
      return [];
    }
  }

  // Modal para mostrar los visitantes
  void _mostrarModalVisitas(
    BuildContext context,
    List<Map<String, dynamic>> visitas,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Personas que vieron tu perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12),
              visitas.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'Aún no registras visitas nuevas',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: visitas.length,
                        itemBuilder: (context, index) {
                          final visita = visitas[index];
                          final perfilVisitante =
                              visita['profiles'] as Map<String, dynamic>?;
                          final nombre =
                              perfilVisitante?['full_name'] ??
                              perfilVisitante?['username'] ??
                              'Usuario';
                          final avatarUrl = perfilVisitante?['avatar_url'];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: avatarUrl != null
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              child: avatarUrl == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              nombre,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Visitó tu perfil reciente',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: const Color(0xFF1E293B),
              expandedHeight: 340,
              pinned: true,
              actions: [
                // ÍCONO DE CONFIGURACIÓN (ENGRANAJE)
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white70),
                  tooltip: 'Configuración',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar de perfil con borde brillante
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B5CF6), Colors.pinkAccent],
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Nombre de usuario
                      const Text(
                        'Maricel Herrera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '@maricel_convos',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      // Estadísticas
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ProfileStatItem(label: 'Siguiendo', count: '142'),
                          SizedBox(width: 24),
                          _ProfileStatItem(label: 'Seguidores', count: '1.2K'),
                          SizedBox(width: 24),
                          _ProfileStatItem(label: 'Me gusta', count: '8.5K'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Tarjeta de Visitas al Perfil
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _obtenerMisVisitas(),
                        builder: (context, snapshot) {
                          final visitas = snapshot.data ?? [];
                          return GestureDetector(
                            onTap: () => _mostrarModalVisitas(context, visitas),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF8B5CF6)
                                      .withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Color(0xFF8B5CF6),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Visitas al perfil (${visitas.length})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF8B5CF6),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                tabs: const [
                  Tab(icon: Icon(Icons.grid_view), text: 'Videos / Reels'),
                  Tab(icon: Icon(Icons.photo_library), text: 'Fotos'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            _MediaGridContent(isVideo: true),
            _MediaGridContent(isVideo: false),
          ],
        ),
      ),
    );
  }
}

// Pantalla de Configuración para datos personales, bancarios y soporte
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Ajustes de Cuenta',
            style: TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    'Editar Nombre y Datos',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    // Aquí puedes abrir un formulario para actualizar el nombre en Supabase
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de editar nombre próximamente'),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white10, height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    'Datos Bancarios / Pagos',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'CBU, Alias o métodos de cobro',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    // Configuración de datos bancarios
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Configuración de CBU/Alias'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Soporte y Ayuda',
            style: TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    'Reportar un Problema',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Redirigiendo a soporte técnico'),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white10, height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    'Acerca de CONVOS',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Versión 1.0.0',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String label;
  final String count;

  const _ProfileStatItem({Key? key, required this.label, required this.count})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _MediaGridContent extends StatelessWidget {
  final bool isVideo;

  const _MediaGridContent({Key? key, required this.isVideo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                isVideo ? Icons.play_circle_fill : Icons.image,
                color: Colors.white54,
                size: 36,
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Row(
                  children: [
                    Icon(
                      isVideo ? Icons.remove_red_eye : Icons.favorite,
                      color: Colors.white70,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(index + 1) * 120}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
