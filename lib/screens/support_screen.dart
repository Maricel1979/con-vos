import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isBot': true,
      'text': '¡Hola! Soy Bruno, tu asistente virtual de CONVOS 🤖. ¿En qué puedo ayudarte hoy?',
      'time': 'Ahora',
    },
  ];

  bool _isEscalatedToHuman = false;

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isBot': false, 'text': text, 'time': 'Ahora'});
      _messageController.clear();
    });

    // Simulación de respuesta inteligente de Bruno (Asistente IA)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      String reply = '';
      final lowerText = text.toLowerCase();

      if (lowerText.contains('token') || lowerText.contains('comprar')) {
        reply = 'Para comprar tokens, ve a Ajustes > Billetera (Zona de Compras) y elige el paquete. Recuerda que 1 Token = \$0.01 USD. 🪙';
      } else if (lowerText.contains('cbu') ||
          lowerText.contains('retiro') ||
          lowerText.contains('cobrar') ||
          lowerText.contains('minimo') ||
          lowerText.contains('lunes')) {
        reply = 'Las solicitudes de retiro son los LUNES (mínimo \$15.000 ARS). Cobras el 50% neto de tus ganancias directo a tu CBU/CVU en pesos ARS. 🏦';
      } else if (lowerText.contains('bloquear') ||
          lowerText.contains('bloqueo') ||
          lowerText.contains('reportar') ||
          lowerText.contains('usuario') ||
          lowerText.contains('silenciar')) {
        reply = '🛡️ BLOQUEO Y MODERACIÓN EN CONVOS:\n\n1. En los Vivos: Mantén presionado cualquier mensaje o toca los tres puntos (...) junto al usuario para seleccionar "Bloquear" o "Eliminar comentario".\n2. En Perfiles/Descubrir: Ingresa al perfil del usuario y presiona los tres puntos superiores para "Bloquear perfil". Sus comentarios y transmisiones desaparecerán de tu vista inmediatamente.';
      } else if (lowerText.contains('termino') ||
          lowerText.contains('condicion') ||
          lowerText.contains('regla') ||
          lowerText.contains('politica')) {
        reply = '📋 NORMAS CLAVE DE CONVOS:\n\n1. Comisión 50/50 entre creadora y plataforma.\n2. Retiros exclusivamente los lunes (mínimo \$15.000 ARS).\n3. Verificación KYC por única vez.\n4. Prohibición estricta de intercambiar teléfonos, redes sociales o links de pago externos.';
      } else if (lowerText.contains('contacto') ||
          lowerText.contains('redes') ||
          lowerText.contains('whatsapp') ||
          lowerText.contains('fuera')) {
        reply = '⚠️ Por seguridad de la comunidad, está prohibido pasar números de teléfono o redes sociales. El sistema detecta intentos y suspende la cuenta automáticamente.';
      } else if (lowerText.contains('humano') ||
          lowerText.contains('ayuda') ||
          lowerText.contains('persona') ||
          lowerText.contains('admin')) {
        reply = 'Entendido. Estoy derivando tu consulta con un administrador. Te avisaremos apenas te respondan. 📩';
        _isEscalatedToHuman = true;
      } else {
        reply = 'Entiendo tu consulta. Soy Bruno 🤖 y te puedo ayudar con:\n• Bloqueos y reportes de usuarios\n• Reglas de retiros (lunes y \$15.000 ARS)\n• Compra de tokens y Billetera\n• Términos y condiciones\n\nSi necesitas ayuda humana, escribe "Hablar con humano".';
      }

      setState(() {
        _messages.add({'isBot': true, 'text': reply, 'time': 'Ahora'});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Color(0xFF8B5CF6)),
            SizedBox(width: 8),
            Text('Soporte - Asistente Bruno'),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Banner de estado
          if (_isEscalatedToHuman)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.amber.withOpacity(0.2),
              child: const Row(
                children: [
                  Icon(Icons.mark_chat_unread, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Consulta derivada al Administrador. Se te avisará cuando respondan.',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // Lista de Mensajes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isBot = msg['isBot'] as bool;

                return Align(
                  alignment: isBot
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    decoration: BoxDecoration(
                      color: isBot
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isBot ? 0 : 16),
                        bottomRight: Radius.circular(isBot ? 16 : 0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Caja de texto para escribir
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu consulta a Bruno aquí...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF8B5CF6),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
