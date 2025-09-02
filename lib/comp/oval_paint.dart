import 'package:flutter/material.dart';

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Lingkaran paling kecil
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.25,
      paint,
    );

    // Lingkaran sedang
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.45,
      paint,
    );

    // Lingkaran besar
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.7,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
