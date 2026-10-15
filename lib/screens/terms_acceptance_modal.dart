import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TermsAcceptanceModal extends StatefulWidget {
  final VoidCallback onAccepted;

  const TermsAcceptanceModal({Key? key, required this.onAccepted})
    : super(key: key);

  @override
  State<TermsAcceptanceModal> createState() => _TermsAcceptanceModalState();
}

class _TermsAcceptanceModalState extends State<TermsAcceptanceModal> {
  final supabase = Supabase.instance.client;
  bool _acceptedCheck = false;
  bool _isLoading = false;

  Future<void> _aceptarReglamento() async {
    if (!_acceptedCheck) return;

    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Marcamos en la base de datos que ya aceptó el reglamento
        await supabase
            .from('profiles')
            .update({
              'terms_accepted': true,
              'terms_accepted_at': DateTime.now().toIso8601String(),
            })
            .eq('id', user.id);
      }

      if (!mounted) return;
      widget.onAccepted(); // Cierra el modal y da paso a la app
    } catch (e) {
      debugPrint('Error al guardar aceptación: $e');
      widget.onAccepted(); // Permite avanzar en caso de error local
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Impede cerrar tocando afuera o el botón atrás
      child: Dialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.gavel, color: Color(0xFF8B5CF6), size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Reglamento de CONVOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Bienvenido/a a CONVOS. Para garantizar una comunidad segura y transparente, por favor acepta las reglas principales:',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),

              // Contenedor con las reglas y restricciones de tamaño corregidas
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Conversión: 1 Token = \$0.01 USD.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '• Reparto 50/50: 50% para la creadora y 50% comisión de mantenimiento de la app.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '• Retiros: Cobros directos a CBU/CVU registrado en pesos ARS.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ' • Convivencia: Prohibido el acoso, spam o cualquier contenido ilegal.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ' • Contenido y Transmisiones: Prohibida la desnudez y actos explícitos en vivos públicos. En salas/chats privados se permite contenido de desnudez, pero quedan estrictamente prohibidas las relaciones sexuales explícitas.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ' • Seguridad y Privacidad: Prohibido compartir CBU, CVU, Alias, datos bancarios o números personales en vivos, chats o llamadas.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tilde de aceptación
              Row(
                children: [
                  Checkbox(
                    value: _acceptedCheck,
                    activeColor: const Color(0xFF8B5CF6),
                    onChanged: (val) {
                      setState(() => _acceptedCheck = val ?? false);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'He leído y acepto el reglamento de uso por única vez.',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Botón Entrar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _acceptedCheck
                        ? const Color(0xFF8B5CF6)
                        : Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _acceptedCheck && !_isLoading
                      ? _aceptarReglamento
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Entrar a la App',
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
      ),
    );
  }
}
