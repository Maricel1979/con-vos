import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Asegúrate de importar tus otros servicios/widgets si los usas aquí (Agora, etc.)

class LiveRoomScreen extends StatefulWidget {
  final String roomId;
  const LiveRoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();

  late RealtimeChannel _roomChannel;

  // Lista o controlador para tus emojis locales si lo necesitas
  // List<String> emojisActivos = [];

  @override
  void initState() {
    super.initState();
    _initRealtimeReactions();
  }

  void _initRealtimeReactions() {
    // Conectamos al canal único de esta sala
    _roomChannel = supabase.channel('room_${widget.roomId}');

    // Escuchamos el evento de reacciones enviado por otros usuarios
    _roomChannel
        .onBroadcast(
          event: 'reaction',
          callback: (payload) {
            final emoji = payload['emoji'] as String?;
            if (emoji != null && mounted) {
              _mostrarEmojiFlotanteLocal(emoji);
            }
          },
        )
        .subscribe();
  }

  void _mostrarEmojiFlotanteLocal(String emoji) {
    // Lógica para disparar la animación del emoji en la pantalla
    setState(() {
      // Aquí puedes agregar el emoji a tu widget flotante
    });
  }

  void enviarReaccion(String emoji) {
    // 1. Mostrar localmente de forma inmediata
    _mostrarEmojiFlotanteLocal(emoji);

    // 2. Enviar por broadcast a todos los demás espectadores en la sala
    _roomChannel.sendBroadcastMessage(
      event: 'reaction',
      payload: {'emoji': emoji},
    );
  }

  @override
  void dispose() {
    _roomChannel.unsubscribe();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala: ${widget.roomId}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          // Contenido principal de tu streaming y chat
          Center(
            child: Text(
              'Transmisión en vivo activa',
              style: TextStyle(color: Colors.white70),
            ),
          ),

          // Botones de reacción flotantes de prueba
          Positioned(
            bottom: 30,
            right: 20,
            child: Row(
              children: [
                FloatingActionButton(
                  mini: true,
                  heroTag: 'btn_heart',
                  onPressed: () => enviarReaccion('❤️'),
                  child: Text('❤️', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'btn_fire',
                  onPressed: () => enviarReaccion('🔥'),
                  child: Text('🔥', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
