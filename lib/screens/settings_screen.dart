import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:convos/screens/buy_tokens_screen.dart';
import 'package:convos/screens/withdrawal_screen.dart';
import 'package:convos/screens/support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final supabase = Supabase.instance.client;

  // Saldos simulados
  int _tokensCompradorBalance = 250;
  int _tokensCreadoraGanados = 4200;
  double _dolarCotizacion = 1550.0;

  // Preferencias
  bool _notificacionesActivas = true;

  // Modal para Editar Perfil
  void _mostrarModalEditarPerfil() {
    final nameController = TextEditingController(text: 'Mi Nombre');
    final bioController = TextEditingController(
      text: '¡Hola! Estoy usando CONVOS 🚀',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Editar Perfil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Nombre de Usuario', Icons.person),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: _inputDecoration('Biografía', Icons.info_outline),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil actualizado correctamente'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modal donde SE EXPLICA TODO al cerrar la cuenta
  void _mostrarModalCerrarCuenta() {
    bool aceptoPerdida = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'Eliminar Cuenta',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚠️ TÉRMINOS Y CONDICIONES DE CIERRE DE CUENTA:',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Pérdida de Saldos: Todos los tokens no consumidos y las ganancias no retiradas a CBU/CVU se perderán definitivamente.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '• Conversión y Modelo: La tasa aplicable fue 1 Token = \$0.01 USD con la regla de comisión 50/50. No se realizarán reembolsos posteriores.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '• Datos y Contenido: Tu perfil, transmisiones e historial de mensajes serán eliminados de la plataforma CONVOS sin posibilidad de recuperación.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: aceptoPerdida,
                        activeColor: Colors.redAccent,
                        onChanged: (val) {
                          setModalState(() => aceptoPerdida = val ?? false);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Entiendo y acepto las condiciones de eliminación definitiva.',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: aceptoPerdida
                      ? Colors.redAccent
                      : Colors.grey,
                ),
                onPressed: aceptoPerdida
                    ? () async {
                        Navigator.pop(context);
                        await supabase.auth.signOut();
                      }
                    : null,
                child: const Text(
                  'Eliminar Mi Cuenta',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double gananciasUsd = (_tokensCreadoraGanados * 0.01) * 0.50;
    double gananciasArs = gananciasUsd * _dolarCotizacion;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Mi Cuenta y Billetera CONVOS'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Cuenta Dual
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withOpacity(0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.star, color: Color(0xFF8B5CF6)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '¡Tu cuenta es dual! Puedes enviar regalos o generar ingresos vendiendo tus propios Vivos.',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🛒 BILLETERA COMPRADOR
          const Text(
            'ZONA DE COMPRAS Y GASTOS',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tokens para Gastar',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Comprador',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$_tokensCompradorBalance Tokens',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuyTokensScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                      ),
                      child: const Text(
                        'Cargar más Tokens (Comprar)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 💰 BILLETERA CREADORA
          const Text(
            'ZONA DE CREADORA (INGRESOS NETOS)',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ganancias Disponibles',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'USD \$${gananciasUsd.toStringAsFixed(2)} (~ \$${gananciasArs.toStringAsFixed(0)} ARS)',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF10B981)),
                      ),
                      icon: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF10B981),
                      ),
                      label: const Text(
                        'Retirar a mi CBU / CVU (Pesos ARS)',
                        style: TextStyle(color: Color(0xFF10B981)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WithdrawalScreen(
                              gananciasUsd: gananciasUsd,
                              gananciasArs: gananciasArs,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ⚙️ GESTIÓN DE MI PERFIL
          const Text(
            'MI PERFIL',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.edit, color: Color(0xFF8B5CF6)),
            title: const Text(
              'Editar Perfil',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: const Text(
              'Cambia tu nombre, biografía y foto',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: _mostrarModalEditarPerfil,
          ),

          const SizedBox(height: 20),

          // 💬 SOPORTE Y AYUDA
          const Text(
            'SOPORTE Y AYUDA',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.headset_mic, color: Color(0xFF8B5CF6)),
            title: const Text(
              'Asistente Virtual y Soporte',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: const Text(
              'Consultas 24/7 sobre tokens, pagos y la app',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔔 PREFERENCIAS
          const Text(
            'PREFERENCIAS',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            activeColor: const Color(0xFF8B5CF6),
            title: const Text(
              'Notificaciones Push',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: const Text(
              'Avisos de regalos, transmisiones y soporte',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            value: _notificacionesActivas,
            onChanged: (val) => setState(() => _notificacionesActivas = val),
          ),

          const SizedBox(height: 24),

          // 🚪 SESIÓN Y ELIMINACIÓN DE CUENTA
          const Text(
            'SEGURIDAD Y SESIÓN',
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.logout, color: Colors.amber),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.amber, fontSize: 14),
            ),
            onTap: () async {
              await supabase.auth.signOut();
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text(
              'Eliminar / Cerrar Cuenta',
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
            subtitle: const Text(
              'Requiere leer y aceptar los términos de baja',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            onTap: _mostrarModalCerrarCuenta,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF8B5CF6)),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
