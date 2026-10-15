import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void mostrarModalCompartir({
  required BuildContext context,
  required String tituloLive,
  required String urlLive,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E293B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compartir Transmisión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Opción 1: Compartir por WhatsApp, Telegram o Redes Externas
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.white),
              ),
              title: const Text(
                'Compartir por WhatsApp / Telegram',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Enviar enlace a tus redes externas',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                Share.share(
                  '¡Hola! 👋 Te invito a ver esta transmisión en vivo en CONVOS: $tituloLive\n$urlLive',
                );
              },
            ),

            const Divider(color: Colors.white10),

            // Opción 2: Compartir Internamente a usuarios de CONVOS
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
              title: const Text(
                'Enviar a un usuario de CONVOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Enviar mensaje privado dentro de la app',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _mostrarListaSeguidoresInternos(context, tituloLive, urlLive);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _mostrarListaSeguidoresInternos(
  BuildContext context,
  String titulo,
  String url,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0F172A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final usuariosEjemplo = [
        {'id': '1', 'name': 'María López', 'username': '@maria_l'},
        {'id': '2', 'name': 'Carlos Gómez', 'username': '@carlos_g'},
        {'id': '3', 'name': 'Ana Martínez', 'username': '@ana_m'},
      ];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enviar mensaje a:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: usuariosEjemplo.length,
                itemBuilder: (context, index) {
                  final user = usuariosEjemplo[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF8B5CF6),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      user['name']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      user['username']!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡Live enviado a ${user['name']} con éxito!',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white),
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
