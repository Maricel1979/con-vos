import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatefulWidget {
  final bool requireAcceptance; // true si es obligatoria durante el registro

  const TermsConditionsScreen({Key? key, this.requireAcceptance = false})
    : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'TÉRMINOS Y CONDICIONES DE USO - CONVOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Última actualización: Octubre 2026',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Divider(color: Colors.white24, height: 24),

                    // 1. Edad
                    _TermSection(
                      title: '1. RESTRICCIÓN DE EDAD (+18)',
                      content: 'CONVOS es de uso exclusivo para personas mayores de 18 años. Queda totalmente prohibido el registro o transmisión por parte de menores de edad. La plataforma se reserva el derecho de solicitar verificación de identidad y eliminar de inmediato cuentas pertenecientes a menores.',
                    ),

                    // 2. Responsabilidad de contenido
                    _TermSection(
                      title: '2. RESPONSABILIDAD EXCLUSIVA DEL USUARIO',
                      content: 'Los usuarios son los únicos y absolutos responsables de todo el contenido, transmisiones, mensajes e imágenes que compartan. CONVOS actúa como un intermediario tecnológico y no asume responsabilidad civil, penal ni comercial por el contenido de los usuarios.',
                    ),

                    // 3. Convivencia y Baneo
                    _TermSection(
                      title: '3. NORMAS DE CONVIVENCIA Y TOLERANCIA CERO',
                      content: 'Está estrictamente prohibido el contenido sexual explícito, violento, acosador o ilegal. CONVOS se reserva el derecho de suspender o bloquear cuentas infractoras sin previo aviso.',
                    ),

                    // 4. Retención de Fondos
                    _TermSection(
                      title: '4. RETENCIÓN DE FONDOS POR INFRACCIÓN',
                      content: 'En caso de baneo o suspensión debido a violaciones graves de las reglas, acoso o fraude, todos los fondos acumulados, ganancias o saldos pendientes quedarán automáticamente retenidos a favor de la plataforma como penalización por daños.',
                    ),

                    // 5. Autoridades
                    _TermSection(
                      title: '5. DENUNCIA Y COOPERACIÓN CON AUTORIDADES',
                      content: 'Si se detecta o sospecha que un usuario está siendo obligado, coaccionado o extorsionado, o ante la presencia de actividades delictivas, CONVOS dará aviso inmediato a las autoridades correspondientes compartiendo la información de registro para la investigación legal.',
                    ),

                    // 6. Offline
                    _TermSection(
                      title: '6. EXENCIÓN DE RESPONSABILIDAD FUERA DE LÍNEA',
                      content: 'CONVOS no recomienda ni organiza encuentros presenciales o citas cara a cara. Cualquier contacto o reunión fuera de la app es responsabilidad exclusiva de los involucrados.',
                    ),
                  ],
                ),
              ),
            ),

            // Muestra casilla y botón de aceptar sólo si viene del registro
            if (widget.requireAcceptance) ...[
              Container(
                color: const Color(0xFF1E293B),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CheckboxListTile(
                      activeColor: const Color(0xFF8B5CF6),
                      value: _accepted,
                      onChanged: (val) {
                        setState(() {
                          _accepted = val ?? false;
                        });
                      },
                      title: const Text(
                        'Confirmo que soy mayor de 18 años y acepto los Términos y Condiciones.',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accepted
                              ? const Color(0xFF8B5CF6)
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _accepted
                            ? () {
                                Navigator.pop(context, true);
                              }
                            : null,
                        child: const Text(
                          'Continuar',
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
            ],
          ],
        ),
      ),
    );
  }
}

class _TermSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermSection({Key? key, required this.title, required this.content})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
