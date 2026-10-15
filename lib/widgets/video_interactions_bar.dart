import 'package:flutter/material.dart';

class BotonesInteraccionVertical extends StatefulWidget {
  final int cantidadMeGustaInicial;
  final int cantidadComentarios;
  final VoidCallback alPresionarComentarios;
  final VoidCallback alPresionarCompartir;

  const BotonesInteraccionVertical({
    Key? key,
    required this.cantidadMeGustaInicial,
    required this.cantidadComentarios,
    required this.alPresionarComentarios,
    required this.alPresionarCompartir,
  }) : super(key: key);

  @override
  State<BotonesInteraccionVertical> createState() =>
      _BotonesInteraccionVerticalState();
}

class _BotonesInteraccionVerticalState
    extends State<BotonesInteraccionVertical> {
  late bool meGusta;
  late int cantidadMeGusta;

  @override
  void initState() {
    super.initState();
    meGusta = false; // Por defecto no está presionado
    cantidadMeGusta = widget.cantidadMeGustaInicial;
  }

  void _alternarMeGusta() {
    setState(() {
      meGusta = !meGusta;
      cantidadMeGusta += meGusta ? 1 : -1;
    });
    // Aquí puedes agregar la lógica para enviar la actualización al backend
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize:
          MainAxisSize.min, // Ocupa solo el espacio necesario verticalmente
      children: [
        // Botón Me Gusta (Corazón)
        Column(
          children: [
            IconButton(
              icon: Icon(
                meGusta ? Icons.favorite : Icons.favorite_border,
                color: meGusta ? Colors.pinkAccent : Colors.white,
                size: 32,
              ),
              onPressed: _alternarMeGusta,
            ),
            Text(
              '$cantidadMeGusta',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Espaciado entre botones
        // Botón Comentarios
        Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.mode_comment_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: widget.alPresionarComentarios,
            ),
            Text(
              '${widget.cantidadComentarios}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Espaciado entre botones
        // Botón Compartir (Flecha)
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 28),
              onPressed: widget.alPresionarCompartir,
            ),
            const Text(
              'Compartir',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
