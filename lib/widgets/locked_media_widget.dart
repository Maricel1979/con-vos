import 'package:flutter/material.dart';

class LockedMediaWidget extends StatelessWidget {
  final String mediaUrl;
  final bool isLocked;
  final double price;
  final bool isPurchased;
  final String currentUsername; // El @ del usuario actual para la marca de agua
  final VoidCallback onUnlockPressed;

  const LockedMediaWidget({
    Key? key,
    required this.mediaUrl,
    required this.isLocked,
    required this.price,
    required this.isPurchased,
    required this.currentUsername,
    required this.onUnlockPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si es público, o si es bloqueado pero ya fue comprado, se muestra la imagen
    bool showContent = !isLocked || isPurchased;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Imagen base
          showContent
              ? Image.network(mediaUrl, fit: BoxFit.cover)
              : Container(
                  color: const Color(0xFF1E293B),
                  child: Image.network(mediaUrl, fit: BoxFit.cover),
                ),

          // 2. Si está bloqueado y no se ha comprado, mostrar candado y precio
          if (!showContent) ...[
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: Color(0xFF8B5CF6), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Contenido Exclusivo\n\$${price.toStringAsFixed(0)} créditos',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: onUnlockPressed,
                    child: const Text(
                      'Desbloquear',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 3. MARCA DE AGUA DINÁMICA (Si el contenido es visible para el comprador)
          if (showContent && isLocked) ...[
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '@$currentUsername',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(blurRadius: 2, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
