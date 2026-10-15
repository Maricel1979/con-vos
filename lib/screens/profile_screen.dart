import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'terms_conditions_screen.dart';
import '../widgets/locked_media_widget.dart';

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

              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

class _MediaGridContent extends StatefulWidget {
  final bool isVideo;

  const _MediaGridContent({Key? key, required this.isVideo}) : super(key: key);

  @override
  State<_MediaGridContent> createState() => _MediaGridContentState();
}

class _MediaGridContentState extends State<_MediaGridContent> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _obtenerPostsYCompras() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final tipoMedia = widget.isVideo ? 'video' : 'image';
    final postsResponse = await supabase
        .from('posts')
        .select()
        .eq('media_type', tipoMedia)
        .order('created_at', ascending: false);

    final posts = List<Map<String, dynamic>>.from(postsResponse);

    final comprasResponse = await supabase
        .from('content_purchases')
        .select('post_id')
        .eq('user_id', user.id);

    final comprasIds = comprasResponse.map((c) => c['post_id']).toSet();

    for (var post in posts) {
      final postId = post['id'];
      post['is_purchased'] = comprasIds.contains(postId);
    }

    return posts;
  }

  Future<void> _desbloquearContenido(String postId, double precio) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('content_purchases').insert({
        'user_id': user.id,
        'post_id': postId,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Contenido desbloqueado con éxito!')),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al desbloquear: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _obtenerPostsYCompras(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar contenido',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return const Center(
            child: Text(
              'Aún no hay publicaciones en esta sección',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.8,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final postId = post['id'];
            final mediaUrl = post['media_url'] ?? '';
            final isLocked = post['is_locked'] ?? false;
            final price = (post['price'] ?? 0).toDouble();
            final isPurchased = post['is_purchased'] ?? false;

            return LockedMediaWidget(
              mediaUrl: mediaUrl,
              isLocked: isLocked,
              price: price,
              isPurchased: isPurchased,
              currentUsername: 'maricel_convos',
              onUnlockPressed: () => _desbloquearContenido(postId, price),
            );
          },
        );
      },
    );
  }
}
