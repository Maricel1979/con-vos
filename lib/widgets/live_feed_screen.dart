import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart'; // Descomentar cuando uses el motor real de Agora

class LiveFeedScreen extends StatefulWidget {
  const LiveFeedScreen({Key? key}) : super(key: key);

  @override
  State<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends State<LiveFeedScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoadingRooms = true;
  List<Map<String, dynamic>> _rooms = [];
  final Set<String> _unlockedChannels = {};

  @override
  void initState() {
    super.initState();
    _fetchRoomsFromDatabase();
  }

  Future<void> _fetchRoomsFromDatabase() async {
    // Simulamos una carga elegante con indicador visual (spinner)
    await Future.delayed(const Duration(seconds: 1));

    // Aquí podés conectar tu tabla real de Supabase 'rooms'
    setState(() {
      _rooms = [
        {
          'channelName': 'sala_principal',
          'hostName': 'María López',
          'isPrivate': false,
          'price': 0.0,
        },
        {
          'channelName': 'sala_vip_carlos',
          'hostName': 'Carlos Gómez (VIP)',
          'isPrivate': true,
          'price': 500.0,
        },
        {
          'channelName': 'sala_exclusiva_ana',
          'hostName': 'Ana Martínez',
          'isPrivate': true,
          'price': 1000.0,
        },
      ];
      _isLoadingRooms = false;
    });
  }

  void _simulatePayment(String channelName, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Confirmar Pago',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Deseas abonar \$${price.toStringAsFixed(2)} para acceder sin límites a este vivo privado?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
            onPressed: () {
              setState(() {
                _unlockedChannels.add(channelName);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Pago exitoso! Acceso total desbloqueado.'),
                ),
              );
            },
            child: const Text(
              'Pagar ahora',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRooms) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              SizedBox(height: 16),
              Text(
                'Cargando transmisiones en vivo...',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          final String channelName = room['channelName'];
          final String hostName = room['hostName'];
          final bool isPrivate = room['isPrivate'];
          final double price = room['price'];

          final bool isUnlocked = _unlockedChannels.contains(channelName);

          return _LiveStreamPageItem(
            channelName: channelName,
            hostName: hostName,
            isPrivate: isPrivate,
            price: price,
            isUnlocked: isUnlocked,
            onPayPressed: () => _simulatePayment(channelName, price),
          );
        },
      ),
    );
  }
}

/// Widget individual para manejar la vista previa de 10 segundos y el motor de video por página
class _LiveStreamPageItem extends StatefulWidget {
  final String channelName;
  final String hostName;
  final bool isPrivate;
  final double price;
  final bool isUnlocked;
  final VoidCallback onPayPressed;

  const _LiveStreamPageItem({
    Key? key,
    required this.channelName,
    required this.hostName,
    required this.isPrivate,
    required this.price,
    required this.isUnlocked,
    required this.onPayPressed,
  }) : super(key: key);

  @override
  State<_LiveStreamPageItem> createState() => _LiveStreamPageItemState();
}

class _LiveStreamPageItemState extends State<_LiveStreamPageItem> {
  bool _showPaywall = false;
  Timer? _previewTimer;
  int _secondsLeft = 10;

  @override
  void initState() {
    super.initState();
    // Si es privado y aún no pagó, iniciamos la vista previa de 10 segundos
    if (widget.isPrivate && !widget.isUnlocked) {
      _startPreviewCountdown();
    }
  }

  void _startPreviewCountdown() {
    _previewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _showPaywall =
                true; // Se cumple el tiempo y salta el cartel de pago
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool blockAccess =
        widget.isPrivate && !widget.isUnlocked && _showPaywall;

    return Stack(
      children: [
        // 1. Simulación de Video de Agora en Vivo de Fondo
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF0F172A),
          child: Stack(
            children: [
              // Aquí iría el widget de Agora RTC: AgoraVideoView(...)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.videocam,
                      color: Color(0xFF8B5CF6),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Transmitiendo: ${widget.hostName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Canal Agora: ${widget.channelName}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Indicador visual superior si está en modo Vista Previa Gratuita
              if (widget.isPrivate && !widget.isUnlocked && !_showPaywall)
                Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: Colors.amber, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Vista previa gratuita: $_secondsLeft s restantes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 2. Paywall Bloqueante (Aparece al terminar los 10 segundos)
        if (blockAccess)
          Container(
            color: Colors.black.withOpacity(0.9),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, color: Colors.amber, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      '¡Terminó tu vista previa!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Para continuar viendo la transmisión de ${widget.hostName} y participar del chat exclusivo, debés abonar \$${widget.price.toStringAsFixed(2)}.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.payment),
                      label: Text(
                        'Pagar \$${widget.price.toStringAsFixed(2)} para ingresar',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onPressed: widget.onPayPressed,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Deslizá hacia arriba o abajo para ver otros vivos',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Indicador lateral de desplazamiento tipo TikTok
        Positioned(
          right: 16,
          top: MediaQuery.of(context).size.height / 2 - 40,
          child: const Column(
            children: [
              Icon(Icons.keyboard_arrow_up, color: Colors.white54),
              Text(
                'Deslizá',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.white54),
            ],
          ),
        ),
      ],
    );
  }
}
