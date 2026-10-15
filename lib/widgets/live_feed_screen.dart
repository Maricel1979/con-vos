import 'package:flutter/material.dart';

import 'video_interactions_bar.dart';
import 'live_room_screen.dart';
import 'share_modal.dart';

class LiveFeedScreen extends StatefulWidget {
  const LiveFeedScreen({Key? key}) : super(key: key);

  @override
  State<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends State<LiveFeedScreen> {
  // Lista de transmisiones de prueba
  final List<Map<String, String>> _lives = [
    {
      'id': 'room_101',
      'title': 'Charlando en vivo con la comunidad 🚀',
      'streamer': 'María López',
      'viewers': '124',
    },
    {
      'id': 'room_102',
      'title': 'Música y buena onda en directo 🎵',
      'streamer': 'Carlos Gómez',
      'viewers': '89',
    },
    {
      'id': 'room_103',
      'title': 'Preguntas y Respuestas 💬',
      'streamer': 'Ana Martínez',
      'viewers': '256',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Transmisiones en Vivo'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _lives.length,
        itemBuilder: (context, index) {
          final live = _lives[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado con foto y nombre del streamer
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF8B5CF6),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            live['streamer']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '🔴 EN VIVO • ${live['viewers']} espectadores',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Título de la transmisión
                  Text(
                    live['title']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Barra de botones e interacción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Aquí agregamos los botones de interacción al lado
                      BotonesInteraccionVertical(
                        cantidadMeGustaInicial: 1250,
                        cantidadComentarios: 84,
                        alPresionarComentarios: () {
                          // Abrir comentarios
                        },
                        alPresionarCompartir: () {
                          // Abrir compartir
                        },
                      ),
                      // Botón para unirse al Live
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Ver Live'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LiveRoomScreen(roomId: live['id']!),
                            ),
                          );
                        },
                      ),

                      // PASO 3: Botón de Compartir (despliega el modal con WhatsApp/Interno)
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        tooltip: 'Compartir transmisión',
                        onPressed: () {
                          mostrarModalCompartir(
                            context: context,
                            tituloLive: live['title']!,
                            urlLive:
                                'https://maricel1979.github.io/con-vos/#/live?room=${live['id']}',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
