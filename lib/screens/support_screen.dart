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
      'text': '¡Hola! Soy la asistente virtual de CONVOS 🤖. ¿En qué puedo ayudarte hoy?',
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

    // Simulación de respuesta automática de la Asistente IA
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      String reply = '';
      final lowerText = text.toLowerCase();

      if (lowerText.contains('token') || lowerText.contains('comprar')) {
        reply = 'Para comprar tokens, ve a Ajustes > Zona de Compras y elige el paquete que prefieras. Recuerda que 1 Token = \$0.01 USD. 🪙';
      } else if (lowerText.contains('cbu') ||
          lowerText.contains('retiro') ||
          lowerText.contains('cobrar')) {
        reply = 'Los retiros se realizan ingresando tu CBU/CVU en la Zona de Creadora. Cobras el 50% neto de tus ganancias directo a tu cuenta bancaria en pesos ARS. 🏦';
      } else if (lowerText.contains('humano') ||
          lowerText.contains('ayuda') ||
          lowerText.contains('persona')) {
        reply = 'Entendido. Estoy derivando tu consulta con el equipo de soporte. Te llegará una notificación cuando un agente te responda. 📩';
        _isEscalatedToHuman = true;
      } else {
        reply =
            'Entiendo tu consulta sobre "$text". Si deseas que un representante revise tu caso personalmente, escribe "Hablar con humano".';
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
            Text('Soporte y Asistente CONVOS'),
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
                      'Consulta derivada al Administrador. Se te avisará con un tilde cuando respondan.',
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
                      hintText: 'Escribe tu consulta aquí...',
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
