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
                      content: 'CONVOS es de uso exclusivo para personas mayores de 18 años (conforme a la Ley N° 26.061). Queda estrictamente prohibido el registro, acceso, interacción o monetización por parte de menores de edad. La plataforma eliminará de inmediato cualquier cuenta perteneciente a un menor.',
                    ),

                    // 2. PROHIBICIÓN DE DATOS DE CONTACTO
                    _TermSection(
                      title: '2. PROHIBICIÓN DE COMPARTIR DATOS DE CONTACTO Y BANEO',
                      content: 'Queda estrictamente prohibido compartir, solicitar o difundir números de teléfono/celular, alias bancarios, CBU/CVU, enlaces de pago externos o redes sociales dentro de chats, salas o perfiles. CONVOS se reserva el derecho de suspender o eliminar definitivamente la cuenta infractora sin previo aviso.',
                    ),

                    // 3. REMUNERACIÓN, COMISIÓN Y RETIROS
                    // 3. REMUNERACIÓN, COMISIÓN Y RETIROS
                    _TermSection(
                      title: '3. COMISIÓN, LIQUIDACIONES Y RETIROS',
                      content:
                          '• División de Ingresos: El valor consumido en fichas/tokens dentro de salas o chats se distribuye en un 50% para el creador y un 50% para la plataforma por servicio e infraestructura.\n'
                          '• Solicitud de Retiro: Las liquidaciones se procesan únicamente los días lunes.\n'
                          '• Monto Mínimo: El piso mínimo para solicitar un retiro a tu cuenta bancaria o billetera virtual es de \$15.000 ARS. Si no se alcanza dicho saldo el lunes, este permanecerá acumulado para la semana siguiente.\n'
                          '• Verificación KYC por Única Vez: La validación de identidad (DNI y biometría) se realiza una sola vez al activar la monetización. No se volverá a solicitar para futuros retiros.',
                    ),

                    // 4. CONDUCTA Y NORMAS
                    _TermSection(
                      title: '4. DIRECTRICES DE CONDUCTA Y TOLERANCIA CERO',
                      content: 'Queda prohibido el contenido sexual explícito, actos sexuales en vivo, consumo de sustancias ilícitas, violencia, acoso, extorsión o grooming (Ley 26.388). La app sancionará las infracciones con el bloqueo de cuenta/IP y dará aviso a la Justicia si correspondiera.',
                    ),

                    // 5. RESPONSABILIDAD SUBJETIVA
                    _TermSection(
                      title: '5. RESPONSABILIDAD SUBJETIVA POR CONTENIDO',
                      content: 'Conforme a la doctrina judicial "Belén Rodríguez" (CSJN), los usuarios son responsables únicos de sus publicaciones y transmisiones. CONVOS actúa como intermediario tecnológico y removerá contenidos infractores tras ser notificado fehacientemente.',
                    ),

                    // 6. RETENCIÓN DE FONDOS
                    _TermSection(
                      title: '6. RETENCIÓN CAUTELAR DE FONDOS POR INFRACCIÓN',
                      content: 'En caso de baneo por faltas graves, acoso, fraude o violación de estas normas, los saldos acumulados o pendientes quedarán retenidos en forma cautelar como penalización por daños y perjuicios.',
                    ),

                    // 7. ECONOMÍA VIRTUAL Y NO REEMBOLSO
                    _TermSection(
                      title: '7. BIENES DIGITALES Y POLÍTICA DE NO REEMBOLSO',
                      content: 'Las fichas o tokens consumidos e intercambiados dentro de la plataforma son bienes digitales intangibles y no son reembolsables. Se garantiza el derecho de arrepentimiento (Ley 24.240, Art. 34) dentro de los 10 días exclusivamente sobre saldos NO consumidos.',
                    ),

                    // 8. CUMPLIMIENTO FISCAL
                    _TermSection(
                      title: '8. CUMPLIMIENTO FISCAL (ARCA / ARBA)',
                      content: 'Las liquidaciones en Pesos Argentinos (ARS) vía CBU/CVU están sujetas a la validación del CUIT/CUIL y regímenes de información tributaria de los organismos correspondientes (ARCA y ARBA).',
                    ),

                    // 9. PRIVACIDAD DE DATOS
                    _TermSection(
                      title: '9. PROTECCIÓN DE DATOS PERSONALES (LEY 25.326 Y GDPR)',
                      content: 'Los datos personales recopilados se tratan bajo estrictos protocolos de confidencialidad conforme a la Ley N° 25.326 de Argentina y estándares internacionales GDPR. El usuario puede ejercer sus derechos de acceso, rectificación o eliminación.',
                    ),

                    // 10. EXENCIÓN FUERA DE LÍNEA
                    _TermSection(
                      title: '10. EXENCIÓN DE RESPONSABILIDAD FUERA DE LÍNEA',
                      content: 'CONVOS opera únicamente como plataforma de intermediación virtual. Cualquier encuentro, cita o reunión presencial fuera de la PWA es de exclusiva responsabilidad de las partes, quedando la plataforma eximida de cualquier reclamo.',
                    ),

                    // 11. AUTORIDADES
                    _TermSection(
                      title: '11. COOPERACIÓN CON AUTORIDADES JUDICIALES',
                      content: 'Ante sospechas de ilícitos, extorsión o delitos digitales, CONVOS prestará colaboración activa compartiendo registros y datos identificatorios con las autoridades judiciales competentes.',
                    ),

                    // 12. JURISDICCIÓN
                    _TermSection(
                      title: '12. LEY APLICABLE Y JURISDICCIÓN',
                      content: 'Estos términos se rigen por la legislación de la República Argentina. Cualquier controversia se someterá a los Tribunales Ordinarios de la Ciudad Autónoma de Buenos Aires (CABA).',
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
