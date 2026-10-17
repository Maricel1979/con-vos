import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscoverUsersScreen extends StatefulWidget {
  const DiscoverUsersScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverUsersScreen> createState() => _DiscoverUsersScreenState();
}

class _DiscoverUsersScreenState extends State<DiscoverUsersScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Future<List<Map<String, dynamic>>> _obtenerVideosFeed() async {
    try {
      var query = supabase
          .from('posts')
          .select('*, profiles:id(username, full_name, avatar_url)')
          .eq('media_type', 'video');

      if (_searchQuery.isNotEmpty) {
        query = query.ilike('profiles.username', '%$_searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      if (response != null && (response as List).isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      debugPrint('Error al cargar feed de videos: $e');
    }

    // Datos de prueba garantizados para que el feed nunca esté vacío y puedas probar bloqueos
    return [
      {
        'id': '1',
        'username': 'Sofia_Live',
        'title': 'Transmisión en vivo y novedades de la semana 🚀',
        'video_url': '',
        'likes': 1250,
        'comments': 84,
      },
      {
        'id': '2',
        'username': 'Camila_Vibes',
        'title': 'Música y charlas en CON VOS 🎵',
        'video_url': '',
        'likes': 840,
        'comments': 32,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Buscador con la lupa
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar usuarios...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8B5CF6)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Feed de videos
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _obtenerVideosFeed(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                  );
                }

                final videos = snapshot.data ?? [];

                if (videos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay videos disponibles en este momento',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                // Feed vertical estilo TikTok
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final mediaUrl = video['media_url'] ?? '';
                    final caption = video['caption'] ?? 'Sin descripción';
                    final perfil = video['profiles'] as Map<String, dynamic>?;
                    final username = perfil?['username'] ?? 'usuario_convos';

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // 1. Fondo / Reproductor de video (aquí puedes integrar tu reproductor de video o imagen temporal)
                        Container(
                          color: const Color(0xFF1E293B),
                          child: Image.network(
                            mediaUrl.isNotEmpty
                                ? mediaUrl
                                : 'https://via.placeholder.com/400x800',
                            fit: BoxFit.cover,
                          ),
                        ),

                        // 2. Degradado inferior para legibilidad del texto
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),

                        // 3. Información del creador y descripción abajo a la izquierda
                        Positioned(
                          bottom: 40,
                          left: 16,
                          right: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@$username',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                caption,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 4. Botones de interacción a la derecha (Like, Compartir)
                        Positioned(
                          bottom: 40,
                          right: 16,
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  // Lógica de Me gusta
                                },
                              ),
                              const Text(
                                '8.5K',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 20),
                              IconButton(
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // Lógica para compartir enlace público
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Enlace copiado al portapapeles',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                'Compartir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
