import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatefulWidget {
  final bool requireAcceptance; // true si es obligatoria la aceptación

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

                    // 1. EDAD
                    _TermSection(
                      title: '1. RESTRICCIÓN DE EDAD (+18)',
                      content: 'CONVOS es de uso exclusivo para personas mayores de 18 años. Queda totalmente prohibido el registro, transmisión o monetización por parte de menores de edad. La plataforma se reserva el derecho de solicitar verificación de identidad (KYC) y eliminar de inmediato cuentas pertenecientes a menores.',
                    ),

                    // 2. CONDUCTA Y NORMAS
                    _TermSection(
                      title: '2. DIRECTRICES DE CONDUCTA Y TOLERANCIA CERO',
                      content: 'Queda estrictamente prohibido el contenido sexual explícito, desnudez (total o parcial), ropa interior en transmisiones públicas, actos sexuales, consumo de sustancias ilícitas, violencia, acoso o discursos de odio. CONVOS se reserva el derecho de suspender, bloquear por HWID/IP o eliminar cuentas infractoras de forma unilateral y sin previo aviso.',
                    ),

                    // 3. RESPONSABILIDAD SUBJETIVA
                    _TermSection(
                      title: '3. RESPONSABILIDAD SUBJETIVA POR CONTENIDO (DOCTRINA BELÉN RODRÍGUEZ)',
                      content: 'Los usuarios son los únicos responsables de todo el contenido, transmisiones en vivo, mensajes e imágenes que compartan. CONVOS actúa como un intermediario tecnológico y no realiza un monitoreo previo generalizado. Conforme a la jurisprudencia aplicable, la plataforma solo será responsable si, tras ser notificada fehacientemente sobre un contenido ilegal o infractor, no actuase con celeridad para removerlo.',
                    ),

                    // 4. RETENCIÓN DE FONDOS
                    _TermSection(
                      title: '4. RETENCIÓN DE FONDOS Y PENALIZACIÓN POR INFRACCIÓN',
                      content: 'En caso de baneo o suspensión debido a violaciones graves de las reglas, acoso, contenido ilegal o fraude, todos los fondos acumulados, ganancias o saldos pendientes dentro de la app quedarán retenidos a favor de la plataforma como penalización por daños y perjuicios.',
                    ),

                    // 5. ECONOMÍA VIRTUAL Y REEMBOLSOS
                    _TermSection(
                      title: '5. ECONOMÍA VIRTUAL, MONEDAS Y RETIROS',
                      content: 'Las compras de monedas digitales, diamantes y bienes virtuales dentro de la aplicación son finales y no reembolsables. Para usuarios en la República Argentina, se contempla el derecho de revocación (botón de arrepentimiento) exclusivamente sobre compras no consumidas ni canjeadas dentro de los 10 días corridos.',
                    ),

                    // 6. VALIDACIÓN KYC Y NORMATIVA FISCAL
                    _TermSection(
                      title: '6. VALIDACIÓN KYC Y CUMPLIMIENTO FISCAL (ARCA / ARBA)',
                      content:
                          'Para retirar fondos o ganancias por dinero real, el creador deberá realizar de forma obligatoria la validación de identidad (KYC con DNI y biometría).\n'
                          '• Residentes en Argentina: Los cobros se realizarán en Pesos Argentinos (ARS) vía CBU/CVU. La plataforma y sus pasarelas asociadas podrán actuar como agentes de retención e informar movimientos ante organismos tributarios (ARCA y ARBA).\n'
                          '• Creadores en el Exterior: Los retiros en divisas (USD/Cripto) se procesarán mediante pasarelas internacionales, siendo a cargo del creador las comisiones de intermediarios.',
                    ),

                    // 7. PRIVACIDAD DE DATOS
                    _TermSection(
                      title: '7. PROTECCIÓN DE DATOS PERSONALES (LEY 25.326 Y GDPR)',
                      content: 'Los datos personales recopilados (email, datos bancarios, geolocalización, uso de cámara y micrófono) se tratan bajo estrictos protocolos de seguridad conforme a la Ley N° 25.326 de Argentina y estándares internacionales como el GDPR. El usuario puede solicitar el acceso, rectificación o eliminación total de sus datos en cualquier momento.',
                    ),

                    // 8. AUTORIDADES
                    _TermSection(
                      title: '8. DENUNCIA Y COOPERACIÓN CON AUTORIDADES',
                      content: 'Si se detecta o sospecha que un usuario está siendo obligado, coaccionado o extorsionado, o ante la presencia de actividades delictivas, CONVOS dará aviso inmediato a las autoridades correspondientes compartiendo la información de registro necesaria para la investigación legal.',
                    ),

                    // 9. OFFLINE
                    _TermSection(
                      title: '9. EXENCIÓN DE RESPONSABILIDAD FUERA DE LÍNEA',
                      content: 'CONVOS no recomienda ni organiza encuentros presenciales o citas cara a cara. Cualquier contacto, reunión o transacción fuera de la aplicación es responsabilidad exclusiva e independiente de los involucrados.',
                    ),

                    // 10. JURISDICCIÓN
                    _TermSection(
                      title: '10. LEY APLICABLE Y JURISDICCIÓN',
                      content: 'Los presentes términos se rigen por las leyes de la República Argentina. Cualquier controversia judicial se someterá a los Tribunales Ordinarios en lo Comercial de la Ciudad Autónoma de Buenos Aires, sin perjuicio de las normas de orden público vigentes en materia de Defensa del Consumidor.',
                    ),
                  ],
                ),
              ),
            ),

            // Casilla de verificación y botón (solo si requiere aceptación)
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
