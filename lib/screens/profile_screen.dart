import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: const Color(0xFF1E293B),
              expandedHeight: 280,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
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
                          radius: 45,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Nombre de usuario
                      const Text(
                        'Maricel Herrera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '@maricel_convos',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      // Estadísticas (Siguiendo, Seguidores, Likes)
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
            // Pestaña de Videos (Grid estilo TikTok)
            _MediaGridContent(isVideo: true),
            // Pestaña de Fotos (Grid estilo Instagram)
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
