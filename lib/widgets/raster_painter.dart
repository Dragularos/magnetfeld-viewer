// lib/widgets/raster_painter.dart
import 'package:flutter/material.dart';

class RasterPainter extends CustomPainter {
  final int gridSize;
  final double cellSizePx;

  RasterPainter({required this.gridSize, required this.cellSizePx});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.5)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= gridSize; i++) {
      final offset = i * cellSizePx;
      // vertikal
      canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
      // horizontal
      canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
