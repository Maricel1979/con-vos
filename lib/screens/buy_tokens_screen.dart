import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuyTokensScreen extends StatefulWidget {
  const BuyTokensScreen({Key? key}) : super(key: key);

  @override
  State<BuyTokensScreen> createState() => _BuyTokensScreenState();
}

class _BuyTokensScreenState extends State<BuyTokensScreen> {
  final supabase = Supabase.instance.client;
  final double _dolarCotizacion = 1550.0; // Dólar referencia ARS

  // Paquetes de tokens disponibles para comprar
  final List<Map<String, dynamic>> _paquetesTokens = [
    {'tokens': 100, 'usd': 1.00, 'popular': false},
    {'tokens': 500, 'usd': 5.00, 'popular': false},
    {
      'tokens': 1500,
      'usd': 15.00,
      'popular': true,
    }, // El más elegido para regalos medianos/VIP
    {'tokens': 3000, 'usd': 30.00, 'popular': false},
    {'tokens': 10000, 'usd': 100.00, 'popular': false},
  ];

  bool _isProcessing = false;

  Future<void> _comprarPaquete(int tokens, double usd) async {
    setState(() => _isProcessing = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // 1. Consultar saldo actual del comprador en Supabase
      final res = await supabase
          .from('user_wallets')
          .select('tokens_balance')
          .eq('user_id', user.id)
          .maybeSingle();

      int saldoActual = 0;
      if (res != null && res['tokens_balance'] != null) {
        saldoActual = res['tokens_balance'] as int;
      }

      int nuevoSaldo = saldoActual + tokens;

      // 2. Actualizar el saldo de tokens en la base de datos
      await supabase.from('user_wallets').upsert({
        'user_id': user.id,
        'tokens_balance': nuevoSaldo,
      });

      if (!mounted) return;

      // 3. Simulación de pago exitoso (aquí luego integrarías Mercado Pago / Stripe)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Compra exitosa! Se acreditaron +$tokens Tokens a tu billetera 🪙',
          ),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (e) {
      debugPrint('Error en la compra: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hubo un error al procesar la compra. Inténtalo de nuevo.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Comprar Tokens CONVOS'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: _isProcessing
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Encabezado explicativo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Recarga tu Billetera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Usa tus tokens para enviar regalos exclusivos en transmisiones en vivo, hacer llamadas o comprar contenido privado (PPV).\nCotización fija: 1 Token = \$0.01 USD.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'SELECCIONA UN PAQUETE',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),

                // Lista de paquetes de tokens
                ..._paquetesTokens.map((paquete) {
                  final int tokens = paquete['tokens'];
                  final double usd = paquete['usd'];
                  final bool popular = paquete['popular'];
                  final double ars = usd * _dolarCotizacion;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: popular
                              ? const Color(0xFF8B5CF6)
                              : Colors.transparent,
                          width: popular ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '$tokens Tokens',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (popular) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8B5CF6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          'Más Elegido',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'USD \$${usd.toStringAsFixed(2)} (~ \$${ars.toStringAsFixed(0)} ARS)',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: popular
                                    ? const Color(0xFF8B5CF6)
                                    : const Color(0xFF334155),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _comprarPaquete(tokens, usd),
                              child: const Text('Comprar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}
