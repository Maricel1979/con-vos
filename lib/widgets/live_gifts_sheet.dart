import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveGiftsSheet extends StatelessWidget {
  const LiveGiftsSheet({Key? key}) : super(key: key);

  // Lista completa de regalos pagos ($0.50 a $15 USD)
  final List<Map<String, dynamic>> _regalosPagos = const [
    {
      'nombre': 'Diamante Mini',
      'precioUsd': 0.50,
      'tokens': 50,
      'icono': '💎',
      'color': Colors.blueAccent,
    },
    {
      'nombre': 'Rosa de Cristal',
      'precioUsd': 1.00,
      'tokens': 100,
      'icono': '🌹',
      'color': Colors.pinkAccent,
    },
    {
      'nombre': 'Fuego Sagrado',
      'precioUsd': 3.00,
      'tokens': 300,
      'icono': '🔥',
      'color': Colors.deepOrange,
    },
    {
      'nombre': 'Anillo Brillante',
      'precioUsd': 5.00,
      'tokens': 500,
      'icono': '💍',
      'color': Colors.purpleAccent,
    },
    {
      'nombre': 'Corona Real',
      'precioUsd': 10.00,
      'tokens': 1000,
      'icono': '👑',
      'color': Colors.amber,
    },
    {
      'nombre': 'Cofre de Diamantes',
      'precioUsd': 15.00,
      'tokens': 1500,
      'icono': '💰',
      'color': Color(0xFF10B981),
    },
  ];

  Future<void> _enviarRegalo(
    BuildContext context,
    Map<String, dynamic> regalo,
  ) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para enviar regalos'),
        ),
      );
      return;
    }

    try {
      Navigator.pop(context); // Cierra el panel de regalos

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Enviaste ${regalo['nombre']} (${regalo['tokens']} tokens / \$${regalo['precioUsd'].toStringAsFixed(2)} USD)! 🚀',
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar regalo: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Regalos Exclusivos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.card_giftcard, color: Color(0xFF8B5CF6)),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Apoya a la creadora desde \$0.50 hasta \$15 USD',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Grilla de regalos pagos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.3,
            ),
            itemCount: _regalosPagos.length,
            itemBuilder: (context, index) {
              final regalo = _regalosPagos[index];
              return InkWell(
                onTap: () => _enviarRegalo(context, regalo),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: regalo['color'].withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        regalo['icono'],
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              regalo['nombre'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${regalo['tokens']} Tks (\$${regalo['precioUsd'].toStringAsFixed(2)})',
                              style: TextStyle(
                                color: regalo['color'],
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
