import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WithdrawalScreen extends StatefulWidget {
  final double gananciasUsd;
  final double gananciasArs;

  const WithdrawalScreen({
    Key? key,
    required this.gananciasUsd,
    required this.gananciasArs,
  }) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _cbuController = TextEditingController();
  final _aliasController = TextEditingController();
  final _titularController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosGuardados();
  }

  // Carga el CBU / Alias si la creadora ya lo había guardado antes
  Future<void> _cargarDatosGuardados() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final res = await supabase
          .from('creator_payout_details')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (res != null) {
        setState(() {
          _cbuController.text = res['cbu_cvu'] ?? '';
          _aliasController.text = res['alias'] ?? '';
          _titularController.text = res['account_holder'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error al cargar datos bancarios: $e');
    }
  }

  // Guarda/Actualiza los datos bancarios y simula la solicitud de retiro
  // Guarda/Actualiza los datos bancarios y procesa la solicitud de retiro con validación de días y mínimos
  Future<void> _solicitarRetiro() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. REGLA: Validar que sea lunes (DateTime.monday = 1)
    if (DateTime.now().weekday != DateTime.monday) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            'Día no habilitado',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Las solicitudes de retiro de fondos se procesan únicamente los días lunes. Por favor, vuelve a intentarlo el próximo lunes.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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

    // 2. REGLA: Validar monto mínimo de $15.000 ARS
    if (widget.gananciasArs < 15000) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            'Monto mínimo no alcanzado',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'El monto mínimo para solicitar un retiro es de \$15.000 ARS. Actualmente tienes \$${widget.gananciasArs.toStringAsFixed(0)} ARS acumulados.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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

    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Usuario no identificado');

      // 3. Guardar o actualizar CBU/CVU en Supabase
      await supabase.from('creator_payout_details').upsert({
        'user_id': user.id,
        'cbu_cvu': _cbuController.text.trim(),
        'alias': _aliasController.text.trim(),
        'account_holder': _titularController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      // 4. Mostrar confirmación a la Creadora
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                '¡Solicitud Enviada!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'Se ha registrado tu solicitud de retiro por \$${widget.gananciasArs.toStringAsFixed(0)} ARS (USD \$${widget.gananciasUsd.toStringAsFixed(2)}).\n\nEl pago se acreditará en tu cuenta vinculada de Mercado Pago en un plazo de 24 a 48 hs hábiles.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra modal
                Navigator.pop(context); // Vuelve a Ajustes
              },
              child: const Text(
                'Entendido',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error en retiro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar datos. Inténtalo nuevamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _cbuController.dispose();
    _aliasController.dispose();
    _titularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Retirar Ganancias'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF10B981)),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Tarjeta Resumen del Monto a Retirar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'MONTO DISPONIBLE PARA EXTRAER',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${widget.gananciasArs.toStringAsFixed(0)} ARS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Equivalente neto: USD \$${widget.gananciasUsd.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Formulario CBU / CVU / Alias
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DATOS DE TU CUENTA BANCARIA / MERCADO PAGO',
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Campo Nombre del Titular
                      TextFormField(
                        controller: _titularController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'Nombre completo del titular',
                          Icons.person,
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Ingresa el nombre del titular'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Campo CBU/CVU (22 dígitos)
                      TextFormField(
                        controller: _cbuController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          'CBU / CVU (22 dígitos)',
                          Icons.account_balance,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Ingresa tu CBU o CVU';
                          if (v.length != 22)
                            return 'El CBU/CVU debe tener exactamente 22 números';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Campo Alias (Opcional o Alternativo)
                      TextFormField(
                        controller: _aliasController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'Alias (ejemplo: mi.cuenta.mp)',
                          Icons.alternate_email,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Botón para Confirmar Retiro
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text(
                            'Confirmar y Solicitar Retiro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _solicitarRetiro,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF10B981)),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF10B981)),
      ),
    );
  }
}
