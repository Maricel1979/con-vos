import 'video_interactions_bar.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'live_gifts_sheet.dart';

class LiveRoomScreen extends StatefulWidget {
  final String roomId;
  const LiveRoomScreen({super.key, required this.roomId});
  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  final supabase = Supabase.instance.client;
  late RealtimeChannel _roomChannel;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  // Lista completa de emojis variados para el chat de los vivos
  final List<String> _emojisGratuitos = const [
    // Caras y Emociones
    '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃',
    '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😙',
    '😋', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔',
    '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥',
    '😌', '😔', '😴', '🤤', '😷', '🤒', '🤕', '🤢', '🤮',
    '🥵', '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '😎', '🤓', '🧐',

    // Corazones, Manos y Gestos
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
    '❣️', '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💋',
    '👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞',
    '🫰', '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕', '👇', '☝️',
    '👍', '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '👐', '🤲',
    '🤝', '🙏', '✍️', '💅', '🤳', '💪', '🦾', '🦿', '🦵', '🦶',

    // Celebración, Objetos y Símbolos
    '🔥', '⭐', '🌟', '✨', '⚡', '💥', '🎉', '🎊', '🎈', '🎁',
    '🏆', '👑', '💎', '🌹', '🌷', '💐', '🌸', '🌺', '🌻', '🍻',
    '🍷', '🍸', '🍹', '🍾', '🍕', '🍔', '🍟', '🍦', '🍩', '🍫',
    '🎵', '🎶', '🎤', '🎧', '🎸', '🎹', '🎷', '🎺', '🥁', '💯',
    '💃', '🕺', '👯‍♂️', '👯‍♀️', '☀️', '🌞', '⛈️', '🌤️', '🌈',
  ];

  @override
  void initState() {
    super.initState();

    // Muestra el cartelito de seguridad a los 2 segundos de entrar al vivo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.security, color: Color(0xFF10B981)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '🛡️ Tip: Por tu seguridad, no compartas tu CBU, CVU o Alias en el vivo.',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
              backgroundColor: Color(0xFF1E293B),
              duration: Duration(seconds: 10),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    });

    _conectarCanalVivo();
  }

  void _conectarCanalVivo() {
    _roomChannel = supabase.channel('room_${widget.roomId}');
    _roomChannel
        .onBroadcast(
          event: 'chat_message',
          callback: (payload) {
            if (mounted) {
              setState(() {
                _messages.add(payload);
              });
            }
          },
        )
        .subscribe();
  }

  void _enviarTexto(String texto) {
    if (texto.trim().isEmpty) return;

    final textoMinus = texto.toLowerCase();

    // Filtro estricto de seguridad para CBU, CVU, Alias, Teléfonos y Celulares
    bool contieneDatosProhibidos =
        textoMinus.contains('cbu') ||
        textoMinus.contains('cvu') ||
        textoMinus.contains('alias') ||
        textoMinus.contains('cel') ||
        textoMinus.contains('telefono') ||
        textoMinus.contains('tel') ||
        RegExp(r'\b(?:\+?54)?(?:9)?(?:0?[1-1]?[2-9]\d{2})?\d{6,8}\b')
            .hasMatch(texto) ||
        RegExp(r'\b\d{8,}\b').hasMatch(texto);

    if (contieneDatosProhibidos) {
      supabase.auth.signOut();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            'Cuenta suspendida',
            style: TextStyle(color: Colors.redAccent),
          ),
          content: const Text(
            'Se ha detectado un intento de compartir datos bancarios o números de celular/contacto prohibidos. Tu cuenta ha sido cerrada automáticamente por seguridad.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Text(
                'Entendido',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final mensaje = {
      'user': supabase.auth.currentUser?.email ?? 'Anónimo',
      'text': texto.trim(),
      'time': DateTime.now().toIso8601String(),
    };

    _roomChannel.sendBroadcastMessage(event: 'chat_message', payload: mensaje);

    _messageController.clear();
  }

  void _mostrarMenuRegalos() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const LiveGiftsSheet();
      },
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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icons/app_logo.png', width: 32, height: 32),
            const SizedBox(width: 10),
            Text('Sala: ${widget.roomId}'),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
            tooltip: 'Enviar Regalo',
            onPressed: _mostrarMenuRegalos,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenido principal de la sala (chat, emojis y entrada de texto)
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return ListTile(
                      onLongPress: () => _mostrarOpcionesModeracion(msg, index),
                      title: Text(
                        msg['user'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        msg['text'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white38,
                          size: 18,
                        ),
                        onPressed: () => _mostrarOpcionesModeracion(msg, index),
                      ),
                    );
                  },
                ),
              ),

              // Barra horizontal de Emojis Gratuitos
              Container(
                height: 45,
                color: const Color(0xFF1E293B).withOpacity(0.5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _emojisGratuitos.length,
                  itemBuilder: (context, index) {
                    final emoji = _emojisGratuitos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: InkWell(
                        onTap: () => _enviarTexto(emoji),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Caja de texto y botones inferiores
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color(0xFF1E293B),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje o emoji...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF8B5CF6)),
                      onPressed: () => _enviarTexto(_messageController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Botones flotantes de interacción a la derecha (Corazón, Comentarios, Compartir)
          // Botones flotantes de interacción a la derecha para Vivos (Corazón, Fueguito, Compartir)
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Botón Corazón
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❤️ Enviaste un corazón al vivo'),
                            duration: Duration(milliseconds: 600),
                            backgroundColor: Colors.pink,
                          ),
                        );
                      },
                    ),
                    const Text(
                      '1250',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 2. Botón Fueguito 🔥 (Reemplaza a comentarios en Vivos)
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _enviarTexto('🔥');
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('🔥', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fueguito',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 3. Botón Compartir 🔗
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '🔗 Enlace del vivo copiado para compartir',
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF8B5CF6),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Compartir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarOpcionesModeracion(Map<String, dynamic> msg, int index) {
    final usuario = msg['user'] ?? 'Anónimo';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Opciones de moderación: $usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Divider(color: Colors.white10),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.amberAccent,
                ),
                title: const Text(
                  'Eliminar este comentario',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Comentario eliminado del vivo.'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.redAccent),
                title: Text(
                  'Bloquear a $usuario',
                  style: const TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.removeWhere((m) => m['user'] == usuario);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Usuario $usuario bloqueado y removido.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
